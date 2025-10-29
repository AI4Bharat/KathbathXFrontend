import 'package:flutter/material.dart';
import 'package:kathbath_lite/data/database/models/microtask_assignment_record.dart';
import 'package:kathbath_lite/data/database/models/microtask_record.dart';
import 'package:kathbath_lite/data/database/models/task_record.dart';
import 'package:kathbath_lite/data/manager/karya_db.dart';
import 'package:kathbath_lite/providers/recorder_player_providers.dart';
import 'package:kathbath_lite/scenarios/speech_data/speech_data_model.dart';
import 'package:kathbath_lite/scenarios/speech_data/speech_data_widget.dart';
import 'package:kathbath_lite/widgets/instruction_widget.dart';
import 'package:kathbath_lite/widgets/next_n_back_button_widget.dart';
import 'package:provider/provider.dart';

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
  late PageController _pageController;
  late List<SpeechDataWidget> speechDataWidgets;

  void createMicrotaskModels() {
    List<SpeechDataWidget> tmpSpeechDataWidgets =
        widget.microtaskAssignments.map((microtaskAssignment) {
      final speechDataModel =
          SpeechDataModel.fromRecords(microtaskAssignment, widget.microtasks);
      return SpeechDataWidget(speechDataModel: speechDataModel);
    }).toList();

    setState(() {
      speechDataWidgets = tmpSpeechDataWidgets;
    });
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    createMicrotaskModels();
  }

  void nextTask() {}

  void previousTask() {}

  @override
  Widget build(BuildContext buildContext) {
    return ChangeNotifierProvider(
        create: (context) => RecorderPlayerInfoProvider(filePath: ""),
        child: Padding(
            padding: const EdgeInsetsGeometry.all(16),
            child: Column(spacing: 16, children: [
              InstructionWidget(sentence: widget.task.description),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  children: speechDataWidgets,
                ),
              ),
              NextBackWidget(
                  onBackPressed: previousTask, onNextPressed: nextTask),
            ])));
  }
}
