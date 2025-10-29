import 'package:flutter/material.dart';

class IconWithTextButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final Function onTap;
  final Color backgroundColor;

  IconWithTextButton(
      {required this.text,
      required this.icon,
      required this.backgroundColor,
      required this.onTap});

  @override
  Widget build(BuildContext buildContext) {
    return GestureDetector(
        onTap: () => onTap(),
        child: Column(
          children: [
            Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: const BorderRadius.all(Radius.circular(16))),
                child: Icon(icon, size: 35, color: Colors.white)),
            Text(text, style: const TextStyle(color: Colors.blueGrey))
          ],
        ));
  }
}
