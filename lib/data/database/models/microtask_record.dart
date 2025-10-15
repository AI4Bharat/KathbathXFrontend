import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:kathbath_lite/data/manager/karya_db.dart';
import 'package:kathbath_lite/utils/type_checker.dart';

@DataClassName('MicroTaskRecord')
class MicroTaskRecords extends Table {
  Int64Column get id => int64()(); // Primary Key
  Int64Column get taskId => int64().named("task_id")();
  Int64Column get groupId => int64().named("group_id").nullable()();
  TextColumn get input => text()();
  Int64Column get inputFileId => int64().named("input_file_id").nullable()();
  DateTimeColumn get deadline => dateTime().nullable()();
  RealColumn get baseCredits => real().named("base_credits")();
  RealColumn get credits => real().named("credits")();
  TextColumn get status => text()();
  TextColumn get output => text().nullable()();
  TextColumn get extras => text().nullable()();
  DateTimeColumn get createdAt => dateTime().named("created_at")();
  DateTimeColumn get lastUpdatedAt => dateTime().named("last_updated_at")();

  @override
  Set<Column> get primaryKey => {id};
}

class Microtask {
  final int id;
  final int taskId;
  final int? groupId;
  final Map<String, dynamic> input;
  final int? inputFileId;
  final DateTime? deadline;
  final double baseCredits;
  final double credits;
  final String status;
  final Map<String, dynamic>? output;
  final Map<String, dynamic>? extras;
  final DateTime createdAt;
  final DateTime lastUpdatedAt;

  const Microtask(
      {required this.id,
      required this.taskId,
      required this.groupId,
      required this.input,
      required this.inputFileId,
      required this.deadline,
      required this.baseCredits,
      required this.credits,
      required this.status,
      required this.output,
      required this.extras,
      required this.createdAt,
      required this.lastUpdatedAt});

  Microtask.fromRecord(MicroTaskRecord mr)
      : id = mr.id.toInt(),
        taskId = mr.taskId.toInt(),
        groupId = mr.groupId?.toInt(),
        input = jsonDecode(mr.input),
        inputFileId = mr.inputFileId?.toInt(),
        deadline = mr.deadline,
        baseCredits = mr.baseCredits.toDouble(),
        credits = mr.credits.toDouble(),
        status = mr.status,
        output = mr.output != null ? jsonDecode(mr.output!) : null,
        extras = mr.output != null ? jsonDecode(mr.extras!) : null,
        createdAt = mr.createdAt,
        lastUpdatedAt = mr.lastUpdatedAt;

  factory Microtask.fromJson(Map<String, dynamic> microtaskJson) {
    print("From json called with $json");

    try {
      final id = checkIfValueExistInJson<int>(microtaskJson, "id");
      final taskId = checkIfValueExistInJson<int>(microtaskJson, "task_id");
      final groupId = checkIfValueExistInJson<int?>(microtaskJson, "group_id");
      final input =
          checkIfValueExistInJson<Map<String, dynamic>>(microtaskJson, "input");
      final inputFileId =
          checkIfValueExistInJson<int?>(microtaskJson, "input_file_id");
      final deadlineString =
          checkIfValueExistInJson<String?>(microtaskJson, "deadline");
      final deadline = DateTime.tryParse(deadlineString ?? '');
      final baseCredit =
          checkIfValueExistInJson<int>(microtaskJson, "base_credits");
      final credits = checkIfValueExistInJson<int>(microtaskJson, "credits");
      final status = checkIfValueExistInJson<String>(microtaskJson, "status");
      final output = checkIfValueExistInJson<Map<String, dynamic>?>(
          microtaskJson, "output");
      final extras = checkIfValueExistInJson<Map<String, dynamic>?>(
          microtaskJson, "extras");
      final createdAtString =
          checkIfValueExistInJson<String>(microtaskJson, "created_at");
      final createdAt = DateTime.parse(createdAtString);
      final lastUpdatedAtString =
          checkIfValueExistInJson<String>(microtaskJson, "last_updated_at");
      final lastUpdateAt = DateTime.parse(lastUpdatedAtString);
      return Microtask(
        id: id,
        taskId: taskId,
        groupId: groupId,
        input: input,
        inputFileId: inputFileId,
        deadline: deadline,
        baseCredits: baseCredit.toDouble(),
        credits: credits.toDouble(),
        status: status,
        output: output,
        extras: extras,
        createdAt: createdAt,
        lastUpdatedAt: lastUpdateAt,
      );
    } on FormatException catch (e) {
      print("Exception occured while creating json $e");
      rethrow;
    }
  }

  MicroTaskRecord getMicrotaskRecord() {
    return MicroTaskRecord(
        id: BigInt.from(id),
        taskId: BigInt.from(taskId),
        groupId: groupId != null ? BigInt.from(groupId!) : null,
        input: jsonEncode(input),
        inputFileId: inputFileId != null ? BigInt.from(inputFileId!) : null,
        deadline: deadline,
        baseCredits: baseCredits,
        credits: credits,
        status: status,
        output: jsonEncode(output ?? ""),
        extras: jsonEncode(extras ?? ""),
        createdAt: createdAt,
        lastUpdatedAt: lastUpdatedAt);
  }
}
