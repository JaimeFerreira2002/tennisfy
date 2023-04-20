import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tennisfy/pages/profile_page.dart';

import '../helpers/services/auth.dart';
import '../helpers/helper_methods.dart';
import '../helpers/services/firebase_users.dart';
import '../models/user_model.dart';

class FindPage extends StatefulWidget {
  const FindPage({Key? key}) : super(key: key);

  @override
  State<FindPage> createState() => _FindPageState();
}

class _FindPageState extends State<FindPage> {
  String userSearchInput = '';

  TextEditingController userSearchInputController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Column(
              children: [
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.1)),
                  child: TextField(
                    controller: userSearchInputController,
                    onChanged: (input) {
                      setState(() {
                        userSearchInput = input;
                      });
                    },
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.primary),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(14),
                      hintText: 'Enter user´s name or email',
                      hintStyle: const TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Color.fromARGB(255, 178, 178, 178)),
                      border: InputBorder.none,
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              userSearchInput = '';
                              userSearchInputController.text = '';
                            });
                          },
                          icon: const Icon(Icons.cancel)),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  height: 400,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('Users')
                        .snapshots(),
                    builder: (context, snapshots) {
                      if ((snapshots.connectionState ==
                          ConnectionState.waiting)) {
                        return const Center(child: CircularProgressIndicator());
                      } else {
                        return ListView.builder(
                            itemCount: snapshots.data!.docs.length,
                            itemBuilder: (context, index) {
                              UserData userData = UserData.fromJson(
                                  snapshots.data!.docs[index].data()
                                      as Map<String, dynamic>);

                              if (userSearchInput.isEmpty) {
                                return Visibility(
                                  visible:
                                      userData.UID != Auth().currentUser!.uid,
                                  child: ListTile(
                                    title: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          userData.firstName +
                                              userData.lastName,
                                          style: TextStyle(
                                              fontFamily: 'Poppins',
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              fontSize: 18),
                                        ),
                                        Text(
                                          userData.email,
                                          style: TextStyle(
                                              fontFamily: 'Poppins',
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary
                                                  .withOpacity(0.4),
                                              fontSize: 12),
                                        ),
                                      ],
                                    ),
                                    contentPadding: const EdgeInsets.all(6),
                                    leading: FutureBuilder(
                                      //profile image
                                      future: FirebaseUsers()
                                          .getProfileImageURL(userData.UID),
                                      builder: ((context,
                                          AsyncSnapshot<String> snapshot) {
                                        return CircleAvatar(
                                          //border
                                          radius: 30,
                                          backgroundColor: Theme.of(context)
                                              .colorScheme
                                              .primary,

                                          child: CircleAvatar(
                                              radius: 26,
                                              backgroundColor: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              backgroundImage: snapshot.data !=
                                                      null
                                                  ? Image.network(
                                                          snapshot.data!)
                                                      .image
                                                  : Image.network(
                                                          "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png")
                                                      .image),
                                        );
                                      }),
                                    ),
                                    onTap: () {
                                      goToPage(context,
                                          ProfilePage(userUID: userData.UID));
                                    },
                                  ),
                                );
                              } else {
                                //everything in lower case to make search easier
                                if (userData.firstName.toLowerCase().contains(
                                        userSearchInput.toLowerCase()) ||
                                    userData.email.toLowerCase().contains(
                                        userSearchInput.toLowerCase())) {
                                  return Visibility(
                                    visible:
                                        userData.UID != Auth().currentUser!.uid,
                                    child: ListTile(
                                      title: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            userData.firstName +
                                                userData.lastName,
                                            style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.normal,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                                fontSize: 18),
                                          ),
                                          Text(
                                            userData.email,
                                            style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.normal,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary
                                                    .withOpacity(0.4),
                                                fontSize: 10),
                                          ),
                                        ],
                                      ),
                                      contentPadding: const EdgeInsets.all(6),
                                      leading: FutureBuilder(
                                        //profile image
                                        future: FirebaseUsers()
                                            .getProfileImageURL(userData.UID),
                                        builder: ((context,
                                            AsyncSnapshot<String> snapshot) {
                                          return CircleAvatar(
                                            //border
                                            radius: 30,
                                            backgroundColor: Theme.of(context)
                                                .colorScheme
                                                .primary,

                                            child: CircleAvatar(
                                                radius: 26,
                                                backgroundColor:
                                                    Theme.of(context)
                                                        .colorScheme
                                                        .primary,
                                                backgroundImage: snapshot
                                                            .data !=
                                                        null
                                                    ? Image.network(
                                                            snapshot.data!)
                                                        .image
                                                    : Image.network(
                                                            "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png")
                                                        .image),
                                          );
                                        }),
                                      ),
                                      onTap: () {
                                        goToPage(context,
                                            ProfilePage(userUID: userData.UID));
                                      },
                                    ),
                                  );
                                } else {
                                  return Container();
                                }
                              }
                            });
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
    ;
  }
}
