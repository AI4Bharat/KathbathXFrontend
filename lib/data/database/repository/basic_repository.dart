import 'package:kathbath_lite/data/database/dao/microtask_assignment_dao.dart';
import 'package:kathbath_lite/data/database/dao/microtask_dao.dart';
import 'package:kathbath_lite/data/database/dao/task_dao.dart';

Future<bool> clearAllDbData(TaskDao taskDao, MicroTaskDao microtaskDao,
    MicroTaskAssignmentDao microtaskAssignmentDao) async {
  try {
    await taskDao.clearAllTasks();
    await microtaskDao.clearAllMicroTasks();
    await microtaskAssignmentDao.clearAllMicroTaskAssignments();
    return true;
  } catch (_) {
    return false;
  }
}
