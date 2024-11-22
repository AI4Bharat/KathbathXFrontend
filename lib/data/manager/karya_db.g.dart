// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'karya_db.dart';

// ignore_for_file: type=lint
class $TaskRecordsTable extends TaskRecords
    with TableInfo<$TaskRecordsTable, TaskRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TaskRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _scenarioNameMeta =
      const VerificationMeta('scenarioName');
  @override
  late final GeneratedColumn<String> scenarioName = GeneratedColumn<String>(
      'scenario_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _displayNameMeta =
      const VerificationMeta('displayName');
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
      'display_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _paramsMeta = const VerificationMeta('params');
  @override
  late final GeneratedColumn<String> params = GeneratedColumn<String>(
      'params', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _deadlineMeta =
      const VerificationMeta('deadline');
  @override
  late final GeneratedColumn<String> deadline = GeneratedColumn<String>(
      'deadline', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _assignmentGranularityMeta =
      const VerificationMeta('assignmentGranularity');
  @override
  late final GeneratedColumn<String> assignmentGranularity =
      GeneratedColumn<String>('assignment_granularity', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _groupAssignmentOrderMeta =
      const VerificationMeta('groupAssignmentOrder');
  @override
  late final GeneratedColumn<String> groupAssignmentOrder =
      GeneratedColumn<String>('group_assignment_order', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _microtaskAssignmentOrderMeta =
      const VerificationMeta('microtaskAssignmentOrder');
  @override
  late final GeneratedColumn<String> microtaskAssignmentOrder =
      GeneratedColumn<String>('microtask_assignment_order', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
      'created_at', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _lastUpdatedAtMeta =
      const VerificationMeta('lastUpdatedAt');
  @override
  late final GeneratedColumn<String> lastUpdatedAt = GeneratedColumn<String>(
      'last_updated_at', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        scenarioName,
        name,
        description,
        displayName,
        params,
        deadline,
        assignmentGranularity,
        groupAssignmentOrder,
        microtaskAssignmentOrder,
        status,
        createdAt,
        lastUpdatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'task_records';
  @override
  VerificationContext validateIntegrity(Insertable<TaskRecord> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('scenario_name')) {
      context.handle(
          _scenarioNameMeta,
          scenarioName.isAcceptableOrUnknown(
              data['scenario_name']!, _scenarioNameMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('display_name')) {
      context.handle(
          _displayNameMeta,
          displayName.isAcceptableOrUnknown(
              data['display_name']!, _displayNameMeta));
    }
    if (data.containsKey('params')) {
      context.handle(_paramsMeta,
          params.isAcceptableOrUnknown(data['params']!, _paramsMeta));
    }
    if (data.containsKey('deadline')) {
      context.handle(_deadlineMeta,
          deadline.isAcceptableOrUnknown(data['deadline']!, _deadlineMeta));
    }
    if (data.containsKey('assignment_granularity')) {
      context.handle(
          _assignmentGranularityMeta,
          assignmentGranularity.isAcceptableOrUnknown(
              data['assignment_granularity']!, _assignmentGranularityMeta));
    }
    if (data.containsKey('group_assignment_order')) {
      context.handle(
          _groupAssignmentOrderMeta,
          groupAssignmentOrder.isAcceptableOrUnknown(
              data['group_assignment_order']!, _groupAssignmentOrderMeta));
    }
    if (data.containsKey('microtask_assignment_order')) {
      context.handle(
          _microtaskAssignmentOrderMeta,
          microtaskAssignmentOrder.isAcceptableOrUnknown(
              data['microtask_assignment_order']!,
              _microtaskAssignmentOrderMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('last_updated_at')) {
      context.handle(
          _lastUpdatedAtMeta,
          lastUpdatedAt.isAcceptableOrUnknown(
              data['last_updated_at']!, _lastUpdatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TaskRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaskRecord(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      scenarioName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}scenario_name']),
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name']),
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      displayName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}display_name']),
      params: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}params']),
      deadline: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}deadline']),
      assignmentGranularity: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}assignment_granularity']),
      groupAssignmentOrder: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}group_assignment_order']),
      microtaskAssignmentOrder: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}microtask_assignment_order']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_at']),
      lastUpdatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}last_updated_at']),
    );
  }

  @override
  $TaskRecordsTable createAlias(String alias) {
    return $TaskRecordsTable(attachedDatabase, alias);
  }
}

class TaskRecord extends DataClass implements Insertable<TaskRecord> {
  final String id;
  final String? scenarioName;
  final String? name;
  final String? description;
  final String? displayName;
  final String? params;
  final String? deadline;
  final String? assignmentGranularity;
  final String? groupAssignmentOrder;
  final String? microtaskAssignmentOrder;
  final String? status;
  final String? createdAt;
  final String? lastUpdatedAt;
  const TaskRecord(
      {required this.id,
      this.scenarioName,
      this.name,
      this.description,
      this.displayName,
      this.params,
      this.deadline,
      this.assignmentGranularity,
      this.groupAssignmentOrder,
      this.microtaskAssignmentOrder,
      this.status,
      this.createdAt,
      this.lastUpdatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || scenarioName != null) {
      map['scenario_name'] = Variable<String>(scenarioName);
    }
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || displayName != null) {
      map['display_name'] = Variable<String>(displayName);
    }
    if (!nullToAbsent || params != null) {
      map['params'] = Variable<String>(params);
    }
    if (!nullToAbsent || deadline != null) {
      map['deadline'] = Variable<String>(deadline);
    }
    if (!nullToAbsent || assignmentGranularity != null) {
      map['assignment_granularity'] = Variable<String>(assignmentGranularity);
    }
    if (!nullToAbsent || groupAssignmentOrder != null) {
      map['group_assignment_order'] = Variable<String>(groupAssignmentOrder);
    }
    if (!nullToAbsent || microtaskAssignmentOrder != null) {
      map['microtask_assignment_order'] =
          Variable<String>(microtaskAssignmentOrder);
    }
    if (!nullToAbsent || status != null) {
      map['status'] = Variable<String>(status);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<String>(createdAt);
    }
    if (!nullToAbsent || lastUpdatedAt != null) {
      map['last_updated_at'] = Variable<String>(lastUpdatedAt);
    }
    return map;
  }

  TaskRecordsCompanion toCompanion(bool nullToAbsent) {
    return TaskRecordsCompanion(
      id: Value(id),
      scenarioName: scenarioName == null && nullToAbsent
          ? const Value.absent()
          : Value(scenarioName),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      displayName: displayName == null && nullToAbsent
          ? const Value.absent()
          : Value(displayName),
      params:
          params == null && nullToAbsent ? const Value.absent() : Value(params),
      deadline: deadline == null && nullToAbsent
          ? const Value.absent()
          : Value(deadline),
      assignmentGranularity: assignmentGranularity == null && nullToAbsent
          ? const Value.absent()
          : Value(assignmentGranularity),
      groupAssignmentOrder: groupAssignmentOrder == null && nullToAbsent
          ? const Value.absent()
          : Value(groupAssignmentOrder),
      microtaskAssignmentOrder: microtaskAssignmentOrder == null && nullToAbsent
          ? const Value.absent()
          : Value(microtaskAssignmentOrder),
      status:
          status == null && nullToAbsent ? const Value.absent() : Value(status),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      lastUpdatedAt: lastUpdatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastUpdatedAt),
    );
  }

  factory TaskRecord.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaskRecord(
      id: serializer.fromJson<String>(json['id']),
      scenarioName: serializer.fromJson<String?>(json['scenarioName']),
      name: serializer.fromJson<String?>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      displayName: serializer.fromJson<String?>(json['displayName']),
      params: serializer.fromJson<String?>(json['params']),
      deadline: serializer.fromJson<String?>(json['deadline']),
      assignmentGranularity:
          serializer.fromJson<String?>(json['assignmentGranularity']),
      groupAssignmentOrder:
          serializer.fromJson<String?>(json['groupAssignmentOrder']),
      microtaskAssignmentOrder:
          serializer.fromJson<String?>(json['microtaskAssignmentOrder']),
      status: serializer.fromJson<String?>(json['status']),
      createdAt: serializer.fromJson<String?>(json['createdAt']),
      lastUpdatedAt: serializer.fromJson<String?>(json['lastUpdatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'scenarioName': serializer.toJson<String?>(scenarioName),
      'name': serializer.toJson<String?>(name),
      'description': serializer.toJson<String?>(description),
      'displayName': serializer.toJson<String?>(displayName),
      'params': serializer.toJson<String?>(params),
      'deadline': serializer.toJson<String?>(deadline),
      'assignmentGranularity':
          serializer.toJson<String?>(assignmentGranularity),
      'groupAssignmentOrder': serializer.toJson<String?>(groupAssignmentOrder),
      'microtaskAssignmentOrder':
          serializer.toJson<String?>(microtaskAssignmentOrder),
      'status': serializer.toJson<String?>(status),
      'createdAt': serializer.toJson<String?>(createdAt),
      'lastUpdatedAt': serializer.toJson<String?>(lastUpdatedAt),
    };
  }

  TaskRecord copyWith(
          {String? id,
          Value<String?> scenarioName = const Value.absent(),
          Value<String?> name = const Value.absent(),
          Value<String?> description = const Value.absent(),
          Value<String?> displayName = const Value.absent(),
          Value<String?> params = const Value.absent(),
          Value<String?> deadline = const Value.absent(),
          Value<String?> assignmentGranularity = const Value.absent(),
          Value<String?> groupAssignmentOrder = const Value.absent(),
          Value<String?> microtaskAssignmentOrder = const Value.absent(),
          Value<String?> status = const Value.absent(),
          Value<String?> createdAt = const Value.absent(),
          Value<String?> lastUpdatedAt = const Value.absent()}) =>
      TaskRecord(
        id: id ?? this.id,
        scenarioName:
            scenarioName.present ? scenarioName.value : this.scenarioName,
        name: name.present ? name.value : this.name,
        description: description.present ? description.value : this.description,
        displayName: displayName.present ? displayName.value : this.displayName,
        params: params.present ? params.value : this.params,
        deadline: deadline.present ? deadline.value : this.deadline,
        assignmentGranularity: assignmentGranularity.present
            ? assignmentGranularity.value
            : this.assignmentGranularity,
        groupAssignmentOrder: groupAssignmentOrder.present
            ? groupAssignmentOrder.value
            : this.groupAssignmentOrder,
        microtaskAssignmentOrder: microtaskAssignmentOrder.present
            ? microtaskAssignmentOrder.value
            : this.microtaskAssignmentOrder,
        status: status.present ? status.value : this.status,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
        lastUpdatedAt:
            lastUpdatedAt.present ? lastUpdatedAt.value : this.lastUpdatedAt,
      );
  TaskRecord copyWithCompanion(TaskRecordsCompanion data) {
    return TaskRecord(
      id: data.id.present ? data.id.value : this.id,
      scenarioName: data.scenarioName.present
          ? data.scenarioName.value
          : this.scenarioName,
      name: data.name.present ? data.name.value : this.name,
      description:
          data.description.present ? data.description.value : this.description,
      displayName:
          data.displayName.present ? data.displayName.value : this.displayName,
      params: data.params.present ? data.params.value : this.params,
      deadline: data.deadline.present ? data.deadline.value : this.deadline,
      assignmentGranularity: data.assignmentGranularity.present
          ? data.assignmentGranularity.value
          : this.assignmentGranularity,
      groupAssignmentOrder: data.groupAssignmentOrder.present
          ? data.groupAssignmentOrder.value
          : this.groupAssignmentOrder,
      microtaskAssignmentOrder: data.microtaskAssignmentOrder.present
          ? data.microtaskAssignmentOrder.value
          : this.microtaskAssignmentOrder,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      lastUpdatedAt: data.lastUpdatedAt.present
          ? data.lastUpdatedAt.value
          : this.lastUpdatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TaskRecord(')
          ..write('id: $id, ')
          ..write('scenarioName: $scenarioName, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('displayName: $displayName, ')
          ..write('params: $params, ')
          ..write('deadline: $deadline, ')
          ..write('assignmentGranularity: $assignmentGranularity, ')
          ..write('groupAssignmentOrder: $groupAssignmentOrder, ')
          ..write('microtaskAssignmentOrder: $microtaskAssignmentOrder, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastUpdatedAt: $lastUpdatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      scenarioName,
      name,
      description,
      displayName,
      params,
      deadline,
      assignmentGranularity,
      groupAssignmentOrder,
      microtaskAssignmentOrder,
      status,
      createdAt,
      lastUpdatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaskRecord &&
          other.id == this.id &&
          other.scenarioName == this.scenarioName &&
          other.name == this.name &&
          other.description == this.description &&
          other.displayName == this.displayName &&
          other.params == this.params &&
          other.deadline == this.deadline &&
          other.assignmentGranularity == this.assignmentGranularity &&
          other.groupAssignmentOrder == this.groupAssignmentOrder &&
          other.microtaskAssignmentOrder == this.microtaskAssignmentOrder &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.lastUpdatedAt == this.lastUpdatedAt);
}

class TaskRecordsCompanion extends UpdateCompanion<TaskRecord> {
  final Value<String> id;
  final Value<String?> scenarioName;
  final Value<String?> name;
  final Value<String?> description;
  final Value<String?> displayName;
  final Value<String?> params;
  final Value<String?> deadline;
  final Value<String?> assignmentGranularity;
  final Value<String?> groupAssignmentOrder;
  final Value<String?> microtaskAssignmentOrder;
  final Value<String?> status;
  final Value<String?> createdAt;
  final Value<String?> lastUpdatedAt;
  final Value<int> rowid;
  const TaskRecordsCompanion({
    this.id = const Value.absent(),
    this.scenarioName = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.displayName = const Value.absent(),
    this.params = const Value.absent(),
    this.deadline = const Value.absent(),
    this.assignmentGranularity = const Value.absent(),
    this.groupAssignmentOrder = const Value.absent(),
    this.microtaskAssignmentOrder = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.lastUpdatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TaskRecordsCompanion.insert({
    required String id,
    this.scenarioName = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.displayName = const Value.absent(),
    this.params = const Value.absent(),
    this.deadline = const Value.absent(),
    this.assignmentGranularity = const Value.absent(),
    this.groupAssignmentOrder = const Value.absent(),
    this.microtaskAssignmentOrder = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.lastUpdatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id);
  static Insertable<TaskRecord> custom({
    Expression<String>? id,
    Expression<String>? scenarioName,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? displayName,
    Expression<String>? params,
    Expression<String>? deadline,
    Expression<String>? assignmentGranularity,
    Expression<String>? groupAssignmentOrder,
    Expression<String>? microtaskAssignmentOrder,
    Expression<String>? status,
    Expression<String>? createdAt,
    Expression<String>? lastUpdatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (scenarioName != null) 'scenario_name': scenarioName,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (displayName != null) 'display_name': displayName,
      if (params != null) 'params': params,
      if (deadline != null) 'deadline': deadline,
      if (assignmentGranularity != null)
        'assignment_granularity': assignmentGranularity,
      if (groupAssignmentOrder != null)
        'group_assignment_order': groupAssignmentOrder,
      if (microtaskAssignmentOrder != null)
        'microtask_assignment_order': microtaskAssignmentOrder,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (lastUpdatedAt != null) 'last_updated_at': lastUpdatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TaskRecordsCompanion copyWith(
      {Value<String>? id,
      Value<String?>? scenarioName,
      Value<String?>? name,
      Value<String?>? description,
      Value<String?>? displayName,
      Value<String?>? params,
      Value<String?>? deadline,
      Value<String?>? assignmentGranularity,
      Value<String?>? groupAssignmentOrder,
      Value<String?>? microtaskAssignmentOrder,
      Value<String?>? status,
      Value<String?>? createdAt,
      Value<String?>? lastUpdatedAt,
      Value<int>? rowid}) {
    return TaskRecordsCompanion(
      id: id ?? this.id,
      scenarioName: scenarioName ?? this.scenarioName,
      name: name ?? this.name,
      description: description ?? this.description,
      displayName: displayName ?? this.displayName,
      params: params ?? this.params,
      deadline: deadline ?? this.deadline,
      assignmentGranularity:
          assignmentGranularity ?? this.assignmentGranularity,
      groupAssignmentOrder: groupAssignmentOrder ?? this.groupAssignmentOrder,
      microtaskAssignmentOrder:
          microtaskAssignmentOrder ?? this.microtaskAssignmentOrder,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (scenarioName.present) {
      map['scenario_name'] = Variable<String>(scenarioName.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (params.present) {
      map['params'] = Variable<String>(params.value);
    }
    if (deadline.present) {
      map['deadline'] = Variable<String>(deadline.value);
    }
    if (assignmentGranularity.present) {
      map['assignment_granularity'] =
          Variable<String>(assignmentGranularity.value);
    }
    if (groupAssignmentOrder.present) {
      map['group_assignment_order'] =
          Variable<String>(groupAssignmentOrder.value);
    }
    if (microtaskAssignmentOrder.present) {
      map['microtask_assignment_order'] =
          Variable<String>(microtaskAssignmentOrder.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (lastUpdatedAt.present) {
      map['last_updated_at'] = Variable<String>(lastUpdatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TaskRecordsCompanion(')
          ..write('id: $id, ')
          ..write('scenarioName: $scenarioName, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('displayName: $displayName, ')
          ..write('params: $params, ')
          ..write('deadline: $deadline, ')
          ..write('assignmentGranularity: $assignmentGranularity, ')
          ..write('groupAssignmentOrder: $groupAssignmentOrder, ')
          ..write('microtaskAssignmentOrder: $microtaskAssignmentOrder, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastUpdatedAt: $lastUpdatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MicroTaskRecordsTable extends MicroTaskRecords
    with TableInfo<$MicroTaskRecordsTable, MicroTaskRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MicroTaskRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<String> taskId = GeneratedColumn<String>(
      'task_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _groupIdMeta =
      const VerificationMeta('groupId');
  @override
  late final GeneratedColumn<String> groupId = GeneratedColumn<String>(
      'group_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _inputMeta = const VerificationMeta('input');
  @override
  late final GeneratedColumn<String> input = GeneratedColumn<String>(
      'input', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _inputFileIdMeta =
      const VerificationMeta('inputFileId');
  @override
  late final GeneratedColumn<String> inputFileId = GeneratedColumn<String>(
      'input_file_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _deadlineMeta =
      const VerificationMeta('deadline');
  @override
  late final GeneratedColumn<String> deadline = GeneratedColumn<String>(
      'deadline', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _creditsMeta =
      const VerificationMeta('credits');
  @override
  late final GeneratedColumn<double> credits = GeneratedColumn<double>(
      'credits', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _outputMeta = const VerificationMeta('output');
  @override
  late final GeneratedColumn<String> output = GeneratedColumn<String>(
      'output', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
      'created_at', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _lastUpdatedAtMeta =
      const VerificationMeta('lastUpdatedAt');
  @override
  late final GeneratedColumn<String> lastUpdatedAt = GeneratedColumn<String>(
      'last_updated_at', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        taskId,
        groupId,
        input,
        inputFileId,
        deadline,
        credits,
        output,
        createdAt,
        lastUpdatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'micro_task_records';
  @override
  VerificationContext validateIntegrity(Insertable<MicroTaskRecord> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('task_id')) {
      context.handle(_taskIdMeta,
          taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta));
    }
    if (data.containsKey('group_id')) {
      context.handle(_groupIdMeta,
          groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta));
    }
    if (data.containsKey('input')) {
      context.handle(
          _inputMeta, input.isAcceptableOrUnknown(data['input']!, _inputMeta));
    }
    if (data.containsKey('input_file_id')) {
      context.handle(
          _inputFileIdMeta,
          inputFileId.isAcceptableOrUnknown(
              data['input_file_id']!, _inputFileIdMeta));
    }
    if (data.containsKey('deadline')) {
      context.handle(_deadlineMeta,
          deadline.isAcceptableOrUnknown(data['deadline']!, _deadlineMeta));
    }
    if (data.containsKey('credits')) {
      context.handle(_creditsMeta,
          credits.isAcceptableOrUnknown(data['credits']!, _creditsMeta));
    }
    if (data.containsKey('output')) {
      context.handle(_outputMeta,
          output.isAcceptableOrUnknown(data['output']!, _outputMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('last_updated_at')) {
      context.handle(
          _lastUpdatedAtMeta,
          lastUpdatedAt.isAcceptableOrUnknown(
              data['last_updated_at']!, _lastUpdatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MicroTaskRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MicroTaskRecord(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      taskId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}task_id']),
      groupId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}group_id']),
      input: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}input']),
      inputFileId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}input_file_id']),
      deadline: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}deadline']),
      credits: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}credits']),
      output: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}output']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_at']),
      lastUpdatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}last_updated_at']),
    );
  }

  @override
  $MicroTaskRecordsTable createAlias(String alias) {
    return $MicroTaskRecordsTable(attachedDatabase, alias);
  }
}

class MicroTaskRecord extends DataClass implements Insertable<MicroTaskRecord> {
  final String id;
  final String? taskId;
  final String? groupId;
  final String? input;
  final String? inputFileId;
  final String? deadline;
  final double? credits;
  final String? output;
  final String? createdAt;
  final String? lastUpdatedAt;
  const MicroTaskRecord(
      {required this.id,
      this.taskId,
      this.groupId,
      this.input,
      this.inputFileId,
      this.deadline,
      this.credits,
      this.output,
      this.createdAt,
      this.lastUpdatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || taskId != null) {
      map['task_id'] = Variable<String>(taskId);
    }
    if (!nullToAbsent || groupId != null) {
      map['group_id'] = Variable<String>(groupId);
    }
    if (!nullToAbsent || input != null) {
      map['input'] = Variable<String>(input);
    }
    if (!nullToAbsent || inputFileId != null) {
      map['input_file_id'] = Variable<String>(inputFileId);
    }
    if (!nullToAbsent || deadline != null) {
      map['deadline'] = Variable<String>(deadline);
    }
    if (!nullToAbsent || credits != null) {
      map['credits'] = Variable<double>(credits);
    }
    if (!nullToAbsent || output != null) {
      map['output'] = Variable<String>(output);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<String>(createdAt);
    }
    if (!nullToAbsent || lastUpdatedAt != null) {
      map['last_updated_at'] = Variable<String>(lastUpdatedAt);
    }
    return map;
  }

  MicroTaskRecordsCompanion toCompanion(bool nullToAbsent) {
    return MicroTaskRecordsCompanion(
      id: Value(id),
      taskId:
          taskId == null && nullToAbsent ? const Value.absent() : Value(taskId),
      groupId: groupId == null && nullToAbsent
          ? const Value.absent()
          : Value(groupId),
      input:
          input == null && nullToAbsent ? const Value.absent() : Value(input),
      inputFileId: inputFileId == null && nullToAbsent
          ? const Value.absent()
          : Value(inputFileId),
      deadline: deadline == null && nullToAbsent
          ? const Value.absent()
          : Value(deadline),
      credits: credits == null && nullToAbsent
          ? const Value.absent()
          : Value(credits),
      output:
          output == null && nullToAbsent ? const Value.absent() : Value(output),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      lastUpdatedAt: lastUpdatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastUpdatedAt),
    );
  }

  factory MicroTaskRecord.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MicroTaskRecord(
      id: serializer.fromJson<String>(json['id']),
      taskId: serializer.fromJson<String?>(json['taskId']),
      groupId: serializer.fromJson<String?>(json['groupId']),
      input: serializer.fromJson<String?>(json['input']),
      inputFileId: serializer.fromJson<String?>(json['inputFileId']),
      deadline: serializer.fromJson<String?>(json['deadline']),
      credits: serializer.fromJson<double?>(json['credits']),
      output: serializer.fromJson<String?>(json['output']),
      createdAt: serializer.fromJson<String?>(json['createdAt']),
      lastUpdatedAt: serializer.fromJson<String?>(json['lastUpdatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'taskId': serializer.toJson<String?>(taskId),
      'groupId': serializer.toJson<String?>(groupId),
      'input': serializer.toJson<String?>(input),
      'inputFileId': serializer.toJson<String?>(inputFileId),
      'deadline': serializer.toJson<String?>(deadline),
      'credits': serializer.toJson<double?>(credits),
      'output': serializer.toJson<String?>(output),
      'createdAt': serializer.toJson<String?>(createdAt),
      'lastUpdatedAt': serializer.toJson<String?>(lastUpdatedAt),
    };
  }

  MicroTaskRecord copyWith(
          {String? id,
          Value<String?> taskId = const Value.absent(),
          Value<String?> groupId = const Value.absent(),
          Value<String?> input = const Value.absent(),
          Value<String?> inputFileId = const Value.absent(),
          Value<String?> deadline = const Value.absent(),
          Value<double?> credits = const Value.absent(),
          Value<String?> output = const Value.absent(),
          Value<String?> createdAt = const Value.absent(),
          Value<String?> lastUpdatedAt = const Value.absent()}) =>
      MicroTaskRecord(
        id: id ?? this.id,
        taskId: taskId.present ? taskId.value : this.taskId,
        groupId: groupId.present ? groupId.value : this.groupId,
        input: input.present ? input.value : this.input,
        inputFileId: inputFileId.present ? inputFileId.value : this.inputFileId,
        deadline: deadline.present ? deadline.value : this.deadline,
        credits: credits.present ? credits.value : this.credits,
        output: output.present ? output.value : this.output,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
        lastUpdatedAt:
            lastUpdatedAt.present ? lastUpdatedAt.value : this.lastUpdatedAt,
      );
  MicroTaskRecord copyWithCompanion(MicroTaskRecordsCompanion data) {
    return MicroTaskRecord(
      id: data.id.present ? data.id.value : this.id,
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
      groupId: data.groupId.present ? data.groupId.value : this.groupId,
      input: data.input.present ? data.input.value : this.input,
      inputFileId:
          data.inputFileId.present ? data.inputFileId.value : this.inputFileId,
      deadline: data.deadline.present ? data.deadline.value : this.deadline,
      credits: data.credits.present ? data.credits.value : this.credits,
      output: data.output.present ? data.output.value : this.output,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      lastUpdatedAt: data.lastUpdatedAt.present
          ? data.lastUpdatedAt.value
          : this.lastUpdatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MicroTaskRecord(')
          ..write('id: $id, ')
          ..write('taskId: $taskId, ')
          ..write('groupId: $groupId, ')
          ..write('input: $input, ')
          ..write('inputFileId: $inputFileId, ')
          ..write('deadline: $deadline, ')
          ..write('credits: $credits, ')
          ..write('output: $output, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastUpdatedAt: $lastUpdatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, taskId, groupId, input, inputFileId,
      deadline, credits, output, createdAt, lastUpdatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MicroTaskRecord &&
          other.id == this.id &&
          other.taskId == this.taskId &&
          other.groupId == this.groupId &&
          other.input == this.input &&
          other.inputFileId == this.inputFileId &&
          other.deadline == this.deadline &&
          other.credits == this.credits &&
          other.output == this.output &&
          other.createdAt == this.createdAt &&
          other.lastUpdatedAt == this.lastUpdatedAt);
}

class MicroTaskRecordsCompanion extends UpdateCompanion<MicroTaskRecord> {
  final Value<String> id;
  final Value<String?> taskId;
  final Value<String?> groupId;
  final Value<String?> input;
  final Value<String?> inputFileId;
  final Value<String?> deadline;
  final Value<double?> credits;
  final Value<String?> output;
  final Value<String?> createdAt;
  final Value<String?> lastUpdatedAt;
  final Value<int> rowid;
  const MicroTaskRecordsCompanion({
    this.id = const Value.absent(),
    this.taskId = const Value.absent(),
    this.groupId = const Value.absent(),
    this.input = const Value.absent(),
    this.inputFileId = const Value.absent(),
    this.deadline = const Value.absent(),
    this.credits = const Value.absent(),
    this.output = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.lastUpdatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MicroTaskRecordsCompanion.insert({
    required String id,
    this.taskId = const Value.absent(),
    this.groupId = const Value.absent(),
    this.input = const Value.absent(),
    this.inputFileId = const Value.absent(),
    this.deadline = const Value.absent(),
    this.credits = const Value.absent(),
    this.output = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.lastUpdatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id);
  static Insertable<MicroTaskRecord> custom({
    Expression<String>? id,
    Expression<String>? taskId,
    Expression<String>? groupId,
    Expression<String>? input,
    Expression<String>? inputFileId,
    Expression<String>? deadline,
    Expression<double>? credits,
    Expression<String>? output,
    Expression<String>? createdAt,
    Expression<String>? lastUpdatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (taskId != null) 'task_id': taskId,
      if (groupId != null) 'group_id': groupId,
      if (input != null) 'input': input,
      if (inputFileId != null) 'input_file_id': inputFileId,
      if (deadline != null) 'deadline': deadline,
      if (credits != null) 'credits': credits,
      if (output != null) 'output': output,
      if (createdAt != null) 'created_at': createdAt,
      if (lastUpdatedAt != null) 'last_updated_at': lastUpdatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MicroTaskRecordsCompanion copyWith(
      {Value<String>? id,
      Value<String?>? taskId,
      Value<String?>? groupId,
      Value<String?>? input,
      Value<String?>? inputFileId,
      Value<String?>? deadline,
      Value<double?>? credits,
      Value<String?>? output,
      Value<String?>? createdAt,
      Value<String?>? lastUpdatedAt,
      Value<int>? rowid}) {
    return MicroTaskRecordsCompanion(
      id: id ?? this.id,
      taskId: taskId ?? this.taskId,
      groupId: groupId ?? this.groupId,
      input: input ?? this.input,
      inputFileId: inputFileId ?? this.inputFileId,
      deadline: deadline ?? this.deadline,
      credits: credits ?? this.credits,
      output: output ?? this.output,
      createdAt: createdAt ?? this.createdAt,
      lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (taskId.present) {
      map['task_id'] = Variable<String>(taskId.value);
    }
    if (groupId.present) {
      map['group_id'] = Variable<String>(groupId.value);
    }
    if (input.present) {
      map['input'] = Variable<String>(input.value);
    }
    if (inputFileId.present) {
      map['input_file_id'] = Variable<String>(inputFileId.value);
    }
    if (deadline.present) {
      map['deadline'] = Variable<String>(deadline.value);
    }
    if (credits.present) {
      map['credits'] = Variable<double>(credits.value);
    }
    if (output.present) {
      map['output'] = Variable<String>(output.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (lastUpdatedAt.present) {
      map['last_updated_at'] = Variable<String>(lastUpdatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MicroTaskRecordsCompanion(')
          ..write('id: $id, ')
          ..write('taskId: $taskId, ')
          ..write('groupId: $groupId, ')
          ..write('input: $input, ')
          ..write('inputFileId: $inputFileId, ')
          ..write('deadline: $deadline, ')
          ..write('credits: $credits, ')
          ..write('output: $output, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastUpdatedAt: $lastUpdatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MicroTaskAssignmentRecordsTable extends MicroTaskAssignmentRecords
    with
        TableInfo<$MicroTaskAssignmentRecordsTable, MicroTaskAssignmentRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MicroTaskAssignmentRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _localIdMeta =
      const VerificationMeta('localId');
  @override
  late final GeneratedColumn<String> localId = GeneratedColumn<String>(
      'local_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _boxIdMeta = const VerificationMeta('boxId');
  @override
  late final GeneratedColumn<String> boxId = GeneratedColumn<String>(
      'box_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _microtaskIdMeta =
      const VerificationMeta('microtaskId');
  @override
  late final GeneratedColumn<String> microtaskId = GeneratedColumn<String>(
      'microtask_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<String> taskId = GeneratedColumn<String>(
      'task_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _workerIdMeta =
      const VerificationMeta('workerId');
  @override
  late final GeneratedColumn<String> workerId = GeneratedColumn<String>(
      'worker_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _deadlineMeta =
      const VerificationMeta('deadline');
  @override
  late final GeneratedColumn<String> deadline = GeneratedColumn<String>(
      'deadline', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _completedAtMeta =
      const VerificationMeta('completedAt');
  @override
  late final GeneratedColumn<String> completedAt = GeneratedColumn<String>(
      'completed_at', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _outputMeta = const VerificationMeta('output');
  @override
  late final GeneratedColumn<String> output = GeneratedColumn<String>(
      'output', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _outputFileIdMeta =
      const VerificationMeta('outputFileId');
  @override
  late final GeneratedColumn<String> outputFileId = GeneratedColumn<String>(
      'output_file_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _logsMeta = const VerificationMeta('logs');
  @override
  late final GeneratedColumn<String> logs = GeneratedColumn<String>(
      'logs', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _maxBaseCreditsMeta =
      const VerificationMeta('maxBaseCredits');
  @override
  late final GeneratedColumn<double> maxBaseCredits = GeneratedColumn<double>(
      'max_base_credits', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _baseCreditsMeta =
      const VerificationMeta('baseCredits');
  @override
  late final GeneratedColumn<double> baseCredits = GeneratedColumn<double>(
      'base_credits', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _creditsMeta =
      const VerificationMeta('credits');
  @override
  late final GeneratedColumn<double> credits = GeneratedColumn<double>(
      'credits', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _verifiedAtMeta =
      const VerificationMeta('verifiedAt');
  @override
  late final GeneratedColumn<String> verifiedAt = GeneratedColumn<String>(
      'verified_at', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _reportMeta = const VerificationMeta('report');
  @override
  late final GeneratedColumn<String> report = GeneratedColumn<String>(
      'report', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
      'created_at', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _lastUpdatedAtMeta =
      const VerificationMeta('lastUpdatedAt');
  @override
  late final GeneratedColumn<String> lastUpdatedAt = GeneratedColumn<String>(
      'last_updated_at', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        localId,
        boxId,
        microtaskId,
        taskId,
        workerId,
        deadline,
        status,
        completedAt,
        output,
        outputFileId,
        logs,
        maxBaseCredits,
        baseCredits,
        credits,
        verifiedAt,
        report,
        createdAt,
        lastUpdatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'micro_task_assignment_records';
  @override
  VerificationContext validateIntegrity(
      Insertable<MicroTaskAssignmentRecord> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('local_id')) {
      context.handle(_localIdMeta,
          localId.isAcceptableOrUnknown(data['local_id']!, _localIdMeta));
    }
    if (data.containsKey('box_id')) {
      context.handle(
          _boxIdMeta, boxId.isAcceptableOrUnknown(data['box_id']!, _boxIdMeta));
    }
    if (data.containsKey('microtask_id')) {
      context.handle(
          _microtaskIdMeta,
          microtaskId.isAcceptableOrUnknown(
              data['microtask_id']!, _microtaskIdMeta));
    }
    if (data.containsKey('task_id')) {
      context.handle(_taskIdMeta,
          taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta));
    }
    if (data.containsKey('worker_id')) {
      context.handle(_workerIdMeta,
          workerId.isAcceptableOrUnknown(data['worker_id']!, _workerIdMeta));
    }
    if (data.containsKey('deadline')) {
      context.handle(_deadlineMeta,
          deadline.isAcceptableOrUnknown(data['deadline']!, _deadlineMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('completed_at')) {
      context.handle(
          _completedAtMeta,
          completedAt.isAcceptableOrUnknown(
              data['completed_at']!, _completedAtMeta));
    }
    if (data.containsKey('output')) {
      context.handle(_outputMeta,
          output.isAcceptableOrUnknown(data['output']!, _outputMeta));
    }
    if (data.containsKey('output_file_id')) {
      context.handle(
          _outputFileIdMeta,
          outputFileId.isAcceptableOrUnknown(
              data['output_file_id']!, _outputFileIdMeta));
    }
    if (data.containsKey('logs')) {
      context.handle(
          _logsMeta, logs.isAcceptableOrUnknown(data['logs']!, _logsMeta));
    }
    if (data.containsKey('max_base_credits')) {
      context.handle(
          _maxBaseCreditsMeta,
          maxBaseCredits.isAcceptableOrUnknown(
              data['max_base_credits']!, _maxBaseCreditsMeta));
    }
    if (data.containsKey('base_credits')) {
      context.handle(
          _baseCreditsMeta,
          baseCredits.isAcceptableOrUnknown(
              data['base_credits']!, _baseCreditsMeta));
    }
    if (data.containsKey('credits')) {
      context.handle(_creditsMeta,
          credits.isAcceptableOrUnknown(data['credits']!, _creditsMeta));
    }
    if (data.containsKey('verified_at')) {
      context.handle(
          _verifiedAtMeta,
          verifiedAt.isAcceptableOrUnknown(
              data['verified_at']!, _verifiedAtMeta));
    }
    if (data.containsKey('report')) {
      context.handle(_reportMeta,
          report.isAcceptableOrUnknown(data['report']!, _reportMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('last_updated_at')) {
      context.handle(
          _lastUpdatedAtMeta,
          lastUpdatedAt.isAcceptableOrUnknown(
              data['last_updated_at']!, _lastUpdatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MicroTaskAssignmentRecord map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MicroTaskAssignmentRecord(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      localId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}local_id']),
      boxId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}box_id']),
      microtaskId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}microtask_id']),
      taskId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}task_id']),
      workerId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}worker_id']),
      deadline: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}deadline']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status']),
      completedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}completed_at']),
      output: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}output']),
      outputFileId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}output_file_id']),
      logs: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}logs']),
      maxBaseCredits: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}max_base_credits']),
      baseCredits: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}base_credits']),
      credits: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}credits']),
      verifiedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}verified_at']),
      report: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}report']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_at']),
      lastUpdatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}last_updated_at']),
    );
  }

  @override
  $MicroTaskAssignmentRecordsTable createAlias(String alias) {
    return $MicroTaskAssignmentRecordsTable(attachedDatabase, alias);
  }
}

class MicroTaskAssignmentRecord extends DataClass
    implements Insertable<MicroTaskAssignmentRecord> {
  final String id;
  final String? localId;
  final String? boxId;
  final String? microtaskId;
  final String? taskId;
  final String? workerId;
  final String? deadline;
  final String? status;
  final String? completedAt;
  final String? output;
  final String? outputFileId;
  final String? logs;
  final double? maxBaseCredits;
  final double? baseCredits;
  final double? credits;
  final String? verifiedAt;
  final String? report;
  final String? createdAt;
  final String? lastUpdatedAt;
  const MicroTaskAssignmentRecord(
      {required this.id,
      this.localId,
      this.boxId,
      this.microtaskId,
      this.taskId,
      this.workerId,
      this.deadline,
      this.status,
      this.completedAt,
      this.output,
      this.outputFileId,
      this.logs,
      this.maxBaseCredits,
      this.baseCredits,
      this.credits,
      this.verifiedAt,
      this.report,
      this.createdAt,
      this.lastUpdatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || localId != null) {
      map['local_id'] = Variable<String>(localId);
    }
    if (!nullToAbsent || boxId != null) {
      map['box_id'] = Variable<String>(boxId);
    }
    if (!nullToAbsent || microtaskId != null) {
      map['microtask_id'] = Variable<String>(microtaskId);
    }
    if (!nullToAbsent || taskId != null) {
      map['task_id'] = Variable<String>(taskId);
    }
    if (!nullToAbsent || workerId != null) {
      map['worker_id'] = Variable<String>(workerId);
    }
    if (!nullToAbsent || deadline != null) {
      map['deadline'] = Variable<String>(deadline);
    }
    if (!nullToAbsent || status != null) {
      map['status'] = Variable<String>(status);
    }
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<String>(completedAt);
    }
    if (!nullToAbsent || output != null) {
      map['output'] = Variable<String>(output);
    }
    if (!nullToAbsent || outputFileId != null) {
      map['output_file_id'] = Variable<String>(outputFileId);
    }
    if (!nullToAbsent || logs != null) {
      map['logs'] = Variable<String>(logs);
    }
    if (!nullToAbsent || maxBaseCredits != null) {
      map['max_base_credits'] = Variable<double>(maxBaseCredits);
    }
    if (!nullToAbsent || baseCredits != null) {
      map['base_credits'] = Variable<double>(baseCredits);
    }
    if (!nullToAbsent || credits != null) {
      map['credits'] = Variable<double>(credits);
    }
    if (!nullToAbsent || verifiedAt != null) {
      map['verified_at'] = Variable<String>(verifiedAt);
    }
    if (!nullToAbsent || report != null) {
      map['report'] = Variable<String>(report);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<String>(createdAt);
    }
    if (!nullToAbsent || lastUpdatedAt != null) {
      map['last_updated_at'] = Variable<String>(lastUpdatedAt);
    }
    return map;
  }

  MicroTaskAssignmentRecordsCompanion toCompanion(bool nullToAbsent) {
    return MicroTaskAssignmentRecordsCompanion(
      id: Value(id),
      localId: localId == null && nullToAbsent
          ? const Value.absent()
          : Value(localId),
      boxId:
          boxId == null && nullToAbsent ? const Value.absent() : Value(boxId),
      microtaskId: microtaskId == null && nullToAbsent
          ? const Value.absent()
          : Value(microtaskId),
      taskId:
          taskId == null && nullToAbsent ? const Value.absent() : Value(taskId),
      workerId: workerId == null && nullToAbsent
          ? const Value.absent()
          : Value(workerId),
      deadline: deadline == null && nullToAbsent
          ? const Value.absent()
          : Value(deadline),
      status:
          status == null && nullToAbsent ? const Value.absent() : Value(status),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      output:
          output == null && nullToAbsent ? const Value.absent() : Value(output),
      outputFileId: outputFileId == null && nullToAbsent
          ? const Value.absent()
          : Value(outputFileId),
      logs: logs == null && nullToAbsent ? const Value.absent() : Value(logs),
      maxBaseCredits: maxBaseCredits == null && nullToAbsent
          ? const Value.absent()
          : Value(maxBaseCredits),
      baseCredits: baseCredits == null && nullToAbsent
          ? const Value.absent()
          : Value(baseCredits),
      credits: credits == null && nullToAbsent
          ? const Value.absent()
          : Value(credits),
      verifiedAt: verifiedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(verifiedAt),
      report:
          report == null && nullToAbsent ? const Value.absent() : Value(report),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      lastUpdatedAt: lastUpdatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastUpdatedAt),
    );
  }

  factory MicroTaskAssignmentRecord.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MicroTaskAssignmentRecord(
      id: serializer.fromJson<String>(json['id']),
      localId: serializer.fromJson<String?>(json['localId']),
      boxId: serializer.fromJson<String?>(json['boxId']),
      microtaskId: serializer.fromJson<String?>(json['microtaskId']),
      taskId: serializer.fromJson<String?>(json['taskId']),
      workerId: serializer.fromJson<String?>(json['workerId']),
      deadline: serializer.fromJson<String?>(json['deadline']),
      status: serializer.fromJson<String?>(json['status']),
      completedAt: serializer.fromJson<String?>(json['completedAt']),
      output: serializer.fromJson<String?>(json['output']),
      outputFileId: serializer.fromJson<String?>(json['outputFileId']),
      logs: serializer.fromJson<String?>(json['logs']),
      maxBaseCredits: serializer.fromJson<double?>(json['maxBaseCredits']),
      baseCredits: serializer.fromJson<double?>(json['baseCredits']),
      credits: serializer.fromJson<double?>(json['credits']),
      verifiedAt: serializer.fromJson<String?>(json['verifiedAt']),
      report: serializer.fromJson<String?>(json['report']),
      createdAt: serializer.fromJson<String?>(json['createdAt']),
      lastUpdatedAt: serializer.fromJson<String?>(json['lastUpdatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'localId': serializer.toJson<String?>(localId),
      'boxId': serializer.toJson<String?>(boxId),
      'microtaskId': serializer.toJson<String?>(microtaskId),
      'taskId': serializer.toJson<String?>(taskId),
      'workerId': serializer.toJson<String?>(workerId),
      'deadline': serializer.toJson<String?>(deadline),
      'status': serializer.toJson<String?>(status),
      'completedAt': serializer.toJson<String?>(completedAt),
      'output': serializer.toJson<String?>(output),
      'outputFileId': serializer.toJson<String?>(outputFileId),
      'logs': serializer.toJson<String?>(logs),
      'maxBaseCredits': serializer.toJson<double?>(maxBaseCredits),
      'baseCredits': serializer.toJson<double?>(baseCredits),
      'credits': serializer.toJson<double?>(credits),
      'verifiedAt': serializer.toJson<String?>(verifiedAt),
      'report': serializer.toJson<String?>(report),
      'createdAt': serializer.toJson<String?>(createdAt),
      'lastUpdatedAt': serializer.toJson<String?>(lastUpdatedAt),
    };
  }

  MicroTaskAssignmentRecord copyWith(
          {String? id,
          Value<String?> localId = const Value.absent(),
          Value<String?> boxId = const Value.absent(),
          Value<String?> microtaskId = const Value.absent(),
          Value<String?> taskId = const Value.absent(),
          Value<String?> workerId = const Value.absent(),
          Value<String?> deadline = const Value.absent(),
          Value<String?> status = const Value.absent(),
          Value<String?> completedAt = const Value.absent(),
          Value<String?> output = const Value.absent(),
          Value<String?> outputFileId = const Value.absent(),
          Value<String?> logs = const Value.absent(),
          Value<double?> maxBaseCredits = const Value.absent(),
          Value<double?> baseCredits = const Value.absent(),
          Value<double?> credits = const Value.absent(),
          Value<String?> verifiedAt = const Value.absent(),
          Value<String?> report = const Value.absent(),
          Value<String?> createdAt = const Value.absent(),
          Value<String?> lastUpdatedAt = const Value.absent()}) =>
      MicroTaskAssignmentRecord(
        id: id ?? this.id,
        localId: localId.present ? localId.value : this.localId,
        boxId: boxId.present ? boxId.value : this.boxId,
        microtaskId: microtaskId.present ? microtaskId.value : this.microtaskId,
        taskId: taskId.present ? taskId.value : this.taskId,
        workerId: workerId.present ? workerId.value : this.workerId,
        deadline: deadline.present ? deadline.value : this.deadline,
        status: status.present ? status.value : this.status,
        completedAt: completedAt.present ? completedAt.value : this.completedAt,
        output: output.present ? output.value : this.output,
        outputFileId:
            outputFileId.present ? outputFileId.value : this.outputFileId,
        logs: logs.present ? logs.value : this.logs,
        maxBaseCredits:
            maxBaseCredits.present ? maxBaseCredits.value : this.maxBaseCredits,
        baseCredits: baseCredits.present ? baseCredits.value : this.baseCredits,
        credits: credits.present ? credits.value : this.credits,
        verifiedAt: verifiedAt.present ? verifiedAt.value : this.verifiedAt,
        report: report.present ? report.value : this.report,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
        lastUpdatedAt:
            lastUpdatedAt.present ? lastUpdatedAt.value : this.lastUpdatedAt,
      );
  MicroTaskAssignmentRecord copyWithCompanion(
      MicroTaskAssignmentRecordsCompanion data) {
    return MicroTaskAssignmentRecord(
      id: data.id.present ? data.id.value : this.id,
      localId: data.localId.present ? data.localId.value : this.localId,
      boxId: data.boxId.present ? data.boxId.value : this.boxId,
      microtaskId:
          data.microtaskId.present ? data.microtaskId.value : this.microtaskId,
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
      workerId: data.workerId.present ? data.workerId.value : this.workerId,
      deadline: data.deadline.present ? data.deadline.value : this.deadline,
      status: data.status.present ? data.status.value : this.status,
      completedAt:
          data.completedAt.present ? data.completedAt.value : this.completedAt,
      output: data.output.present ? data.output.value : this.output,
      outputFileId: data.outputFileId.present
          ? data.outputFileId.value
          : this.outputFileId,
      logs: data.logs.present ? data.logs.value : this.logs,
      maxBaseCredits: data.maxBaseCredits.present
          ? data.maxBaseCredits.value
          : this.maxBaseCredits,
      baseCredits:
          data.baseCredits.present ? data.baseCredits.value : this.baseCredits,
      credits: data.credits.present ? data.credits.value : this.credits,
      verifiedAt:
          data.verifiedAt.present ? data.verifiedAt.value : this.verifiedAt,
      report: data.report.present ? data.report.value : this.report,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      lastUpdatedAt: data.lastUpdatedAt.present
          ? data.lastUpdatedAt.value
          : this.lastUpdatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MicroTaskAssignmentRecord(')
          ..write('id: $id, ')
          ..write('localId: $localId, ')
          ..write('boxId: $boxId, ')
          ..write('microtaskId: $microtaskId, ')
          ..write('taskId: $taskId, ')
          ..write('workerId: $workerId, ')
          ..write('deadline: $deadline, ')
          ..write('status: $status, ')
          ..write('completedAt: $completedAt, ')
          ..write('output: $output, ')
          ..write('outputFileId: $outputFileId, ')
          ..write('logs: $logs, ')
          ..write('maxBaseCredits: $maxBaseCredits, ')
          ..write('baseCredits: $baseCredits, ')
          ..write('credits: $credits, ')
          ..write('verifiedAt: $verifiedAt, ')
          ..write('report: $report, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastUpdatedAt: $lastUpdatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      localId,
      boxId,
      microtaskId,
      taskId,
      workerId,
      deadline,
      status,
      completedAt,
      output,
      outputFileId,
      logs,
      maxBaseCredits,
      baseCredits,
      credits,
      verifiedAt,
      report,
      createdAt,
      lastUpdatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MicroTaskAssignmentRecord &&
          other.id == this.id &&
          other.localId == this.localId &&
          other.boxId == this.boxId &&
          other.microtaskId == this.microtaskId &&
          other.taskId == this.taskId &&
          other.workerId == this.workerId &&
          other.deadline == this.deadline &&
          other.status == this.status &&
          other.completedAt == this.completedAt &&
          other.output == this.output &&
          other.outputFileId == this.outputFileId &&
          other.logs == this.logs &&
          other.maxBaseCredits == this.maxBaseCredits &&
          other.baseCredits == this.baseCredits &&
          other.credits == this.credits &&
          other.verifiedAt == this.verifiedAt &&
          other.report == this.report &&
          other.createdAt == this.createdAt &&
          other.lastUpdatedAt == this.lastUpdatedAt);
}

class MicroTaskAssignmentRecordsCompanion
    extends UpdateCompanion<MicroTaskAssignmentRecord> {
  final Value<String> id;
  final Value<String?> localId;
  final Value<String?> boxId;
  final Value<String?> microtaskId;
  final Value<String?> taskId;
  final Value<String?> workerId;
  final Value<String?> deadline;
  final Value<String?> status;
  final Value<String?> completedAt;
  final Value<String?> output;
  final Value<String?> outputFileId;
  final Value<String?> logs;
  final Value<double?> maxBaseCredits;
  final Value<double?> baseCredits;
  final Value<double?> credits;
  final Value<String?> verifiedAt;
  final Value<String?> report;
  final Value<String?> createdAt;
  final Value<String?> lastUpdatedAt;
  final Value<int> rowid;
  const MicroTaskAssignmentRecordsCompanion({
    this.id = const Value.absent(),
    this.localId = const Value.absent(),
    this.boxId = const Value.absent(),
    this.microtaskId = const Value.absent(),
    this.taskId = const Value.absent(),
    this.workerId = const Value.absent(),
    this.deadline = const Value.absent(),
    this.status = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.output = const Value.absent(),
    this.outputFileId = const Value.absent(),
    this.logs = const Value.absent(),
    this.maxBaseCredits = const Value.absent(),
    this.baseCredits = const Value.absent(),
    this.credits = const Value.absent(),
    this.verifiedAt = const Value.absent(),
    this.report = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.lastUpdatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MicroTaskAssignmentRecordsCompanion.insert({
    required String id,
    this.localId = const Value.absent(),
    this.boxId = const Value.absent(),
    this.microtaskId = const Value.absent(),
    this.taskId = const Value.absent(),
    this.workerId = const Value.absent(),
    this.deadline = const Value.absent(),
    this.status = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.output = const Value.absent(),
    this.outputFileId = const Value.absent(),
    this.logs = const Value.absent(),
    this.maxBaseCredits = const Value.absent(),
    this.baseCredits = const Value.absent(),
    this.credits = const Value.absent(),
    this.verifiedAt = const Value.absent(),
    this.report = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.lastUpdatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id);
  static Insertable<MicroTaskAssignmentRecord> custom({
    Expression<String>? id,
    Expression<String>? localId,
    Expression<String>? boxId,
    Expression<String>? microtaskId,
    Expression<String>? taskId,
    Expression<String>? workerId,
    Expression<String>? deadline,
    Expression<String>? status,
    Expression<String>? completedAt,
    Expression<String>? output,
    Expression<String>? outputFileId,
    Expression<String>? logs,
    Expression<double>? maxBaseCredits,
    Expression<double>? baseCredits,
    Expression<double>? credits,
    Expression<String>? verifiedAt,
    Expression<String>? report,
    Expression<String>? createdAt,
    Expression<String>? lastUpdatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (localId != null) 'local_id': localId,
      if (boxId != null) 'box_id': boxId,
      if (microtaskId != null) 'microtask_id': microtaskId,
      if (taskId != null) 'task_id': taskId,
      if (workerId != null) 'worker_id': workerId,
      if (deadline != null) 'deadline': deadline,
      if (status != null) 'status': status,
      if (completedAt != null) 'completed_at': completedAt,
      if (output != null) 'output': output,
      if (outputFileId != null) 'output_file_id': outputFileId,
      if (logs != null) 'logs': logs,
      if (maxBaseCredits != null) 'max_base_credits': maxBaseCredits,
      if (baseCredits != null) 'base_credits': baseCredits,
      if (credits != null) 'credits': credits,
      if (verifiedAt != null) 'verified_at': verifiedAt,
      if (report != null) 'report': report,
      if (createdAt != null) 'created_at': createdAt,
      if (lastUpdatedAt != null) 'last_updated_at': lastUpdatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MicroTaskAssignmentRecordsCompanion copyWith(
      {Value<String>? id,
      Value<String?>? localId,
      Value<String?>? boxId,
      Value<String?>? microtaskId,
      Value<String?>? taskId,
      Value<String?>? workerId,
      Value<String?>? deadline,
      Value<String?>? status,
      Value<String?>? completedAt,
      Value<String?>? output,
      Value<String?>? outputFileId,
      Value<String?>? logs,
      Value<double?>? maxBaseCredits,
      Value<double?>? baseCredits,
      Value<double?>? credits,
      Value<String?>? verifiedAt,
      Value<String?>? report,
      Value<String?>? createdAt,
      Value<String?>? lastUpdatedAt,
      Value<int>? rowid}) {
    return MicroTaskAssignmentRecordsCompanion(
      id: id ?? this.id,
      localId: localId ?? this.localId,
      boxId: boxId ?? this.boxId,
      microtaskId: microtaskId ?? this.microtaskId,
      taskId: taskId ?? this.taskId,
      workerId: workerId ?? this.workerId,
      deadline: deadline ?? this.deadline,
      status: status ?? this.status,
      completedAt: completedAt ?? this.completedAt,
      output: output ?? this.output,
      outputFileId: outputFileId ?? this.outputFileId,
      logs: logs ?? this.logs,
      maxBaseCredits: maxBaseCredits ?? this.maxBaseCredits,
      baseCredits: baseCredits ?? this.baseCredits,
      credits: credits ?? this.credits,
      verifiedAt: verifiedAt ?? this.verifiedAt,
      report: report ?? this.report,
      createdAt: createdAt ?? this.createdAt,
      lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (localId.present) {
      map['local_id'] = Variable<String>(localId.value);
    }
    if (boxId.present) {
      map['box_id'] = Variable<String>(boxId.value);
    }
    if (microtaskId.present) {
      map['microtask_id'] = Variable<String>(microtaskId.value);
    }
    if (taskId.present) {
      map['task_id'] = Variable<String>(taskId.value);
    }
    if (workerId.present) {
      map['worker_id'] = Variable<String>(workerId.value);
    }
    if (deadline.present) {
      map['deadline'] = Variable<String>(deadline.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<String>(completedAt.value);
    }
    if (output.present) {
      map['output'] = Variable<String>(output.value);
    }
    if (outputFileId.present) {
      map['output_file_id'] = Variable<String>(outputFileId.value);
    }
    if (logs.present) {
      map['logs'] = Variable<String>(logs.value);
    }
    if (maxBaseCredits.present) {
      map['max_base_credits'] = Variable<double>(maxBaseCredits.value);
    }
    if (baseCredits.present) {
      map['base_credits'] = Variable<double>(baseCredits.value);
    }
    if (credits.present) {
      map['credits'] = Variable<double>(credits.value);
    }
    if (verifiedAt.present) {
      map['verified_at'] = Variable<String>(verifiedAt.value);
    }
    if (report.present) {
      map['report'] = Variable<String>(report.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (lastUpdatedAt.present) {
      map['last_updated_at'] = Variable<String>(lastUpdatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MicroTaskAssignmentRecordsCompanion(')
          ..write('id: $id, ')
          ..write('localId: $localId, ')
          ..write('boxId: $boxId, ')
          ..write('microtaskId: $microtaskId, ')
          ..write('taskId: $taskId, ')
          ..write('workerId: $workerId, ')
          ..write('deadline: $deadline, ')
          ..write('status: $status, ')
          ..write('completedAt: $completedAt, ')
          ..write('output: $output, ')
          ..write('outputFileId: $outputFileId, ')
          ..write('logs: $logs, ')
          ..write('maxBaseCredits: $maxBaseCredits, ')
          ..write('baseCredits: $baseCredits, ')
          ..write('credits: $credits, ')
          ..write('verifiedAt: $verifiedAt, ')
          ..write('report: $report, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastUpdatedAt: $lastUpdatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$KaryaDatabase extends GeneratedDatabase {
  _$KaryaDatabase(QueryExecutor e) : super(e);
  $KaryaDatabaseManager get managers => $KaryaDatabaseManager(this);
  late final $TaskRecordsTable taskRecords = $TaskRecordsTable(this);
  late final $MicroTaskRecordsTable microTaskRecords =
      $MicroTaskRecordsTable(this);
  late final $MicroTaskAssignmentRecordsTable microTaskAssignmentRecords =
      $MicroTaskAssignmentRecordsTable(this);
  late final TaskDao taskDao = TaskDao(this as KaryaDatabase);
  late final MicroTaskDao microTaskDao = MicroTaskDao(this as KaryaDatabase);
  late final MicroTaskAssignmentDao microTaskAssignmentDao =
      MicroTaskAssignmentDao(this as KaryaDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [taskRecords, microTaskRecords, microTaskAssignmentRecords];
}

typedef $$TaskRecordsTableCreateCompanionBuilder = TaskRecordsCompanion
    Function({
  required String id,
  Value<String?> scenarioName,
  Value<String?> name,
  Value<String?> description,
  Value<String?> displayName,
  Value<String?> params,
  Value<String?> deadline,
  Value<String?> assignmentGranularity,
  Value<String?> groupAssignmentOrder,
  Value<String?> microtaskAssignmentOrder,
  Value<String?> status,
  Value<String?> createdAt,
  Value<String?> lastUpdatedAt,
  Value<int> rowid,
});
typedef $$TaskRecordsTableUpdateCompanionBuilder = TaskRecordsCompanion
    Function({
  Value<String> id,
  Value<String?> scenarioName,
  Value<String?> name,
  Value<String?> description,
  Value<String?> displayName,
  Value<String?> params,
  Value<String?> deadline,
  Value<String?> assignmentGranularity,
  Value<String?> groupAssignmentOrder,
  Value<String?> microtaskAssignmentOrder,
  Value<String?> status,
  Value<String?> createdAt,
  Value<String?> lastUpdatedAt,
  Value<int> rowid,
});

class $$TaskRecordsTableFilterComposer
    extends Composer<_$KaryaDatabase, $TaskRecordsTable> {
  $$TaskRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get scenarioName => $composableBuilder(
      column: $table.scenarioName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get displayName => $composableBuilder(
      column: $table.displayName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get params => $composableBuilder(
      column: $table.params, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get deadline => $composableBuilder(
      column: $table.deadline, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get assignmentGranularity => $composableBuilder(
      column: $table.assignmentGranularity,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get groupAssignmentOrder => $composableBuilder(
      column: $table.groupAssignmentOrder,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get microtaskAssignmentOrder => $composableBuilder(
      column: $table.microtaskAssignmentOrder,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lastUpdatedAt => $composableBuilder(
      column: $table.lastUpdatedAt, builder: (column) => ColumnFilters(column));
}

class $$TaskRecordsTableOrderingComposer
    extends Composer<_$KaryaDatabase, $TaskRecordsTable> {
  $$TaskRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get scenarioName => $composableBuilder(
      column: $table.scenarioName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get displayName => $composableBuilder(
      column: $table.displayName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get params => $composableBuilder(
      column: $table.params, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get deadline => $composableBuilder(
      column: $table.deadline, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get assignmentGranularity => $composableBuilder(
      column: $table.assignmentGranularity,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get groupAssignmentOrder => $composableBuilder(
      column: $table.groupAssignmentOrder,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get microtaskAssignmentOrder => $composableBuilder(
      column: $table.microtaskAssignmentOrder,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lastUpdatedAt => $composableBuilder(
      column: $table.lastUpdatedAt,
      builder: (column) => ColumnOrderings(column));
}

class $$TaskRecordsTableAnnotationComposer
    extends Composer<_$KaryaDatabase, $TaskRecordsTable> {
  $$TaskRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get scenarioName => $composableBuilder(
      column: $table.scenarioName, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
      column: $table.displayName, builder: (column) => column);

  GeneratedColumn<String> get params =>
      $composableBuilder(column: $table.params, builder: (column) => column);

  GeneratedColumn<String> get deadline =>
      $composableBuilder(column: $table.deadline, builder: (column) => column);

  GeneratedColumn<String> get assignmentGranularity => $composableBuilder(
      column: $table.assignmentGranularity, builder: (column) => column);

  GeneratedColumn<String> get groupAssignmentOrder => $composableBuilder(
      column: $table.groupAssignmentOrder, builder: (column) => column);

  GeneratedColumn<String> get microtaskAssignmentOrder => $composableBuilder(
      column: $table.microtaskAssignmentOrder, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get lastUpdatedAt => $composableBuilder(
      column: $table.lastUpdatedAt, builder: (column) => column);
}

class $$TaskRecordsTableTableManager extends RootTableManager<
    _$KaryaDatabase,
    $TaskRecordsTable,
    TaskRecord,
    $$TaskRecordsTableFilterComposer,
    $$TaskRecordsTableOrderingComposer,
    $$TaskRecordsTableAnnotationComposer,
    $$TaskRecordsTableCreateCompanionBuilder,
    $$TaskRecordsTableUpdateCompanionBuilder,
    (
      TaskRecord,
      BaseReferences<_$KaryaDatabase, $TaskRecordsTable, TaskRecord>
    ),
    TaskRecord,
    PrefetchHooks Function()> {
  $$TaskRecordsTableTableManager(_$KaryaDatabase db, $TaskRecordsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TaskRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TaskRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TaskRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String?> scenarioName = const Value.absent(),
            Value<String?> name = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<String?> displayName = const Value.absent(),
            Value<String?> params = const Value.absent(),
            Value<String?> deadline = const Value.absent(),
            Value<String?> assignmentGranularity = const Value.absent(),
            Value<String?> groupAssignmentOrder = const Value.absent(),
            Value<String?> microtaskAssignmentOrder = const Value.absent(),
            Value<String?> status = const Value.absent(),
            Value<String?> createdAt = const Value.absent(),
            Value<String?> lastUpdatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TaskRecordsCompanion(
            id: id,
            scenarioName: scenarioName,
            name: name,
            description: description,
            displayName: displayName,
            params: params,
            deadline: deadline,
            assignmentGranularity: assignmentGranularity,
            groupAssignmentOrder: groupAssignmentOrder,
            microtaskAssignmentOrder: microtaskAssignmentOrder,
            status: status,
            createdAt: createdAt,
            lastUpdatedAt: lastUpdatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<String?> scenarioName = const Value.absent(),
            Value<String?> name = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<String?> displayName = const Value.absent(),
            Value<String?> params = const Value.absent(),
            Value<String?> deadline = const Value.absent(),
            Value<String?> assignmentGranularity = const Value.absent(),
            Value<String?> groupAssignmentOrder = const Value.absent(),
            Value<String?> microtaskAssignmentOrder = const Value.absent(),
            Value<String?> status = const Value.absent(),
            Value<String?> createdAt = const Value.absent(),
            Value<String?> lastUpdatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TaskRecordsCompanion.insert(
            id: id,
            scenarioName: scenarioName,
            name: name,
            description: description,
            displayName: displayName,
            params: params,
            deadline: deadline,
            assignmentGranularity: assignmentGranularity,
            groupAssignmentOrder: groupAssignmentOrder,
            microtaskAssignmentOrder: microtaskAssignmentOrder,
            status: status,
            createdAt: createdAt,
            lastUpdatedAt: lastUpdatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TaskRecordsTableProcessedTableManager = ProcessedTableManager<
    _$KaryaDatabase,
    $TaskRecordsTable,
    TaskRecord,
    $$TaskRecordsTableFilterComposer,
    $$TaskRecordsTableOrderingComposer,
    $$TaskRecordsTableAnnotationComposer,
    $$TaskRecordsTableCreateCompanionBuilder,
    $$TaskRecordsTableUpdateCompanionBuilder,
    (
      TaskRecord,
      BaseReferences<_$KaryaDatabase, $TaskRecordsTable, TaskRecord>
    ),
    TaskRecord,
    PrefetchHooks Function()>;
typedef $$MicroTaskRecordsTableCreateCompanionBuilder
    = MicroTaskRecordsCompanion Function({
  required String id,
  Value<String?> taskId,
  Value<String?> groupId,
  Value<String?> input,
  Value<String?> inputFileId,
  Value<String?> deadline,
  Value<double?> credits,
  Value<String?> output,
  Value<String?> createdAt,
  Value<String?> lastUpdatedAt,
  Value<int> rowid,
});
typedef $$MicroTaskRecordsTableUpdateCompanionBuilder
    = MicroTaskRecordsCompanion Function({
  Value<String> id,
  Value<String?> taskId,
  Value<String?> groupId,
  Value<String?> input,
  Value<String?> inputFileId,
  Value<String?> deadline,
  Value<double?> credits,
  Value<String?> output,
  Value<String?> createdAt,
  Value<String?> lastUpdatedAt,
  Value<int> rowid,
});

class $$MicroTaskRecordsTableFilterComposer
    extends Composer<_$KaryaDatabase, $MicroTaskRecordsTable> {
  $$MicroTaskRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get taskId => $composableBuilder(
      column: $table.taskId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get groupId => $composableBuilder(
      column: $table.groupId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get input => $composableBuilder(
      column: $table.input, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get inputFileId => $composableBuilder(
      column: $table.inputFileId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get deadline => $composableBuilder(
      column: $table.deadline, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get credits => $composableBuilder(
      column: $table.credits, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get output => $composableBuilder(
      column: $table.output, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lastUpdatedAt => $composableBuilder(
      column: $table.lastUpdatedAt, builder: (column) => ColumnFilters(column));
}

class $$MicroTaskRecordsTableOrderingComposer
    extends Composer<_$KaryaDatabase, $MicroTaskRecordsTable> {
  $$MicroTaskRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get taskId => $composableBuilder(
      column: $table.taskId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get groupId => $composableBuilder(
      column: $table.groupId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get input => $composableBuilder(
      column: $table.input, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get inputFileId => $composableBuilder(
      column: $table.inputFileId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get deadline => $composableBuilder(
      column: $table.deadline, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get credits => $composableBuilder(
      column: $table.credits, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get output => $composableBuilder(
      column: $table.output, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lastUpdatedAt => $composableBuilder(
      column: $table.lastUpdatedAt,
      builder: (column) => ColumnOrderings(column));
}

class $$MicroTaskRecordsTableAnnotationComposer
    extends Composer<_$KaryaDatabase, $MicroTaskRecordsTable> {
  $$MicroTaskRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get taskId =>
      $composableBuilder(column: $table.taskId, builder: (column) => column);

  GeneratedColumn<String> get groupId =>
      $composableBuilder(column: $table.groupId, builder: (column) => column);

  GeneratedColumn<String> get input =>
      $composableBuilder(column: $table.input, builder: (column) => column);

  GeneratedColumn<String> get inputFileId => $composableBuilder(
      column: $table.inputFileId, builder: (column) => column);

  GeneratedColumn<String> get deadline =>
      $composableBuilder(column: $table.deadline, builder: (column) => column);

  GeneratedColumn<double> get credits =>
      $composableBuilder(column: $table.credits, builder: (column) => column);

  GeneratedColumn<String> get output =>
      $composableBuilder(column: $table.output, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get lastUpdatedAt => $composableBuilder(
      column: $table.lastUpdatedAt, builder: (column) => column);
}

class $$MicroTaskRecordsTableTableManager extends RootTableManager<
    _$KaryaDatabase,
    $MicroTaskRecordsTable,
    MicroTaskRecord,
    $$MicroTaskRecordsTableFilterComposer,
    $$MicroTaskRecordsTableOrderingComposer,
    $$MicroTaskRecordsTableAnnotationComposer,
    $$MicroTaskRecordsTableCreateCompanionBuilder,
    $$MicroTaskRecordsTableUpdateCompanionBuilder,
    (
      MicroTaskRecord,
      BaseReferences<_$KaryaDatabase, $MicroTaskRecordsTable, MicroTaskRecord>
    ),
    MicroTaskRecord,
    PrefetchHooks Function()> {
  $$MicroTaskRecordsTableTableManager(
      _$KaryaDatabase db, $MicroTaskRecordsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MicroTaskRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MicroTaskRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MicroTaskRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String?> taskId = const Value.absent(),
            Value<String?> groupId = const Value.absent(),
            Value<String?> input = const Value.absent(),
            Value<String?> inputFileId = const Value.absent(),
            Value<String?> deadline = const Value.absent(),
            Value<double?> credits = const Value.absent(),
            Value<String?> output = const Value.absent(),
            Value<String?> createdAt = const Value.absent(),
            Value<String?> lastUpdatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MicroTaskRecordsCompanion(
            id: id,
            taskId: taskId,
            groupId: groupId,
            input: input,
            inputFileId: inputFileId,
            deadline: deadline,
            credits: credits,
            output: output,
            createdAt: createdAt,
            lastUpdatedAt: lastUpdatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<String?> taskId = const Value.absent(),
            Value<String?> groupId = const Value.absent(),
            Value<String?> input = const Value.absent(),
            Value<String?> inputFileId = const Value.absent(),
            Value<String?> deadline = const Value.absent(),
            Value<double?> credits = const Value.absent(),
            Value<String?> output = const Value.absent(),
            Value<String?> createdAt = const Value.absent(),
            Value<String?> lastUpdatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MicroTaskRecordsCompanion.insert(
            id: id,
            taskId: taskId,
            groupId: groupId,
            input: input,
            inputFileId: inputFileId,
            deadline: deadline,
            credits: credits,
            output: output,
            createdAt: createdAt,
            lastUpdatedAt: lastUpdatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$MicroTaskRecordsTableProcessedTableManager = ProcessedTableManager<
    _$KaryaDatabase,
    $MicroTaskRecordsTable,
    MicroTaskRecord,
    $$MicroTaskRecordsTableFilterComposer,
    $$MicroTaskRecordsTableOrderingComposer,
    $$MicroTaskRecordsTableAnnotationComposer,
    $$MicroTaskRecordsTableCreateCompanionBuilder,
    $$MicroTaskRecordsTableUpdateCompanionBuilder,
    (
      MicroTaskRecord,
      BaseReferences<_$KaryaDatabase, $MicroTaskRecordsTable, MicroTaskRecord>
    ),
    MicroTaskRecord,
    PrefetchHooks Function()>;
typedef $$MicroTaskAssignmentRecordsTableCreateCompanionBuilder
    = MicroTaskAssignmentRecordsCompanion Function({
  required String id,
  Value<String?> localId,
  Value<String?> boxId,
  Value<String?> microtaskId,
  Value<String?> taskId,
  Value<String?> workerId,
  Value<String?> deadline,
  Value<String?> status,
  Value<String?> completedAt,
  Value<String?> output,
  Value<String?> outputFileId,
  Value<String?> logs,
  Value<double?> maxBaseCredits,
  Value<double?> baseCredits,
  Value<double?> credits,
  Value<String?> verifiedAt,
  Value<String?> report,
  Value<String?> createdAt,
  Value<String?> lastUpdatedAt,
  Value<int> rowid,
});
typedef $$MicroTaskAssignmentRecordsTableUpdateCompanionBuilder
    = MicroTaskAssignmentRecordsCompanion Function({
  Value<String> id,
  Value<String?> localId,
  Value<String?> boxId,
  Value<String?> microtaskId,
  Value<String?> taskId,
  Value<String?> workerId,
  Value<String?> deadline,
  Value<String?> status,
  Value<String?> completedAt,
  Value<String?> output,
  Value<String?> outputFileId,
  Value<String?> logs,
  Value<double?> maxBaseCredits,
  Value<double?> baseCredits,
  Value<double?> credits,
  Value<String?> verifiedAt,
  Value<String?> report,
  Value<String?> createdAt,
  Value<String?> lastUpdatedAt,
  Value<int> rowid,
});

class $$MicroTaskAssignmentRecordsTableFilterComposer
    extends Composer<_$KaryaDatabase, $MicroTaskAssignmentRecordsTable> {
  $$MicroTaskAssignmentRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get localId => $composableBuilder(
      column: $table.localId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get boxId => $composableBuilder(
      column: $table.boxId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get microtaskId => $composableBuilder(
      column: $table.microtaskId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get taskId => $composableBuilder(
      column: $table.taskId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get workerId => $composableBuilder(
      column: $table.workerId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get deadline => $composableBuilder(
      column: $table.deadline, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get output => $composableBuilder(
      column: $table.output, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get outputFileId => $composableBuilder(
      column: $table.outputFileId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get logs => $composableBuilder(
      column: $table.logs, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get maxBaseCredits => $composableBuilder(
      column: $table.maxBaseCredits,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get baseCredits => $composableBuilder(
      column: $table.baseCredits, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get credits => $composableBuilder(
      column: $table.credits, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get verifiedAt => $composableBuilder(
      column: $table.verifiedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get report => $composableBuilder(
      column: $table.report, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lastUpdatedAt => $composableBuilder(
      column: $table.lastUpdatedAt, builder: (column) => ColumnFilters(column));
}

class $$MicroTaskAssignmentRecordsTableOrderingComposer
    extends Composer<_$KaryaDatabase, $MicroTaskAssignmentRecordsTable> {
  $$MicroTaskAssignmentRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get localId => $composableBuilder(
      column: $table.localId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get boxId => $composableBuilder(
      column: $table.boxId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get microtaskId => $composableBuilder(
      column: $table.microtaskId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get taskId => $composableBuilder(
      column: $table.taskId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get workerId => $composableBuilder(
      column: $table.workerId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get deadline => $composableBuilder(
      column: $table.deadline, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get output => $composableBuilder(
      column: $table.output, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get outputFileId => $composableBuilder(
      column: $table.outputFileId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get logs => $composableBuilder(
      column: $table.logs, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get maxBaseCredits => $composableBuilder(
      column: $table.maxBaseCredits,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get baseCredits => $composableBuilder(
      column: $table.baseCredits, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get credits => $composableBuilder(
      column: $table.credits, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get verifiedAt => $composableBuilder(
      column: $table.verifiedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get report => $composableBuilder(
      column: $table.report, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lastUpdatedAt => $composableBuilder(
      column: $table.lastUpdatedAt,
      builder: (column) => ColumnOrderings(column));
}

class $$MicroTaskAssignmentRecordsTableAnnotationComposer
    extends Composer<_$KaryaDatabase, $MicroTaskAssignmentRecordsTable> {
  $$MicroTaskAssignmentRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get localId =>
      $composableBuilder(column: $table.localId, builder: (column) => column);

  GeneratedColumn<String> get boxId =>
      $composableBuilder(column: $table.boxId, builder: (column) => column);

  GeneratedColumn<String> get microtaskId => $composableBuilder(
      column: $table.microtaskId, builder: (column) => column);

  GeneratedColumn<String> get taskId =>
      $composableBuilder(column: $table.taskId, builder: (column) => column);

  GeneratedColumn<String> get workerId =>
      $composableBuilder(column: $table.workerId, builder: (column) => column);

  GeneratedColumn<String> get deadline =>
      $composableBuilder(column: $table.deadline, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => column);

  GeneratedColumn<String> get output =>
      $composableBuilder(column: $table.output, builder: (column) => column);

  GeneratedColumn<String> get outputFileId => $composableBuilder(
      column: $table.outputFileId, builder: (column) => column);

  GeneratedColumn<String> get logs =>
      $composableBuilder(column: $table.logs, builder: (column) => column);

  GeneratedColumn<double> get maxBaseCredits => $composableBuilder(
      column: $table.maxBaseCredits, builder: (column) => column);

  GeneratedColumn<double> get baseCredits => $composableBuilder(
      column: $table.baseCredits, builder: (column) => column);

  GeneratedColumn<double> get credits =>
      $composableBuilder(column: $table.credits, builder: (column) => column);

  GeneratedColumn<String> get verifiedAt => $composableBuilder(
      column: $table.verifiedAt, builder: (column) => column);

  GeneratedColumn<String> get report =>
      $composableBuilder(column: $table.report, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get lastUpdatedAt => $composableBuilder(
      column: $table.lastUpdatedAt, builder: (column) => column);
}

class $$MicroTaskAssignmentRecordsTableTableManager extends RootTableManager<
    _$KaryaDatabase,
    $MicroTaskAssignmentRecordsTable,
    MicroTaskAssignmentRecord,
    $$MicroTaskAssignmentRecordsTableFilterComposer,
    $$MicroTaskAssignmentRecordsTableOrderingComposer,
    $$MicroTaskAssignmentRecordsTableAnnotationComposer,
    $$MicroTaskAssignmentRecordsTableCreateCompanionBuilder,
    $$MicroTaskAssignmentRecordsTableUpdateCompanionBuilder,
    (
      MicroTaskAssignmentRecord,
      BaseReferences<_$KaryaDatabase, $MicroTaskAssignmentRecordsTable,
          MicroTaskAssignmentRecord>
    ),
    MicroTaskAssignmentRecord,
    PrefetchHooks Function()> {
  $$MicroTaskAssignmentRecordsTableTableManager(
      _$KaryaDatabase db, $MicroTaskAssignmentRecordsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MicroTaskAssignmentRecordsTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$MicroTaskAssignmentRecordsTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MicroTaskAssignmentRecordsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String?> localId = const Value.absent(),
            Value<String?> boxId = const Value.absent(),
            Value<String?> microtaskId = const Value.absent(),
            Value<String?> taskId = const Value.absent(),
            Value<String?> workerId = const Value.absent(),
            Value<String?> deadline = const Value.absent(),
            Value<String?> status = const Value.absent(),
            Value<String?> completedAt = const Value.absent(),
            Value<String?> output = const Value.absent(),
            Value<String?> outputFileId = const Value.absent(),
            Value<String?> logs = const Value.absent(),
            Value<double?> maxBaseCredits = const Value.absent(),
            Value<double?> baseCredits = const Value.absent(),
            Value<double?> credits = const Value.absent(),
            Value<String?> verifiedAt = const Value.absent(),
            Value<String?> report = const Value.absent(),
            Value<String?> createdAt = const Value.absent(),
            Value<String?> lastUpdatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MicroTaskAssignmentRecordsCompanion(
            id: id,
            localId: localId,
            boxId: boxId,
            microtaskId: microtaskId,
            taskId: taskId,
            workerId: workerId,
            deadline: deadline,
            status: status,
            completedAt: completedAt,
            output: output,
            outputFileId: outputFileId,
            logs: logs,
            maxBaseCredits: maxBaseCredits,
            baseCredits: baseCredits,
            credits: credits,
            verifiedAt: verifiedAt,
            report: report,
            createdAt: createdAt,
            lastUpdatedAt: lastUpdatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<String?> localId = const Value.absent(),
            Value<String?> boxId = const Value.absent(),
            Value<String?> microtaskId = const Value.absent(),
            Value<String?> taskId = const Value.absent(),
            Value<String?> workerId = const Value.absent(),
            Value<String?> deadline = const Value.absent(),
            Value<String?> status = const Value.absent(),
            Value<String?> completedAt = const Value.absent(),
            Value<String?> output = const Value.absent(),
            Value<String?> outputFileId = const Value.absent(),
            Value<String?> logs = const Value.absent(),
            Value<double?> maxBaseCredits = const Value.absent(),
            Value<double?> baseCredits = const Value.absent(),
            Value<double?> credits = const Value.absent(),
            Value<String?> verifiedAt = const Value.absent(),
            Value<String?> report = const Value.absent(),
            Value<String?> createdAt = const Value.absent(),
            Value<String?> lastUpdatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MicroTaskAssignmentRecordsCompanion.insert(
            id: id,
            localId: localId,
            boxId: boxId,
            microtaskId: microtaskId,
            taskId: taskId,
            workerId: workerId,
            deadline: deadline,
            status: status,
            completedAt: completedAt,
            output: output,
            outputFileId: outputFileId,
            logs: logs,
            maxBaseCredits: maxBaseCredits,
            baseCredits: baseCredits,
            credits: credits,
            verifiedAt: verifiedAt,
            report: report,
            createdAt: createdAt,
            lastUpdatedAt: lastUpdatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$MicroTaskAssignmentRecordsTableProcessedTableManager
    = ProcessedTableManager<
        _$KaryaDatabase,
        $MicroTaskAssignmentRecordsTable,
        MicroTaskAssignmentRecord,
        $$MicroTaskAssignmentRecordsTableFilterComposer,
        $$MicroTaskAssignmentRecordsTableOrderingComposer,
        $$MicroTaskAssignmentRecordsTableAnnotationComposer,
        $$MicroTaskAssignmentRecordsTableCreateCompanionBuilder,
        $$MicroTaskAssignmentRecordsTableUpdateCompanionBuilder,
        (
          MicroTaskAssignmentRecord,
          BaseReferences<_$KaryaDatabase, $MicroTaskAssignmentRecordsTable,
              MicroTaskAssignmentRecord>
        ),
        MicroTaskAssignmentRecord,
        PrefetchHooks Function()>;

class $KaryaDatabaseManager {
  final _$KaryaDatabase _db;
  $KaryaDatabaseManager(this._db);
  $$TaskRecordsTableTableManager get taskRecords =>
      $$TaskRecordsTableTableManager(_db, _db.taskRecords);
  $$MicroTaskRecordsTableTableManager get microTaskRecords =>
      $$MicroTaskRecordsTableTableManager(_db, _db.microTaskRecords);
  $$MicroTaskAssignmentRecordsTableTableManager
      get microTaskAssignmentRecords =>
          $$MicroTaskAssignmentRecordsTableTableManager(
              _db, _db.microTaskAssignmentRecords);
}
