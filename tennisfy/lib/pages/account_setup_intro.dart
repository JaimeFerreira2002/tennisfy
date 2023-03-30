import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tennisfy/helpers/helper_methods.dart';
import 'package:tennisfy/helpers/media_query_helpers.dart';
import 'package:tennisfy/pages/tennis_setup_intro.dart';

class AccountSetupIntro extends StatefulWidget {
  const AccountSetupIntro({Key? key}) : super(key: key);

  @override
  State<AccountSetupIntro> createState() => _AccountSetupIntroState();
}

class _AccountSetupIntroState extends State<AccountSetupIntro> {
  File profileImage = File("assets/images/profileImagePlaceHolder.png");
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  bool _hasPickedDate = false;
  String datePickerHintText = "Enter your date of birth";
  DateTime datePicked = DateTime.now();
  bool sexSelected = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          //this container is needed because of SingleChildScrollView, to fill the whole screen
          height: displayHeight(context),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    children: [
                      //why several aligns? and not just on in column
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Welcome",
                          style: Theme.of(context).textTheme.headline1,
                        ),
                      ),
                      const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                              "We are thrilled to have you in our community!")),
                      const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                              "Now let's get started by setting up your profile"))
                    ],
                  ),
                ),
                Row(
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
                    Container(
                      height: displayHeight(context) * 0.05,
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
                Padding(
                  padding: const EdgeInsets.all(14),
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
                  padding: const EdgeInsets.all(14),
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
                              offset: const Offset(0, 0),
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
                              offset: const Offset(0, 0),
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
                  padding: const EdgeInsets.all(14.0),
                  child: Container(
                    height: displayHeight(context) * 0.074,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      color: Theme.of(context).colorScheme.tertiary,
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
                        DateTime? newDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1950),
                            lastDate: DateTime.now());

                        if (newDate == null) {
                          return;
                        } else {
                          setState(() {
                            _hasPickedDate = true;
                            datePicked = newDate;
                            datePickerHintText = newDate.day.toString() +
                                " / " +
                                newDate.month.toString() +
                                " / " +
                                newDate.year.toString();
                          });
                        }
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Container(
                    height: displayHeight(context) * 0.1,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.tertiary,
                      boxShadow: [
                        BoxShadow(
                          offset: const Offset(0, 0),
                          blurRadius: 8.0,
                          spreadRadius: 0.5,
                          color: const Color.fromARGB(255, 59, 59, 59)
                              .withOpacity(0.2),
                        ),
                      ],
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
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
                Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      width: displayWidth(context) * 0.3,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                      ),
                      child: TextButton(
                          onPressed: () {
                            goToPage(context, TennisSetupIntro());
                          },
                          child: Text(
                            "Next",
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.tertiary,
                                fontSize: 16),
                          )),
                    ),
                  ),
                )
              ],
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
              ? MediaQuery.of(context).size.width * 0.5
              : MediaQuery.of(context).size.width * 0.4,
          decoration: BoxDecoration(
              color: sexSelected == sex
                  ? Theme.of(context).colorScheme.secondary
                  : Theme.of(context).colorScheme.tertiary,
              borderRadius: BorderRadius.circular(30),
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

  Widget _showPopupDialog(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.all(12),
      contentPadding: const EdgeInsets.all(14),
      content: Text(
        "Give a short description of yourself, think of what you would like to know about a person your going to play against.",
        style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.6),
            fontSize: 14),
      ),
    );
  }
}
