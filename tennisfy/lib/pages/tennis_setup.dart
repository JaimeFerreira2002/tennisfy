import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:tennisfy/helpers/media_query_helpers.dart';
import 'package:tennisfy/pages/elo_show_page.dart';
import '../helpers/services/auth.dart';
import '../models/user_model.dart';

class TennisSetup extends StatefulWidget {
  UserData currentUserData;
  File profileImage;
  TennisSetup(
      {Key? key, required this.currentUserData, required this.profileImage})
      : super(key: key);

  @override
  State<TennisSetup> createState() => _TennisSetupState();
}

class _TennisSetupState extends State<TennisSetup> {
  int _questionSelected = 0; //used to keep track of withc quastions the user is
  //be aware thet questionSelectd is from 0 to 3

  //list of each of the three answers the user  choose, the values are from 1 to 4
  final List<int> _answersSelected = [0, 0, 0, 0];

  //list with all the answers labels
  final List<List<String>> _answersList = [
    ["0 - 6 months", "6 months - 1 year", "1 - 3 years", "3+ years"],
    ["Recreational", "Amateur", "Semi - Professional", "Professional"],
    ["0 - 5", "5 - 10", "10 - 20", "20+"],
    ["No", "0 - 6 Months", "6 months - 1 year", "1+ years"]
  ];

  String _errorMessage = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Container(
          height: 100,
        ),
      ),
      body: Column(
        children: [
          Container(
            height: displayHeight(context) * 0.35,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "About Tennis",
                          style: Theme.of(context).textTheme.headline1,
                        ),
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.arrow_back))
                      ],
                    ),
                  ),
                  SizedBox(height: displayHeight(context) * 0.01),
                  Text(
                    "Now let's get a fell for your tennis level. For us to be able to provide you with the best experience possible, we ask you to answer the following questions as honestly as possible.",
                    style: Theme.of(context).textTheme.subtitle1,
                  )
                ],
              ),
            ),
          ),
          //this values have to add up to 0,85, to put the green container in the bottom of the page
          Container(
            height: displayHeight(context) * 0.35,
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    child: Stack(
                      children: [
                        _Question(0, _answersList[0],
                            "For how long have you been playing ?"),
                        _Question(1, _answersList[1],
                            "What is your current level of competition ?"),
                        _Question(2, _answersList[2],
                            "How often do you play or practice monthly ?"),
                        _Question(3, _answersList[3],
                            "Have you haver taken lesson from a coach? If so, for how long ?"),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: displayWidth(context) * 0.4,
                        height: displayHeight(context) * 0.01,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: Theme.of(context).colorScheme.secondary,
                                width: 1),
                            color: Theme.of(context).colorScheme.tertiary),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: AnimatedContainer(
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeInOutSine,
                              width: displayWidth(context) *
                                  0.1 *
                                  (_questionSelected + 1),
                              height: displayHeight(context) * 0.01,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color:
                                      Theme.of(context).colorScheme.secondary)),
                        ),
                      ),
                      AnimatedOpacity(
                        opacity: _questionSelected != 0 ? 1 : 0,
                        duration: const Duration(milliseconds: 200),
                        child: Container(
                          //when the button doesnt have a shadow, the container is unecessary, just use TextButton, but for some reason, color doens t work on buttonStyle
                          width: displayWidth(context) * 0.1,
                          height: displayHeight(context) * 0.05,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.secondary,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                          ),
                          child: IconButton(
                              onPressed: () {
                                setState(() {
                                  _questionSelected == 0
                                      ? null
                                      : _questionSelected--;
                                });
                              },
                              icon: const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                              )),
                        ),
                      ),
                      Container(
                        //when the button doesnt have a shadow, the container is unecessary, just use TextButton, but for some reason, color doens t work on buttonStyle
                        width: displayWidth(context) * 0.3,
                        height: displayHeight(context) * 0.05,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                        ),
                        child: TextButton(
                            onPressed: () {
                              if (_questionSelected == 3) {
                                if (_answersSelected[0] == 0 ||
                                    _answersSelected[1] == 0 ||
                                    _answersSelected[2] == 0 ||
                                    _answersSelected[3] == 0) {
                                  setState(() {
                                    _errorMessage =
                                        "Please answer all questions";
                                  });
                                } else {
                                  setState(() {
                                    _errorMessage = "";
                                  });
                                  _updateUserData();
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EloShowPage(
                                            ELO: _calculateNewELO(
                                                _answersSelected[0],
                                                _answersSelected[1],
                                                _answersSelected[2],
                                                _answersSelected[3]))),
                                    (Route<dynamic> route) => false,
                                  );
                                }
                              } else {
                                setState(() {
                                  _questionSelected++;
                                });
                              }
                            },
                            child: Text(
                              _questionSelected == 3 ? "Finish" : "Next",
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.tertiary,
                                  fontSize: 16),
                            )),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Text(
            _errorMessage,
            style: const TextStyle(
                fontSize: 12, color: Color.fromARGB(255, 212, 97, 88)),
          ),
          Container(
            height: displayHeight(context) * 0.2825,
            child: Stack(children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: displayHeight(context) * 0.10,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              AnimatedPositioned(
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeInOutCirc,
                left: displayWidth(context) * 0.2 -
                    _questionSelected * displayWidth(context),
                child: Image.asset(
                  "assets/images/tennis_serve_cartoon.png",
                  scale: 1.6,
                ),
              ),
              AnimatedPositioned(
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeInOutCirc,
                top: displayHeight(context) * 0.09,
                left: displayWidth(context) * 0.16 -
                    (_questionSelected - 1) * displayWidth(context),
                child: Image.asset(
                  "assets/images/tennis_net_cartoon.png",
                  scale: 6,
                ),
              ),
              AnimatedPositioned(
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeInOutCirc,
                left: displayWidth(context) * 0.2 -
                    (_questionSelected - 2) * displayWidth(context),
                child: Image.asset(
                  "assets/images/tennis_reciever_cartoon.png",
                  scale: 1.1,
                ),
              ),
            ]),
          )
        ],
      ),
    );
  }

