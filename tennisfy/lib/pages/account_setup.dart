import 'dart:io';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tennisfy/helpers/auth.dart';
import 'package:tennisfy/helpers/helper_methods.dart';
import 'package:tennisfy/helpers/media_query_helpers.dart';
import 'package:tennisfy/models/user_model.dart';
import 'package:tennisfy/pages/tennis_setup.dart';

class AccountSetup extends StatefulWidget {
  const AccountSetup({Key? key}) : super(key: key);

  @override
  State<AccountSetup> createState() => _AccountSetupState();
}

class _AccountSetupState extends State<AccountSetup> {
  File profileImage = File("assets/images/profileImagePlaceHolder.png");
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  bool _hasPickedDate = false;
  String datePickerHintText = "Enter your date of birth";
  DateTime datePicked = DateTime.now();
  bool sexSelected = true;
  String _errorMessage = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: SingleChildScrollView(
          child: Container(
            //this container is needed because of SingleChildScrollView, to fill the whole screen
            height: displayHeight(context),
            child: Padding(
              //padding for the whole page, then we use indidual pasddings for space between, this one is necessary to ajust top and bottom page
              padding: const EdgeInsets.fromLTRB(14, 70, 14, 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      //why several aligns? and not just on in column
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Welcome",
                          style: Theme.of(context).textTheme.headline1,
                        ),
                      ),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "We are thrilled to have you in our community!",
                            style: Theme.of(context).textTheme.bodyText1,
                          )),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Now let's get started by setting up your profile",
                            style: Theme.of(context).textTheme.bodyText1,
                          ))
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          height: displayHeight(context) * 0.22,
                          width: displayHeight(context) * 0.22,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).colorScheme.primary,
                            image: DecorationImage(
                                image: FileImage(profileImage), // placeholder
                                fit: BoxFit.cover),
                          ),
                        ),
                        SizedBox(width: displayWidth(context) * 0.02),
                        Container(
                          height: displayHeight(context) * 0.05,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.tertiary,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            boxShadow: [
                              BoxShadow(
                                offset: Offset(0, 0),
                                blurRadius: 8.0,
                                spreadRadius: 0.5,
                                color: const Color.fromARGB(255, 59, 59, 59)
                                    .withOpacity(0.2),
                              ),
                            ],
                          ),
                          child: TextButton(
                              onPressed: () {
                                pickImage();
                              },
                              child: const Text(
                                "Upload Photo",
                                style: TextStyle(fontSize: 12),
                              )),
                        )
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 7, 0, 7),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _genreSelectionButton(true),
                        _genreSelectionButton(false),
                      ],
                    ),
                  ),
                  //change CostumTextField to take in height and width, to be able to be more costumizable
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 7, 0, 7),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: displayHeight(context) * 0.074,
                          width: displayWidth(context) * 0.45,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.tertiary,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            boxShadow: [
                              BoxShadow(
                                offset: Offset(0, 0),
                                blurRadius: 8.0,
                                spreadRadius: 0.5,
                                color: const Color.fromARGB(255, 59, 59, 59)
                                    .withOpacity(0.2),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: _firstNameController,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.all(20),
                              hintText: "First Name",
                              hintStyle: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Color.fromARGB(255, 178, 178, 178)),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        Container(
                          height: displayHeight(context) * 0.074,
                          width: displayWidth(context) * 0.45,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.tertiary,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            boxShadow: [
                              BoxShadow(
                                offset: Offset(0, 0),
                                blurRadius: 8.0,
                                spreadRadius: 0.5,
                                color: const Color.fromARGB(255, 59, 59, 59)
                                    .withOpacity(0.2),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: _lastNameController,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.all(20),
                              hintText: "Last Name",
                              hintStyle: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Color.fromARGB(255, 178, 178, 178)),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 7, 0, 7),
                    child: Container(
                      height: displayHeight(context) * 0.074,
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        color: Theme.of(context).colorScheme.tertiary,
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 0),
                            blurRadius: 8.0,
                            spreadRadius: 0.5,
                            color: const Color.fromARGB(255, 59, 59, 59)
                                .withOpacity(0.2),
                          ),
                        ],
                      ),
                      child: TextField(
                        readOnly: true,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(20),
                          hintText: datePickerHintText,
                          hintStyle: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: !_hasPickedDate
                                  ? const Color.fromARGB(255, 178, 178, 178)
                                  : Theme.of(context).colorScheme.primary),
                          border: InputBorder.none,
                        ),
                        onTap: () async {
                          showCupertinoModalPopup(
                              context: context,
                              builder: (BuildContext context) => Container(
                                    height: 250,
                                    child: CupertinoDatePicker(
                                        mode: CupertinoDatePickerMode.date,
                                        maximumDate: DateTime(
                                            DateTime.now().year - 18,
                                            DateTime.now().month,
                                            DateTime.now().day),
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .tertiary,
                                        initialDateTime: DateTime(
                                            DateTime.now().year - 18,
                                            DateTime.now().month,
                                            DateTime.now().day),
                                        onDateTimeChanged: (DateTime newDate) {
                                          setState(() {
                                            datePicked = newDate;
                                            if (datePicked == DateTime.now()) {
                                              return;
                                            } else {
                                              setState(() {
                                                _hasPickedDate = true;

                                                datePickerHintText = datePicked
                                                        .day
                                                        .toString() +
                                                    " / " +
                                                    datePicked.month
                                                        .toString() +
                                                    " / " +
                                                    datePicked.year.toString();
                                              });
                                            }
                                          });
                                        }),
                                  ));
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 7, 0, 7),
                    child: Container(
                      height: displayHeight(context) * 0.1,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.tertiary,
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 0),
                            blurRadius: 8.0,
                            spreadRadius: 0.5,
                            color: const Color.fromARGB(255, 59, 59, 59)
                                .withOpacity(0.2),
                          ),
                        ],
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                      ),
                      child: TextField(
                        maxLines: null,
                        maxLength: 300,
                        controller: _bioController,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(20),
                          counterText: "",
                          hintText: "Give us a short description about youself",
                          hintStyle: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Color.fromARGB(255, 178, 178, 178)),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    _errorMessage,
                    style: const TextStyle(
                        fontSize: 12, color: Color.fromARGB(255, 212, 97, 88)),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 7, 0, 7),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                            onPressed: () {
                              signOut();
                            },
                            child: const Text(
                              "Sign out",
                              style: TextStyle(
                                fontSize: 14,
                                color: Color.fromARGB(255, 212, 97, 88),
                              ),
                            )),
                        Container(
                          //when the button doesnt have a shadow, the container is unecessary, just use TextButton, but for some reason, color doens t work on buttonStyle
                          width: displayWidth(context) * 0.3,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.secondary,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                          ),
                          child: TextButton(
                              onPressed: () {
                                if (!_advancePageCheck()) {
                                  setState(() {
                                    _errorMessage = "Missing information";
                                  });
                                } else {
                                  setState(() {
                                    _errorMessage = "";
                                  });
                                  //here we create a userObject with the data we have and send as an argument to the TennisSetupPage, to update there
                                  goToPage(
                                      context,
                                      TennisSetup(
                                        profileImage: profileImage,
                                        currentUserData: UserData(
                                            UID: Auth().currentUser!.uid,
                                            email: Auth().currentUser!.email!,
                                            firstName:
                                                _firstNameController.text,
                                            lastName: _lastNameController.text,
                                            dateOfBirth: datePicked,
                                            sex:
                                                sexSelected ? "Male" : "Female",
                                            bio: _bioController.text,
                                            ELO: 0,
                                            hasSetupAccount: false,
                                            gamesPlayed: [],
                                            friendsList: [],
                                            nextGamesList: [],
                                            reputation: 0,
                                            dateJoined: DateTime.now(),
                                            comments: [],
                                            friendRequests: [],
                                            ELOHistory: [],
                                            chatsIds: []),
                                      ));
                                }
                              },
                              child: Text(
                                "Next",
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.tertiary,
                                    fontSize: 16),
                              )),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  GestureDetector _genreSelectionButton(bool sex) {
    return GestureDetector(
      onTap: () {
        setState(() {
          sexSelected = sex;
        });
      },
      child: AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          curve: Curves.decelerate,
          height: 45,
          width: sexSelected == sex
              ? MediaQuery.of(context).size.width * 0.6
              : MediaQuery.of(context).size.width * 0.3,
          decoration: BoxDecoration(
              color: sexSelected == sex
                  ? Theme.of(context).colorScheme.secondary
                  : Theme.of(context).colorScheme.tertiary,
              borderRadius: BorderRadius.circular(10),
              border: sexSelected == sex
                  ? null
                  : Border.all(
                      color: Theme.of(context).colorScheme.secondary,
                      width: 3)),
          child: Icon(
            sex ? Icons.male : Icons.female,
            size: 35,
            color: sexSelected == sex
                ? Theme.of(context).colorScheme.tertiary
                : Theme.of(context).colorScheme.secondary,
          )),
    );
  }

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() => profileImage = imageTemp);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  bool _advancePageCheck() {
    return _firstNameController.text.isNotEmpty &&
        _lastNameController.text.isNotEmpty &&
        _hasPickedDate &&
        _bioController.text.isNotEmpty;
  }
}
