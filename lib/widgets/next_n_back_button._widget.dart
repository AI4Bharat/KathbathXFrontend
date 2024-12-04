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
    return Column(
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          ///////////Back Button/////////////////////
          ElevatedButton(
            onPressed: onBackPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(5.0),
              elevation: 10.0,
            ),
            child: Image.asset(
              'assets/icons/ic_back_enabled.png',
              width: 70,
              height: 70,
            ),
          ),

          ElevatedButton(
            onPressed: onNextPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(5.0),
              elevation: 5.0, // Shadow effect
            ),
            child: Image.asset(
              'assets/icons/ic_next_enabled.png',
              width: 70,
              height: 70,
            ),
          ),
        ]),
      ],
    );
  }
}
