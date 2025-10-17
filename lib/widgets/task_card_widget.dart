import 'package:flutter/material.dart';
import 'package:kathbath_lite/utils/colors.dart';
import 'package:kathbath_lite/widgets/buttons/action_button.dart';
import 'package:kathbath_lite/widgets/dialogs/show_task_info_dialog.dart';

class TaskCard extends StatelessWidget {
  final String taskName;
  final String taskDescription;
  final int available;
  final int completed;
  final int verified;
  final int skipped;
  final int submitted;
  final int expired;
  final int readCount;
  final int extemporeCount;
  final int totalDuration;
  final VoidCallback? onTap;

  const TaskCard({
    Key? key,
    required this.taskName,
    required this.taskDescription,
    required this.available,
    required this.completed,
    required this.verified,
    required this.skipped,
    required this.submitted,
    required this.expired,
    required this.totalDuration,
    this.readCount = 0,
    this.extemporeCount = 0,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(
              8.0), //padding inside the card around the contents
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                        child: Text(
                      taskName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                    GestureDetector(
                      child: const Icon(Icons.info_outline),
                      onTap: () => showInfoDialog(context),
                    )
                  ]),
              const SizedBox(height: 4),
              Text(
                  'Recorded: ${(totalDuration).toStringAsFixed(0)} seconds'),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8, // space between line
                children: [
                  _MetricsIcon(
                    metricsName: "Available",
                    metricsValue: available.toString(),
                  ),
                  _MetricsIcon(
                    metricsName: "Completed",
                    metricsValue: completed.toString(),
                  ),
                  _MetricsIcon(
                    metricsName: "Skipped",
                    metricsValue: skipped.toString(),
                  ),
                  _MetricsIcon(
                    metricsName: "Submitted",
                    metricsValue: submitted.toString(),
                  ),
                  _MetricsIcon(
                    metricsName: "Verified",
                    metricsValue: available.toString(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showInfoDialog(BuildContext context) {
    //TODO Add animation
    showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel: "Show task info dialog barrier",
        pageBuilder: (BuildContext buildContext, Animation animation,
            Animation secondaryAnimation) {
          return ShowTaskInfoDialog(
              taskName: taskName, taskinfo: taskDescription);
        });
  }
}

class _MetricsIcon extends StatelessWidget {
  final String metricsName;
  final String metricsValue;

  const _MetricsIcon({required this.metricsName, required this.metricsValue});

  @override
  Widget build(BuildContext buildContext) {
    return (Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
              color: Colors.grey, blurRadius: 1, blurStyle: BlurStyle.outer),
        ],
      ),
      child: Text(
          style: const TextStyle(
              fontWeight: FontWeight.bold, color: primaryOrange),
          "$metricsName: $metricsValue".toUpperCase()),
    ));
  }
}
