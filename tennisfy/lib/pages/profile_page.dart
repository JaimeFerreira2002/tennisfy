import 'dart:convert';
import 'dart:math';
import 'package:age_calculator/age_calculator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tennisfy/components/others.dart';
import 'package:tennisfy/components/stats_card.dart';
import 'package:tennisfy/helpers/media_query_helpers.dart';
import 'package:tennisfy/models/comment_model.dart';
import '../helpers/auth.dart';
import '../helpers/helper_methods.dart';
import '../helpers/services/firebase_getters.dart';

class ProfilePage extends StatefulWidget {
  String userUID;
  ProfilePage({Key? key, required this.userUID}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profile",
          style: TextStyle(fontSize: 20),
        ),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Theme.of(context).colorScheme.primary,
            )),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.more_vert,
                color: Theme.of(context).colorScheme.primary,
              ))
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: StreamBuilder(
              stream: getUserDataStream(widget.userUID),
              builder: (context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }

                List<Comment> _commentsList =
                    jsonDecode(snapshot.data.get('CommentsList'))
                        .map((commentJson) => Comment.fromJson(commentJson))
                        .toList()
                        .cast<Comment>();

                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: displayHeight(context) * 0.26,
                      child: Column(
                        children: [
                          FutureBuilder(
                            future: getProfileImageURL(widget.userUID),
                            initialData: "Loading...",
                            builder:
                                ((context, AsyncSnapshot<String> snapshot) {
                              return CircleAvatar(
                                  radius: 70,
                                  backgroundColor:
                                      Theme.of(context).colorScheme.primary,
                                  backgroundImage: snapshot.data != null
                                      ? Image.network(snapshot.data!).image
                                      : Image.network(
                                              "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png")
                                          .image);
                            }),
                          ),
                          SizedBox(height: displayHeight(context) * 0.015),
                          Text(
                            snapshot.data.get('FirstName') +
                                " " +
                                snapshot.data.get('LastName'),
                            style: const TextStyle(fontSize: 26),
                          ),
                          Text(
                            snapshot.data.get('Email'),
                            style: TextStyle(
                                fontSize: 10,
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.4)),
                          ),
                          Text(
                            "Joined in " +
                                dateFromFirebase(
                                        snapshot.data.get('DateJoined'))
                                    .day
                                    .toString() +
                                ' / ' +
                                dateFromFirebase(
                                        snapshot.data.get('DateJoined'))
                                    .month
                                    .toString() +
                                ' / ' +
                                dateFromFirebase(
                                        snapshot.data.get('DateJoined'))
                                    .year
                                    .toString(),
                            style: TextStyle(
                                fontSize: 10,
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.4)),
                          )
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: displayHeight(context) * 0.05,
                          width: displayWidth(context) * 0.6,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.secondary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: TextButton(
                                onPressed: () {},
                                child: Text(
                                  widget.userUID == Auth().currentUser!.uid
                                      ? "Edit"
                                      : "Challenge",
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiary),
                                )),
                          ),
                        )
                      ],
                    ),
                    Container(
                      height: displayHeight(context) * 0.075,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.tertiary,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                  AgeCalculator.age(dateFromFirebase(
                                          snapshot.data.get('DateOfBirth')))
                                      .years
                                      .toString(),
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w900)),
                              const Text("Years"),
                            ],
                          ),
                          smallVerticalDivider(context),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                snapshot.data.get('Reputation').toString(),
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w900),
                              ),
                              const Text("Reputation"),
                            ],
                          ),
                          smallVerticalDivider(context),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                  (jsonDecode(snapshot.data.get('FriendsList'))
                                          as List)
                                      .length
                                      .toString(),
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w900)),
                              const Text("Friends"),
                            ],
                          ),
                        ],
                      ),
                    ),
                    statsCard(context, snapshot),
                    SizedBox(height: displayHeight(context) * 0.00),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Comments",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    Container(
                      height: displayHeight(context) * 0.14,
                      child: _commentsList.isEmpty
                          ? Center(
                              child: Text(
                                  widget.userUID == Auth().currentUser!.uid
                                      ? "You have no comments"
                                      : "This user has no comments"),
                            )
                          //here we use PageView instead of ListView for elements to snap
                          : ListView.builder(
                              controller: PageController(viewportFraction: 0.6),
                              physics: const PageScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              itemCount: _commentsList.length,
                              itemBuilder: (BuildContext context, int index) {
                                Comment comment = _commentsList[index];

                                return Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                  child: Container(
                                    height: displayHeight(context) * 0.08,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiary,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(15)),
                                      boxShadow: [
                                        BoxShadow(
                                          offset: const Offset(0, 0),
                                          blurRadius: 8.0,
                                          spreadRadius: 0.5,
                                          color: const Color.fromARGB(
                                                  255, 59, 59, 59)
                                              .withOpacity(0.2),
                                        ),
                                      ],
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Container(
                                            height:
                                                displayHeight(context) * 0.04,
                                            width: displayWidth(context) * 0.08,
                                            decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Center(
                                              child: FutureBuilder(
                                                initialData: 0.0,
                                                future: getUserReputation(
                                                    comment.authorUID),
                                                builder: (context,
                                                    AsyncSnapshot<double>
                                                        authorRepSnapshot) {
                                                  return Text(
                                                    authorRepSnapshot.data
                                                        .toString(),
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .tertiary),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                              width:
                                                  displayWidth(context) * 0.04),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  FutureBuilder(
                                                    future: getProfileImageURL(
                                                        comment.authorUID),
                                                    initialData: "Loading...",
                                                    builder: ((context,
                                                        AsyncSnapshot<String>
                                                            snapshot) {
                                                      return CircleAvatar(
                                                          radius: 14,
                                                          backgroundColor:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .primary,
                                                          backgroundImage: snapshot
                                                                      .data !=
                                                                  null
                                                              ? Image.network(
                                                                      snapshot
                                                                          .data!)
                                                                  .image
                                                              : Image.network(
                                                                      "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png")
                                                                  .image);
                                                    }),
                                                  ),
                                                  SizedBox(
                                                      width: displayWidth(
                                                              context) *
                                                          0.02),
                                                  FutureBuilder(
                                                    initialData: "Loading",
                                                    future: getUserFullName(
                                                        comment.authorUID),
                                                    builder: (context,
                                                        AsyncSnapshot<String>
                                                            authorNameSnapshot) {
                                                      return Text(
                                                        authorNameSnapshot
                                                            .data!,
                                                        style: const TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w900),
                                                      );
                                                    },
                                                  )
                                                ],
                                              ),
                                              Text(
                                                comment.content,
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 12),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                    )
                  ],
                );
              }),
        ),
      ),
    );
  }

  List<Container> commentsTileList(List commentsList) {
    List<Container> commentsTileList = [];
    commentsList.forEach((element) {
      commentsTileList.add(commentsTile(element));
    });
    return commentsTileList;
  }

  Container commentsTile(Comment comment) {
    return Container(
      height: 20,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.tertiary,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 0),
            blurRadius: 8.0,
            spreadRadius: 0.5,
            color: const Color.fromARGB(255, 59, 59, 59).withOpacity(0.2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              FutureBuilder(
                future: getProfileImageURL(comment.authorUID),
                initialData: "Loading...",
                builder: ((context, AsyncSnapshot<String> snapshot) {
                  return CircleAvatar(
                      radius: 20,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      backgroundImage: snapshot.data != null
                          ? Image.network(snapshot.data!).image
                          : Image.network(
                                  "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png")
                              .image);
                }),
              ),
            ],
          ),
          Text(comment.content)
        ],
      ),
    );
  }

  void addComment(String authorUID, String recieverUID, String content) async {
    double _reputation = await getUserReputation(authorUID);
    Comment newComment = Comment(
        authorUID: authorUID,
        datePosted: DateTime.now(),
        reputaion: _reputation,
        content: content);
    List<Comment> userCommentsList = await getUserCommentsList(recieverUID);
    userCommentsList.add(newComment);

    await FirebaseFirestore.instance
        .collection('Users')
        .doc(recieverUID)
        .update({'CommentsList': jsonEncode(userCommentsList)});
  }
}
