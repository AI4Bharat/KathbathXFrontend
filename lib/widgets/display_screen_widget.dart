import 'package:flutter/material.dart';

class SentenceDisplayWidget extends StatelessWidget {
  final String sentence;

  const SentenceDisplayWidget({
    super.key,
    required this.sentence,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
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
          thumbVisibility: true,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Text(
                sentence,
                style: const TextStyle(fontSize: 28),
                textAlign: TextAlign.left,
              ),
            ),
          ),
        ),
      ),
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
        ),
      ),
    );
  }
}
