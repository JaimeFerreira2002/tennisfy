import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletons/skeletons.dart';
import 'package:tennisfy/components/profile_image_avatar.dart';
import 'package:tennisfy/models/user_model.dart';
import 'package:tennisfy/pages/profile_page.dart';
import '../helpers/services/auth.dart';
import '../helpers/helper_methods.dart';
import '../helpers/media_query_helpers.dart';
import '../pages/settings_page.dart';

AppBar costumAppBar(
  BuildContext context,
) {
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
      Consumer<UserData?>(
        builder: (BuildContext context, userData, Widget? child) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 10, 0),
            child: GestureDetector(
              onTap: () {
                goToPage(
                    context, ProfilePage(userUID: Auth().currentUser!.uid));
              },
              child: Row(
                children: [
                  ProfileImageAvatar(
                      userUID: Auth().currentUserUID, radius: 18),
                  SizedBox(
                    width: displayWidth(context) * 0.02,
                  ),
                  userData == null
                      ? const SkeletonLine()
                      : Text(
                          userData.firstName + " " + userData.lastName,

                          //here we need a costum text style, non of the establushed fits good
                        )
                ],
              ),
            ),
          );
        },
      ),
      IconButton(
          onPressed: () {
            goToPage(context, const SettingsPage());
          },
          icon: Icon(
            Icons.settings_rounded,
            size: 30,
            color: Theme.of(context).colorScheme.primary,
          ))
    ],
  );
}
