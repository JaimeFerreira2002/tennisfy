import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tennisfy/helpers/services/firebase_users.dart';
import 'package:tennisfy/pages/nav_bar.dart';
import '../models/user_model.dart';
import '../pages/login_and_register_page.dart';
import '../pages/verify_email_page.dart';
import 'services/auth.dart';

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
          return MultiProvider(
            providers: [
              //userData
              StreamProvider<UserData?>.value(
                value: FirebaseUsers().getUserDataStream(Auth().currentUserUID),
                initialData: null,
              ),
            ],
            //change this to remove future builer, use provider
            child: FutureBuilder(
              future: FirebaseUsers()
                  .getUserHasSetupAccount(Auth().currentUser!.uid),
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
            ),
          );
        } else {
          return const LoginAndRegisterPage();
        }
      },
    );
  }
}
