import 'package:flutter/material.dart';
import 'package:tennisfy/helpers/media_query_helpers.dart';

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
            // Container(
            //   height: displayHeight(context) * 0.4,
            //   child: ListView.builder(itemBuilder: ),
            // )
          ],
        ),
      ),
    );
    ;
  }
}
