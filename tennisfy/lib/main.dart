import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tennisfy/helpers/widget_tree.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: Platform.isIOS
          //used to override bold text on iphone, only run the mediaquery builder when in IOS,because when it runs in android, it lags a
          ? (context, child) => MediaQuery(
                data: MediaQuery.of(context).copyWith(boldText: false),
                child: child!,
              )
          : null,
      useInheritedMediaQuery: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color.fromARGB(255, 41, 41, 41),
          secondary: const Color(0xff9ec891),
          tertiary: const Color.fromARGB(255, 255, 255, 255),
        ),
        fontFamily: 'Poppins',
        appBarTheme: const AppBarTheme(
            elevation: 0,
            toolbarHeight: 60, //chango to mediaQuery
            backgroundColor: Colors.white,
            titleTextStyle: TextStyle(
              fontSize: 16,
              color: Color.fromARGB(255, 41, 41, 41),
              fontWeight: FontWeight.w900,
            ),
            toolbarTextStyle: TextStyle(
              fontSize: 16,
              color: Color.fromARGB(255, 41, 41, 41),
              fontWeight: FontWeight.w900,
            )),
        textTheme: const TextTheme(
          //body medium
          bodyText1: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              color: Color.fromARGB(255, 41, 41, 41),
              fontWeight: FontWeight.w600),
          //body bold
          bodyText2: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              color: Color.fromARGB(255, 41, 41, 41),
              fontWeight: FontWeight.bold),
          //title big
          headline1: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 34,
              color: Color.fromARGB(255, 41, 41, 41),
              fontWeight: FontWeight.w900),
          //used for smaller text
          subtitle1: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              color: Color.fromARGB(255, 41, 41, 41),
              fontWeight: FontWeight.w600),
          //text for green big buttons
          button: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 20,
              color: Color.fromARGB(255, 255, 255, 255),
              fontWeight: FontWeight.w900),
        ),
      ),
      home: const WidgetTree(),
    );
  }
}
