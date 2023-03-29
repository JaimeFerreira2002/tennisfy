import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tennisfy/components/costum_text_field.dart';
import 'package:tennisfy/helpers/media_query_helpers.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController =
      TextEditingController();
  bool _isRegsiterPage = false;

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
          child: Center(
            child: Stack(
              children: [
                Column(
                  children: [
                    Container(
                      child: Center(
                        child: Container(
                          child: Image.asset(
                            "assets/images/logo.png",
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(14),
                      child: Container(
                        child: CostumTextField(
                            textController: _emailController,
                            hintText: "Enter your email",
                            isPassword: false),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(14),
                      child: Container(
                        child: CostumTextField(
                            textController: _passwordController,
                            hintText: "Enter your password",
                            isPassword: true),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(14),
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 500),
                        opacity: _isRegsiterPage ? 1 : 0,
                        curve: Curves.easeInOutBack,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 700),
                          height: !_isRegsiterPage ? 0 : 60,
                          curve: Curves.easeInOutCirc,
                          child: CostumTextField(
                              textController: _passwordConfirmController,
                              hintText: "Confirm your password",
                              isPassword: true),
                        ),
                      ),
                    ),
                    SizedBox(height: displayHeight(context) * 0.03),
                    Container(
                      //here a container is necessary to ajust button size
                      width: displayWidth(context) * 0.9,
                      height: displayHeight(context) * 0.06,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: TextButton(
                        onPressed: () {},
                        child: AnimatedCrossFade(
                          //is it good?
                          crossFadeState: _isRegsiterPage
                              ? CrossFadeState.showSecond
                              : CrossFadeState.showFirst,
                          duration: const Duration(milliseconds: 600),
                          firstChild: const Text(
                            "Sign in",
                            style: TextStyle(
                                //why doesnt button style from Theme() work here?
                                fontFamily: 'Poppins',
                                fontSize: 22,
                                color: Color.fromARGB(255, 255, 255, 255),
                                fontWeight: FontWeight.w900),
                          ),
                          secondChild: const Text(
                            "Create Account",
                            style: TextStyle(
                                //why doesnt button style from Theme() work here?
                                fontFamily: 'Poppins',
                                fontSize: 22,
                                color: Color.fromARGB(255, 255, 255, 255),
                                fontWeight: FontWeight.w900),
                          ),
                        ),
                        style: TextButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.secondary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(!_isRegsiterPage
                            ? "Not a member yet?"
                            : "Already a member?"),
                        TextButton(
                            onPressed: () {
                              setState(() {
                                _isRegsiterPage = !_isRegsiterPage;
                              });
                            },
                            child: Text(
                              "Create Account",
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 16,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  fontWeight: FontWeight.w900),
                            ))
                      ],
                    ),
                    SizedBox(
                      height: displayHeight(context) * 0.3,
                    )
                  ],
                ),
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOutCirc,
                  top: !_isRegsiterPage
                      ? displayHeight(context) * 0.7
                      : displayHeight(context) * 0.85,
                  left: displayWidth(context) * -0.2,
                  child: Container(
                    child: Image.asset("assets/images/tennis_court.png"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
