import 'package:flutter/material.dart';
import 'package:kathbath_lite/utils/colors.dart';

class ActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final bool isPrimary;

  ActionButton({
    required this.onPressed,
    required this.text,
    this.isPrimary = true,
  });

  @override
  Widget build(BuildContext buildContext) {
    return FilledButton.tonal(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusGeometry.circular(8.0)),
          backgroundColor: isPrimary ? darkerOrange : customOrange,
          foregroundColor: Colors.white),
      child: Text(text),
    );
  }
}
