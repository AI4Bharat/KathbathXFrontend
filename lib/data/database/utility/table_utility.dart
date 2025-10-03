import 'dart:convert';

import 'package:kathbath_lite/data/manager/karya_db.dart';

class UtilityClass {
  static TaskRecord taskRecordFromJson(Map<String, dynamic> json) {
    return TaskRecord(
      id: json['id'] as String,
      scenarioName: json['scenario_name'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      displayName: json['display_name'] as String?,
      params: json['params'] != null ? jsonEncode(json['params']) : null,
      deadline: json['deadline'] as String?,
      assignmentGranularity: json['assignment_granularity'] as String?,
      groupAssignmentOrder: json['group_assignment_order'] as String?,
      microtaskAssignmentOrder: json['microtask_assignment_order'] as String?,
      status: json['status'] as String?,
      createdAt: json['created_at'] as String?,
      lastUpdatedAt: json['last_updated_at'] as String?,
    );
  }

  static MicroTaskRecord mTaskRecordFromJson(Map<String, dynamic> json) {
    return MicroTaskRecord(
      id: json['id'] as String,
      taskId: json['task_id'] as String?,
      groupId: json['group_id'] as String?,
      input: json['input'] != null ? jsonEncode(json['input']) : null,
      inputFileId: json['input_file_id'] as String?,
      deadline: json['deadline'] as String?,
      credits: json['credits']?.toDouble(),
      output: json['output'] as String?,
      createdAt: json['created_at'] as String?,
      lastUpdatedAt: json['last_updated_at'] as String?,
    );
  }

  static MicroTaskAssignmentRecord mTaskAssignmentRecordFromJson(
      Map<String, dynamic> json) {
    return MicroTaskAssignmentRecord(
      id: json['id'] as String,
      localId: json['local_id'] as String?,
      boxId: json['box_id'] as String?,
      microtaskId: json['microtask_id'] as String?,
      taskId: json['task_id'] as String?,
      workerId: json['worker_id'] as String?,
      deadline: json['deadline'] as String?,
      status: json['status'] as String?,
      completedAt: json['completed_at'] as String?,
      output: json['output'] != null ? jsonEncode(json['logs']) : null,
      outputFileId: json['output_file_id'] as String?,
      logs: json['logs'] != null ? jsonEncode(json['logs']) : null,
      maxBaseCredits: json['max_base_credits']?.toDouble(),
      baseCredits: json['base_credits']?.toDouble(),
      credits: json['credits']?.toDouble(),
      verifiedAt: json['verifiedAt'] as String?,
      report: json['report'] as String?,
      createdAt: json['created_at'] as String?,
      lastUpdatedAt: json['last_updated_at'] as String?,
    );
  }

  Map<String, dynamic> mTaskAssignmentRecordToJson1(
      MicroTaskAssignmentRecord record) {
    return {
      'id': record.id.toString(),
      'local_id': record.localId?.toString(),
      'box_id': record.boxId?.toString(),
      'microtask_id': record.microtaskId?.toString(),
      'task_id': record.taskId?.toString(),
      'worker_id': record.workerId?.toString(),
      'deadline': record.deadline?.toString(),
      'status': record.status,
      'completed_at': record.completedAt ?? '',
      'output': record.output != null ? jsonDecode(record.output!) : {},
      'output_file_id': record.outputFileId,
      'logs': record.logs,
      'max_base_credits': record.maxBaseCredits ?? 0.0,
      'base_credits': record.baseCredits ?? 0.0,
      'credits': record.credits ?? 0.0,
      'verified_at': record.verifiedAt,
      'report': record.report,
      'created_at': record.createdAt,
      'last_updated_at': record.lastUpdatedAt,
    };
  }
}
