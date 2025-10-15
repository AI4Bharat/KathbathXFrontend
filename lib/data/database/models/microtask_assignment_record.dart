import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:kathbath_lite/data/manager/karya_db.dart';
import 'package:kathbath_lite/utils/type_checker.dart';

@DataClassName('MicroTaskAssignmentRecord')
class MicroTaskAssignmentRecords extends Table {
  Int64Column get id => int64()(); // Primary Key
  Int64Column get boxId => int64().named('box_id')();
  Int64Column get localId => int64().named('local_id')();
  Int64Column get microtaskId => int64().named('microtask_id')();
  Int64Column get taskId => int64().named('task_id')();
  Int64Column get workerId => int64().named('worker_id')();
  TextColumn get wgroup => text().nullable()();
  DateTimeColumn get sentToServerAt => dateTime().named("sent_to_server_at")();
  DateTimeColumn get deadline => dateTime().nullable()();
  TextColumn get status => text()(); // Assuming status is stored as text
  DateTimeColumn get completedAt =>
      dateTime().nullable().named('completed_at')();
  TextColumn get output => text().nullable()();
  Int64Column get outputFileId => int64().nullable().named('output_file_id')();
  TextColumn get logs => text().nullable()();
  DateTimeColumn get submittedToBoxAt =>
      dateTime().nullable().named("submitted_to_box_at")();
  DateTimeColumn get submittedToServerAt =>
      dateTime().nullable().named("submitted_to_server_at")();
  DateTimeColumn get verifiedAt => dateTime().nullable().named("verified_at")();
  TextColumn get report => text().nullable()();
  RealColumn get maxBaseCredits => real().named("max_base_credits")();
  RealColumn get baseCredits => real().named("base_credits")();
  RealColumn get maxCredits => real().named("max_credits")();
  RealColumn get credits => real().nullable()();
  TextColumn get extras => text().nullable()();
  DateTimeColumn get createdAt => dateTime().named('created_at')();
  DateTimeColumn get lastUpdatedAt => dateTime().named('last_updated_at')();

  @override
  Set<Column> get primaryKey => {id};
}

class MicroTaskAssignment {
  final int id;
  final int boxId;
  final int localId;
  final int microtaskId;
  final int taskId;
  final int workerId;
  final String? wgroup;
  final DateTime sentToServerAt;
  final DateTime? deadline;
  final String status;
  final DateTime? completedAt;
  final Map<String, dynamic>? output;
  final int? outputFileId;
  final Map<String, dynamic>? logs;
  final DateTime? submittedToBoxAt;
  final DateTime? submittedToServerAt;
  final DateTime? verifiedAt;
  final Map<String, dynamic>? report;
  final double maxBaseCredits;
  final double baseCredits;
  final double maxCredits;
  final double? credits;
  final Map<String, dynamic>? extras;
  final DateTime createdAt;
  final DateTime lastUpdatedAt;

  MicroTaskAssignment(
      {required this.id,
      required this.boxId,
      required this.localId,
      required this.microtaskId,
      required this.taskId,
      required this.workerId,
      required this.wgroup,
      required this.sentToServerAt,
      required this.deadline,
      required this.status,
      required this.completedAt,
      required this.output,
      required this.outputFileId,
      required this.logs,
      required this.submittedToBoxAt,
      required this.submittedToServerAt,
      required this.verifiedAt,
      required this.report,
      required this.maxBaseCredits,
      required this.baseCredits,
      required this.maxCredits,
      required this.credits,
      required this.extras,
      required this.createdAt,
      required this.lastUpdatedAt});

