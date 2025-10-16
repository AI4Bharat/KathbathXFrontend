import 'package:drift/drift.dart';
import 'package:kathbath_lite/data/database/models/task_record.dart';
import 'package:kathbath_lite/data/manager/karya_db.dart';

part 'task_dao.g.dart';

@DriftAccessor(tables: [TaskRecords])
class TaskDao extends DatabaseAccessor<KaryaDatabase> with _$TaskDaoMixin {
  TaskDao(KaryaDatabase db) : super(db);

  Future<List<Task>> getAllTasks() async {
    try {
      final tRecords = await select(taskRecords).get();
      return tRecords.map((tRecord) => Task.fromTaskRecord(tRecord)).toList();
    } catch (e) {
      return [];
    }
  }

  //Retrieve all tasks by task id
  Future<TaskRecord?> getTaskById(BigInt id) {
    return (select(taskRecords)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  //Upsert all the task from the list to the table (ignores incase of conflict)
  Future<void> upsertAll(List<Task> tasks) async {
    final taskRecords = tasks.map((task) => task.getTaskRecord());
    await db.transaction(() async {
      await batch((batch) {
        batch.insertAll(
          db.taskRecords,
          taskRecords,
          mode: InsertMode.insertOrIgnore,
        );
      });
    });
  }

  Future<int> insertTask(TaskRecord task) => into(taskRecords).insert(task);

  Future<bool> updateTask(TaskRecord task) => update(taskRecords).replace(task);

  Future<int> deleteTask(BigInt id) {
    return (delete(taskRecords)..where((t) => t.id.equals(id))).go();
  }

  Future<void> clearAllTasks() async {
    await delete(taskRecords).go(); // Deletes all rows in the table
  }
}
