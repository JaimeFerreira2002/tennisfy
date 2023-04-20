import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';
import '../helpers/services/firebase_users.dart';

class ProfileImageAvatar extends StatelessWidget {
  String userUID;
  double radius;
  ProfileImageAvatar({Key? key, required this.userUID, required this.radius})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseUsers().getProfileImageURL(userUID),
      builder: ((context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SkeletonAvatar(
            style: SkeletonAvatarStyle(
                width: radius * 2,
                height: radius * 2,
                borderRadius: BorderRadius.circular(20)),
          );
        }
        return CircleAvatar(
            radius: radius,
            backgroundColor: Theme.of(context).colorScheme.primary,
            backgroundImage: snapshot.data != null
                ? Image.network(snapshot.data!).image
                : Image.network(
                        "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png")
                    .image);
      }),
    );
  }
}
