import 'package:flutter/material.dart';
import '../helpers/media_query_helpers.dart';

Container smallVerticalDivider(BuildContext context) {
  return Container(
    width: displayWidth(context) * 0.006,
    height: displayHeight(context) * 0.04,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Theme.of(context).colorScheme.primary.withOpacity(0.4)),
  );
}

//try to use this button to simplify

// Container greenFlatTextButton(BuildContext context, double height, double width,
//     Function onPressed, String label, double borderRadius) {
//   return Container(
//     width: width,
//     height: height,
//     child: Center(
//         child: TextButton(
//             style: TextButton.styleFrom(
//               backgroundColor: Theme.of(context).colorScheme.secondary,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(borderRadius),
//               ),
//             ),
//             onPressed: () {
//               onPressed;
//             },
//             child: Text(
//               label,
//               style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
//             ))),
//   );
// }
