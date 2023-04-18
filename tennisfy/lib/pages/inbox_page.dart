import 'package:flutter/material.dart';
import 'package:tennisfy/helpers/auth.dart';
import 'package:tennisfy/helpers/helper_methods.dart';
import 'package:tennisfy/helpers/media_query_helpers.dart';
import 'package:tennisfy/helpers/services/firebase_getters.dart';
import 'package:tennisfy/pages/chat_page.dart';

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
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Row(
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
            isMessagePage
                ? Container(
                    height: displayHeight(context) * 0.4,
                    child: FutureBuilder(
                      future: getUserChatsIdsList(Auth().currentUser!.uid),
                      builder:
                          (context, AsyncSnapshot<List<String>> listSnapshot) {
                        if (listSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return StreamBuilder<List<String>>(
                          stream: getChatsStream(listSnapshot.data!),
                          builder: (BuildContext context,
                              AsyncSnapshot<List<String>> snapshot) {
                            //when to use this vs ConnectionState.waiting
                            if (!snapshot.hasData) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            final List<String> chatIds = snapshot.data!;
                            return ListView.builder(
                              itemCount: chatIds.length,
                              itemBuilder: (BuildContext context, int index) {
                                final chatId = chatIds[index];
                                return FutureBuilder(
                                  future: getOtherChatUserUID(chatId),
                                  builder: (context,
                                      AsyncSnapshot<String> userUIDSnapshot) {
                                    return ListTile(
                                      title: Text(chatId),
                                      onTap: () {
                                        goToPage(
                                            context,
                                            ChatPage(
                                                userUID: userUIDSnapshot.data!,
                                                chatID: chatId));
                                      },
                                    );
                                  },
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
    ;
  }
}
