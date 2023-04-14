import 'package:flutter/material.dart';

Route pageTransition(Widget pageToGo) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => pageToGo,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1, 0);
      const end = Offset.zero;
      const curve = Curves.easeInOutCirc;
      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

void goToPage(BuildContext context, Widget pageToGo) {
  Navigator.push(context, pageTransition(pageToGo));
}

Map dateToFirebase(DateTime date) {
  return {
    'Day': date.day,
    'Month': date.month,
    'Year': date.year,
  };
}

DateTime dateFromFirebase(Map<String, dynamic> encoded) {
  var day = encoded['Day'];
  var month = encoded['Month'];
  var year = encoded['Year'];
  DateTime dateTime = DateTime(year, month, day);

  return dateTime;
}
