import 'package:flutter/material.dart';
import 'package:tennisfy/helpers/services/firebase_getters.dart';
import 'package:tennisfy/pages/profile_page.dart';
import '../helpers/auth.dart';
import '../helpers/helper_methods.dart';
import '../helpers/media_query_helpers.dart';
import '../pages/settings_page.dart';

AppBar costunAppBar(BuildContext context) {
  return AppBar(
    title: Image.asset("assets/images/logo.png"),
    titleSpacing: 0,
    bottom: PreferredSize(
      child: Container(
        color: Theme.of(context)
            .colorScheme
            .primary
            .withOpacity(0.2), // choose your desired color
        height: 1.5, // choose your desired height
      ),
      preferredSize: const Size.fromHeight(0.0),
    ),
    actions: [
      Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 10, 0),
        child: GestureDetector(
          onTap: () {
            goToPage(context, ProfilePage(userUID: Auth().currentUser!.uid));
          },
          child: Row(
            children: [
              FutureBuilder(
                future: getProfileImageURL(Auth().currentUser!.uid),
                initialData: "Loading...",
                builder: ((context, AsyncSnapshot<String> snapshot) {
                  return CircleAvatar(
                      radius: 18,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      backgroundImage: snapshot.data != null
                          ? Image.network(snapshot.data!).image
                          : Image.network(
                                  "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png")
                              .image);
                }),
              ),
              SizedBox(
                width: displayWidth(context) * 0.02,
              ),
              FutureBuilder(
                initialData: "Loading",
                future: getUserFullName(Auth().currentUser!.uid),
                builder: ((context, AsyncSnapshot<String> snapshot) {
                  debugPrint(snapshot.data);
                  return Text(
                    snapshot.data!,

                    //here we need a costum text style, non of the establushed fits good
                  );
                }),
              ),
            ],
          ),
        ),
      ),
      IconButton(
          onPressed: () {
            goToPage(context, SettingsPage());
          },
          icon: Icon(
            Icons.settings_rounded,
            size: 30,
            color: Theme.of(context).colorScheme.primary,
          ))
    ],
  );
}
