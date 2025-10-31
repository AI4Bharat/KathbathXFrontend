import 'package:flutter/material.dart';

String _combinePermissionName(List<String> permissionNames) {
  String permissionMessage = permissionNames.length > 1
      ? "The following permissions are required:"
      : "The following permission is required";
  permissionMessage += permissionNames.join(", ");

  return permissionMessage;
}

Future<void> showPermissionNotGivenDialog(
    List<String> permissionNames, BuildContext context) {
  return showDialog(
      context: context,
      builder: (BuildContext buildContext) {
        return AlertDialog(
          title: const Text("Permission issues"),
          content: Row(
            spacing: 16.0,
            children: [
              Flexible(
                child: Text(
                  _combinePermissionName(permissionNames),
                  softWrap: true,
                  maxLines: 2,
                ),
              )
            ],
          ),
          actions: [
            TextButton(
                onPressed: () =>
                    {Navigator.of(context).pushReplacementNamed("/dashboard")},
                child: const Text("Okay"))
          ],
        );
      });
}
