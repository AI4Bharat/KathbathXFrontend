import 'package:flutter/material.dart';
import 'package:kathbath_lite/data/database/models/microtask_assignment_record.dart';
import 'package:kathbath_lite/data/database/models/microtask_record.dart';
import 'package:kathbath_lite/data/database/models/task_record.dart';
import 'package:kathbath_lite/data/manager/karya_db.dart';
import 'package:kathbath_lite/providers/recorder_player_providers.dart';
import 'package:kathbath_lite/scenarios/speech_data/speech_data_screen.dart';

class ScenarioBaseScreen extends StatefulWidget {
  final KaryaDatabase db;
  final Task task;
  final List<Microtask> microtasks;
  final List<MicroTaskAssignment> microtaskAssignments;

  const ScenarioBaseScreen(
      {required this.db,
      required this.task,
      required this.microtasks,
      required this.microtaskAssignments});

  @override
  State<ScenarioBaseScreen> createState() => _ScenarioBaseScreen();
}

class _ScenarioBaseScreen extends State<ScenarioBaseScreen> {
  @override
  Widget build(BuildContext buildContext) {
		print("The scenario namie is ${widget.task.scenarioName}");
    switch (widget.task.scenarioName) {
      case "SPEECH_DATA":
        return SpeechDataScreen(
            karyaDatabase: widget.db,
            task: widget.task,
            microtasks: widget.microtasks,
            microtaskAssignments: widget.microtaskAssignments);
      default:
        return const Text("Not implemented");
    }
  }
}
