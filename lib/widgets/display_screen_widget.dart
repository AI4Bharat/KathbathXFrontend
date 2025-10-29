import 'dart:math';

import 'package:flutter/material.dart';

class SentenceDisplayWidget extends StatefulWidget {
  final String sentence;

  SentenceDisplayWidget({required this.sentence});

  @override
  State<SentenceDisplayWidget> createState() => _SentenceDisplayWidget();
}

class _SentenceDisplayWidget extends State<SentenceDisplayWidget> {
  double fontSize = 24;
  void modifyFontSize(int quantity) {
    setState(() {
      fontSize = min(max(24, fontSize + quantity), 40);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
            color: const Color.fromARGB(255, 226, 114, 49), width: 4.0),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
        ZoomButtonsWidget(
          modifyFontSize: modifyFontSize,
        ),
        Expanded(
          child: Scrollbar(
            thumbVisibility: false,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: Text(
                  widget.sentence,
                  style: TextStyle(fontSize: fontSize),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}

class SentenceDisplayWOExpandedWidget extends StatelessWidget {
  final String sentence;

  const SentenceDisplayWOExpandedWidget({
    super.key,
    required this.sentence,
  });

  @override
  Widget build(BuildContext context) {
    final scrollController = ScrollController();

    return SizedBox(
      height: 400, // 👈 fixed height, adjust as needed

      child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
                color: const Color.fromARGB(255, 226, 114, 49), width: 4.0),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Scrollbar(
            controller: scrollController,
            thumbVisibility: true,
            child: SingleChildScrollView(
              controller: scrollController,
              child: Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: Text(
                  sentence,
                  style: const TextStyle(fontSize: 28),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
          )),
    );
  }
}

class ZoomButtonsWidget extends StatelessWidget {
  final Function modifyFontSize;
  ZoomButtonsWidget({required this.modifyFontSize});

  @override
  Widget build(BuildContext buildContext) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        GestureDetector(
            child: const Icon(Icons.zoom_in, size: 24),
            onTap: () => modifyFontSize(1)),
        GestureDetector(
            child: const Icon(Icons.zoom_out, size: 24),
            onTap: () => modifyFontSize(-1))
      ],
    );
  }
}
