import 'package:flutter/material.dart';

class InstructionWidget extends StatelessWidget {
  final String sentence;

  const InstructionWidget({
    super.key,
    required this.sentence,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 10.0),
        Text(
          sentence,
          style: const TextStyle(
            fontSize: 15.0,
          ),
        ),
        const SizedBox(height: 3.0),
      ],
    );
  }
}
