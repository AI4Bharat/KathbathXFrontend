import 'package:flutter/material.dart';
import 'package:karya_flutter/utils/colors.dart';

class AppScaffold extends StatelessWidget {
  final Widget body;

  const AppScaffold({Key? key, required this.body}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: darkerOrange,
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
