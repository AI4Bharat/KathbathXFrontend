import 'package:flutter/material.dart';

Future<void> showLoadingDialog(String message, BuildContext context) {
  return showDialog(
      context: context,
      builder: (BuildContext buildContext) {
        return AlertDialog(
            title: const Text("Please wait..."),
            content: Row(
              spacing: 16.0,
              children: [
                const CircularProgressIndicator(),
                Flexible(
                  child: Text(
                    message,
                    softWrap: true,
                    maxLines: 2,
                  ),
                )
              ],
            ));
      });
}
