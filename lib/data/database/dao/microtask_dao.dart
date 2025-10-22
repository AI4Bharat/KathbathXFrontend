import 'package:drift/drift.dart';
import 'package:kathbath_lite/data/database/models/microtask_assignment_record.dart';
import 'package:kathbath_lite/data/database/models/microtask_record.dart';
import 'package:kathbath_lite/data/manager/karya_db.dart';
import 'package:kathbath_lite/models/assignment_status_enum.dart';

part 'microtask_dao.g.dart';

@DriftAccessor(tables: [MicroTaskRecords, MicroTaskAssignmentRecords])
class MicroTaskDao extends DatabaseAccessor<KaryaDatabase>
    with _$MicroTaskDaoMixin {
  final KaryaDatabase db;

  MicroTaskDao(this.db) : super(db);

  // Retrieve all microtasks
  Future<List<MicroTaskRecord>> getAllMicroTasks() =>
      select(db.microTaskRecords).get();

  // Retrieve a specific microtask by microtask ID
  Future<MicroTaskRecord?> getMicroTaskById(BigInt id) {
    return (select(db.microTaskRecords)..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
  }

  //Rertrieve microtask by task ID
  Future<List<MicroTaskRecord>> getAllMicroTasksByTaskId(BigInt taskId) {
    return (select(db.microTaskRecords)
          ..where((tbl) => tbl.taskId.equals(taskId)))
        .get();
  }

  Future<List<Microtask>> getMicroTasksWithPendingAssignments(int id) async {
    final taskId = BigInt.from(id);
    final query = select(db.microTaskRecords).join([
      innerJoin(
        db.microTaskAssignmentRecords,
        db.microTaskAssignmentRecords.microtaskId
            .equalsExp(db.microTaskRecords.id),
      )
    ])
      ..where(db.microTaskRecords.taskId.equals(taskId))
      ..where(db.microTaskAssignmentRecords.status.isNotValue(
              MicrotaskAssignmentStatus.SUBMITTED.toString().split('.').last) &
          db.microTaskAssignmentRecords.status.isNotValue(
              MicrotaskAssignmentStatus.EXPIRED.toString().split('.').last));

    // Map the result to get only microTaskRecords
    final microtaskRecords = await query.map((row) {
      return row.readTable(db.microTaskRecords);
    }).get();
    return microtaskRecords
        .toList()
        .map((microtaskRecord) => Microtask.fromRecord(microtaskRecord))
        .toList();
  }

  Future<void> upsertAll(List<Microtask> microtasks) async {
    final microtaskRecords =
        microtasks.map((microtask) => microtask.getMicrotaskRecord());
    await db.transaction(() async {
      await batch((batch) {
        batch.insertAll(
          db.microTaskRecords,
          microtaskRecords,
          mode: InsertMode.insertOrIgnore, // Ignores conflicts
        );
      });
    });
  }

  // Insert a new microtask
  Future<int> insertMicroTask(MicroTaskRecord microTask) =>
      into(db.microTaskRecords).insert(microTask);

  // Update an existing microtask
  Future<bool> updateMicroTask(MicroTaskRecord microTask) =>
      update(db.microTaskRecords).replace(microTask);

  // Delete a microtask by ID
  Future<int> deleteMicroTask(BigInt id) =>
      (delete(db.microTaskRecords)..where((tbl) => tbl.id.equals(id))).go();

  // Clear all microtasks
  Future<void> clearAllMicroTasks() {
    return (delete(db.microTaskRecords)).go();
  }
}
