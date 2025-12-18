import 'package:flutter/material.dart';

Future<void> showErrorDialog(BuildContext buildContext, String errorMessage) {
  return showDialog(
      context: buildContext,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Error occured"),
          content: Text(errorMessage),
        );
      });
}
