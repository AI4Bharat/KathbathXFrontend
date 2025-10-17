import 'package:flutter/material.dart';
import 'package:kathbath_lite/utils/colors.dart';

class AppScaffold extends StatelessWidget {
  final Widget body;

  const AppScaffold({Key? key, required this.body}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: SafeArea(
          child: Container(
            color: Colors.white,
            child: body,
          ),
        ),
      ),
    );
  }
}
