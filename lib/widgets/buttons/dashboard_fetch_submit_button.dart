import 'package:flutter/material.dart';

class DashboardFetchSubmitButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final bool isPrimary;

  DashboardFetchSubmitButton({
    required this.onPressed,
    required this.text,
    this.isPrimary = true,
  });

  @override
  Widget build(BuildContext buildContext) {
    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(12.0)),
      ),
      child: Text(text),
    );
  }
}
