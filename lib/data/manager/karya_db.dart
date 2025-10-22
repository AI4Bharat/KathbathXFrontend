import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:kathbath_lite/data/database/dao/microtask_assignment_dao.dart';
import 'package:kathbath_lite/data/database/dao/microtask_dao.dart';
import 'package:kathbath_lite/data/database/dao/task_dao.dart';
import 'package:kathbath_lite/data/database/models/microtask_assignment_record.dart';
import 'package:kathbath_lite/data/database/models/microtask_record.dart';
import 'package:kathbath_lite/data/database/models/task_record.dart';
import 'package:path_provider/path_provider.dart';

part 'karya_db.g.dart';

@DriftDatabase(tables: [
  TaskRecords,
  MicroTaskRecords,
  MicroTaskAssignmentRecords,
], daos: [
  TaskDao,
  MicroTaskDao,
  MicroTaskAssignmentDao
])
class KaryaDatabase extends _$KaryaDatabase {
  KaryaDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File('${dbFolder.path}/db.sqlite');
    return NativeDatabase(file);
  });
}
