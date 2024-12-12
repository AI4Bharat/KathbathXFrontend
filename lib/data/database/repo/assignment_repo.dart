import 'dart:async';
import 'package:dio/dio.dart';
import 'package:karya_flutter/data/database/utility/table_utility.dart';
import 'package:karya_flutter/data/database/dao/microtask_assignment_dao.dart';
import 'package:karya_flutter/data/database/dao/microtask_dao.dart';
import 'package:karya_flutter/data/database/dao/task_dao.dart';
import 'package:karya_flutter/data/manager/karya_db.dart';
import 'package:karya_flutter/services/api_services_baseUrl.dart';
import 'package:karya_flutter/services/task_api.dart';
import 'dart:developer';

class AssignmentRepository {
  final TaskDao taskDao;
  final MicroTaskDao microTaskDao;
  final MicroTaskAssignmentDao microTaskAssignmentDao;

  late Dio dio;
  late ApiService apiService;

  AssignmentRepository(
      this.taskDao, this.microTaskDao, this.microTaskAssignmentDao);

  Future<bool> loadAndSaveAssignments() async {
    try {
      dio = Dio();
      apiService = ApiService(dio);
      final MicroTaskAssignmentService microApiService =
          MicroTaskAssignmentService(apiService);
      var jsonData = await microApiService.getNewAssignments('2024-02-02');
      // log('JSON Data: $jsonData');

      // Parse the tasks
      final List<TaskRecord> tasks = (jsonData['tasks'] as List)
          .map((taskJson) => UtilityClass.taskRecordFromJson(taskJson))
          .toList();

      final List<MicroTaskRecord> microTasks = (jsonData['microtasks'] as List)
          .map((microTaskJson) =>
              UtilityClass.mTaskRecordFromJson(microTaskJson))
          .toList();

      final List<MicroTaskAssignmentRecord> assignments =
          (jsonData['assignments'] as List)
              .map((assignmentJson) =>
                  UtilityClass.mTaskAssignmentRecordFromJson(assignmentJson))
              .toList();

      // Save the tasks to the database (uncomment the below 3 lines if you wish to vlear the db before adding new tasks)
      // await taskDao.clearAllTasks();
      // await microTaskDao.clearAllMicroTasks();
      // await microTaskAssignmentDao.clearAllMicrotaskAssignments();
      await taskDao.upsertAll(tasks);
      await microTaskDao.upsertAll(microTasks);
      await microTaskAssignmentDao.upsertAll(assignments);
      return true;
    } catch (e) {
      log('Failed to load and save assignments', error: e);
      return false;
    }
  }
}
