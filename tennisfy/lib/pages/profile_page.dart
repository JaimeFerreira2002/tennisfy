import 'dart:convert';
import 'package:age_calculator/age_calculator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tennisfy/components/profile_image_avatar.dart';
import 'package:tennisfy/components/stats_card.dart';
import 'package:tennisfy/helpers/media_query_helpers.dart';
import 'package:tennisfy/helpers/services/firebase_chats.dart';
import 'package:tennisfy/models/comment_model.dart';
import 'package:tennisfy/models/user_model.dart';
import 'package:tennisfy/pages/chat_page.dart';
import 'package:tennisfy/pages/profile_edit_page.dart';
import '../helpers/services/auth.dart';
import '../helpers/helper_methods.dart';
import '../helpers/services/firebase_users.dart';

class ProfilePage extends StatefulWidget {
  UserData? userData;
  ProfilePage({Key? key, required this.userData}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    UserData? userData = widget.userData;
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
      body: userData == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ProfileImageAvatar(
                                  userUID: userData.UID, radius: 65),
                              Column(
                                children: [
                                  Text(
                                    userData.firstName +
                                        " " +
                                        userData.lastName,
                                    style: const TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.w900),
                                  ),
                                  Text(
                                    userData.email,
                                    style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary
                                            .withOpacity(0.4)),
                                  ),
                                  Text(
                                    "Joined in " +
                                        userData.dateJoined.day.toString() +
                                        ' / ' +
                                        userData.dateJoined.month.toString() +
                                        ' / ' +
                                        userData.dateJoined.year.toString(),
                                    style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary
                                            .withOpacity(0.4)),
                                  ),
                                  SizedBox(
                                      height: displayHeight(context) * 0.02),
                                  Container(
                                    height: displayHeight(context) * 0.05,
                                    width: displayWidth(context) * 0.55,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                                AgeCalculator.age(
                                                        userData.dateOfBirth)
                                                    .years
                                                    .toString(),
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w900)),
                                            const Text("Years",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w500)),
                                          ],
                                        ),
                                        Container(
                                          width: displayWidth(context) * 0.004,
                                          height: displayHeight(context) * 0.02,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary
                                                  .withOpacity(0.4)),
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              userData.reputation.toString(),
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w900),
                                            ),
                                            const Text("Reputation",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w500)),
                                          ],
                                        ),
                                        Container(
                                          width: displayWidth(context) * 0.004,
                                          height: displayHeight(context) * 0.02,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary
                                                  .withOpacity(0.4)),
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                                userData.friendsList.length
                                                    .toString(),
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w900)),
                                            const Text("Friends",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w500)),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: displayHeight(context) * 0.008),
                    Row(
                      mainAxisAlignment: userData.UID != Auth().currentUser!.uid
                          ? MainAxisAlignment.spaceBetween
                          : MainAxisAlignment.center,
                      children: [
                        Container(
                          height: displayHeight(context) * 0.05,
                          width: userData.UID != Auth().currentUser!.uid
                              ? displayWidth(context) * 0.6
                              : displayWidth(context) * 0.9,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.secondary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextButton(
                              onPressed: () {
                                userData.UID == Auth().currentUser!.uid
                                    ? goToPage(context, ProfileEditPage())
                                    : {}; //challenge user;
                              },
                              child: Text(
                                userData.UID == Auth().currentUser!.uid
                                    ? "Edit"
                                    : "Challenge",
                                style: TextStyle(
                                    fontSize: 20,
                                    color:
                                        Theme.of(context).colorScheme.tertiary),
                              )),
                        ),
                        Visibility(
                            visible: userData.UID != Auth().currentUser!.uid,
                            child: Container(
                                height: displayHeight(context) * 0.05,
                                width: displayWidth(context) * 0.3,
                                decoration: BoxDecoration(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: IconButton(
                                  onPressed: () async {
                                    goToPage(
                                        context,
                                        ChatPage(
                                          userUID: userData.UID,
                                          chatID: await FirebaseChats()
                                              .getOrCreateChatId(userData.UID),
                                        ));
                                  },
                                  icon: Icon(
                                    Icons.message,
                                    color:
                                        Theme.of(context).colorScheme.tertiary,
                                  ),
                                ))),
                      ],
                    ),
                    //are sized boxs needed here? or mainAxisAliment should be enough?
                    SizedBox(height: displayHeight(context) * 0.002),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Record",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w900),
                      ),
                    ),
                    statsCard(context, userData),
                    SizedBox(height: displayHeight(context) * 0.008),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Comments",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w900),
                      ),
                    ),
                    Container(
                      height: displayHeight(context) * 0.25,
                      child: userData.comments.isEmpty
                          ? Center(
                              child: Text(
                                  userData.UID == Auth().currentUser!.uid
                                      ? "You have no comments"
                                      : "This user has no comments"),
                            )
                          //here we use PageView instead of ListView for elements to snap
                          : ListView.builder(
                              controller: PageController(viewportFraction: 0.2),
                              physics: const PageScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              itemCount: userData.comments.length,
                              itemBuilder: (BuildContext context, int index) {
                                Comment comment = userData.comments[index];

                                return Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(4, 8, 4, 8),
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
                                                future: FirebaseUsers()
                                                    .getUserReputation(
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
                                                    future: FirebaseUsers()
                                                        .getProfileImageURL(
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
                                                    future: FirebaseUsers()
                                                        .getUserFullName(
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
                                          SizedBox(
                                              width:
                                                  displayWidth(context) * 0.24),
                                          Text(
                                            comment.datePosted.day.toString() +
                                                " / " +
                                                comment.datePosted.month
                                                    .toString(),
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w900,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary
                                                    .withOpacity(0.2)),
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
                ),
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
                future: FirebaseUsers().getProfileImageURL(comment.authorUID),
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
    double _reputation = await FirebaseUsers().getUserReputation(authorUID);
    Comment newComment = Comment(
        authorUID: authorUID,
        datePosted: DateTime.now(),
        reputaion: _reputation,
        content: content);
    List<Comment> userCommentsList =
        await FirebaseUsers().getUserCommentsList(recieverUID);
    userCommentsList.add(newComment);

    await FirebaseFirestore.instance
        .collection('Users')
        .doc(recieverUID)
        .update({'CommentsList': jsonEncode(userCommentsList)});
  }
}
