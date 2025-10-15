// ignore_for_file: constant_identifier_names

import 'dart:convert';
import 'dart:ffi';

import 'package:drift/drift.dart';
import 'package:kathbath_lite/data/manager/karya_db.dart';
import 'package:kathbath_lite/utils/type_checker.dart';

enum AssignmentGranularityType { GROUP, MICROTASK, EITHER }

enum AssignmentOrderType { SEQUENTIAL, RANDOM, EITHER }

@DataClassName('TaskRecord')
class TaskRecords extends Table {
  Int64Column get id => int64()(); // Primary Key
  Int64Column get workProviderId => int64().named("work_provider_id")();
  TextColumn get scenarioName => text().named("scenario_name")();
  TextColumn get name => text()();
  TextColumn get description => text()();
  TextColumn get displayName => text().named("display_name")();
  TextColumn get policy => text()();
  TextColumn get params => text()();
  TextColumn get itags => text()();
  TextColumn get otags => text()();
  TextColumn get wgroup => text().nullable()();
  DateTimeColumn get deadline => dateTime().nullable()();
  TextColumn get assignmentGranularity =>
      text().named("assignment_granularity")();
  TextColumn get groupAssignmentOrder =>
      text().named("group_assignment_order")();
  TextColumn get microtaskAssignmentOrder =>
      text().named("microtask_assignment_order")();
  IntColumn get assignmentBatchSize =>
      integer().nullable().named("assignment_batch_size")();
  TextColumn get status => text()();
  TextColumn get extras => text().nullable()();
  DateTimeColumn get createdAt => dateTime().named("created_at")();
  DateTimeColumn get lastUpdatedAt => dateTime().named("last_updated_at")();

  @override
  Set<Column> get primaryKey => {id};

  Map<String, dynamic> getMap() {
    return {};
  }
}

class Task {
  final int id;
  final int workProviderId;
  final String scenarioName;
  final String name;
  final String description;
  final String displayName;
  final String policy;
  final Map<String, dynamic> params;
  final Map<String, dynamic> itags;
  final Map<String, dynamic> otags;
  final String? wgroup;
  final DateTime? deadline;
  final String assignmentGranularity;
  final String groupAssignmentOrder;
  final String microtaskAssignmentOrder;
  final int? assignmentBatchSize;
  final String status;
  final Map<String, dynamic>? extras;
  final DateTime createdAt;
  final DateTime lastUpdatedAt;

  Task({
    required this.id,
    required this.workProviderId,
    required this.scenarioName,
    required this.name,
    required this.description,
    required this.displayName,
    required this.policy,
    required this.params,
    required this.itags,
    required this.otags,
    required this.wgroup,
    required this.deadline,
    required this.assignmentGranularity,
    required this.groupAssignmentOrder,
    required this.microtaskAssignmentOrder,
    required this.assignmentBatchSize,
    required this.status,
    required this.extras,
    required this.createdAt,
    required this.lastUpdatedAt,
  });

  Task.fromTaskRecord(TaskRecord tr)
      : id = tr.id.toInt(),
        workProviderId = tr.workProviderId.toInt(),
        scenarioName = tr.scenarioName,
        name = tr.name,
        description = tr.description,
        displayName = tr.displayName,
        policy = tr.policy,
        params = jsonDecode(tr.params),
        itags = jsonDecode(tr.itags),
        otags = jsonDecode(tr.otags),
        wgroup = tr.wgroup,
        deadline = tr.deadline,
        assignmentGranularity = tr.assignmentGranularity,
        groupAssignmentOrder = tr.groupAssignmentOrder,
        microtaskAssignmentOrder = tr.microtaskAssignmentOrder,
        assignmentBatchSize = tr.assignmentBatchSize,
        status = tr.status,
        extras = tr.extras != null ? jsonDecode(tr.extras!) : null,
        createdAt = tr.createdAt,
        lastUpdatedAt = tr.lastUpdatedAt;

