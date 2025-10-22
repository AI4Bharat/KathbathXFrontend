import 'package:drift/drift.dart';
import 'package:kathbath_lite/data/database/models/microtask_assignment_record.dart';
import 'package:kathbath_lite/data/manager/karya_db.dart';
import 'package:kathbath_lite/models/assignment_status_enum.dart';

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
  Future<MicroTaskAssignmentRecord?> getMicroTaskAssignmentById(BigInt id) {
    return (select(db.microTaskAssignmentRecords)
          ..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
  }

  Future<void> upsertAll(List<MicroTaskAssignment> microtaskAssignments) async {
    final microtaskAssignmentRecords = microtaskAssignments.map(
        (microtaskAssignment) =>
            microtaskAssignment.getMicrotaskAssignmentRecord());
    await db.transaction(() async {
      await batch((batch) {
        batch.insertAll(
          db.microTaskAssignmentRecords,
          microtaskAssignmentRecords,
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
  Future<int> deleteMicroTaskAssignment(BigInt id) =>
      (delete(db.microTaskAssignmentRecords)..where((tbl) => tbl.id.equals(id)))
          .go();

  // Clear all microtask assignments
  Future<void> clearAllMicroTaskAssignments() {
    return (delete(db.microTaskAssignmentRecords)).go();
  }

  Future<List<MicroTaskAssignment>> getMicroTaskAssignmentByTaskId(
      int id) async {
    final taskId = BigInt.from(id);
    final maRecords = await (select(db.microTaskAssignmentRecords)
          ..where((tbl) => tbl.taskId.equals(taskId)))
        .get();
    final microtaskAssignments = maRecords.map((microTaskAssignmentRecord) =>
        MicroTaskAssignment.fromRecord(microTaskAssignmentRecord));
    return microtaskAssignments.toList();
  }

  Future<List<MicroTaskAssignmentRecord>> getMicroTaskAssignmentByMicrotaskId(
      BigInt microtaskId) {
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
      BigInt id, MicrotaskAssignmentStatus newStatus) {
    return (update(db.microTaskAssignmentRecords)
          ..where((tbl) => tbl.id.equals(id)))
        .write(MicroTaskAssignmentRecordsCompanion(
      status: Value(newStatus.toString().split('.').last),
      completedAt: Value(DateTime.now().toUtc()),
      lastUpdatedAt: Value(DateTime.now().toUtc()),
    ));
  }

  Future<int> updateMicrotaskAssignmentOutputFile(BigInt id, String fileJson) {
    return (update(db.microTaskAssignmentRecords)
          ..where((tbl) => tbl.id.equals(id)))
        .write(MicroTaskAssignmentRecordsCompanion(
      output: Value(fileJson),
    ));
  }

  Future<int> updateMicrotaskAssignmentOutputFileId(
      BigInt id, BigInt outputId) {
    return (update(db.microTaskAssignmentRecords)
          ..where((tbl) => tbl.id.equals(id)))
        .write(MicroTaskAssignmentRecordsCompanion(
      outputFileId: Value(outputId),
    ));
  }

  Future<List<MicroTaskAssignment>> getToBeDoneMicrotaskAssignments(int id) async {
    final taskId = BigInt.from(id);
    final microtaskAssignmentRecords =
        await (select(db.microTaskAssignmentRecords)
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

    return microtaskAssignmentRecords
        .toList()
        .map((microtaskAssignmentRecord) =>
            MicroTaskAssignment.fromRecord(microtaskAssignmentRecord))
        .toList();
  }

  Future<void> clearAllMicrotaskAssignments() {
    return (delete(db.microTaskAssignmentRecords)).go();
  }
}
