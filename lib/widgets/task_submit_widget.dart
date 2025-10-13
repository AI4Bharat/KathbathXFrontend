import 'package:flutter/material.dart';
import 'package:kathbath_lite/utils/colors.dart';

class TaskSubmitWidget extends StatelessWidget {
  final int uploadedTasks;
  final int onPhoneTasks;
  final VoidCallback handleSubmitTasks;

  const TaskSubmitWidget({
    Key? key,
    required this.uploadedTasks,
    required this.onPhoneTasks,
    required this.handleSubmitTasks,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 5.0, vertical: 5.0),
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 155, 216, 157),
                  ),
                  child: Text(
                    "[Uploaded: $uploadedTasks tasks]",
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 5.0, vertical: 5.0),
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(180, 233, 163, 176),
                  ),
                  child: Text(
                    "[On Phone: $onPhoneTasks tasks]",
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
          // const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10.0),
            width: double.infinity,
            child: ElevatedButton(
              onPressed: handleSubmitTasks,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 20.0),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                ),
                minimumSize: const Size(double.infinity, 48),
                fixedSize: const Size(double.infinity, 48),
              ),
              child: const Text(
                'Submit Tasks / Get New Tasks',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
