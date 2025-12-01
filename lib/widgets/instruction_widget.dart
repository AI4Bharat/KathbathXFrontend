import 'package:flutter/material.dart';
import 'package:kathbath_lite/widgets/dialogs/show_task_instruction_dialog.dart';

class InstructionWidget extends StatelessWidget {
  final String instruction;
  static const TextStyle headingStyle =
      TextStyle(fontSize: 20, fontWeight: FontWeight.bold);

  const InstructionWidget({
    super.key,
    required this.instruction,
  });

  showInstruction(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return ShowTaskInstructionDialog(
            instruction: instruction,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const Text("Instruction", style: headingStyle),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        spacing: 16,
        children: [
          Expanded(
              child: Text(
            instruction,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 16.0,
            ),
          )),
          GestureDetector(
            child: const Icon(Icons.info_outline_rounded),
            onTap: () => showInstruction(context),
          ),
        ],
      )
    ]);
  }
}
