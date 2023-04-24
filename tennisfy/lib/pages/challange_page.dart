import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tennisfy/components/profile_image_avatar.dart';
import 'package:tennisfy/helpers/media_query_helpers.dart';
import 'package:tennisfy/helpers/services/firebase_users.dart';
import 'package:tennisfy/models/user_model.dart';

class ChallengePage extends StatefulWidget {
  UserData userData; //user that we are challenging
  ChallengePage({Key? key, required this.userData}) : super(key: key);

  @override
  State<ChallengePage> createState() => _ChallengePageState();
}

class _ChallengePageState extends State<ChallengePage> {
  bool _isCompetetive =
      true; //used to keep track of the invite mode, Competitive = true, Recreational = false
  final TextEditingController _inviteMessageController =
      TextEditingController();

  bool _sendingInvite = false;
  @override
  Widget build(BuildContext context) {
    UserData userData = widget.userData;

    return Scaffold(
      appBar: AppBar(
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
      body: SingleChildScrollView(
        child: Container(
          height: displayHeight(context) -
              85, //this is a temporary solution, fix this
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            //beacuse we have a mix of widget in the center and widget to the left, we ajust the indivually
            children: [
              Padding(
                //individual paddings because of the green decoration in the bottom
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Your challenging",
                        style: TextStyle(
                            fontSize: 28, fontWeight: FontWeight.w900),
                      ),
                    ),
                    SizedBox(height: displayHeight(context) * 0.01),
                    Container(
                      height: displayHeight(context) * 0.08,
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
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
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            ProfileImageAvatar(
                                userUID: userData.UID, radius: 28),
                            SizedBox(
                              width: displayWidth(context) * 0.04,
                            ),
                            Text(
                              userData.firstName + " " + userData.lastName,
                              style: const TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.w900),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  children: [
                    Column(
                      children: const [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Game mode",
                            style: TextStyle(
                                fontWeight: FontWeight.w900, fontSize: 20),
                          ),
                        ),
                        Text(
                          "A Competitive match result affect both user's ELO rating, while a Recreational mathc doens't",
                          style: TextStyle(
                              fontSize: 10, fontWeight: FontWeight.w400),
                        )
                      ],
                    ),
                    SizedBox(height: displayHeight(context) * 0.02),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _isCompetetive = true;
                            });
                          },
                          child: Row(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    height: 20,
                                    width: 20,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: _isCompetetive
                                            ? Theme.of(context)
                                                .colorScheme
                                                .secondary
                                            : Theme.of(context)
                                                .colorScheme
                                                .tertiary),
                                  ),
                                  const Text(
                                    'Competetive',
                                    style: TextStyle(fontSize: 16),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _isCompetetive = false;
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    height: 20,
                                    width: 20,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: !_isCompetetive
                                            ? Theme.of(context)
                                                .colorScheme
                                                .secondary
                                            : Theme.of(context)
                                                .colorScheme
                                                .tertiary),
                                  ),
                                  const Text(
                                    'Recreational',
                                    style: TextStyle(fontSize: 16),
                                  )
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Invite message",
                      style:
                          TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
                    ),
                    Text(
                      "If you want " +
                          userData.firstName +
                          " to know any adittional info you can write it here",
                      style: const TextStyle(
                          fontSize: 10, fontWeight: FontWeight.w400),
                    ),
                    SizedBox(height: displayHeight(context) * 0.02),
                    Container(
                      width: displayWidth(context),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.05),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                      ),
                      child: TextField(
                        maxLength: 300,
                        controller: _inviteMessageController,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        decoration: const InputDecoration(
                          counterText: "",
                          contentPadding: EdgeInsets.all(10),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: displayHeight(context) * 0.06,
                width: displayWidth(context) * 0.9,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextButton(
                    onPressed: () async {
                      _sendingInvite
                          ? null
                          :
                          //we can use this technique more often
                          setState(() {
                              _sendingInvite = true;
                            });
                      await FirebaseUsers().sendGameInvite(
                          userData.UID,
                          _isCompetetive,
                          _inviteMessageController.text.isEmpty
                              ? null
                              : _inviteMessageController.text);
                      setState(() {
                        _sendingInvite = false;
                      });
                      showDialog(
                        context: context,
                        builder: (_) => const AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          title: Center(
                            child: Text(
                              'Invite sent !',
                              style: TextStyle(
                                  fontWeight: FontWeight.w900, fontSize: 20),
                            ),
                          ),
                        ),
                      );

                      Future.delayed(const Duration(seconds: 1), () {
                        //is there a cleaner way to do this?
                        Navigator.pop(context);
                        Navigator.pop(context);
                        Navigator.pop(context);
                      });
                    },
                    child: _sendingInvite
                        ? CupertinoActivityIndicator(
                            color: Theme.of(context).colorScheme.tertiary,
                          )
                        : Text(
                            "Challenge",
                            style: TextStyle(
                                fontSize: 20,
                                color: Theme.of(context).colorScheme.tertiary),
                          )),
              ),
              Container(
                width: displayWidth(context),
                height: displayHeight(context) * 0.3,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Container(
                      width: displayWidth(context),
                      height: displayHeight(context) * 0.14,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    Image.asset(
                      "assets/images/single_player_cartoon.png",
                      scale: 1.5,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class SuccessPopup extends StatefulWidget {
  final String message;

  const SuccessPopup({Key? key, required this.message}) : super(key: key);

  @override
  _SuccessPopupState createState() => _SuccessPopupState();
}

class _SuccessPopupState extends State<SuccessPopup>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _animation =
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);

    _animationController.forward();

    Future.delayed(const Duration(seconds: 1)).then((_) {
      if (mounted) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.message),
      content: ScaleTransition(
        scale: _animation,
        child: Image.asset('assets/checkmark.png'),
      ),
    );
  }
}
