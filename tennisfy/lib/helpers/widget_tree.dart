import 'package:flutter/material.dart';
import 'package:tennisfy/helpers/services/firebase_getters.dart';
import 'package:tennisfy/pages/elo_show_page.dart';
import 'package:tennisfy/pages/nav_bar.dart';

import '../pages/login_and_register_page.dart';
import '../pages/verify_email_page.dart';
import 'auth.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({Key? key}) : super(key: key);
  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return FutureBuilder(
            future: getUserHasSetupAccount(Auth().currentUser!.uid),
            builder: ((context, AsyncSnapshot<bool> userData) {
              if (userData.connectionState == ConnectionState.waiting) {
                //loading page
                return Scaffold(
                  body: Center(
                    child: SizedBox(
                      height: 320,
                      child: Image.asset(
                        'assets/images/logo.png',
                        width: 300,
                        height: 300,
                      ),
                    ),
                  ),
                );
              } else {
                if (userData.data == true) {
                  return const NavBar();
                } else {
                  return const VerifyEmailPage();
                }
              }
            }),
          );
        } else {
          return const LoginAndRegisterPage();
        }
      },
    );
  }
}
