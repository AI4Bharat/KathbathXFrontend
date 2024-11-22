// ignore_for_file: constant_identifier_names

import 'package:drift/drift.dart';

enum AssignmentGranularityType { GROUP, MICROTASK, EITHER }

enum AssignmentOrderType { SEQUENTIAL, RANDOM, EITHER }

@DataClassName('TaskRecord')
class TaskRecords extends Table {
  TextColumn get id => text()(); // Primary Key
  TextColumn get scenarioName => text().nullable()();
  TextColumn get name => text().nullable()();
  TextColumn get description => text().nullable()();
  TextColumn get displayName => text().nullable()();
  TextColumn get params => text().nullable()();
  TextColumn get deadline => text().nullable()();
  TextColumn get assignmentGranularity => text().nullable()();
  TextColumn get groupAssignmentOrder => text().nullable()();
  TextColumn get microtaskAssignmentOrder => text().nullable()();
  TextColumn get status => text().nullable()();
  TextColumn get createdAt => text().nullable()();
  TextColumn get lastUpdatedAt => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
