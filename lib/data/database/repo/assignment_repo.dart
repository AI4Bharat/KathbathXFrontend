import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:kathbath_lite/data/database/models/microtask_assignment_record.dart';
import 'package:kathbath_lite/data/database/models/microtask_record.dart';
import 'package:kathbath_lite/data/database/models/task_record.dart';
import 'package:kathbath_lite/data/database/dao/microtask_assignment_dao.dart';
import 'package:kathbath_lite/data/database/dao/microtask_dao.dart';
import 'package:kathbath_lite/data/database/dao/task_dao.dart';
import 'package:kathbath_lite/data/manager/karya_db.dart';
import 'package:kathbath_lite/services/api_services_baseUrl.dart';
import 'package:kathbath_lite/services/task_api.dart';
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

      final List<Task> tasks = (jsonData['tasks'] as List)
          .map((taskJson) => Task.fromJson(taskJson))
          .toList();

      final List<Microtask> microTasks = (jsonData['microtasks'] as List)
          .map((microTaskJson) => Microtask.fromJson(microTaskJson))
          .toList();

      final List<MicroTaskAssignment> assignments = (jsonData['assignments']
              as List)
          .map((assignmentJson) => MicroTaskAssignment.fromJson(assignmentJson))
          .toList();

      // Save the tasks to the database (uncomment the below 3 lines if you wish to vlear the db before adding new tasks)
      // await taskDao.clearAllTasks();
      // await microTaskDao.clearAllMicroTasks();
      // await microTaskAssignmentDao.clearAllMicrotaskAssignments();
      await taskDao.upsertAll(tasks);
      await microTaskDao.upsertAll(microTasks);
      await microTaskAssignmentDao.upsertAll(assignments);
    } catch (e) {
      log('Failed to load and save assignments', error: e);
    }
    return true;
    // Will always return true to show that the api request was completed
  }
}
