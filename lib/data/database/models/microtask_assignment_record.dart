import 'package:drift/drift.dart';

@DataClassName('MicroTaskAssignmentRecord')
class MicroTaskAssignmentRecords extends Table {
  TextColumn get id => text()(); // Primary Key
  TextColumn get localId => text().named('local_id').nullable()();
  TextColumn get boxId => text().named('box_id').nullable()();
  TextColumn get microtaskId => text().named('microtask_id').nullable()();
  TextColumn get taskId => text().named('task_id').nullable()();
  TextColumn get workerId => text().named('worker_id').nullable()();
  TextColumn get deadline => text().nullable().nullable()();
  TextColumn get status =>
      text().nullable()(); // Assuming status is stored as text
  TextColumn get completedAt => text().named('completed_at').nullable()();
  TextColumn get output => text().nullable()();
  TextColumn get outputFileId => text().named('output_file_id').nullable()();
  TextColumn get logs => text().nullable()();
  RealColumn get maxBaseCredits => real().nullable()();
  RealColumn get baseCredits => real().nullable()();
  RealColumn get credits => real().nullable()();
  TextColumn get verifiedAt => text().named('verified_at').nullable()();
  TextColumn get report => text().nullable()();
  TextColumn get createdAt => text().named('created_at').nullable()();
  TextColumn get lastUpdatedAt => text().named('last_updated_at').nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
