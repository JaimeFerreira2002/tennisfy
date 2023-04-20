import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/message_model.dart';
import 'auth.dart';

///
///This class holds all functions of the collection 'Chats'.
///It is only through this class that we can access the 'Chats' collection in firebase Firestore
/////////////////////////////////////////////////////////////////////////////////////////////////

class FirebaseChats {
  ///
  ///Get the [CollectionReference] that references the 'Chats collection'
  ///
  final CollectionReference chatsRef =
      FirebaseFirestore.instance.collection('Chats');

  ///
  ///This function update the field "IsRead" in all the messages (recived) in the 'Messages' sub-collection in a given chat
  ///[chatID] is the id of the chat to update the messages
  ///[myUserID]
  ///
  Future<void> markAllAsRead(String chatID, String myUserID) async {
    final CollectionReference collectionRef =
        chatsRef.doc(chatID).collection('Messages');

    final QuerySnapshot snapshot = await collectionRef.get();
    final List<DocumentSnapshot> documents = snapshot.docs;

    for (DocumentSnapshot document in documents) {
      final String senderID = document['SenderID'];
      final bool isRead = document['IsRead'];

      if (senderID != myUserID && !isRead) {
        await document.reference.update({'IsRead': true});
      }
    }
  }

  ///
  ///This function returns a stream of a bool value : true if all the messages from the other user are read, false otherwise
  ///[chatID] is the ID of the chat document
  ///[myUserID] is the current user UID
  ///
  Stream<bool> checkUnreadMessages(String chatID, String myUserID) {
    final CollectionReference collectionRef =
        chatsRef.doc(chatID).collection('Messages');

    return collectionRef.snapshots().map((snapshot) {
      final List<DocumentSnapshot> documents = snapshot.docs;

      for (DocumentSnapshot document in documents) {
        final String senderID = document['SenderID'];
        final bool isRead = document['IsRead'];

        if (senderID != myUserID && !isRead) {
          return true;
        }
      }

      return false;
    });
  }

  ///
  ///This function returns the content of the last message in a Chat document
  ///[chatID] is the ID of the chat document
  ///
  Stream<String> getChatLastMessageStream(String chatID) {
    return chatsRef
        .doc(chatID)
        .collection('Messages')
        .orderBy('TimeSent', descending: true)
        .limit(1)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isEmpty) {
        // handle the case where there are no messages in the chat
        return '';
      }
      final DocumentSnapshot lastMessage = snapshot.docs.first;
      final String messageText = lastMessage.get('Message');
      return messageText;
    });
  }

  ///
  ///This function returns the UID of the other user in a chat. It compares both of the participants UIDs to the current user UID, and returns the one that doesnt match
  ///[chatID] is the ID of the chat document
  ///
  Future<String> getOtherChatUserUID(String chatID) async {
    final DocumentSnapshot chatDoc = await chatsRef.doc(chatID).get();
    String user1Id = chatDoc.get('User1');
    String user2Id = chatDoc.get('User2');
    if (user1Id == Auth().currentUser!.uid) {
      return user2Id;
    } else
      return user1Id;
  }

  ///
  ///This function gets a userUID, checks if the current user already has a chat document with that user, if so, it returns the chatID of that document, else it creates a new chat document and returns that chatID
  ///[otherUserUID] is the UID of the other user
  ///
  Future<String> getOrCreateChatId(String otherUserUID) async {
    String currentUserUid = Auth().currentUser!.uid;

    final currentUserDocRef =
        FirebaseFirestore.instance.collection('Users').doc(currentUserUid);
    final currentUserData = await currentUserDocRef.get();

    final currentUserChatIdsList =
        jsonDecode(currentUserData.data()!['ChatsIDsList']);

    final otherUserDocRef =
        FirebaseFirestore.instance.collection('Users').doc(otherUserUID);
    final otherUserData = await otherUserDocRef.get();

    final otherUserChatIdsList =
        jsonDecode(otherUserData.data()!['ChatsIDsList']);

    // Check if there's an existing chat with the other user
    for (final chatId in currentUserChatIdsList) {
      final chatDocRef = chatsRef.doc(chatId);
      final chatData = await chatDocRef.get();
      final user1 = chatData['User1'];
      final user2 = chatData['User2'];

      if ((user1 == currentUserUid && user2 == otherUserUID) ||
          (user1 == otherUserUID && user2 == currentUserUid)) {
        // Found an existing chat with the other user, return the chat ID
        return chatId;
      }
    }

    // No existing chat with the other user, create a new chat document

    final newChatDocRef = chatsRef.doc();
    final newChatId = newChatDocRef.id;

    //user1 and user2 are UIDs
    await newChatDocRef.set({
      'User1': currentUserUid,
      'User2': otherUserUID,
    });

    // Add the new chat ID to both  user's list of chats
    currentUserChatIdsList.add(newChatId);
    await currentUserDocRef
        .update({'ChatsIDsList': jsonEncode(currentUserChatIdsList)});

    otherUserChatIdsList.add(newChatId);
    await otherUserDocRef
        .update({'ChatsIDsList': jsonEncode(otherUserChatIdsList)});

    return newChatId;
  }

  ///
  ///This fucntion returns a Stream of list of all the Messages in a chat document, to display in a chatPage.
  ///[chatID] is the id of the chat document
  ///
  Stream<List<Message>> getMessagesStream(String chatID) {
    final chatDocRef = chatsRef.doc(chatID);

    return chatDocRef
        .collection('Messages')
        .orderBy('TimeSent', descending: false)
        .snapshots()
        .map((querySnapshot) {
      final messages = querySnapshot.docs
          .map((doc) => Message.fromJson(doc.data()))
          .toList()
          .cast<Message>();

      messages
          .sort((a, b) => b.timeSent.compareTo(a.timeSent)); // sort by timeSent

      return messages;
    });
  }

  ///
  ///This fucntion gets a list of chatIds and returns a stream of
  ///
  Stream<List<String>> getChatsStream(List<String> docIDs) {
    return chatsRef
        .where(FieldPath.documentId, whereIn: docIDs)
        .snapshots()
        .map((QuerySnapshot snapshot) =>
            snapshot.docs.map((doc) => doc.id).toList());
  }

  ///
  ///This function gets 2 UIDs, one for the user thats sending the message and the other of the one how is recieving, and adds a new Message document to the Messages sub collection of the given chatID
  ///[senderUID] UID of the user thats sending the message
  ///[recieverUID] UID of the user thats recieving the message
  ///[messageContent] content of the message
  ///[chatID] id of the chat document
  ///
  Future sendMessage(String senderUID, String recieverUID,
      String messageContent, String chatID) async {
    final messageCollection =
        FirebaseFirestore.instance.collection('Chats/$chatID/Messages');

    final Message _newMessage = Message(
        senderUID: senderUID,
        revieverUID: recieverUID,
        message: messageContent,
        isRead: false,
        timeSent: DateTime.now());

    messageCollection.add(_newMessage.toJson());
  }
}
