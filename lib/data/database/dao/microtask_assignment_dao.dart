import 'package:drift/drift.dart';
import 'package:karya_flutter/data/database/models/microtask_assignment_record.dart';
import 'package:karya_flutter/data/manager/karya_db.dart';
import 'package:karya_flutter/models/assignment_status_enum.dart';

part 'microtask_assignment_dao.g.dart';

@DriftAccessor(tables: [MicroTaskAssignmentRecords])
class MicroTaskAssignmentDao extends DatabaseAccessor<KaryaDatabase>
    with _$MicroTaskAssignmentDaoMixin {
  final KaryaDatabase db;

  MicroTaskAssignmentDao(this.db) : super(db);

  // Retrieve all microtask assignments
  Future<List<MicroTaskAssignmentRecord>> getAllMicroTaskAssignments() =>
      select(db.microTaskAssignmentRecords).get();

  // Retrieve a specific microtask assignment by ID
  Future<MicroTaskAssignmentRecord?> getMicroTaskAssignmentById(String id) {
    return (select(db.microTaskAssignmentRecords)
          ..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
  }

  Future<void> upsertAll(List<MicroTaskAssignmentRecord> tasks) async {
    await db.transaction(() async {
      await batch((batch) {
        batch.insertAll(
          db.microTaskAssignmentRecords,
          tasks,
          mode: InsertMode.insertOrIgnore, // Ignores conflicts
        );
      });
    });
  }

  // Insert a new microtask assignment
  Future<int> insertMicroTaskAssignment(
          MicroTaskAssignmentRecord microTaskAssignment) =>
      into(db.microTaskAssignmentRecords).insert(microTaskAssignment);

  // Update an existing microtask assignment
  Future<bool> updateMicroTaskAssignment(
          MicroTaskAssignmentRecord microTaskAssignment) =>
      update(db.microTaskAssignmentRecords).replace(microTaskAssignment);

  // Delete a microtask assignment by ID
  Future<int> deleteMicroTaskAssignment(String id) =>
      (delete(db.microTaskAssignmentRecords)..where((tbl) => tbl.id.equals(id)))
          .go();

  // Clear all microtask assignments
  Future<void> clearAllMicroTaskAssignments() {
    return (delete(db.microTaskAssignmentRecords)).go();
  }

  Future<List<MicroTaskAssignmentRecord>> getMicroTaskAssignmentByTaskId(
      String taskId) {
    return (select(db.microTaskAssignmentRecords)
          ..where((tbl) => tbl.taskId.equals(taskId)))
        .get();
  }

  Future<List<MicroTaskAssignmentRecord>> getMicroTaskAssignmentByMicrotaskId(
      String microtaskId) {
    return (select(db.microTaskAssignmentRecords)
          ..where((tbl) => tbl.microtaskId.equals(microtaskId)))
        .get();
  }

  Future<List<MicroTaskAssignmentRecord>> getMicrotaskAssignmentByStatus(
      MicrotaskAssignmentStatus status) {
    return (select(db.microTaskAssignmentRecords)
          ..where(
              (tbl) => tbl.status.equals(status.toString().split('.').last)))
        .get();
  }

  Future<int> updateMicrotaskAssignmentStatus(
      String id, MicrotaskAssignmentStatus newStatus) {
    return (update(db.microTaskAssignmentRecords)
          ..where((tbl) => tbl.id.equals(id)))
        .write(MicroTaskAssignmentRecordsCompanion(
      status: Value(newStatus.toString().split('.').last),
      completedAt: Value(DateTime.now().toUtc().toIso8601String()),
      lastUpdatedAt: Value(DateTime.now().toUtc().toIso8601String()),
    ));
  }

  Future<int> updateMicrotaskAssignmentOutputFile(String id, String fileJson) {
    return (update(db.microTaskAssignmentRecords)
          ..where((tbl) => tbl.id.equals(id)))
        .write(MicroTaskAssignmentRecordsCompanion(
      output: Value(fileJson),
    ));
  }

  Future<int> updateMicrotaskAssignmentOutputFileId(
      String id, String? outputId) {
    return (update(db.microTaskAssignmentRecords)
          ..where((tbl) => tbl.id.equals(id)))
        .write(MicroTaskAssignmentRecordsCompanion(
      outputFileId: Value(outputId),
    ));
  }

  Future<List<MicroTaskAssignmentRecord>> getToBeDoneMicrotaskAssignments(
      String taskId) {
    return (select(db.microTaskAssignmentRecords)
          ..where((tbl) =>
              tbl.taskId.equals(taskId) &
              tbl.status.isNotValue(MicrotaskAssignmentStatus.SUBMITTED
                  .toString()
                  .split('.')
                  .last) &
              tbl.status.isNotValue(MicrotaskAssignmentStatus.EXPIRED
                  .toString()
                  .split('.')
                  .last)))
        .get();
  }

  Future<void> clearAllMicrotaskAssignments() {
    return (delete(db.microTaskAssignmentRecords)).go();
  }
}
