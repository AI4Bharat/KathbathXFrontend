import 'package:drift/drift.dart';
import 'package:karya_flutter/data/database/models/task_record.dart';
import 'package:karya_flutter/data/manager/karya_db.dart';

part 'task_dao.g.dart';

@DriftAccessor(tables: [TaskRecords])
class TaskDao extends DatabaseAccessor<KaryaDatabase> with _$TaskDaoMixin {
  TaskDao(KaryaDatabase db) : super(db);

  Future<List<TaskRecord>> getAllTasks() => select(taskRecords).get();

  //Retrieve all tasks by task id
  Future<TaskRecord?> getTaskById(String id) {
    return (select(taskRecords)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  //Upsert all the task from the list to the table (ignores incase of conflict)
  Future<void> upsertAll(List<TaskRecord> tasks) async {
    await db.transaction(() async {
      await batch((batch) {
        batch.insertAll(
          db.taskRecords,
          tasks,
          mode: InsertMode.insertOrIgnore,
        );
      });
    });
  }

  Future<int> insertTask(TaskRecord task) => into(taskRecords).insert(task);

  Future<bool> updateTask(TaskRecord task) => update(taskRecords).replace(task);

  Future<int> deleteTask(String id) {
    return (delete(taskRecords)..where((t) => t.id.equals(id))).go();
  }

  Future<void> clearAllTasks() async {
    await delete(taskRecords).go(); // Deletes all rows in the table
  }
}
