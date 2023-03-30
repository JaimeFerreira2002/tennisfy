import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../Models/comment_model.dart';
import '../../models/user_model.dart';
import '../auth.dart';

///
///Retrieves the bool value - if the user already varified his email
///
Future<bool> getUserHasEmailVerified() async {
  return Auth().currentUser!.emailVerified;
}

///
///Retrieves a user data object from firebase cloud
///
Future<UserData> getUserData(String userUID) async {
  final DocumentSnapshot userDoc =
      await FirebaseFirestore.instance.collection('Users').doc(userUID).get();

  return UserData.fromJson(userDoc.data() as Map<String, dynamic>) as UserData;
}

///
///Return a strem of a users data
///
Stream<DocumentSnapshot<Map<String, dynamic>>> getUserDataStream(
    String userUID) {
  final userDoc = FirebaseFirestore.instance.collection('Users').doc(userUID);

  return userDoc.snapshots();
}

///
///Retrieves current user profile image
///
Future<String> getProfileImageURL(String userUID) async {
  final imageURL = await FirebaseStorage.instance
      .ref()
      .child("ProfilePictures/" + userUID + ".jpg")
      .getDownloadURL();

  return imageURL;
}

///
///Retrieves current user banner image
///
Future<String> getBannerImageURL(String userUID) async {
  final imageURL = await FirebaseStorage.instance
      .ref()
      .child("BannerPictures/" + userUID + ".jpg")
      .getDownloadURL();

  return imageURL;
}

///
///Retrieves current user user name
///

Future<String> getUserName(String userUID) async {
  final DocumentSnapshot userDoc =
      await FirebaseFirestore.instance.collection('Users').doc(userUID).get();

  return userDoc.get('Name');
}

///
///retrieves current user biography
///

Future<String> getUserBio(String userUID) async {
  final DocumentSnapshot userDoc =
      await FirebaseFirestore.instance.collection('Users').doc(userUID).get();

  return userDoc.get('Biography');
}

///
///retrieves current user date of birth as String
///

Future<DateTime> getUserDateOfBirth(String userUID) async {
  final DocumentSnapshot userDoc =
      await FirebaseFirestore.instance.collection('Users').doc(userUID).get();

  return UserData.dateFromFirebase(userDoc.get('DateOfBirth'));
}

///
///retrieves current user bool value - hasSetupAccount
///

Future<bool> getUserHasSetupAccount(String userUID) async {
  final DocumentSnapshot userDoc =
      await FirebaseFirestore.instance.collection('Users').doc(userUID).get();

  return userDoc.get('HasSetupAccount');
}

///
///retrieves current user int value - Reputation
///

Future<double> getUserReputation(String userUID) async {
  final DocumentSnapshot userDoc =
      await FirebaseFirestore.instance.collection('Users').doc(userUID).get();

  return userDoc.get('Reputation');
}

///
///retrieves current user number of friends
///
Future<int> getUserNumberOfFriends(String userUID) async {
  final DocumentSnapshot userDoc =
      await FirebaseFirestore.instance.collection('Users').doc(userUID).get();

  return userDoc.get('NumberOfFriends');
}

///
///retrieves current user friends list
///
Future<List<String>> getUserFriendsList(String userUID) async {
  final DocumentSnapshot userDoc =
      await FirebaseFirestore.instance.collection('Users').doc(userUID).get();

  return userDoc.get('FriendsList');
}

///
///Retrieves number of games the user played
///
Future<int> getUserNumberOfGamesPLayed(String userUID) async {
  final DocumentSnapshot userDoc =
      await FirebaseFirestore.instance.collection('Users').doc(userUID).get();

  return userDoc.get('NumberOfGamesPlayed');
}

///
///Retreives a map with the sports the current user plays
///
Future<Map<String, dynamic>> getUserSportsPlayedList(String userUID) async {
  final DocumentSnapshot userDoc =
      await FirebaseFirestore.instance.collection('Users').doc(userUID).get();

  return jsonDecode(userDoc.get('SportsPlayed'));
}

///
///Retreives a list off all user comments
///
Future<List<Comment>> getUserCommentsList(String userUID) async {
  final DocumentSnapshot userDoc =
      await FirebaseFirestore.instance.collection('Users').doc(userUID).get();

  List<dynamic> _tempList = jsonDecode(userDoc.get('CommentsList'));

  return _tempList.cast<Comment>();
}

///
///Checks if two users are friends or not
///
Future<bool> userAreFriends(String userUID1, String userUID2) async {
  UserData user1 = await getUserData(userUID1);

  if (user1.friendsList.contains(userUID2)) {
    return true;
  } else {
    return false;
  }
}

///
///Checks if a user has sent a friend request to another user
///
Future<bool> userSentFriendRequest(String senderUID, String recieverUID) async {
  UserData reciever = await getUserData(recieverUID);
  if (reciever.friendRequests.contains(senderUID)) {
    return true;
  } else {
    return false;
  }
}

///
///Sends a friend request, it recieves as argument both the user sender and the reciever
///
Future<void> sendFriendRequest(String senderUID, String recieverUID) async {
  UserData reciever = await getUserData(recieverUID);
  if (!reciever.friendRequests.contains(senderUID)) {
    reciever.friendRequests.add(senderUID);
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(recieverUID)
        .update(reciever.toJson());
  } else {
    print('Already sent a firend request');
  }
}

///
///Unsends a friend request, it recieves as argument both the user sender and the reciever
///

Future<void> unsendFriendRequest(String senderUID, String recieverUID) async {
  UserData reciever = await getUserData(recieverUID);
  if (reciever.friendRequests.contains(senderUID)) {
    reciever.friendRequests.remove(senderUID);
    print(reciever.friendRequests.toString());
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(recieverUID)
        .update(reciever.toJson());
  } else
    print(
        'error, user has not sent friend request'); //useful print, used for debugging, leave it? use in every method?
}

Future acceptFriendRequest(String recieverUID, String senderUID) async {
  UserData reciever = await getUserData(recieverUID);
  UserData sender = await getUserData(senderUID);

//remove request from requests list,add sender to reciever friends list and update firebase reference
  reciever.friendRequests.remove(senderUID);
  reciever.friendsList.add(senderUID);

  await FirebaseFirestore.instance
      .collection('Users')
      .doc(recieverUID)
      .update(reciever.toJson());

  //add  reciever to sender friends list and update firebase reference
  sender.friendsList.add(recieverUID);

  await FirebaseFirestore.instance
      .collection('Users')
      .doc(senderUID)
      .update(sender.toJson());
}

Future unfriend(String recieverUID, String senderUID) async {
  UserData reciever = await getUserData(recieverUID);
  UserData sender = await getUserData(senderUID);

  if (!reciever.friendsList.contains(sender.UID) ||
      !sender.friendsList.contains(recieverUID)) {
    print('error, users are not firends');
    return;
  }
//remove sender to reciever friends list and update firebase reference

  reciever.friendsList.remove(senderUID);

  await FirebaseFirestore.instance
      .collection('Users')
      .doc(recieverUID)
      .update(reciever.toJson());

  //remove  reciever to sender friends list and update firebase reference
  sender.friendsList.remove(recieverUID);

  await FirebaseFirestore.instance
      .collection('Users')
      .doc(senderUID)
      .update(sender.toJson());
}

Future rejectFriendRequest(String recieverUID, String senderUID) async {
  UserData reciever = await getUserData(recieverUID);

//remove request from requests list
  reciever.friendRequests.remove(senderUID);
  await FirebaseFirestore.instance
      .collection('Users')
      .doc(recieverUID)
      .update(reciever.toJson());
}
