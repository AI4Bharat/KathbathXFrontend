import 'package:flutter/material.dart';

Future<bool> showSkipDialog(BuildContext context) async {
  final wantToSkip = await showDialog<bool>(
      context: context,
      builder: (BuildContext buildContext) {
        return AlertDialog(
          title: const Text("Skip this task?"),
          content: const Text("Are you sure you want to skip this task?"),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(buildContext).pop(false);
              },
            ),
            TextButton(
              child: const Text('Skip'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      });
  return wantToSkip ?? false;
}
