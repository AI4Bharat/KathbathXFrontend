import 'package:flutter/material.dart';

class ShowTaskInstructionDialog extends StatelessWidget {
  final String instruction;

  const ShowTaskInstructionDialog({required this.instruction});

  @override
  Widget build(BuildContext buildContext) {
    return AlertDialog(
      title: const Text("Instruction"),
      content: Text(instruction),
    );
  }
}
