import 'package:flutter/material.dart';

class TennisSetupIntro extends StatefulWidget {
  const TennisSetupIntro({Key? key}) : super(key: key);

  @override
  State<TennisSetupIntro> createState() => _TennisSetupIntroState();
}

class _TennisSetupIntroState extends State<TennisSetupIntro> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Back")),
      ),
    );
  }
}
