import 'package:flutter/material.dart';

// ignore: must_be_immutable
class NextBackWidget extends StatelessWidget {
  final VoidCallback onBackPressed;
  final VoidCallback onNextPressed;

  const NextBackWidget({
    super.key,
    required this.onBackPressed,
    required this.onNextPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
      ElevatedButton(
        onPressed: onBackPressed,
        child: const Text("Previous"),
      ),
      ElevatedButton(
        onPressed: onNextPressed,
        child: const Text("Next"),
      ),
    ]);
  }
}
