import 'package:flutter/material.dart';
import 'package:karya_flutter/widgets/custom_expansiontile_widget.dart';

class TaskCard extends StatelessWidget {
  final String taskName;
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
      child: Padding(
        padding: const EdgeInsets.symmetric(
            vertical: 10.0, horizontal: 12.0), //padding around the card
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey[200],
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(
                8.0), //padding inside the card around the contents
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  taskName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                // --- Task Progress ---

//////////////////////////////////////////////////////
                CustomExpansionTile(
                    available: available,
                    completed: completed,
                    skipped: skipped,
                    submitted: submitted,
                    verified: verified),
                const SizedBox(height: 10),
                // --- Read/Extempore Counts ---
                if (readCount > 0 || extemporeCount > 0)
                  Row(
                    children: [
                      Text('Read: $readCount'),
                      Text('Extempore: $extemporeCount'),
                    ],
                  ),

                if (totalDuration >= 0)
                  Row(
                    children: [
                      Text(
                          'Recorded duration: ${(totalDuration).toStringAsFixed(2)} seconds'),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
