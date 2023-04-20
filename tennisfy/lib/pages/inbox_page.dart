import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletons/skeletons.dart';
import 'package:tennisfy/helpers/helper_methods.dart';
import 'package:tennisfy/helpers/media_query_helpers.dart';
import 'package:tennisfy/helpers/services/firebase_chats.dart';
import 'package:tennisfy/helpers/services/firebase_users.dart';
import 'package:tennisfy/models/user_model.dart';
import 'package:tennisfy/pages/chat_page.dart';

import '../components/profile_image_avatar.dart';

class InboxPage extends StatefulWidget {
  const InboxPage({Key? key}) : super(key: key);

  @override
  State<InboxPage> createState() => _InboxPageState();
}

class _InboxPageState extends State<InboxPage> {
//here we use a bool instead of an int because we only have 2 option ,therefore is less expensive this way
  bool isMessagePage = true;
  @override
  Widget build(BuildContext context) {
    return Consumer<UserData>(builder: (context, userData, Widget? child) {
      return Scaffold(
        body: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                        onPressed: () {
                          setState(() {
                            isMessagePage = true;
                          });
                        },
                        child: Text("Messages",
                            style: TextStyle(
                                fontSize: isMessagePage ? 18 : 16,
                                color: isMessagePage
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withOpacity(0.6),
                                fontWeight: isMessagePage
                                    ? FontWeight.w900
                                    : FontWeight.w600))),
                    Container(
                      height: 30,
                      width: displayWidth(context) * 0.006,
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(15)),
                    ),
                    TextButton(
                        onPressed: () {
                          setState(() {
                            isMessagePage = false;
                          });
                        },
                        child: Text("Invites",
                            style: TextStyle(
                                fontSize: !isMessagePage ? 18 : 16,
                                color: !isMessagePage
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withOpacity(0.6),
                                fontWeight: !isMessagePage
                                    ? FontWeight.w900
                                    : FontWeight.w600)))
                  ],
                ),
              ),
              Expanded(
                  child: isMessagePage
                      ? Container(
                          child: ListView.builder(
                            itemCount: userData.chatsIds.length,
                            itemBuilder: (BuildContext context, int index) {
                              final chatId = userData.chatsIds[index];
                              return _buildChatsListTile(chatId: chatId);
                            },
                          ),
                        )
                      : Container())
            ],
          ),
        ),
      );
    });
  }
}

class _buildChatsListTile extends StatelessWidget {
  const _buildChatsListTile({
    Key? key,
    required this.chatId,
  }) : super(key: key);

  final String chatId;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: FirebaseChats().getOtherChatUserUID(chatId),
      builder: (context, AsyncSnapshot<String> userUIDSnapshot) {
        if (userUIDSnapshot.connectionState == ConnectionState.waiting) {
          return SkeletonLine(
            style: SkeletonLineStyle(
                height: displayHeight(context) * 0.08,
                padding: const EdgeInsets.all(8),
                borderRadius: BorderRadius.circular(10)),
          );
        }
        return StreamBuilder(
          //this is not in the main provider because its data of other users
          stream: FirebaseUsers().getUserDataStream(userUIDSnapshot.data!),
          builder: (context, AsyncSnapshot otherUserDataSnapshot) {
            if (otherUserDataSnapshot.connectionState ==
                ConnectionState.waiting) {
              return SkeletonLine(
                style: SkeletonLineStyle(
                    height: displayHeight(context) * 0.08,
                    padding: const EdgeInsets.all(8),
                    borderRadius: BorderRadius.circular(10)),
              );
            }
            UserData otherUserData = otherUserDataSnapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  color: Theme.of(context).colorScheme.tertiary,
                  boxShadow: [
                    BoxShadow(
                      offset: const Offset(0, 0),
                      blurRadius: 8.0,
                      spreadRadius: 0.5,
                      color: const Color.fromARGB(255, 59, 59, 59)
                          .withOpacity(0.2),
                    ),
                  ],
                ),
                child: ListTile(
                  leading: ProfileImageAvatar(
                    userUID: otherUserData.UID,
                    radius: 25,
                  ),
                  title: Text(
                    otherUserData.firstName + " " + otherUserData.lastName,
                    style: const TextStyle(fontSize: 16),
                  ),
                  subtitle: StreamBuilder(
                    stream: FirebaseChats().getChatLastMessageStream(chatId),
                    builder: ((context, AsyncSnapshot messageSnapshot) {
                      if (messageSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const SkeletonLine();
                      }
                      return Text(messageSnapshot.data);
                    }),
                  ),
                  onTap: () => goToPage(
                    context,
                    ChatPage(userUID: userUIDSnapshot.data!, chatID: chatId),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