  MicroTaskAssignment.fromRecord(MicroTaskAssignmentRecord mar)
      : id = mar.id.toInt(),
        boxId = mar.id.toInt(),
        localId = mar.localId.toInt(),
        microtaskId = mar.microtaskId.toInt(),
        taskId = mar.taskId.toInt(),
        workerId = mar.workerId.toInt(),
        wgroup = mar.wgroup,
        sentToServerAt = mar.sentToServerAt,
        deadline = mar.deadline,
        status = mar.status,
        completedAt = mar.completedAt,
        output = mar.output != null ? jsonDecode(mar.output!) : null,
        outputFileId = mar.outputFileId?.toInt(),
        logs = mar.logs != null ? jsonDecode(mar.logs!) : null,
        submittedToBoxAt = mar.submittedToBoxAt,
        submittedToServerAt = mar.submittedToServerAt,
        verifiedAt = mar.verifiedAt,
        report = mar.report != null ? jsonDecode(mar.report!) : null,
        maxBaseCredits = mar.maxBaseCredits,
        baseCredits = mar.baseCredits,
        maxCredits = mar.maxCredits,
        credits = mar.credits,
        extras = mar.output != null ? jsonDecode(mar.extras!) : null,
        createdAt = mar.createdAt,
        lastUpdatedAt = mar.lastUpdatedAt;

  factory MicroTaskAssignment.fromJson(
      Map<String, dynamic> microtaskAssignmentJson) {
    try {
      final id = checkIfValueExistInJson<int>(microtaskAssignmentJson, "id");
      final boxId =
          checkIfValueExistInJson<int>(microtaskAssignmentJson, "box_id");
      final localId =
          checkIfValueExistInJson<int>(microtaskAssignmentJson, "local_id");
      final microtaskId =
          checkIfValueExistInJson<int>(microtaskAssignmentJson, "microtask_id");
      final taskId =
          checkIfValueExistInJson<int>(microtaskAssignmentJson, "task_id");
      final workerId =
          checkIfValueExistInJson<int>(microtaskAssignmentJson, "worker_id");
      final wgroup =
          checkIfValueExistInJson<String?>(microtaskAssignmentJson, "wgroup");
      final sentToServerAtString = checkIfValueExistInJson<String>(
          microtaskAssignmentJson, "sent_to_server_at");
      final sentToServerAt = DateTime.parse(sentToServerAtString);
      final deadlineString =
          checkIfValueExistInJson<String?>(microtaskAssignmentJson, "deadline");
      final deadline = DateTime.parse(deadlineString ?? "");
      final status =
          checkIfValueExistInJson<String>(microtaskAssignmentJson, "status");
      final completedAtString = checkIfValueExistInJson<String?>(
          microtaskAssignmentJson, "completed_at");
      final completedAt = DateTime.parse(completedAtString ?? "");
      final output = checkIfValueExistInJson<Map<String, dynamic>?>(
          microtaskAssignmentJson, "output");
      final outputFileId = checkIfValueExistInJson<int?>(
          microtaskAssignmentJson, "output_file_id");
      final logs = checkIfValueExistInJson<Map<String, dynamic>?>(
          microtaskAssignmentJson, "logs");
      final submittedToBoxAtString = checkIfValueExistInJson<String?>(
          microtaskAssignmentJson, "submitted_to_box_at");
      final submittedToBoxAt = DateTime.parse(submittedToBoxAtString ?? "");
      final submittedToServerAtString = checkIfValueExistInJson<String?>(
          microtaskAssignmentJson, "submitted_to_server_at");
      final submittedToServerAt =
          DateTime.parse(submittedToServerAtString ?? "");
      final verifiedAtString = checkIfValueExistInJson<String?>(
          microtaskAssignmentJson, "verified_at");
      final verifiedAt = DateTime.parse(verifiedAtString ?? "");
      final report = checkIfValueExistInJson<Map<String, dynamic>?>(
          microtaskAssignmentJson, "report");
      final maxBaseCredits = checkIfValueExistInJson<int>(
          microtaskAssignmentJson, "max_base_credits");
      final baseCredits = checkIfValueExistInJson<int>(
          microtaskAssignmentJson, "base_credits");
      final maxCredits = checkIfValueExistInJson<int>(
          microtaskAssignmentJson, "max_credits");
      final credits =
          checkIfValueExistInJson<int?>(microtaskAssignmentJson, "credits");
      final extras = checkIfValueExistInJson<Map<String, dynamic>?>(
          microtaskAssignmentJson, "extras");
      final createdAtString = checkIfValueExistInJson<String>(
          microtaskAssignmentJson, "created_at");
      final createdAt = DateTime.parse(createdAtString);
      final lastUpdatedAtString = checkIfValueExistInJson<String>(
          microtaskAssignmentJson, "last_updated_at");
      final lastUpdatedAt = DateTime.parse(lastUpdatedAtString);
      return (MicroTaskAssignment(
          id: id,
          boxId: boxId,
          localId: localId,
          microtaskId: microtaskId,
          taskId: taskId,
          workerId: workerId,
          wgroup: wgroup,
          sentToServerAt: sentToServerAt,
          deadline: deadline,
          status: status,
          completedAt: completedAt,
          output: output,
          outputFileId: outputFileId,
          logs: logs,
          submittedToBoxAt: submittedToBoxAt,
          submittedToServerAt: submittedToServerAt,
          verifiedAt: verifiedAt,
          report: report,
          maxBaseCredits: maxBaseCredits.toDouble(),
          baseCredits: baseCredits.toDouble(),
          maxCredits: maxCredits.toDouble(),
          credits: credits?.toDouble(),
          extras: extras,
          createdAt: createdAt,
          lastUpdatedAt: lastUpdatedAt));
    } on FormatException catch (e) {
      print("Exception occured while creating microtask assignment $e");
      rethrow;
    }
  }

