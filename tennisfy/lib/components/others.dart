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
