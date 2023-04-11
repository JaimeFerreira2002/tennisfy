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