//each of the answers row, qeuestionnumber is to know with of the questions the row is, answer number is to know with of the answers it is
  Padding _QuestionRowButton(
      int questionNumber, int answerNumber, String label) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _answersSelected[questionNumber] = answerNumber;
          });
        },
        child: Row(
          children: [
            Container(
              height: 16,
              width: 16,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: _answersSelected[questionNumber] == answerNumber
                      ? Theme.of(context).colorScheme.secondary
                      : Colors.white,
                  border: Border.all(
                      color: const Color.fromARGB(255, 54, 54, 54),
                      width: 1.6)),
            ),
            SizedBox(
              width: displayWidth(context) * 0.08,
            ),
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  AnimatedPositioned _Question(
      int questionNumber, List<String> answers, String question) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOutCirc,
      left: _questionSelected == questionNumber
          ? displayWidth(context) * 0.06
          : _questionSelected - questionNumber > 0
              ? -displayWidth(context) * 0.8 * (questionNumber + 1)
              : displayWidth(context) * 0.8 * (questionNumber + 1),
      child: Container(
        width: displayWidth(context) * 0.8,
        child: Column(
          children: [
            Align(alignment: Alignment.centerLeft, child: Text(question)),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _QuestionRowButton(questionNumber, 1, answers[0]),
                  _QuestionRowButton(questionNumber, 2, answers[1]),
                  _QuestionRowButton(questionNumber, 3, answers[2]),
                  _QuestionRowButton(questionNumber, 4, answers[3])
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _updateUserData() {
    int _newELO = _calculateNewELO(_answersSelected[0], _answersSelected[1],
        _answersSelected[2], _answersSelected[3]);
//create updated userData
    UserData newUser = UserData(
      UID: Auth().currentUser!.uid,
      email: Auth().currentUser!.email!,
      firstName: widget.currentUserData.firstName,
      lastName: widget.currentUserData.lastName,
      dateOfBirth: widget.currentUserData.dateOfBirth,
      sex: widget.currentUserData.sex,
      bio: widget.currentUserData.bio,
      location: widget.currentUserData.location,
      ELO: _newELO,
      hasSetupAccount: true,
      gamesPlayed: [],
      friendsList: [],
      nextGamesList: [],
      gamesInvitesList: [],
      reputation: 0.0,
      dateJoined: DateTime.now(),
      comments: [],
      friendRequests: [],
      ELOHistory: [
        _newELO,
      ],
      chatsIds: [],
    );

    //update firebase instace of this user
    final json = newUser.toJson();
    FirebaseFirestore.instance
        .collection('Users')
        .doc(Auth().currentUser!.uid.toString())
        .update(json);

    //last we update the user profile image in Firebase Storage
    _uploadImage();
  }

  void _uploadImage() async {
    final _firabaseStorage = FirebaseStorage.instance;
    await _firabaseStorage
        .ref()
        .child("ProfilePictures/" + Auth().currentUser!.uid.toString() + ".jpg")
        .putFile(widget.profileImage);
  }

//all the parameters are values from 0 to 3 - representing the users answers
  int _calculateNewELO(
      int playTime, int competitionLevel, int playFrequency, int lessonTime) {
    //base ELO, if a user has the lowest on all questions, this is his ELO
    int baseELO = 20;

    // Calculate the user's total play time
    int totalPlayTime = (playTime - 1) * 30;

    // Calculate the user's competition level multiplier
    int competitionMultiplier = (competitionLevel - 1) * 50;

    // Calculate the user's play frequency multiplier
    int playFrequencyMultiplier = (playFrequency - 1) * 20;

    // Calculate the user's lesson time multiplier
    int lessonMultiplier = (lessonTime - 1) * 20;

    // Calculate the user's total rating
    int rating = baseELO +
        totalPlayTime +
        competitionMultiplier +
        playFrequencyMultiplier +
        lessonMultiplier;

    // Make sure the rating is within the range of 0 to 200
    if (rating > 200) {
      return 200;
    } else if (rating < 0) {
      return 0;
    } else {
      return rating;
    }
  }

  Widget _showPopupDialog(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.all(12),
      contentPadding: const EdgeInsets.all(14),
      content: Text(
        "Give a short description of yourself, think of what you would like to know about a person your going to play against.",
        style: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }
}
