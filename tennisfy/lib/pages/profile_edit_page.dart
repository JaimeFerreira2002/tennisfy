import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tennisfy/helpers/auth.dart';
import 'package:tennisfy/helpers/media_query_helpers.dart';

import '../helpers/services/firebase_getters.dart';

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({Key? key}) : super(key: key);

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  final TextEditingController _newFirstNameController = TextEditingController();
  final TextEditingController _newLastNameController = TextEditingController();
  bool hasPickedProfileImage = false;
  File profilePickedImage = File('assets/images/Empty_Profile_Image.png');
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Edit profile",
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
        ),
        body: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  !hasPickedProfileImage
                      ? FutureBuilder(
                          future: getProfileImageURL(Auth().currentUser!.uid),
                          initialData: "Loading...",
                          builder: ((context, AsyncSnapshot<String> snapshot) {
                            return CircleAvatar(
                                radius: 65,
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                                backgroundImage: snapshot.data != null
                                    ? Image.network(snapshot.data!).image
                                    : Image.network(
                                            "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png")
                                        .image);
                          }),
                        )
                      : CircleAvatar(
                          radius: 65,
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          backgroundImage: FileImage(profilePickedImage),
                        ),
                  Container(
                    width: displayWidth(context) * 0.5,
                    height: displayHeight(context) * 0.05,
                    child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.secondary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13),
                          ),
                        ),
                        onPressed: () {
                          pickProfileImage();
                        },
                        child: Text(
                          "Change profile image",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Theme.of(context).colorScheme.tertiary),
                        )),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FutureBuilder(
                    future: getUserFirstName(Auth().currentUser!.uid),
                    initialData: "Loading",
                    builder: ((BuildContext context,
                        AsyncSnapshot<String> snapshot) {
                      return Container(
                        height: displayHeight(context) * 0.074,
                        width: displayWidth(context) * 0.45,
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
                        child: TextField(
                          controller: _newFirstNameController,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(20),
                            hintText: snapshot.data!,
                            hintStyle: const TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Color.fromARGB(255, 178, 178, 178)),
                            border: InputBorder.none,
                          ),
                        ),
                      );
                    }),
                  ),
                  FutureBuilder(
                    future: getUserLastName(Auth().currentUser!.uid),
                    initialData: "Loading",
                    builder: ((BuildContext context,
                        AsyncSnapshot<String> snapshot) {
                      return Container(
                        height: displayHeight(context) * 0.074,
                        width: displayWidth(context) * 0.45,
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
                        child: TextField(
                          controller: _newLastNameController,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(20),
                            hintText: snapshot.data!,
                            hintStyle: const TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Color.fromARGB(255, 178, 178, 178)),
                            border: InputBorder.none,
                          ),
                        ),
                      );
                    }),
                  )
                ],
              ),
              SizedBox(height: 300),
              Container(
                width: displayWidth(context) * 0.9,
                height: displayHeight(context) * 0.06,
                child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13),
                      ),
                    ),
                    onPressed: () {
                      updateProfile(_newFirstNameController.text,
                          _newLastNameController.text);
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Save",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.tertiary),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }

  void updateProfile(String newFirstName, String newLastName) async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(Auth().currentUser!.uid)
        .update({'FirstName': newFirstName, 'LastName': newLastName});
  }

  Future pickProfileImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;
    final imageTemp = File(image.path);
    setState(() => profilePickedImage = imageTemp);
    setState(() {
      hasPickedProfileImage = true;
    });
  }
}