  factory Task.fromJson(Map<String, dynamic> taskJson) {
    try {
      final id = checkIfValueExistInJson<int>(taskJson, "id");
      final workProviderId =
          checkIfValueExistInJson<int>(taskJson, "work_provider_id");
      final scenarioName =
          checkIfValueExistInJson<String>(taskJson, "scenario_name");
      final name = checkIfValueExistInJson<String>(taskJson, "name");
      final description =
          checkIfValueExistInJson<String>(taskJson, "description");
      final displayName =
          checkIfValueExistInJson<String>(taskJson, "display_name");
      final policy = checkIfValueExistInJson<String>(taskJson, "policy");
      final params =
          checkIfValueExistInJson<Map<String, dynamic>>(taskJson, "params");
      final itags =
          checkIfValueExistInJson<Map<String, dynamic>>(taskJson, "itags");
      final otags =
          checkIfValueExistInJson<Map<String, dynamic>>(taskJson, "otags");
      final wgroup = checkIfValueExistInJson<String?>(taskJson, "wgroup");
      final deadlineString =
          checkIfValueExistInJson<String>(taskJson, "deadline");
      final deadline = DateTime.tryParse(deadlineString ?? '');
      final assignmentGranularity =
          checkIfValueExistInJson<String>(taskJson, "assignment_granularity");
      final groupAssignmentOrder =
          checkIfValueExistInJson<String>(taskJson, "group_assignment_order");
      final microtaskAssignmentOrder = checkIfValueExistInJson<String>(
          taskJson, "microtask_assignment_order");
      final assignmentBatchSize =
          checkIfValueExistInJson<int?>(taskJson, "assignment_batch_size");
      final status = checkIfValueExistInJson<String>(taskJson, "status");
      final extras =
          checkIfValueExistInJson<Map<String, dynamic>?>(taskJson, "extras");
      final createdAtString =
          checkIfValueExistInJson<String>(taskJson, "created_at");
      final createdAt = DateTime.parse(createdAtString);
      final lastUpdatedAtString =
          checkIfValueExistInJson<String>(taskJson, "last_updated_at");
      final lastUpdatedAt = DateTime.parse(lastUpdatedAtString);

      return Task(
          id: id,
          workProviderId: workProviderId,
          scenarioName: scenarioName,
          name: name,
          description: description,
          displayName: displayName,
          policy: policy,
          params: params,
          itags: itags,
          otags: otags,
          wgroup: wgroup,
          deadline: deadline,
          assignmentGranularity: assignmentGranularity,
          groupAssignmentOrder: groupAssignmentOrder,
          microtaskAssignmentOrder: microtaskAssignmentOrder,
          assignmentBatchSize: assignmentBatchSize,
          status: status,
          extras: extras,
          createdAt: createdAt,
          lastUpdatedAt: lastUpdatedAt);
    } on FormatException catch (e) {
      print("Exception occured while creating task $e ");
      rethrow;
    }
  }

  TaskRecord getTaskRecord() {
    return TaskRecord(
      id: BigInt.from(id),
      workProviderId: BigInt.from(workProviderId),
      scenarioName: scenarioName,
      name: name,
      description: description,
      displayName: displayName,
      policy: policy,
      params: jsonEncode(params),
      itags: jsonEncode(itags),
      otags: jsonEncode(otags),
      wgroup: wgroup,
      deadline: deadline,
      assignmentGranularity: assignmentGranularity,
      groupAssignmentOrder: groupAssignmentOrder,
      microtaskAssignmentOrder: microtaskAssignmentOrder,
      assignmentBatchSize: assignmentBatchSize,
      status: status,
      extras: jsonEncode(extras ?? ""),
      createdAt: createdAt,
      lastUpdatedAt: lastUpdatedAt,
    );
  }
}

TaskRecord getTaskRecordFromJson(Map<String, dynamic> taskJson) {
  print(
      "The tasks are ${taskJson['params'] as Map<String, dynamic>}, ${DateTime.parse(taskJson['last_updated_at'])}");
  return TaskRecord(
    id: BigInt.from(taskJson['id']),
    workProviderId: BigInt.from(taskJson['work_provider_id']),
    scenarioName: taskJson['scenario_name'] as String,
    name: taskJson['name'] as String,
    description: taskJson['description'] as String,
    displayName: taskJson['display_name'] as String,
    policy: taskJson['policy'] as String,
    params: taskJson['params'] as String,
    itags: taskJson['itags'] as String,
    otags: taskJson['otags'] as String,
    wgroup: taskJson['wgroup'] as String,
    deadline: DateTime.tryParse(taskJson['deadline'] ?? ''),
    assignmentGranularity: taskJson['assignment_granularity'] as String,
    groupAssignmentOrder: taskJson['group_assignment_order'] as String,
    microtaskAssignmentOrder: taskJson['microtask_assignment_order'] as String,
    assignmentBatchSize: taskJson['assignment_batch_size'] as int,
    status: taskJson['status'] as String,
    extras: taskJson['extras'] as String?,
    createdAt: DateTime.parse(taskJson['created_at']),
    lastUpdatedAt: DateTime.parse(taskJson['last_updated_at']),
  );
}
