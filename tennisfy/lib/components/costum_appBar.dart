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
        builder: (BuildContext context, currentUserData, Widget? child) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 10, 0),
            child: GestureDetector(
              onTap: () {
                goToPage(
                    context,
                    ProfilePage(
                      userData: currentUserData,
                    ));
              },
              child: Row(
                children: [
                  CircleAvatar(
                      radius: 18,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      backgroundImage: Provider.of<String?>(context) != null
                          ? Image.network(Provider.of<String?>(context)!).image
                          : Image.network(
                                  "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png")
                              .image),
                  SizedBox(
                    width: displayWidth(context) * 0.02,
                  ),
                  currentUserData == null
                      ? const SkeletonLine()
                      : Text(
                          currentUserData.firstName +
                              " " +
                              currentUserData.lastName,
                        )
                ],
              ),
            ),
          );
        },
      ),
      IconButton(
          onPressed: () {
            goToPage(
                context,
                SettingsPage(
                  currentUserData:
                      Provider.of<UserData?>(context, listen: false),
                )); //find a better solution here, hwat does listen do
          },
          icon: Icon(
            Icons.settings_rounded,
            size: 30,
            color: Theme.of(context).colorScheme.primary,
          ))
    ],
  );
}