  MicroTaskAssignmentRecord getMicrotaskAssignmentRecord() {
    return MicroTaskAssignmentRecord(
      id: BigInt.from(id),
      boxId: BigInt.from(boxId),
      localId: BigInt.from(localId),
      microtaskId: BigInt.from(microtaskId),
      taskId: BigInt.from(taskId),
      workerId: BigInt.from(workerId),
      wgroup: wgroup,
      sentToServerAt: sentToServerAt,
      deadline: deadline,
      status: status,
      completedAt: completedAt,
      output: jsonEncode(output),
      outputFileId: outputFileId != null ? BigInt.from(outputFileId!) : null,
      logs: jsonEncode(logs ?? ""),
      submittedToBoxAt: submittedToBoxAt,
      submittedToServerAt: submittedToServerAt,
      verifiedAt: verifiedAt,
      report: jsonEncode(report ?? ""),
      maxBaseCredits: maxBaseCredits.toDouble(),
      baseCredits: baseCredits.toDouble(),
      maxCredits: maxCredits.toDouble(),
      credits: credits?.toDouble(),
      extras: jsonEncode(extras ?? ""),
      createdAt: createdAt,
      lastUpdatedAt: lastUpdatedAt,
    );
  }
}

Map<String, dynamic> getJsonFromMicrotaskAssignmentRecord(
    MicroTaskAssignmentRecord microtaskAssignmentRecord) {
  return {
    'id': microtaskAssignmentRecord.id.toString(),
    'local_id': microtaskAssignmentRecord.localId.toString(),
    'box_id': microtaskAssignmentRecord.boxId.toString(),
    'microtask_id': microtaskAssignmentRecord.microtaskId.toString(),
    'task_id': microtaskAssignmentRecord.taskId.toString(),
    'worker_id': microtaskAssignmentRecord.workerId.toString(),
    'deadline': microtaskAssignmentRecord.deadline.toString(),
    'status': microtaskAssignmentRecord.status,
    'completed_at': microtaskAssignmentRecord.completedAt ?? '',
    'output': microtaskAssignmentRecord.output,
    'output_file_id': microtaskAssignmentRecord.outputFileId,
    'logs': microtaskAssignmentRecord.logs,
    'max_base_credits': microtaskAssignmentRecord.maxBaseCredits,
    'base_credits': microtaskAssignmentRecord.baseCredits,
    'credits': microtaskAssignmentRecord.credits ?? 0,
    'verified_at': microtaskAssignmentRecord.verifiedAt,
    'report': microtaskAssignmentRecord.report,
    'created_at': microtaskAssignmentRecord.createdAt,
    'last_updated_at': microtaskAssignmentRecord.lastUpdatedAt,
  };
}
