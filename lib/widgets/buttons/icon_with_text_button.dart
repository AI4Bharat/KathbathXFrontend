import 'package:flutter/material.dart';

class IconWithTextButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final Function onTap;
  final Color backgroundColor;
  final double size;

  IconWithTextButton({
    required this.text,
    required this.icon,
    required this.backgroundColor,
    required this.onTap,
    this.size = 36,
  });

  @override
  Widget build(BuildContext buildContext) {
    return GestureDetector(
        onTap: () => onTap(),
        child: Column(
          spacing: 4,
          children: [
            Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: size, color: Colors.white)),
            Text(text,
                style: const TextStyle(color: Colors.blueGrey, fontSize: 16))
          ],
        ));
  }
}
