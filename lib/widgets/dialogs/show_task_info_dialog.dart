import 'package:flutter/material.dart';

class ShowTaskInfoDialog extends StatelessWidget {
  final String taskName;
  final String taskinfo;

  const ShowTaskInfoDialog({required this.taskName, required this.taskinfo});

  @override
  Widget build(BuildContext buildContext) {
    return AlertDialog(
      title: Text(taskName),
      content: Text(taskinfo),
    );
  }
}
