import 'package:drift/drift.dart';

@DataClassName('MicroTaskRecord')
class MicroTaskRecords extends Table {
  TextColumn get id => text()(); // Primary Key
  TextColumn get taskId => text().nullable()();
  TextColumn get groupId => text().nullable()();
  TextColumn get input => text().nullable()();
  TextColumn get inputFileId => text().nullable()();
  TextColumn get deadline => text().nullable()();
  RealColumn get credits => real().nullable()();
  TextColumn get output => text().nullable()();
  TextColumn get createdAt => text().nullable()();
  TextColumn get lastUpdatedAt => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
