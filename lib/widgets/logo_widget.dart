import 'package:flutter/material.dart';

class WelcomeLogoWidget extends StatelessWidget {
  final String imagePath;
  final String welcomeText;
  final TextStyle textStyle;

  const WelcomeLogoWidget({
    super.key,
    this.imagePath = 'assets/logo-ai4b.png',
    this.welcomeText = 'Welcome to Kathbath!',
    this.textStyle = const TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Colors.orange,
    ),
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Image.asset(imagePath, height: 100),
        const SizedBox(height: 20),
        Text(
          welcomeText,
          style: textStyle,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
