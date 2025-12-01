import 'package:flutter/widgets.dart';
import 'package:kathbath_lite/data/database/models/microtask_assignment_record.dart';
import 'package:kathbath_lite/data/database/models/microtask_record.dart';
import 'package:kathbath_lite/data/database/models/task_record.dart';
import 'package:kathbath_lite/data/manager/karya_db.dart';
import 'package:kathbath_lite/scenarios/speech_data/speech_data_input_widget.dart';
import 'package:kathbath_lite/scenarios/speech_data/speech_data_model.dart';
import 'package:kathbath_lite/scenarios/speech_data/speech_data_output_widget.dart';
import 'package:kathbath_lite/scenarios/speech_data/speech_data_provider.dart';
import 'package:kathbath_lite/widgets/instruction_widget.dart';
import 'package:kathbath_lite/widgets/next_n_back_button_widget.dart';
import 'package:provider/provider.dart';

class SpeechDataScreen extends StatefulWidget {
  final KaryaDatabase karyaDatabase;
  final Task task;
  final List<Microtask> microtasks;
  final List<MicroTaskAssignment> microtaskAssignments;

  const SpeechDataScreen(
      {required this.karyaDatabase,
      required this.task,
      required this.microtasks,
      required this.microtaskAssignments});

  @override
  State<SpeechDataScreen> createState() => _SpeechDataScreen();
}

class _SpeechDataScreen extends State<SpeechDataScreen> {
  late PageController _pageController;
  late List<Widget> speechDataWidgets;

  void initVariablesAndMicrotasks() {
    _pageController = PageController();
    List<Widget> tmpSpeechDataWidgets =
        widget.microtaskAssignments.map((microtaskAssignment) {
      final speechDataModel =
          SpeechDataModel.fromRecords(microtaskAssignment, widget.microtasks);
      return _speechDataWidget(speechDataModel);
    }).toList();

    setState(() {
      speechDataWidgets = tmpSpeechDataWidgets;
    });
  }

  @override
  void initState() {
    super.initState();
    initVariablesAndMicrotasks();
  }

  void nextTask() {
    _pageController.nextPage(
        duration: const Duration(milliseconds: 200), curve: Curves.linear);
  }

  void previousTask() {
    _pageController.previousPage(
        duration: const Duration(milliseconds: 200), curve: Curves.linear);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        spacing: 8,
        children: [
          InstructionWidget(instruction: widget.task.description),
          ChangeNotifierProvider(
            create: (context) {
              final speechDataProvider = SpeechDataProvider();
              speechDataProvider.init(widget.microtaskAssignments[0].id);
              return speechDataProvider;
            },
            child: Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: speechDataWidgets,
              ),
            ),
          ),
          NextBackWidget(onBackPressed: previousTask, onNextPressed: nextTask),
        ],
      ),
    );
  }

  Widget _speechDataWidget(SpeechDataModel speechDataModel) {
    return Flex(
      direction: Axis.vertical,
      children: [
        Flexible(
          flex: 2,
          child: SpeechDataInputWidget(speechDataInput: speechDataModel.input),
        ),
        Flexible(
          flex: 1,
          child: SpeechDataOutputWidget(
            speechDataOutput: speechDataModel.output,
            karyaDatabase: widget.karyaDatabase,
          ),
        )
      ],
    );
  }
}
