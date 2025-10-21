import 'package:flutter/material.dart';
import 'package:kathbath_lite/utils/colors.dart';
import 'package:kathbath_lite/widgets/buttons/dashboard_fetch_submit_button.dart';

class TaskSubmitWidget extends StatelessWidget {
  final int uploadedTasks;
  final int onPhoneTasks;
  final VoidCallback handleSubmitTasks;

  final textStyle = const TextStyle(fontWeight: FontWeight.bold, fontSize: 16);

  const TaskSubmitWidget({
    Key? key,
    required this.uploadedTasks,
    required this.onPhoneTasks,
    required this.handleSubmitTasks,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color.fromARGB(255, 252, 190, 133),
        ),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 8,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text(style: textStyle, "Submitted: $uploadedTasks"),
                      Text(style: textStyle, "To Submit: $onPhoneTasks"),
                      const SizedBox(height: 10),
                    ],
                  ),
                  const CircularProgressIndicator(
                    value: .4,
                    strokeWidth: 10,
                    backgroundColor: Colors.white,
                    strokeCap: StrokeCap.round,
                  )
                ],
              ),
              DashboardFetchSubmitButton(
                text: "Submit and Fetch",
                onPressed: handleSubmitTasks,
              )
            ]));
  }
}
