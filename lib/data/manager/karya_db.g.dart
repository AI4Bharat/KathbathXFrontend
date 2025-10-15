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
  late final GeneratedColumn<BigInt> id = GeneratedColumn<BigInt>(
      'id', aliasedName, false,
      type: DriftSqlType.bigInt, requiredDuringInsert: false);
  static const VerificationMeta _workProviderIdMeta =
      const VerificationMeta('workProviderId');
  @override
  late final GeneratedColumn<BigInt> workProviderId = GeneratedColumn<BigInt>(
      'work_provider_id', aliasedName, false,
      type: DriftSqlType.bigInt, requiredDuringInsert: true);
  static const VerificationMeta _scenarioNameMeta =
      const VerificationMeta('scenarioName');
  @override
  late final GeneratedColumn<String> scenarioName = GeneratedColumn<String>(
      'scenario_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _displayNameMeta =
      const VerificationMeta('displayName');
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
      'display_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _policyMeta = const VerificationMeta('policy');
  @override
  late final GeneratedColumn<String> policy = GeneratedColumn<String>(
      'policy', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _paramsMeta = const VerificationMeta('params');
  @override
  late final GeneratedColumn<String> params = GeneratedColumn<String>(
      'params', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _itagsMeta = const VerificationMeta('itags');
  @override
  late final GeneratedColumn<String> itags = GeneratedColumn<String>(
      'itags', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _otagsMeta = const VerificationMeta('otags');
  @override
  late final GeneratedColumn<String> otags = GeneratedColumn<String>(
      'otags', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _wgroupMeta = const VerificationMeta('wgroup');
  @override
  late final GeneratedColumn<String> wgroup = GeneratedColumn<String>(
      'wgroup', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _deadlineMeta =
      const VerificationMeta('deadline');
  @override
  late final GeneratedColumn<DateTime> deadline = GeneratedColumn<DateTime>(
      'deadline', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _assignmentGranularityMeta =
      const VerificationMeta('assignmentGranularity');
  @override
  late final GeneratedColumn<String> assignmentGranularity =
      GeneratedColumn<String>('assignment_granularity', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _groupAssignmentOrderMeta =
      const VerificationMeta('groupAssignmentOrder');
  @override
  late final GeneratedColumn<String> groupAssignmentOrder =
      GeneratedColumn<String>('group_assignment_order', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _microtaskAssignmentOrderMeta =
      const VerificationMeta('microtaskAssignmentOrder');
  @override
  late final GeneratedColumn<String> microtaskAssignmentOrder =
      GeneratedColumn<String>('microtask_assignment_order', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _assignmentBatchSizeMeta =
      const VerificationMeta('assignmentBatchSize');
  @override
  late final GeneratedColumn<int> assignmentBatchSize = GeneratedColumn<int>(
      'assignment_batch_size', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _extrasMeta = const VerificationMeta('extras');
  @override
  late final GeneratedColumn<String> extras = GeneratedColumn<String>(
      'extras', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _lastUpdatedAtMeta =
      const VerificationMeta('lastUpdatedAt');
  @override
  late final GeneratedColumn<DateTime> lastUpdatedAt =
      GeneratedColumn<DateTime>('last_updated_at', aliasedName, false,
          type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        workProviderId,
        scenarioName,
        name,
        description,
        displayName,
        policy,
        params,
        itags,
        otags,
        wgroup,
        deadline,
        assignmentGranularity,
        groupAssignmentOrder,
        microtaskAssignmentOrder,
        assignmentBatchSize,
        status,
        extras,
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
    }
    if (data.containsKey('work_provider_id')) {
      context.handle(
          _workProviderIdMeta,
          workProviderId.isAcceptableOrUnknown(
              data['work_provider_id']!, _workProviderIdMeta));
    } else if (isInserting) {
      context.missing(_workProviderIdMeta);
    }
    if (data.containsKey('scenario_name')) {
      context.handle(
          _scenarioNameMeta,
          scenarioName.isAcceptableOrUnknown(
              data['scenario_name']!, _scenarioNameMeta));
    } else if (isInserting) {
      context.missing(_scenarioNameMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(
          _displayNameMeta,
          displayName.isAcceptableOrUnknown(
              data['display_name']!, _displayNameMeta));
    } else if (isInserting) {
      context.missing(_displayNameMeta);
    }
    if (data.containsKey('policy')) {
      context.handle(_policyMeta,
          policy.isAcceptableOrUnknown(data['policy']!, _policyMeta));
    } else if (isInserting) {
      context.missing(_policyMeta);
    }
    if (data.containsKey('params')) {
      context.handle(_paramsMeta,
          params.isAcceptableOrUnknown(data['params']!, _paramsMeta));
    } else if (isInserting) {
      context.missing(_paramsMeta);
    }
    if (data.containsKey('itags')) {
      context.handle(
          _itagsMeta, itags.isAcceptableOrUnknown(data['itags']!, _itagsMeta));
    } else if (isInserting) {
      context.missing(_itagsMeta);
    }
    if (data.containsKey('otags')) {
      context.handle(
          _otagsMeta, otags.isAcceptableOrUnknown(data['otags']!, _otagsMeta));
    } else if (isInserting) {
      context.missing(_otagsMeta);
    }
    if (data.containsKey('wgroup')) {
      context.handle(_wgroupMeta,
          wgroup.isAcceptableOrUnknown(data['wgroup']!, _wgroupMeta));
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
    } else if (isInserting) {
      context.missing(_assignmentGranularityMeta);
    }
    if (data.containsKey('group_assignment_order')) {
      context.handle(
          _groupAssignmentOrderMeta,
          groupAssignmentOrder.isAcceptableOrUnknown(
              data['group_assignment_order']!, _groupAssignmentOrderMeta));
    } else if (isInserting) {
      context.missing(_groupAssignmentOrderMeta);
    }
    if (data.containsKey('microtask_assignment_order')) {
      context.handle(
          _microtaskAssignmentOrderMeta,
          microtaskAssignmentOrder.isAcceptableOrUnknown(
              data['microtask_assignment_order']!,
              _microtaskAssignmentOrderMeta));
    } else if (isInserting) {
      context.missing(_microtaskAssignmentOrderMeta);
    }
    if (data.containsKey('assignment_batch_size')) {
      context.handle(
          _assignmentBatchSizeMeta,
          assignmentBatchSize.isAcceptableOrUnknown(
              data['assignment_batch_size']!, _assignmentBatchSizeMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('extras')) {
      context.handle(_extrasMeta,
          extras.isAcceptableOrUnknown(data['extras']!, _extrasMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('last_updated_at')) {
      context.handle(
          _lastUpdatedAtMeta,
          lastUpdatedAt.isAcceptableOrUnknown(
              data['last_updated_at']!, _lastUpdatedAtMeta));
    } else if (isInserting) {
      context.missing(_lastUpdatedAtMeta);
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
          .read(DriftSqlType.bigInt, data['${effectivePrefix}id'])!,
      workProviderId: attachedDatabase.typeMapping.read(
          DriftSqlType.bigInt, data['${effectivePrefix}work_provider_id'])!,
      scenarioName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}scenario_name'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      displayName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}display_name'])!,
      policy: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}policy'])!,
      params: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}params'])!,
      itags: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}itags'])!,
      otags: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}otags'])!,
      wgroup: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}wgroup']),
      deadline: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}deadline']),
      assignmentGranularity: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}assignment_granularity'])!,
      groupAssignmentOrder: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}group_assignment_order'])!,
      microtaskAssignmentOrder: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}microtask_assignment_order'])!,
      assignmentBatchSize: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}assignment_batch_size']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      extras: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}extras']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      lastUpdatedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_updated_at'])!,
    );
  }

  @override
  $TaskRecordsTable createAlias(String alias) {
    return $TaskRecordsTable(attachedDatabase, alias);
  }
}

class TaskRecord extends DataClass implements Insertable<TaskRecord> {
  final BigInt id;
  final BigInt workProviderId;
  final String scenarioName;
  final String name;
  final String description;
  final String displayName;
  final String policy;
  final String params;
  final String itags;
  final String otags;
  final String? wgroup;
  final DateTime? deadline;
  final String assignmentGranularity;
  final String groupAssignmentOrder;
  final String microtaskAssignmentOrder;
  final int? assignmentBatchSize;
  final String status;
  final String? extras;
  final DateTime createdAt;
  final DateTime lastUpdatedAt;
  const TaskRecord(
      {required this.id,
      required this.workProviderId,
      required this.scenarioName,
      required this.name,
      required this.description,
      required this.displayName,
      required this.policy,
      required this.params,
      required this.itags,
      required this.otags,
      this.wgroup,
      this.deadline,
      required this.assignmentGranularity,
      required this.groupAssignmentOrder,
      required this.microtaskAssignmentOrder,
      this.assignmentBatchSize,
      required this.status,
      this.extras,
      required this.createdAt,
      required this.lastUpdatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<BigInt>(id);
    map['work_provider_id'] = Variable<BigInt>(workProviderId);
    map['scenario_name'] = Variable<String>(scenarioName);
    map['name'] = Variable<String>(name);
    map['description'] = Variable<String>(description);
    map['display_name'] = Variable<String>(displayName);
    map['policy'] = Variable<String>(policy);
    map['params'] = Variable<String>(params);
    map['itags'] = Variable<String>(itags);
    map['otags'] = Variable<String>(otags);
    if (!nullToAbsent || wgroup != null) {
      map['wgroup'] = Variable<String>(wgroup);
    }
    if (!nullToAbsent || deadline != null) {
      map['deadline'] = Variable<DateTime>(deadline);
    }
    map['assignment_granularity'] = Variable<String>(assignmentGranularity);
    map['group_assignment_order'] = Variable<String>(groupAssignmentOrder);
    map['microtask_assignment_order'] =
        Variable<String>(microtaskAssignmentOrder);
    if (!nullToAbsent || assignmentBatchSize != null) {
      map['assignment_batch_size'] = Variable<int>(assignmentBatchSize);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || extras != null) {
      map['extras'] = Variable<String>(extras);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['last_updated_at'] = Variable<DateTime>(lastUpdatedAt);
    return map;
  }

  TaskRecordsCompanion toCompanion(bool nullToAbsent) {
    return TaskRecordsCompanion(
      id: Value(id),
      workProviderId: Value(workProviderId),
      scenarioName: Value(scenarioName),
      name: Value(name),
      description: Value(description),
      displayName: Value(displayName),
      policy: Value(policy),
      params: Value(params),
      itags: Value(itags),
      otags: Value(otags),
      wgroup:
          wgroup == null && nullToAbsent ? const Value.absent() : Value(wgroup),
      deadline: deadline == null && nullToAbsent
          ? const Value.absent()
          : Value(deadline),
      assignmentGranularity: Value(assignmentGranularity),
      groupAssignmentOrder: Value(groupAssignmentOrder),
      microtaskAssignmentOrder: Value(microtaskAssignmentOrder),
      assignmentBatchSize: assignmentBatchSize == null && nullToAbsent
          ? const Value.absent()
          : Value(assignmentBatchSize),
      status: Value(status),
      extras:
          extras == null && nullToAbsent ? const Value.absent() : Value(extras),
      createdAt: Value(createdAt),
      lastUpdatedAt: Value(lastUpdatedAt),
    );
  }

  factory TaskRecord.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaskRecord(
      id: serializer.fromJson<BigInt>(json['id']),
      workProviderId: serializer.fromJson<BigInt>(json['workProviderId']),
      scenarioName: serializer.fromJson<String>(json['scenarioName']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String>(json['description']),
      displayName: serializer.fromJson<String>(json['displayName']),
      policy: serializer.fromJson<String>(json['policy']),
      params: serializer.fromJson<String>(json['params']),
      itags: serializer.fromJson<String>(json['itags']),
      otags: serializer.fromJson<String>(json['otags']),
      wgroup: serializer.fromJson<String?>(json['wgroup']),
      deadline: serializer.fromJson<DateTime?>(json['deadline']),
      assignmentGranularity:
          serializer.fromJson<String>(json['assignmentGranularity']),
      groupAssignmentOrder:
          serializer.fromJson<String>(json['groupAssignmentOrder']),
      microtaskAssignmentOrder:
          serializer.fromJson<String>(json['microtaskAssignmentOrder']),
      assignmentBatchSize:
          serializer.fromJson<int?>(json['assignmentBatchSize']),
      status: serializer.fromJson<String>(json['status']),
      extras: serializer.fromJson<String?>(json['extras']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      lastUpdatedAt: serializer.fromJson<DateTime>(json['lastUpdatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<BigInt>(id),
      'workProviderId': serializer.toJson<BigInt>(workProviderId),
      'scenarioName': serializer.toJson<String>(scenarioName),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String>(description),
      'displayName': serializer.toJson<String>(displayName),
      'policy': serializer.toJson<String>(policy),
      'params': serializer.toJson<String>(params),
      'itags': serializer.toJson<String>(itags),
      'otags': serializer.toJson<String>(otags),
      'wgroup': serializer.toJson<String?>(wgroup),
      'deadline': serializer.toJson<DateTime?>(deadline),
      'assignmentGranularity': serializer.toJson<String>(assignmentGranularity),
      'groupAssignmentOrder': serializer.toJson<String>(groupAssignmentOrder),
      'microtaskAssignmentOrder':
          serializer.toJson<String>(microtaskAssignmentOrder),
      'assignmentBatchSize': serializer.toJson<int?>(assignmentBatchSize),
      'status': serializer.toJson<String>(status),
      'extras': serializer.toJson<String?>(extras),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'lastUpdatedAt': serializer.toJson<DateTime>(lastUpdatedAt),
    };
  }

  TaskRecord copyWith(
          {BigInt? id,
          BigInt? workProviderId,
          String? scenarioName,
          String? name,
          String? description,
          String? displayName,
          String? policy,
          String? params,
          String? itags,
          String? otags,
          Value<String?> wgroup = const Value.absent(),
          Value<DateTime?> deadline = const Value.absent(),
          String? assignmentGranularity,
          String? groupAssignmentOrder,
          String? microtaskAssignmentOrder,
          Value<int?> assignmentBatchSize = const Value.absent(),
          String? status,
          Value<String?> extras = const Value.absent(),
          DateTime? createdAt,
          DateTime? lastUpdatedAt}) =>
      TaskRecord(
        id: id ?? this.id,
        workProviderId: workProviderId ?? this.workProviderId,
        scenarioName: scenarioName ?? this.scenarioName,
        name: name ?? this.name,
        description: description ?? this.description,
        displayName: displayName ?? this.displayName,
        policy: policy ?? this.policy,
        params: params ?? this.params,
        itags: itags ?? this.itags,
        otags: otags ?? this.otags,
        wgroup: wgroup.present ? wgroup.value : this.wgroup,
        deadline: deadline.present ? deadline.value : this.deadline,
        assignmentGranularity:
            assignmentGranularity ?? this.assignmentGranularity,
        groupAssignmentOrder: groupAssignmentOrder ?? this.groupAssignmentOrder,
        microtaskAssignmentOrder:
            microtaskAssignmentOrder ?? this.microtaskAssignmentOrder,
        assignmentBatchSize: assignmentBatchSize.present
            ? assignmentBatchSize.value
            : this.assignmentBatchSize,
        status: status ?? this.status,
        extras: extras.present ? extras.value : this.extras,
        createdAt: createdAt ?? this.createdAt,
        lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
      );
  TaskRecord copyWithCompanion(TaskRecordsCompanion data) {
    return TaskRecord(
      id: data.id.present ? data.id.value : this.id,
      workProviderId: data.workProviderId.present
          ? data.workProviderId.value
          : this.workProviderId,
      scenarioName: data.scenarioName.present
          ? data.scenarioName.value
          : this.scenarioName,
      name: data.name.present ? data.name.value : this.name,
      description:
          data.description.present ? data.description.value : this.description,
      displayName:
          data.displayName.present ? data.displayName.value : this.displayName,
      policy: data.policy.present ? data.policy.value : this.policy,
      params: data.params.present ? data.params.value : this.params,
      itags: data.itags.present ? data.itags.value : this.itags,
      otags: data.otags.present ? data.otags.value : this.otags,
      wgroup: data.wgroup.present ? data.wgroup.value : this.wgroup,
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
      assignmentBatchSize: data.assignmentBatchSize.present
          ? data.assignmentBatchSize.value
          : this.assignmentBatchSize,
      status: data.status.present ? data.status.value : this.status,
      extras: data.extras.present ? data.extras.value : this.extras,
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
          ..write('workProviderId: $workProviderId, ')
          ..write('scenarioName: $scenarioName, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('displayName: $displayName, ')
          ..write('policy: $policy, ')
          ..write('params: $params, ')
          ..write('itags: $itags, ')
          ..write('otags: $otags, ')
          ..write('wgroup: $wgroup, ')
          ..write('deadline: $deadline, ')
          ..write('assignmentGranularity: $assignmentGranularity, ')
          ..write('groupAssignmentOrder: $groupAssignmentOrder, ')
          ..write('microtaskAssignmentOrder: $microtaskAssignmentOrder, ')
          ..write('assignmentBatchSize: $assignmentBatchSize, ')
          ..write('status: $status, ')
          ..write('extras: $extras, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastUpdatedAt: $lastUpdatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      workProviderId,
      scenarioName,
      name,
      description,
      displayName,
      policy,
      params,
      itags,
      otags,
      wgroup,
      deadline,
      assignmentGranularity,
      groupAssignmentOrder,
      microtaskAssignmentOrder,
      assignmentBatchSize,
      status,
      extras,
      createdAt,
      lastUpdatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaskRecord &&
          other.id == this.id &&
          other.workProviderId == this.workProviderId &&
          other.scenarioName == this.scenarioName &&
          other.name == this.name &&
          other.description == this.description &&
          other.displayName == this.displayName &&
          other.policy == this.policy &&
          other.params == this.params &&
          other.itags == this.itags &&
          other.otags == this.otags &&
          other.wgroup == this.wgroup &&
          other.deadline == this.deadline &&
          other.assignmentGranularity == this.assignmentGranularity &&
          other.groupAssignmentOrder == this.groupAssignmentOrder &&
          other.microtaskAssignmentOrder == this.microtaskAssignmentOrder &&
          other.assignmentBatchSize == this.assignmentBatchSize &&
          other.status == this.status &&
          other.extras == this.extras &&
          other.createdAt == this.createdAt &&
          other.lastUpdatedAt == this.lastUpdatedAt);
}

class TaskRecordsCompanion extends UpdateCompanion<TaskRecord> {
  final Value<BigInt> id;
  final Value<BigInt> workProviderId;
  final Value<String> scenarioName;
  final Value<String> name;
  final Value<String> description;
  final Value<String> displayName;
  final Value<String> policy;
  final Value<String> params;
  final Value<String> itags;
  final Value<String> otags;
  final Value<String?> wgroup;
  final Value<DateTime?> deadline;
  final Value<String> assignmentGranularity;
  final Value<String> groupAssignmentOrder;
  final Value<String> microtaskAssignmentOrder;
  final Value<int?> assignmentBatchSize;
  final Value<String> status;
  final Value<String?> extras;
  final Value<DateTime> createdAt;
  final Value<DateTime> lastUpdatedAt;
  const TaskRecordsCompanion({
    this.id = const Value.absent(),
    this.workProviderId = const Value.absent(),
    this.scenarioName = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.displayName = const Value.absent(),
    this.policy = const Value.absent(),
    this.params = const Value.absent(),
    this.itags = const Value.absent(),
    this.otags = const Value.absent(),
    this.wgroup = const Value.absent(),
    this.deadline = const Value.absent(),
    this.assignmentGranularity = const Value.absent(),
    this.groupAssignmentOrder = const Value.absent(),
    this.microtaskAssignmentOrder = const Value.absent(),
    this.assignmentBatchSize = const Value.absent(),
    this.status = const Value.absent(),
    this.extras = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.lastUpdatedAt = const Value.absent(),
  });
  TaskRecordsCompanion.insert({
    this.id = const Value.absent(),
    required BigInt workProviderId,
    required String scenarioName,
    required String name,
    required String description,
    required String displayName,
    required String policy,
    required String params,
    required String itags,
    required String otags,
    this.wgroup = const Value.absent(),
    this.deadline = const Value.absent(),
    required String assignmentGranularity,
    required String groupAssignmentOrder,
    required String microtaskAssignmentOrder,
    this.assignmentBatchSize = const Value.absent(),
    required String status,
    this.extras = const Value.absent(),
    required DateTime createdAt,
    required DateTime lastUpdatedAt,
  })  : workProviderId = Value(workProviderId),
        scenarioName = Value(scenarioName),
        name = Value(name),
        description = Value(description),
        displayName = Value(displayName),
        policy = Value(policy),
        params = Value(params),
        itags = Value(itags),
        otags = Value(otags),
        assignmentGranularity = Value(assignmentGranularity),
        groupAssignmentOrder = Value(groupAssignmentOrder),
        microtaskAssignmentOrder = Value(microtaskAssignmentOrder),
        status = Value(status),
        createdAt = Value(createdAt),
        lastUpdatedAt = Value(lastUpdatedAt);
  static Insertable<TaskRecord> custom({
    Expression<BigInt>? id,
    Expression<BigInt>? workProviderId,
    Expression<String>? scenarioName,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? displayName,
    Expression<String>? policy,
    Expression<String>? params,
    Expression<String>? itags,
    Expression<String>? otags,
    Expression<String>? wgroup,
    Expression<DateTime>? deadline,
    Expression<String>? assignmentGranularity,
    Expression<String>? groupAssignmentOrder,
    Expression<String>? microtaskAssignmentOrder,
    Expression<int>? assignmentBatchSize,
    Expression<String>? status,
    Expression<String>? extras,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? lastUpdatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (workProviderId != null) 'work_provider_id': workProviderId,
      if (scenarioName != null) 'scenario_name': scenarioName,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (displayName != null) 'display_name': displayName,
      if (policy != null) 'policy': policy,
      if (params != null) 'params': params,
      if (itags != null) 'itags': itags,
      if (otags != null) 'otags': otags,
      if (wgroup != null) 'wgroup': wgroup,
      if (deadline != null) 'deadline': deadline,
      if (assignmentGranularity != null)
        'assignment_granularity': assignmentGranularity,
      if (groupAssignmentOrder != null)
        'group_assignment_order': groupAssignmentOrder,
      if (microtaskAssignmentOrder != null)
        'microtask_assignment_order': microtaskAssignmentOrder,
      if (assignmentBatchSize != null)
        'assignment_batch_size': assignmentBatchSize,
      if (status != null) 'status': status,
      if (extras != null) 'extras': extras,
      if (createdAt != null) 'created_at': createdAt,
      if (lastUpdatedAt != null) 'last_updated_at': lastUpdatedAt,
    });
  }

  TaskRecordsCompanion copyWith(
      {Value<BigInt>? id,
      Value<BigInt>? workProviderId,
      Value<String>? scenarioName,
      Value<String>? name,
      Value<String>? description,
      Value<String>? displayName,
      Value<String>? policy,
      Value<String>? params,
      Value<String>? itags,
      Value<String>? otags,
      Value<String?>? wgroup,
      Value<DateTime?>? deadline,
      Value<String>? assignmentGranularity,
      Value<String>? groupAssignmentOrder,
      Value<String>? microtaskAssignmentOrder,
      Value<int?>? assignmentBatchSize,
      Value<String>? status,
      Value<String?>? extras,
      Value<DateTime>? createdAt,
      Value<DateTime>? lastUpdatedAt}) {
    return TaskRecordsCompanion(
      id: id ?? this.id,
      workProviderId: workProviderId ?? this.workProviderId,
      scenarioName: scenarioName ?? this.scenarioName,
      name: name ?? this.name,
      description: description ?? this.description,
      displayName: displayName ?? this.displayName,
      policy: policy ?? this.policy,
      params: params ?? this.params,
      itags: itags ?? this.itags,
      otags: otags ?? this.otags,
      wgroup: wgroup ?? this.wgroup,
      deadline: deadline ?? this.deadline,
      assignmentGranularity:
          assignmentGranularity ?? this.assignmentGranularity,
      groupAssignmentOrder: groupAssignmentOrder ?? this.groupAssignmentOrder,
      microtaskAssignmentOrder:
          microtaskAssignmentOrder ?? this.microtaskAssignmentOrder,
      assignmentBatchSize: assignmentBatchSize ?? this.assignmentBatchSize,
      status: status ?? this.status,
      extras: extras ?? this.extras,
      createdAt: createdAt ?? this.createdAt,
      lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<BigInt>(id.value);
    }
    if (workProviderId.present) {
      map['work_provider_id'] = Variable<BigInt>(workProviderId.value);
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
    if (policy.present) {
      map['policy'] = Variable<String>(policy.value);
    }
    if (params.present) {
      map['params'] = Variable<String>(params.value);
    }
    if (itags.present) {
      map['itags'] = Variable<String>(itags.value);
    }
    if (otags.present) {
      map['otags'] = Variable<String>(otags.value);
    }
    if (wgroup.present) {
      map['wgroup'] = Variable<String>(wgroup.value);
    }
    if (deadline.present) {
      map['deadline'] = Variable<DateTime>(deadline.value);
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
    if (assignmentBatchSize.present) {
      map['assignment_batch_size'] = Variable<int>(assignmentBatchSize.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (extras.present) {
      map['extras'] = Variable<String>(extras.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (lastUpdatedAt.present) {
      map['last_updated_at'] = Variable<DateTime>(lastUpdatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TaskRecordsCompanion(')
          ..write('id: $id, ')
          ..write('workProviderId: $workProviderId, ')
          ..write('scenarioName: $scenarioName, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('displayName: $displayName, ')
          ..write('policy: $policy, ')
          ..write('params: $params, ')
          ..write('itags: $itags, ')
          ..write('otags: $otags, ')
          ..write('wgroup: $wgroup, ')
          ..write('deadline: $deadline, ')
          ..write('assignmentGranularity: $assignmentGranularity, ')
          ..write('groupAssignmentOrder: $groupAssignmentOrder, ')
          ..write('microtaskAssignmentOrder: $microtaskAssignmentOrder, ')
          ..write('assignmentBatchSize: $assignmentBatchSize, ')
          ..write('status: $status, ')
          ..write('extras: $extras, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastUpdatedAt: $lastUpdatedAt')
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
  late final GeneratedColumn<BigInt> id = GeneratedColumn<BigInt>(
      'id', aliasedName, false,
      type: DriftSqlType.bigInt, requiredDuringInsert: false);
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<BigInt> taskId = GeneratedColumn<BigInt>(
      'task_id', aliasedName, false,
      type: DriftSqlType.bigInt, requiredDuringInsert: true);
  static const VerificationMeta _groupIdMeta =
      const VerificationMeta('groupId');
  @override
  late final GeneratedColumn<BigInt> groupId = GeneratedColumn<BigInt>(
      'group_id', aliasedName, true,
      type: DriftSqlType.bigInt, requiredDuringInsert: false);
  static const VerificationMeta _inputMeta = const VerificationMeta('input');
  @override
  late final GeneratedColumn<String> input = GeneratedColumn<String>(
      'input', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _inputFileIdMeta =
      const VerificationMeta('inputFileId');
  @override
  late final GeneratedColumn<BigInt> inputFileId = GeneratedColumn<BigInt>(
      'input_file_id', aliasedName, true,
      type: DriftSqlType.bigInt, requiredDuringInsert: false);
  static const VerificationMeta _deadlineMeta =
      const VerificationMeta('deadline');
  @override
  late final GeneratedColumn<DateTime> deadline = GeneratedColumn<DateTime>(
      'deadline', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _baseCreditsMeta =
      const VerificationMeta('baseCredits');
  @override
  late final GeneratedColumn<double> baseCredits = GeneratedColumn<double>(
      'base_credits', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _creditsMeta =
      const VerificationMeta('credits');
  @override
  late final GeneratedColumn<double> credits = GeneratedColumn<double>(
      'credits', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _outputMeta = const VerificationMeta('output');
  @override
  late final GeneratedColumn<String> output = GeneratedColumn<String>(
      'output', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _extrasMeta = const VerificationMeta('extras');
  @override
  late final GeneratedColumn<String> extras = GeneratedColumn<String>(
      'extras', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _lastUpdatedAtMeta =
      const VerificationMeta('lastUpdatedAt');
  @override
  late final GeneratedColumn<DateTime> lastUpdatedAt =
      GeneratedColumn<DateTime>('last_updated_at', aliasedName, false,
          type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        taskId,
        groupId,
        input,
        inputFileId,
        deadline,
        baseCredits,
        credits,
        status,
        output,
        extras,
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
    }
    if (data.containsKey('task_id')) {
      context.handle(_taskIdMeta,
          taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta));
    } else if (isInserting) {
      context.missing(_taskIdMeta);
    }
    if (data.containsKey('group_id')) {
      context.handle(_groupIdMeta,
          groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta));
    }
    if (data.containsKey('input')) {
      context.handle(
          _inputMeta, input.isAcceptableOrUnknown(data['input']!, _inputMeta));
    } else if (isInserting) {
      context.missing(_inputMeta);
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
    if (data.containsKey('base_credits')) {
      context.handle(
          _baseCreditsMeta,
          baseCredits.isAcceptableOrUnknown(
              data['base_credits']!, _baseCreditsMeta));
    } else if (isInserting) {
      context.missing(_baseCreditsMeta);
    }
    if (data.containsKey('credits')) {
      context.handle(_creditsMeta,
          credits.isAcceptableOrUnknown(data['credits']!, _creditsMeta));
    } else if (isInserting) {
      context.missing(_creditsMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('output')) {
      context.handle(_outputMeta,
          output.isAcceptableOrUnknown(data['output']!, _outputMeta));
    }
    if (data.containsKey('extras')) {
      context.handle(_extrasMeta,
          extras.isAcceptableOrUnknown(data['extras']!, _extrasMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('last_updated_at')) {
      context.handle(
          _lastUpdatedAtMeta,
          lastUpdatedAt.isAcceptableOrUnknown(
              data['last_updated_at']!, _lastUpdatedAtMeta));
    } else if (isInserting) {
      context.missing(_lastUpdatedAtMeta);
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
          .read(DriftSqlType.bigInt, data['${effectivePrefix}id'])!,
      taskId: attachedDatabase.typeMapping
          .read(DriftSqlType.bigInt, data['${effectivePrefix}task_id'])!,
      groupId: attachedDatabase.typeMapping
          .read(DriftSqlType.bigInt, data['${effectivePrefix}group_id']),
      input: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}input'])!,
      inputFileId: attachedDatabase.typeMapping
          .read(DriftSqlType.bigInt, data['${effectivePrefix}input_file_id']),
      deadline: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}deadline']),
      baseCredits: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}base_credits'])!,
      credits: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}credits'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      output: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}output']),
      extras: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}extras']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      lastUpdatedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_updated_at'])!,
    );
  }

  @override
  $MicroTaskRecordsTable createAlias(String alias) {
    return $MicroTaskRecordsTable(attachedDatabase, alias);
  }
}

class MicroTaskRecord extends DataClass implements Insertable<MicroTaskRecord> {
  final BigInt id;
  final BigInt taskId;
  final BigInt? groupId;
  final String input;
  final BigInt? inputFileId;
  final DateTime? deadline;
  final double baseCredits;
  final double credits;
  final String status;
  final String? output;
  final String? extras;
  final DateTime createdAt;
  final DateTime lastUpdatedAt;
  const MicroTaskRecord(
      {required this.id,
      required this.taskId,
      this.groupId,
      required this.input,
      this.inputFileId,
      this.deadline,
      required this.baseCredits,
      required this.credits,
      required this.status,
      this.output,
      this.extras,
      required this.createdAt,
      required this.lastUpdatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<BigInt>(id);
    map['task_id'] = Variable<BigInt>(taskId);
    if (!nullToAbsent || groupId != null) {
      map['group_id'] = Variable<BigInt>(groupId);
    }
    map['input'] = Variable<String>(input);
    if (!nullToAbsent || inputFileId != null) {
      map['input_file_id'] = Variable<BigInt>(inputFileId);
    }
    if (!nullToAbsent || deadline != null) {
      map['deadline'] = Variable<DateTime>(deadline);
    }
    map['base_credits'] = Variable<double>(baseCredits);
    map['credits'] = Variable<double>(credits);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || output != null) {
      map['output'] = Variable<String>(output);
    }
    if (!nullToAbsent || extras != null) {
      map['extras'] = Variable<String>(extras);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['last_updated_at'] = Variable<DateTime>(lastUpdatedAt);
    return map;
  }

  MicroTaskRecordsCompanion toCompanion(bool nullToAbsent) {
    return MicroTaskRecordsCompanion(
      id: Value(id),
      taskId: Value(taskId),
      groupId: groupId == null && nullToAbsent
          ? const Value.absent()
          : Value(groupId),
      input: Value(input),
      inputFileId: inputFileId == null && nullToAbsent
          ? const Value.absent()
          : Value(inputFileId),
      deadline: deadline == null && nullToAbsent
          ? const Value.absent()
          : Value(deadline),
      baseCredits: Value(baseCredits),
      credits: Value(credits),
      status: Value(status),
      output:
          output == null && nullToAbsent ? const Value.absent() : Value(output),
      extras:
          extras == null && nullToAbsent ? const Value.absent() : Value(extras),
      createdAt: Value(createdAt),
      lastUpdatedAt: Value(lastUpdatedAt),
    );
  }

  factory MicroTaskRecord.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MicroTaskRecord(
      id: serializer.fromJson<BigInt>(json['id']),
      taskId: serializer.fromJson<BigInt>(json['taskId']),
      groupId: serializer.fromJson<BigInt?>(json['groupId']),
      input: serializer.fromJson<String>(json['input']),
      inputFileId: serializer.fromJson<BigInt?>(json['inputFileId']),
      deadline: serializer.fromJson<DateTime?>(json['deadline']),
      baseCredits: serializer.fromJson<double>(json['baseCredits']),
      credits: serializer.fromJson<double>(json['credits']),
      status: serializer.fromJson<String>(json['status']),
      output: serializer.fromJson<String?>(json['output']),
      extras: serializer.fromJson<String?>(json['extras']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      lastUpdatedAt: serializer.fromJson<DateTime>(json['lastUpdatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<BigInt>(id),
      'taskId': serializer.toJson<BigInt>(taskId),
      'groupId': serializer.toJson<BigInt?>(groupId),
      'input': serializer.toJson<String>(input),
      'inputFileId': serializer.toJson<BigInt?>(inputFileId),
      'deadline': serializer.toJson<DateTime?>(deadline),
      'baseCredits': serializer.toJson<double>(baseCredits),
      'credits': serializer.toJson<double>(credits),
      'status': serializer.toJson<String>(status),
      'output': serializer.toJson<String?>(output),
      'extras': serializer.toJson<String?>(extras),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'lastUpdatedAt': serializer.toJson<DateTime>(lastUpdatedAt),
    };
  }

  MicroTaskRecord copyWith(
          {BigInt? id,
          BigInt? taskId,
          Value<BigInt?> groupId = const Value.absent(),
          String? input,
          Value<BigInt?> inputFileId = const Value.absent(),
          Value<DateTime?> deadline = const Value.absent(),
          double? baseCredits,
          double? credits,
          String? status,
          Value<String?> output = const Value.absent(),
          Value<String?> extras = const Value.absent(),
          DateTime? createdAt,
          DateTime? lastUpdatedAt}) =>
      MicroTaskRecord(
        id: id ?? this.id,
        taskId: taskId ?? this.taskId,
        groupId: groupId.present ? groupId.value : this.groupId,
        input: input ?? this.input,
        inputFileId: inputFileId.present ? inputFileId.value : this.inputFileId,
        deadline: deadline.present ? deadline.value : this.deadline,
        baseCredits: baseCredits ?? this.baseCredits,
        credits: credits ?? this.credits,
        status: status ?? this.status,
        output: output.present ? output.value : this.output,
        extras: extras.present ? extras.value : this.extras,
        createdAt: createdAt ?? this.createdAt,
        lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
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
      baseCredits:
          data.baseCredits.present ? data.baseCredits.value : this.baseCredits,
      credits: data.credits.present ? data.credits.value : this.credits,
      status: data.status.present ? data.status.value : this.status,
      output: data.output.present ? data.output.value : this.output,
      extras: data.extras.present ? data.extras.value : this.extras,
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
          ..write('baseCredits: $baseCredits, ')
          ..write('credits: $credits, ')
          ..write('status: $status, ')
          ..write('output: $output, ')
          ..write('extras: $extras, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastUpdatedAt: $lastUpdatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      taskId,
      groupId,
      input,
      inputFileId,
      deadline,
      baseCredits,
      credits,
      status,
      output,
      extras,
      createdAt,
      lastUpdatedAt);
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
          other.baseCredits == this.baseCredits &&
          other.credits == this.credits &&
          other.status == this.status &&
          other.output == this.output &&
          other.extras == this.extras &&
          other.createdAt == this.createdAt &&
          other.lastUpdatedAt == this.lastUpdatedAt);
}

class MicroTaskRecordsCompanion extends UpdateCompanion<MicroTaskRecord> {
  final Value<BigInt> id;
  final Value<BigInt> taskId;
  final Value<BigInt?> groupId;
  final Value<String> input;
  final Value<BigInt?> inputFileId;
  final Value<DateTime?> deadline;
  final Value<double> baseCredits;
  final Value<double> credits;
  final Value<String> status;
  final Value<String?> output;
  final Value<String?> extras;
  final Value<DateTime> createdAt;
  final Value<DateTime> lastUpdatedAt;
  const MicroTaskRecordsCompanion({
    this.id = const Value.absent(),
    this.taskId = const Value.absent(),
    this.groupId = const Value.absent(),
    this.input = const Value.absent(),
    this.inputFileId = const Value.absent(),
    this.deadline = const Value.absent(),
    this.baseCredits = const Value.absent(),
    this.credits = const Value.absent(),
    this.status = const Value.absent(),
    this.output = const Value.absent(),
    this.extras = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.lastUpdatedAt = const Value.absent(),
  });
  MicroTaskRecordsCompanion.insert({
    this.id = const Value.absent(),
    required BigInt taskId,
    this.groupId = const Value.absent(),
    required String input,
    this.inputFileId = const Value.absent(),
    this.deadline = const Value.absent(),
    required double baseCredits,
    required double credits,
    required String status,
    this.output = const Value.absent(),
    this.extras = const Value.absent(),
    required DateTime createdAt,
    required DateTime lastUpdatedAt,
  })  : taskId = Value(taskId),
        input = Value(input),
        baseCredits = Value(baseCredits),
        credits = Value(credits),
        status = Value(status),
        createdAt = Value(createdAt),
        lastUpdatedAt = Value(lastUpdatedAt);
  static Insertable<MicroTaskRecord> custom({
    Expression<BigInt>? id,
    Expression<BigInt>? taskId,
    Expression<BigInt>? groupId,
    Expression<String>? input,
    Expression<BigInt>? inputFileId,
    Expression<DateTime>? deadline,
    Expression<double>? baseCredits,
    Expression<double>? credits,
    Expression<String>? status,
    Expression<String>? output,
    Expression<String>? extras,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? lastUpdatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (taskId != null) 'task_id': taskId,
      if (groupId != null) 'group_id': groupId,
      if (input != null) 'input': input,
      if (inputFileId != null) 'input_file_id': inputFileId,
      if (deadline != null) 'deadline': deadline,
      if (baseCredits != null) 'base_credits': baseCredits,
      if (credits != null) 'credits': credits,
      if (status != null) 'status': status,
      if (output != null) 'output': output,
      if (extras != null) 'extras': extras,
      if (createdAt != null) 'created_at': createdAt,
      if (lastUpdatedAt != null) 'last_updated_at': lastUpdatedAt,
    });
  }

  MicroTaskRecordsCompanion copyWith(
      {Value<BigInt>? id,
      Value<BigInt>? taskId,
      Value<BigInt?>? groupId,
      Value<String>? input,
      Value<BigInt?>? inputFileId,
      Value<DateTime?>? deadline,
      Value<double>? baseCredits,
      Value<double>? credits,
      Value<String>? status,
      Value<String?>? output,
      Value<String?>? extras,
      Value<DateTime>? createdAt,
      Value<DateTime>? lastUpdatedAt}) {
    return MicroTaskRecordsCompanion(
      id: id ?? this.id,
      taskId: taskId ?? this.taskId,
      groupId: groupId ?? this.groupId,
      input: input ?? this.input,
      inputFileId: inputFileId ?? this.inputFileId,
      deadline: deadline ?? this.deadline,
      baseCredits: baseCredits ?? this.baseCredits,
      credits: credits ?? this.credits,
      status: status ?? this.status,
      output: output ?? this.output,
      extras: extras ?? this.extras,
      createdAt: createdAt ?? this.createdAt,
      lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<BigInt>(id.value);
    }
    if (taskId.present) {
      map['task_id'] = Variable<BigInt>(taskId.value);
    }
    if (groupId.present) {
      map['group_id'] = Variable<BigInt>(groupId.value);
    }
    if (input.present) {
      map['input'] = Variable<String>(input.value);
    }
    if (inputFileId.present) {
      map['input_file_id'] = Variable<BigInt>(inputFileId.value);
    }
    if (deadline.present) {
      map['deadline'] = Variable<DateTime>(deadline.value);
    }
    if (baseCredits.present) {
      map['base_credits'] = Variable<double>(baseCredits.value);
    }
    if (credits.present) {
      map['credits'] = Variable<double>(credits.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (output.present) {
      map['output'] = Variable<String>(output.value);
    }
    if (extras.present) {
      map['extras'] = Variable<String>(extras.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (lastUpdatedAt.present) {
      map['last_updated_at'] = Variable<DateTime>(lastUpdatedAt.value);
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
          ..write('baseCredits: $baseCredits, ')
          ..write('credits: $credits, ')
          ..write('status: $status, ')
          ..write('output: $output, ')
          ..write('extras: $extras, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastUpdatedAt: $lastUpdatedAt')
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
  late final GeneratedColumn<BigInt> id = GeneratedColumn<BigInt>(
      'id', aliasedName, false,
      type: DriftSqlType.bigInt, requiredDuringInsert: false);
  static const VerificationMeta _boxIdMeta = const VerificationMeta('boxId');
  @override
  late final GeneratedColumn<BigInt> boxId = GeneratedColumn<BigInt>(
      'box_id', aliasedName, false,
      type: DriftSqlType.bigInt, requiredDuringInsert: true);
  static const VerificationMeta _localIdMeta =
      const VerificationMeta('localId');
  @override
  late final GeneratedColumn<BigInt> localId = GeneratedColumn<BigInt>(
      'local_id', aliasedName, false,
      type: DriftSqlType.bigInt, requiredDuringInsert: true);
  static const VerificationMeta _microtaskIdMeta =
      const VerificationMeta('microtaskId');
  @override
  late final GeneratedColumn<BigInt> microtaskId = GeneratedColumn<BigInt>(
      'microtask_id', aliasedName, false,
      type: DriftSqlType.bigInt, requiredDuringInsert: true);
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<BigInt> taskId = GeneratedColumn<BigInt>(
      'task_id', aliasedName, false,
      type: DriftSqlType.bigInt, requiredDuringInsert: true);
  static const VerificationMeta _workerIdMeta =
      const VerificationMeta('workerId');
  @override
  late final GeneratedColumn<BigInt> workerId = GeneratedColumn<BigInt>(
      'worker_id', aliasedName, false,
      type: DriftSqlType.bigInt, requiredDuringInsert: true);
  static const VerificationMeta _wgroupMeta = const VerificationMeta('wgroup');
  @override
  late final GeneratedColumn<String> wgroup = GeneratedColumn<String>(
      'wgroup', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _sentToServerAtMeta =
      const VerificationMeta('sentToServerAt');
  @override
  late final GeneratedColumn<DateTime> sentToServerAt =
      GeneratedColumn<DateTime>('sent_to_server_at', aliasedName, false,
          type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _deadlineMeta =
      const VerificationMeta('deadline');
  @override
  late final GeneratedColumn<DateTime> deadline = GeneratedColumn<DateTime>(
      'deadline', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _completedAtMeta =
      const VerificationMeta('completedAt');
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
      'completed_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _outputMeta = const VerificationMeta('output');
  @override
  late final GeneratedColumn<String> output = GeneratedColumn<String>(
      'output', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _outputFileIdMeta =
      const VerificationMeta('outputFileId');
  @override
  late final GeneratedColumn<BigInt> outputFileId = GeneratedColumn<BigInt>(
      'output_file_id', aliasedName, true,
      type: DriftSqlType.bigInt, requiredDuringInsert: false);
  static const VerificationMeta _logsMeta = const VerificationMeta('logs');
  @override
  late final GeneratedColumn<String> logs = GeneratedColumn<String>(
      'logs', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _submittedToBoxAtMeta =
      const VerificationMeta('submittedToBoxAt');
  @override
  late final GeneratedColumn<DateTime> submittedToBoxAt =
      GeneratedColumn<DateTime>('submitted_to_box_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _submittedToServerAtMeta =
      const VerificationMeta('submittedToServerAt');
  @override
  late final GeneratedColumn<DateTime> submittedToServerAt =
      GeneratedColumn<DateTime>('submitted_to_server_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _verifiedAtMeta =
      const VerificationMeta('verifiedAt');
  @override
  late final GeneratedColumn<DateTime> verifiedAt = GeneratedColumn<DateTime>(
      'verified_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _reportMeta = const VerificationMeta('report');
  @override
  late final GeneratedColumn<String> report = GeneratedColumn<String>(
      'report', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _maxBaseCreditsMeta =
      const VerificationMeta('maxBaseCredits');
  @override
  late final GeneratedColumn<double> maxBaseCredits = GeneratedColumn<double>(
      'max_base_credits', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _baseCreditsMeta =
      const VerificationMeta('baseCredits');
  @override
  late final GeneratedColumn<double> baseCredits = GeneratedColumn<double>(
      'base_credits', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _maxCreditsMeta =
      const VerificationMeta('maxCredits');
  @override
  late final GeneratedColumn<double> maxCredits = GeneratedColumn<double>(
      'max_credits', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _creditsMeta =
      const VerificationMeta('credits');
  @override
  late final GeneratedColumn<double> credits = GeneratedColumn<double>(
      'credits', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _extrasMeta = const VerificationMeta('extras');
  @override
  late final GeneratedColumn<String> extras = GeneratedColumn<String>(
      'extras', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _lastUpdatedAtMeta =
      const VerificationMeta('lastUpdatedAt');
  @override
  late final GeneratedColumn<DateTime> lastUpdatedAt =
      GeneratedColumn<DateTime>('last_updated_at', aliasedName, false,
          type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        boxId,
        localId,
        microtaskId,
        taskId,
        workerId,
        wgroup,
        sentToServerAt,
        deadline,
        status,
        completedAt,
        output,
        outputFileId,
        logs,
        submittedToBoxAt,
        submittedToServerAt,
        verifiedAt,
        report,
        maxBaseCredits,
        baseCredits,
        maxCredits,
        credits,
        extras,
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
    }
    if (data.containsKey('box_id')) {
      context.handle(
          _boxIdMeta, boxId.isAcceptableOrUnknown(data['box_id']!, _boxIdMeta));
    } else if (isInserting) {
      context.missing(_boxIdMeta);
    }
    if (data.containsKey('local_id')) {
      context.handle(_localIdMeta,
          localId.isAcceptableOrUnknown(data['local_id']!, _localIdMeta));
    } else if (isInserting) {
      context.missing(_localIdMeta);
    }
    if (data.containsKey('microtask_id')) {
      context.handle(
          _microtaskIdMeta,
          microtaskId.isAcceptableOrUnknown(
              data['microtask_id']!, _microtaskIdMeta));
    } else if (isInserting) {
      context.missing(_microtaskIdMeta);
    }
    if (data.containsKey('task_id')) {
      context.handle(_taskIdMeta,
          taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta));
    } else if (isInserting) {
      context.missing(_taskIdMeta);
    }
    if (data.containsKey('worker_id')) {
      context.handle(_workerIdMeta,
          workerId.isAcceptableOrUnknown(data['worker_id']!, _workerIdMeta));
    } else if (isInserting) {
      context.missing(_workerIdMeta);
    }
    if (data.containsKey('wgroup')) {
      context.handle(_wgroupMeta,
          wgroup.isAcceptableOrUnknown(data['wgroup']!, _wgroupMeta));
    }
    if (data.containsKey('sent_to_server_at')) {
      context.handle(
          _sentToServerAtMeta,
          sentToServerAt.isAcceptableOrUnknown(
              data['sent_to_server_at']!, _sentToServerAtMeta));
    } else if (isInserting) {
      context.missing(_sentToServerAtMeta);
    }
    if (data.containsKey('deadline')) {
      context.handle(_deadlineMeta,
          deadline.isAcceptableOrUnknown(data['deadline']!, _deadlineMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
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
    if (data.containsKey('submitted_to_box_at')) {
      context.handle(
          _submittedToBoxAtMeta,
          submittedToBoxAt.isAcceptableOrUnknown(
              data['submitted_to_box_at']!, _submittedToBoxAtMeta));
    }
    if (data.containsKey('submitted_to_server_at')) {
      context.handle(
          _submittedToServerAtMeta,
          submittedToServerAt.isAcceptableOrUnknown(
              data['submitted_to_server_at']!, _submittedToServerAtMeta));
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
    if (data.containsKey('max_base_credits')) {
      context.handle(
          _maxBaseCreditsMeta,
          maxBaseCredits.isAcceptableOrUnknown(
              data['max_base_credits']!, _maxBaseCreditsMeta));
    } else if (isInserting) {
      context.missing(_maxBaseCreditsMeta);
    }
    if (data.containsKey('base_credits')) {
      context.handle(
          _baseCreditsMeta,
          baseCredits.isAcceptableOrUnknown(
              data['base_credits']!, _baseCreditsMeta));
    } else if (isInserting) {
      context.missing(_baseCreditsMeta);
    }
    if (data.containsKey('max_credits')) {
      context.handle(
          _maxCreditsMeta,
          maxCredits.isAcceptableOrUnknown(
              data['max_credits']!, _maxCreditsMeta));
    } else if (isInserting) {
      context.missing(_maxCreditsMeta);
    }
    if (data.containsKey('credits')) {
      context.handle(_creditsMeta,
          credits.isAcceptableOrUnknown(data['credits']!, _creditsMeta));
    }
    if (data.containsKey('extras')) {
      context.handle(_extrasMeta,
          extras.isAcceptableOrUnknown(data['extras']!, _extrasMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('last_updated_at')) {
      context.handle(
          _lastUpdatedAtMeta,
          lastUpdatedAt.isAcceptableOrUnknown(
              data['last_updated_at']!, _lastUpdatedAtMeta));
    } else if (isInserting) {
      context.missing(_lastUpdatedAtMeta);
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
          .read(DriftSqlType.bigInt, data['${effectivePrefix}id'])!,
      boxId: attachedDatabase.typeMapping
          .read(DriftSqlType.bigInt, data['${effectivePrefix}box_id'])!,
      localId: attachedDatabase.typeMapping
          .read(DriftSqlType.bigInt, data['${effectivePrefix}local_id'])!,
      microtaskId: attachedDatabase.typeMapping
          .read(DriftSqlType.bigInt, data['${effectivePrefix}microtask_id'])!,
      taskId: attachedDatabase.typeMapping
          .read(DriftSqlType.bigInt, data['${effectivePrefix}task_id'])!,
      workerId: attachedDatabase.typeMapping
          .read(DriftSqlType.bigInt, data['${effectivePrefix}worker_id'])!,
      wgroup: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}wgroup']),
      sentToServerAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}sent_to_server_at'])!,
      deadline: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}deadline']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      completedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}completed_at']),
      output: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}output']),
      outputFileId: attachedDatabase.typeMapping
          .read(DriftSqlType.bigInt, data['${effectivePrefix}output_file_id']),
      logs: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}logs']),
      submittedToBoxAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}submitted_to_box_at']),
      submittedToServerAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime,
          data['${effectivePrefix}submitted_to_server_at']),
      verifiedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}verified_at']),
      report: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}report']),
      maxBaseCredits: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}max_base_credits'])!,
      baseCredits: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}base_credits'])!,
      maxCredits: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}max_credits'])!,
      credits: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}credits']),
      extras: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}extras']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      lastUpdatedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_updated_at'])!,
    );
  }

  @override
  $MicroTaskAssignmentRecordsTable createAlias(String alias) {
    return $MicroTaskAssignmentRecordsTable(attachedDatabase, alias);
  }
}

class MicroTaskAssignmentRecord extends DataClass
    implements Insertable<MicroTaskAssignmentRecord> {
  final BigInt id;
  final BigInt boxId;
  final BigInt localId;
  final BigInt microtaskId;
  final BigInt taskId;
  final BigInt workerId;
  final String? wgroup;
  final DateTime sentToServerAt;
  final DateTime? deadline;
  final String status;
  final DateTime? completedAt;
  final String? output;
  final BigInt? outputFileId;
  final String? logs;
  final DateTime? submittedToBoxAt;
  final DateTime? submittedToServerAt;
  final DateTime? verifiedAt;
  final String? report;
  final double maxBaseCredits;
  final double baseCredits;
  final double maxCredits;
  final double? credits;
  final String? extras;
  final DateTime createdAt;
  final DateTime lastUpdatedAt;
  const MicroTaskAssignmentRecord(
      {required this.id,
      required this.boxId,
      required this.localId,
      required this.microtaskId,
      required this.taskId,
      required this.workerId,
      this.wgroup,
      required this.sentToServerAt,
      this.deadline,
      required this.status,
      this.completedAt,
      this.output,
      this.outputFileId,
      this.logs,
      this.submittedToBoxAt,
      this.submittedToServerAt,
      this.verifiedAt,
      this.report,
      required this.maxBaseCredits,
      required this.baseCredits,
      required this.maxCredits,
      this.credits,
      this.extras,
      required this.createdAt,
      required this.lastUpdatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<BigInt>(id);
    map['box_id'] = Variable<BigInt>(boxId);
    map['local_id'] = Variable<BigInt>(localId);
    map['microtask_id'] = Variable<BigInt>(microtaskId);
    map['task_id'] = Variable<BigInt>(taskId);
    map['worker_id'] = Variable<BigInt>(workerId);
    if (!nullToAbsent || wgroup != null) {
      map['wgroup'] = Variable<String>(wgroup);
    }
    map['sent_to_server_at'] = Variable<DateTime>(sentToServerAt);
    if (!nullToAbsent || deadline != null) {
      map['deadline'] = Variable<DateTime>(deadline);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    if (!nullToAbsent || output != null) {
      map['output'] = Variable<String>(output);
    }
    if (!nullToAbsent || outputFileId != null) {
      map['output_file_id'] = Variable<BigInt>(outputFileId);
    }
    if (!nullToAbsent || logs != null) {
      map['logs'] = Variable<String>(logs);
    }
    if (!nullToAbsent || submittedToBoxAt != null) {
      map['submitted_to_box_at'] = Variable<DateTime>(submittedToBoxAt);
    }
    if (!nullToAbsent || submittedToServerAt != null) {
      map['submitted_to_server_at'] = Variable<DateTime>(submittedToServerAt);
    }
    if (!nullToAbsent || verifiedAt != null) {
      map['verified_at'] = Variable<DateTime>(verifiedAt);
    }
    if (!nullToAbsent || report != null) {
      map['report'] = Variable<String>(report);
    }
    map['max_base_credits'] = Variable<double>(maxBaseCredits);
    map['base_credits'] = Variable<double>(baseCredits);
    map['max_credits'] = Variable<double>(maxCredits);
    if (!nullToAbsent || credits != null) {
      map['credits'] = Variable<double>(credits);
    }
    if (!nullToAbsent || extras != null) {
      map['extras'] = Variable<String>(extras);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['last_updated_at'] = Variable<DateTime>(lastUpdatedAt);
    return map;
  }

  MicroTaskAssignmentRecordsCompanion toCompanion(bool nullToAbsent) {
    return MicroTaskAssignmentRecordsCompanion(
      id: Value(id),
      boxId: Value(boxId),
      localId: Value(localId),
      microtaskId: Value(microtaskId),
      taskId: Value(taskId),
      workerId: Value(workerId),
      wgroup:
          wgroup == null && nullToAbsent ? const Value.absent() : Value(wgroup),
      sentToServerAt: Value(sentToServerAt),
      deadline: deadline == null && nullToAbsent
          ? const Value.absent()
          : Value(deadline),
      status: Value(status),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      output:
          output == null && nullToAbsent ? const Value.absent() : Value(output),
      outputFileId: outputFileId == null && nullToAbsent
          ? const Value.absent()
          : Value(outputFileId),
      logs: logs == null && nullToAbsent ? const Value.absent() : Value(logs),
      submittedToBoxAt: submittedToBoxAt == null && nullToAbsent
          ? const Value.absent()
          : Value(submittedToBoxAt),
      submittedToServerAt: submittedToServerAt == null && nullToAbsent
          ? const Value.absent()
          : Value(submittedToServerAt),
      verifiedAt: verifiedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(verifiedAt),
      report:
          report == null && nullToAbsent ? const Value.absent() : Value(report),
      maxBaseCredits: Value(maxBaseCredits),
      baseCredits: Value(baseCredits),
      maxCredits: Value(maxCredits),
      credits: credits == null && nullToAbsent
          ? const Value.absent()
          : Value(credits),
      extras:
          extras == null && nullToAbsent ? const Value.absent() : Value(extras),
      createdAt: Value(createdAt),
      lastUpdatedAt: Value(lastUpdatedAt),
    );
  }

  factory MicroTaskAssignmentRecord.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MicroTaskAssignmentRecord(
      id: serializer.fromJson<BigInt>(json['id']),
      boxId: serializer.fromJson<BigInt>(json['boxId']),
      localId: serializer.fromJson<BigInt>(json['localId']),
      microtaskId: serializer.fromJson<BigInt>(json['microtaskId']),
      taskId: serializer.fromJson<BigInt>(json['taskId']),
      workerId: serializer.fromJson<BigInt>(json['workerId']),
      wgroup: serializer.fromJson<String?>(json['wgroup']),
      sentToServerAt: serializer.fromJson<DateTime>(json['sentToServerAt']),
      deadline: serializer.fromJson<DateTime?>(json['deadline']),
      status: serializer.fromJson<String>(json['status']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      output: serializer.fromJson<String?>(json['output']),
      outputFileId: serializer.fromJson<BigInt?>(json['outputFileId']),
      logs: serializer.fromJson<String?>(json['logs']),
      submittedToBoxAt:
          serializer.fromJson<DateTime?>(json['submittedToBoxAt']),
      submittedToServerAt:
          serializer.fromJson<DateTime?>(json['submittedToServerAt']),
      verifiedAt: serializer.fromJson<DateTime?>(json['verifiedAt']),
      report: serializer.fromJson<String?>(json['report']),
      maxBaseCredits: serializer.fromJson<double>(json['maxBaseCredits']),
      baseCredits: serializer.fromJson<double>(json['baseCredits']),
      maxCredits: serializer.fromJson<double>(json['maxCredits']),
      credits: serializer.fromJson<double?>(json['credits']),
      extras: serializer.fromJson<String?>(json['extras']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      lastUpdatedAt: serializer.fromJson<DateTime>(json['lastUpdatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<BigInt>(id),
      'boxId': serializer.toJson<BigInt>(boxId),
      'localId': serializer.toJson<BigInt>(localId),
      'microtaskId': serializer.toJson<BigInt>(microtaskId),
      'taskId': serializer.toJson<BigInt>(taskId),
      'workerId': serializer.toJson<BigInt>(workerId),
      'wgroup': serializer.toJson<String?>(wgroup),
      'sentToServerAt': serializer.toJson<DateTime>(sentToServerAt),
      'deadline': serializer.toJson<DateTime?>(deadline),
      'status': serializer.toJson<String>(status),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'output': serializer.toJson<String?>(output),
      'outputFileId': serializer.toJson<BigInt?>(outputFileId),
      'logs': serializer.toJson<String?>(logs),
      'submittedToBoxAt': serializer.toJson<DateTime?>(submittedToBoxAt),
      'submittedToServerAt': serializer.toJson<DateTime?>(submittedToServerAt),
      'verifiedAt': serializer.toJson<DateTime?>(verifiedAt),
      'report': serializer.toJson<String?>(report),
      'maxBaseCredits': serializer.toJson<double>(maxBaseCredits),
      'baseCredits': serializer.toJson<double>(baseCredits),
      'maxCredits': serializer.toJson<double>(maxCredits),
      'credits': serializer.toJson<double?>(credits),
      'extras': serializer.toJson<String?>(extras),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'lastUpdatedAt': serializer.toJson<DateTime>(lastUpdatedAt),
    };
  }

  MicroTaskAssignmentRecord copyWith(
          {BigInt? id,
          BigInt? boxId,
          BigInt? localId,
          BigInt? microtaskId,
          BigInt? taskId,
          BigInt? workerId,
          Value<String?> wgroup = const Value.absent(),
          DateTime? sentToServerAt,
          Value<DateTime?> deadline = const Value.absent(),
          String? status,
          Value<DateTime?> completedAt = const Value.absent(),
          Value<String?> output = const Value.absent(),
          Value<BigInt?> outputFileId = const Value.absent(),
          Value<String?> logs = const Value.absent(),
          Value<DateTime?> submittedToBoxAt = const Value.absent(),
          Value<DateTime?> submittedToServerAt = const Value.absent(),
          Value<DateTime?> verifiedAt = const Value.absent(),
          Value<String?> report = const Value.absent(),
          double? maxBaseCredits,
          double? baseCredits,
          double? maxCredits,
          Value<double?> credits = const Value.absent(),
          Value<String?> extras = const Value.absent(),
          DateTime? createdAt,
          DateTime? lastUpdatedAt}) =>
      MicroTaskAssignmentRecord(
        id: id ?? this.id,
        boxId: boxId ?? this.boxId,
        localId: localId ?? this.localId,
        microtaskId: microtaskId ?? this.microtaskId,
        taskId: taskId ?? this.taskId,
        workerId: workerId ?? this.workerId,
        wgroup: wgroup.present ? wgroup.value : this.wgroup,
        sentToServerAt: sentToServerAt ?? this.sentToServerAt,
        deadline: deadline.present ? deadline.value : this.deadline,
        status: status ?? this.status,
        completedAt: completedAt.present ? completedAt.value : this.completedAt,
        output: output.present ? output.value : this.output,
        outputFileId:
            outputFileId.present ? outputFileId.value : this.outputFileId,
        logs: logs.present ? logs.value : this.logs,
        submittedToBoxAt: submittedToBoxAt.present
            ? submittedToBoxAt.value
            : this.submittedToBoxAt,
        submittedToServerAt: submittedToServerAt.present
            ? submittedToServerAt.value
            : this.submittedToServerAt,
        verifiedAt: verifiedAt.present ? verifiedAt.value : this.verifiedAt,
        report: report.present ? report.value : this.report,
        maxBaseCredits: maxBaseCredits ?? this.maxBaseCredits,
        baseCredits: baseCredits ?? this.baseCredits,
        maxCredits: maxCredits ?? this.maxCredits,
        credits: credits.present ? credits.value : this.credits,
        extras: extras.present ? extras.value : this.extras,
        createdAt: createdAt ?? this.createdAt,
        lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
      );
  MicroTaskAssignmentRecord copyWithCompanion(
      MicroTaskAssignmentRecordsCompanion data) {
    return MicroTaskAssignmentRecord(
      id: data.id.present ? data.id.value : this.id,
      boxId: data.boxId.present ? data.boxId.value : this.boxId,
      localId: data.localId.present ? data.localId.value : this.localId,
      microtaskId:
          data.microtaskId.present ? data.microtaskId.value : this.microtaskId,
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
      workerId: data.workerId.present ? data.workerId.value : this.workerId,
      wgroup: data.wgroup.present ? data.wgroup.value : this.wgroup,
      sentToServerAt: data.sentToServerAt.present
          ? data.sentToServerAt.value
          : this.sentToServerAt,
      deadline: data.deadline.present ? data.deadline.value : this.deadline,
      status: data.status.present ? data.status.value : this.status,
      completedAt:
          data.completedAt.present ? data.completedAt.value : this.completedAt,
      output: data.output.present ? data.output.value : this.output,
      outputFileId: data.outputFileId.present
          ? data.outputFileId.value
          : this.outputFileId,
      logs: data.logs.present ? data.logs.value : this.logs,
      submittedToBoxAt: data.submittedToBoxAt.present
          ? data.submittedToBoxAt.value
          : this.submittedToBoxAt,
      submittedToServerAt: data.submittedToServerAt.present
          ? data.submittedToServerAt.value
          : this.submittedToServerAt,
      verifiedAt:
          data.verifiedAt.present ? data.verifiedAt.value : this.verifiedAt,
      report: data.report.present ? data.report.value : this.report,
      maxBaseCredits: data.maxBaseCredits.present
          ? data.maxBaseCredits.value
          : this.maxBaseCredits,
      baseCredits:
          data.baseCredits.present ? data.baseCredits.value : this.baseCredits,
      maxCredits:
          data.maxCredits.present ? data.maxCredits.value : this.maxCredits,
      credits: data.credits.present ? data.credits.value : this.credits,
      extras: data.extras.present ? data.extras.value : this.extras,
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
          ..write('boxId: $boxId, ')
          ..write('localId: $localId, ')
          ..write('microtaskId: $microtaskId, ')
          ..write('taskId: $taskId, ')
          ..write('workerId: $workerId, ')
          ..write('wgroup: $wgroup, ')
          ..write('sentToServerAt: $sentToServerAt, ')
          ..write('deadline: $deadline, ')
          ..write('status: $status, ')
          ..write('completedAt: $completedAt, ')
          ..write('output: $output, ')
          ..write('outputFileId: $outputFileId, ')
          ..write('logs: $logs, ')
          ..write('submittedToBoxAt: $submittedToBoxAt, ')
          ..write('submittedToServerAt: $submittedToServerAt, ')
          ..write('verifiedAt: $verifiedAt, ')
          ..write('report: $report, ')
          ..write('maxBaseCredits: $maxBaseCredits, ')
          ..write('baseCredits: $baseCredits, ')
          ..write('maxCredits: $maxCredits, ')
          ..write('credits: $credits, ')
          ..write('extras: $extras, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastUpdatedAt: $lastUpdatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        id,
        boxId,
        localId,
        microtaskId,
        taskId,
        workerId,
        wgroup,
        sentToServerAt,
        deadline,
        status,
        completedAt,
        output,
        outputFileId,
        logs,
        submittedToBoxAt,
        submittedToServerAt,
        verifiedAt,
        report,
        maxBaseCredits,
        baseCredits,
        maxCredits,
        credits,
        extras,
        createdAt,
        lastUpdatedAt
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MicroTaskAssignmentRecord &&
          other.id == this.id &&
          other.boxId == this.boxId &&
          other.localId == this.localId &&
          other.microtaskId == this.microtaskId &&
          other.taskId == this.taskId &&
          other.workerId == this.workerId &&
          other.wgroup == this.wgroup &&
          other.sentToServerAt == this.sentToServerAt &&
          other.deadline == this.deadline &&
          other.status == this.status &&
          other.completedAt == this.completedAt &&
          other.output == this.output &&
          other.outputFileId == this.outputFileId &&
          other.logs == this.logs &&
          other.submittedToBoxAt == this.submittedToBoxAt &&
          other.submittedToServerAt == this.submittedToServerAt &&
          other.verifiedAt == this.verifiedAt &&
          other.report == this.report &&
          other.maxBaseCredits == this.maxBaseCredits &&
          other.baseCredits == this.baseCredits &&
          other.maxCredits == this.maxCredits &&
          other.credits == this.credits &&
          other.extras == this.extras &&
          other.createdAt == this.createdAt &&
          other.lastUpdatedAt == this.lastUpdatedAt);
}

class MicroTaskAssignmentRecordsCompanion
    extends UpdateCompanion<MicroTaskAssignmentRecord> {
  final Value<BigInt> id;
  final Value<BigInt> boxId;
  final Value<BigInt> localId;
  final Value<BigInt> microtaskId;
  final Value<BigInt> taskId;
  final Value<BigInt> workerId;
  final Value<String?> wgroup;
  final Value<DateTime> sentToServerAt;
  final Value<DateTime?> deadline;
  final Value<String> status;
  final Value<DateTime?> completedAt;
  final Value<String?> output;
  final Value<BigInt?> outputFileId;
  final Value<String?> logs;
  final Value<DateTime?> submittedToBoxAt;
  final Value<DateTime?> submittedToServerAt;
  final Value<DateTime?> verifiedAt;
  final Value<String?> report;
  final Value<double> maxBaseCredits;
  final Value<double> baseCredits;
  final Value<double> maxCredits;
  final Value<double?> credits;
  final Value<String?> extras;
  final Value<DateTime> createdAt;
  final Value<DateTime> lastUpdatedAt;
  const MicroTaskAssignmentRecordsCompanion({
    this.id = const Value.absent(),
    this.boxId = const Value.absent(),
    this.localId = const Value.absent(),
    this.microtaskId = const Value.absent(),
    this.taskId = const Value.absent(),
    this.workerId = const Value.absent(),
    this.wgroup = const Value.absent(),
    this.sentToServerAt = const Value.absent(),
    this.deadline = const Value.absent(),
    this.status = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.output = const Value.absent(),
    this.outputFileId = const Value.absent(),
    this.logs = const Value.absent(),
    this.submittedToBoxAt = const Value.absent(),
    this.submittedToServerAt = const Value.absent(),
    this.verifiedAt = const Value.absent(),
    this.report = const Value.absent(),
    this.maxBaseCredits = const Value.absent(),
    this.baseCredits = const Value.absent(),
    this.maxCredits = const Value.absent(),
    this.credits = const Value.absent(),
    this.extras = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.lastUpdatedAt = const Value.absent(),
  });
  MicroTaskAssignmentRecordsCompanion.insert({
    this.id = const Value.absent(),
    required BigInt boxId,
    required BigInt localId,
    required BigInt microtaskId,
    required BigInt taskId,
    required BigInt workerId,
    this.wgroup = const Value.absent(),
    required DateTime sentToServerAt,
    this.deadline = const Value.absent(),
    required String status,
    this.completedAt = const Value.absent(),
    this.output = const Value.absent(),
    this.outputFileId = const Value.absent(),
    this.logs = const Value.absent(),
    this.submittedToBoxAt = const Value.absent(),
    this.submittedToServerAt = const Value.absent(),
    this.verifiedAt = const Value.absent(),
    this.report = const Value.absent(),
    required double maxBaseCredits,
    required double baseCredits,
    required double maxCredits,
    this.credits = const Value.absent(),
    this.extras = const Value.absent(),
    required DateTime createdAt,
    required DateTime lastUpdatedAt,
  })  : boxId = Value(boxId),
        localId = Value(localId),
        microtaskId = Value(microtaskId),
        taskId = Value(taskId),
        workerId = Value(workerId),
        sentToServerAt = Value(sentToServerAt),
        status = Value(status),
        maxBaseCredits = Value(maxBaseCredits),
        baseCredits = Value(baseCredits),
        maxCredits = Value(maxCredits),
        createdAt = Value(createdAt),
        lastUpdatedAt = Value(lastUpdatedAt);
  static Insertable<MicroTaskAssignmentRecord> custom({
    Expression<BigInt>? id,
    Expression<BigInt>? boxId,
    Expression<BigInt>? localId,
    Expression<BigInt>? microtaskId,
    Expression<BigInt>? taskId,
    Expression<BigInt>? workerId,
    Expression<String>? wgroup,
    Expression<DateTime>? sentToServerAt,
    Expression<DateTime>? deadline,
    Expression<String>? status,
    Expression<DateTime>? completedAt,
    Expression<String>? output,
    Expression<BigInt>? outputFileId,
    Expression<String>? logs,
    Expression<DateTime>? submittedToBoxAt,
    Expression<DateTime>? submittedToServerAt,
    Expression<DateTime>? verifiedAt,
    Expression<String>? report,
    Expression<double>? maxBaseCredits,
    Expression<double>? baseCredits,
    Expression<double>? maxCredits,
    Expression<double>? credits,
    Expression<String>? extras,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? lastUpdatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (boxId != null) 'box_id': boxId,
      if (localId != null) 'local_id': localId,
      if (microtaskId != null) 'microtask_id': microtaskId,
      if (taskId != null) 'task_id': taskId,
      if (workerId != null) 'worker_id': workerId,
      if (wgroup != null) 'wgroup': wgroup,
      if (sentToServerAt != null) 'sent_to_server_at': sentToServerAt,
      if (deadline != null) 'deadline': deadline,
      if (status != null) 'status': status,
      if (completedAt != null) 'completed_at': completedAt,
      if (output != null) 'output': output,
      if (outputFileId != null) 'output_file_id': outputFileId,
      if (logs != null) 'logs': logs,
      if (submittedToBoxAt != null) 'submitted_to_box_at': submittedToBoxAt,
      if (submittedToServerAt != null)
        'submitted_to_server_at': submittedToServerAt,
      if (verifiedAt != null) 'verified_at': verifiedAt,
      if (report != null) 'report': report,
      if (maxBaseCredits != null) 'max_base_credits': maxBaseCredits,
      if (baseCredits != null) 'base_credits': baseCredits,
      if (maxCredits != null) 'max_credits': maxCredits,
      if (credits != null) 'credits': credits,
      if (extras != null) 'extras': extras,
      if (createdAt != null) 'created_at': createdAt,
      if (lastUpdatedAt != null) 'last_updated_at': lastUpdatedAt,
    });
  }

  MicroTaskAssignmentRecordsCompanion copyWith(
      {Value<BigInt>? id,
      Value<BigInt>? boxId,
      Value<BigInt>? localId,
      Value<BigInt>? microtaskId,
      Value<BigInt>? taskId,
      Value<BigInt>? workerId,
      Value<String?>? wgroup,
      Value<DateTime>? sentToServerAt,
      Value<DateTime?>? deadline,
      Value<String>? status,
      Value<DateTime?>? completedAt,
      Value<String?>? output,
      Value<BigInt?>? outputFileId,
      Value<String?>? logs,
      Value<DateTime?>? submittedToBoxAt,
      Value<DateTime?>? submittedToServerAt,
      Value<DateTime?>? verifiedAt,
      Value<String?>? report,
      Value<double>? maxBaseCredits,
      Value<double>? baseCredits,
      Value<double>? maxCredits,
      Value<double?>? credits,
      Value<String?>? extras,
      Value<DateTime>? createdAt,
      Value<DateTime>? lastUpdatedAt}) {
    return MicroTaskAssignmentRecordsCompanion(
      id: id ?? this.id,
      boxId: boxId ?? this.boxId,
      localId: localId ?? this.localId,
      microtaskId: microtaskId ?? this.microtaskId,
      taskId: taskId ?? this.taskId,
      workerId: workerId ?? this.workerId,
      wgroup: wgroup ?? this.wgroup,
      sentToServerAt: sentToServerAt ?? this.sentToServerAt,
      deadline: deadline ?? this.deadline,
      status: status ?? this.status,
      completedAt: completedAt ?? this.completedAt,
      output: output ?? this.output,
      outputFileId: outputFileId ?? this.outputFileId,
      logs: logs ?? this.logs,
      submittedToBoxAt: submittedToBoxAt ?? this.submittedToBoxAt,
      submittedToServerAt: submittedToServerAt ?? this.submittedToServerAt,
      verifiedAt: verifiedAt ?? this.verifiedAt,
      report: report ?? this.report,
      maxBaseCredits: maxBaseCredits ?? this.maxBaseCredits,
      baseCredits: baseCredits ?? this.baseCredits,
      maxCredits: maxCredits ?? this.maxCredits,
      credits: credits ?? this.credits,
      extras: extras ?? this.extras,
      createdAt: createdAt ?? this.createdAt,
      lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<BigInt>(id.value);
    }
    if (boxId.present) {
      map['box_id'] = Variable<BigInt>(boxId.value);
    }
    if (localId.present) {
      map['local_id'] = Variable<BigInt>(localId.value);
    }
    if (microtaskId.present) {
      map['microtask_id'] = Variable<BigInt>(microtaskId.value);
    }
    if (taskId.present) {
      map['task_id'] = Variable<BigInt>(taskId.value);
    }
    if (workerId.present) {
      map['worker_id'] = Variable<BigInt>(workerId.value);
    }
    if (wgroup.present) {
      map['wgroup'] = Variable<String>(wgroup.value);
    }
    if (sentToServerAt.present) {
      map['sent_to_server_at'] = Variable<DateTime>(sentToServerAt.value);
    }
    if (deadline.present) {
      map['deadline'] = Variable<DateTime>(deadline.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (output.present) {
      map['output'] = Variable<String>(output.value);
    }
    if (outputFileId.present) {
      map['output_file_id'] = Variable<BigInt>(outputFileId.value);
    }
    if (logs.present) {
      map['logs'] = Variable<String>(logs.value);
    }
    if (submittedToBoxAt.present) {
      map['submitted_to_box_at'] = Variable<DateTime>(submittedToBoxAt.value);
    }
    if (submittedToServerAt.present) {
      map['submitted_to_server_at'] =
          Variable<DateTime>(submittedToServerAt.value);
    }
    if (verifiedAt.present) {
      map['verified_at'] = Variable<DateTime>(verifiedAt.value);
    }
    if (report.present) {
      map['report'] = Variable<String>(report.value);
    }
    if (maxBaseCredits.present) {
      map['max_base_credits'] = Variable<double>(maxBaseCredits.value);
    }
    if (baseCredits.present) {
      map['base_credits'] = Variable<double>(baseCredits.value);
    }
    if (maxCredits.present) {
      map['max_credits'] = Variable<double>(maxCredits.value);
    }
    if (credits.present) {
      map['credits'] = Variable<double>(credits.value);
    }
    if (extras.present) {
      map['extras'] = Variable<String>(extras.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (lastUpdatedAt.present) {
      map['last_updated_at'] = Variable<DateTime>(lastUpdatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MicroTaskAssignmentRecordsCompanion(')
          ..write('id: $id, ')
          ..write('boxId: $boxId, ')
          ..write('localId: $localId, ')
          ..write('microtaskId: $microtaskId, ')
          ..write('taskId: $taskId, ')
          ..write('workerId: $workerId, ')
          ..write('wgroup: $wgroup, ')
          ..write('sentToServerAt: $sentToServerAt, ')
          ..write('deadline: $deadline, ')
          ..write('status: $status, ')
          ..write('completedAt: $completedAt, ')
          ..write('output: $output, ')
          ..write('outputFileId: $outputFileId, ')
          ..write('logs: $logs, ')
          ..write('submittedToBoxAt: $submittedToBoxAt, ')
          ..write('submittedToServerAt: $submittedToServerAt, ')
          ..write('verifiedAt: $verifiedAt, ')
          ..write('report: $report, ')
          ..write('maxBaseCredits: $maxBaseCredits, ')
          ..write('baseCredits: $baseCredits, ')
          ..write('maxCredits: $maxCredits, ')
          ..write('credits: $credits, ')
          ..write('extras: $extras, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastUpdatedAt: $lastUpdatedAt')
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
  Value<BigInt> id,
  required BigInt workProviderId,
  required String scenarioName,
  required String name,
  required String description,
  required String displayName,
  required String policy,
  required String params,
  required String itags,
  required String otags,
  Value<String?> wgroup,
  Value<DateTime?> deadline,
  required String assignmentGranularity,
  required String groupAssignmentOrder,
  required String microtaskAssignmentOrder,
  Value<int?> assignmentBatchSize,
  required String status,
  Value<String?> extras,
  required DateTime createdAt,
  required DateTime lastUpdatedAt,
});
typedef $$TaskRecordsTableUpdateCompanionBuilder = TaskRecordsCompanion
    Function({
  Value<BigInt> id,
  Value<BigInt> workProviderId,
  Value<String> scenarioName,
  Value<String> name,
  Value<String> description,
  Value<String> displayName,
  Value<String> policy,
  Value<String> params,
  Value<String> itags,
  Value<String> otags,
  Value<String?> wgroup,
  Value<DateTime?> deadline,
  Value<String> assignmentGranularity,
  Value<String> groupAssignmentOrder,
  Value<String> microtaskAssignmentOrder,
  Value<int?> assignmentBatchSize,
  Value<String> status,
  Value<String?> extras,
  Value<DateTime> createdAt,
  Value<DateTime> lastUpdatedAt,
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
  ColumnFilters<BigInt> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<BigInt> get workProviderId => $composableBuilder(
      column: $table.workProviderId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get scenarioName => $composableBuilder(
      column: $table.scenarioName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get displayName => $composableBuilder(
      column: $table.displayName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get policy => $composableBuilder(
      column: $table.policy, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get params => $composableBuilder(
      column: $table.params, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get itags => $composableBuilder(
      column: $table.itags, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get otags => $composableBuilder(
      column: $table.otags, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get wgroup => $composableBuilder(
      column: $table.wgroup, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get deadline => $composableBuilder(
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

  ColumnFilters<int> get assignmentBatchSize => $composableBuilder(
      column: $table.assignmentBatchSize,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get extras => $composableBuilder(
      column: $table.extras, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastUpdatedAt => $composableBuilder(
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
  ColumnOrderings<BigInt> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<BigInt> get workProviderId => $composableBuilder(
      column: $table.workProviderId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get scenarioName => $composableBuilder(
      column: $table.scenarioName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get displayName => $composableBuilder(
      column: $table.displayName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get policy => $composableBuilder(
      column: $table.policy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get params => $composableBuilder(
      column: $table.params, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get itags => $composableBuilder(
      column: $table.itags, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get otags => $composableBuilder(
      column: $table.otags, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get wgroup => $composableBuilder(
      column: $table.wgroup, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get deadline => $composableBuilder(
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

  ColumnOrderings<int> get assignmentBatchSize => $composableBuilder(
      column: $table.assignmentBatchSize,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get extras => $composableBuilder(
      column: $table.extras, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastUpdatedAt => $composableBuilder(
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
  GeneratedColumn<BigInt> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<BigInt> get workProviderId => $composableBuilder(
      column: $table.workProviderId, builder: (column) => column);

  GeneratedColumn<String> get scenarioName => $composableBuilder(
      column: $table.scenarioName, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
      column: $table.displayName, builder: (column) => column);

  GeneratedColumn<String> get policy =>
      $composableBuilder(column: $table.policy, builder: (column) => column);

  GeneratedColumn<String> get params =>
      $composableBuilder(column: $table.params, builder: (column) => column);

  GeneratedColumn<String> get itags =>
      $composableBuilder(column: $table.itags, builder: (column) => column);

  GeneratedColumn<String> get otags =>
      $composableBuilder(column: $table.otags, builder: (column) => column);

  GeneratedColumn<String> get wgroup =>
      $composableBuilder(column: $table.wgroup, builder: (column) => column);

  GeneratedColumn<DateTime> get deadline =>
      $composableBuilder(column: $table.deadline, builder: (column) => column);

  GeneratedColumn<String> get assignmentGranularity => $composableBuilder(
      column: $table.assignmentGranularity, builder: (column) => column);

  GeneratedColumn<String> get groupAssignmentOrder => $composableBuilder(
      column: $table.groupAssignmentOrder, builder: (column) => column);

  GeneratedColumn<String> get microtaskAssignmentOrder => $composableBuilder(
      column: $table.microtaskAssignmentOrder, builder: (column) => column);

  GeneratedColumn<int> get assignmentBatchSize => $composableBuilder(
      column: $table.assignmentBatchSize, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get extras =>
      $composableBuilder(column: $table.extras, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastUpdatedAt => $composableBuilder(
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
            Value<BigInt> id = const Value.absent(),
            Value<BigInt> workProviderId = const Value.absent(),
            Value<String> scenarioName = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> description = const Value.absent(),
            Value<String> displayName = const Value.absent(),
            Value<String> policy = const Value.absent(),
            Value<String> params = const Value.absent(),
            Value<String> itags = const Value.absent(),
            Value<String> otags = const Value.absent(),
            Value<String?> wgroup = const Value.absent(),
            Value<DateTime?> deadline = const Value.absent(),
            Value<String> assignmentGranularity = const Value.absent(),
            Value<String> groupAssignmentOrder = const Value.absent(),
            Value<String> microtaskAssignmentOrder = const Value.absent(),
            Value<int?> assignmentBatchSize = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String?> extras = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> lastUpdatedAt = const Value.absent(),
          }) =>
              TaskRecordsCompanion(
            id: id,
            workProviderId: workProviderId,
            scenarioName: scenarioName,
            name: name,
            description: description,
            displayName: displayName,
            policy: policy,
            params: params,
            itags: itags,
            otags: otags,
            wgroup: wgroup,
            deadline: deadline,
            assignmentGranularity: assignmentGranularity,
            groupAssignmentOrder: groupAssignmentOrder,
            microtaskAssignmentOrder: microtaskAssignmentOrder,
            assignmentBatchSize: assignmentBatchSize,
            status: status,
            extras: extras,
            createdAt: createdAt,
            lastUpdatedAt: lastUpdatedAt,
          ),
          createCompanionCallback: ({
            Value<BigInt> id = const Value.absent(),
            required BigInt workProviderId,
            required String scenarioName,
            required String name,
            required String description,
            required String displayName,
            required String policy,
            required String params,
            required String itags,
            required String otags,
            Value<String?> wgroup = const Value.absent(),
            Value<DateTime?> deadline = const Value.absent(),
            required String assignmentGranularity,
            required String groupAssignmentOrder,
            required String microtaskAssignmentOrder,
            Value<int?> assignmentBatchSize = const Value.absent(),
            required String status,
            Value<String?> extras = const Value.absent(),
            required DateTime createdAt,
            required DateTime lastUpdatedAt,
          }) =>
              TaskRecordsCompanion.insert(
            id: id,
            workProviderId: workProviderId,
            scenarioName: scenarioName,
            name: name,
            description: description,
            displayName: displayName,
            policy: policy,
            params: params,
            itags: itags,
            otags: otags,
            wgroup: wgroup,
            deadline: deadline,
            assignmentGranularity: assignmentGranularity,
            groupAssignmentOrder: groupAssignmentOrder,
            microtaskAssignmentOrder: microtaskAssignmentOrder,
            assignmentBatchSize: assignmentBatchSize,
            status: status,
            extras: extras,
            createdAt: createdAt,
            lastUpdatedAt: lastUpdatedAt,
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
  Value<BigInt> id,
  required BigInt taskId,
  Value<BigInt?> groupId,
  required String input,
  Value<BigInt?> inputFileId,
  Value<DateTime?> deadline,
  required double baseCredits,
  required double credits,
  required String status,
  Value<String?> output,
  Value<String?> extras,
  required DateTime createdAt,
  required DateTime lastUpdatedAt,
});
typedef $$MicroTaskRecordsTableUpdateCompanionBuilder
    = MicroTaskRecordsCompanion Function({
  Value<BigInt> id,
  Value<BigInt> taskId,
  Value<BigInt?> groupId,
  Value<String> input,
  Value<BigInt?> inputFileId,
  Value<DateTime?> deadline,
  Value<double> baseCredits,
  Value<double> credits,
  Value<String> status,
  Value<String?> output,
  Value<String?> extras,
  Value<DateTime> createdAt,
  Value<DateTime> lastUpdatedAt,
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
  ColumnFilters<BigInt> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<BigInt> get taskId => $composableBuilder(
      column: $table.taskId, builder: (column) => ColumnFilters(column));

  ColumnFilters<BigInt> get groupId => $composableBuilder(
      column: $table.groupId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get input => $composableBuilder(
      column: $table.input, builder: (column) => ColumnFilters(column));

  ColumnFilters<BigInt> get inputFileId => $composableBuilder(
      column: $table.inputFileId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get deadline => $composableBuilder(
      column: $table.deadline, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get baseCredits => $composableBuilder(
      column: $table.baseCredits, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get credits => $composableBuilder(
      column: $table.credits, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get output => $composableBuilder(
      column: $table.output, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get extras => $composableBuilder(
      column: $table.extras, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastUpdatedAt => $composableBuilder(
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
  ColumnOrderings<BigInt> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<BigInt> get taskId => $composableBuilder(
      column: $table.taskId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<BigInt> get groupId => $composableBuilder(
      column: $table.groupId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get input => $composableBuilder(
      column: $table.input, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<BigInt> get inputFileId => $composableBuilder(
      column: $table.inputFileId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get deadline => $composableBuilder(
      column: $table.deadline, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get baseCredits => $composableBuilder(
      column: $table.baseCredits, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get credits => $composableBuilder(
      column: $table.credits, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get output => $composableBuilder(
      column: $table.output, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get extras => $composableBuilder(
      column: $table.extras, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastUpdatedAt => $composableBuilder(
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
  GeneratedColumn<BigInt> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<BigInt> get taskId =>
      $composableBuilder(column: $table.taskId, builder: (column) => column);

  GeneratedColumn<BigInt> get groupId =>
      $composableBuilder(column: $table.groupId, builder: (column) => column);

  GeneratedColumn<String> get input =>
      $composableBuilder(column: $table.input, builder: (column) => column);

  GeneratedColumn<BigInt> get inputFileId => $composableBuilder(
      column: $table.inputFileId, builder: (column) => column);

  GeneratedColumn<DateTime> get deadline =>
      $composableBuilder(column: $table.deadline, builder: (column) => column);

  GeneratedColumn<double> get baseCredits => $composableBuilder(
      column: $table.baseCredits, builder: (column) => column);

  GeneratedColumn<double> get credits =>
      $composableBuilder(column: $table.credits, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get output =>
      $composableBuilder(column: $table.output, builder: (column) => column);

  GeneratedColumn<String> get extras =>
      $composableBuilder(column: $table.extras, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastUpdatedAt => $composableBuilder(
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
            Value<BigInt> id = const Value.absent(),
            Value<BigInt> taskId = const Value.absent(),
            Value<BigInt?> groupId = const Value.absent(),
            Value<String> input = const Value.absent(),
            Value<BigInt?> inputFileId = const Value.absent(),
            Value<DateTime?> deadline = const Value.absent(),
            Value<double> baseCredits = const Value.absent(),
            Value<double> credits = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String?> output = const Value.absent(),
            Value<String?> extras = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> lastUpdatedAt = const Value.absent(),
          }) =>
              MicroTaskRecordsCompanion(
            id: id,
            taskId: taskId,
            groupId: groupId,
            input: input,
            inputFileId: inputFileId,
            deadline: deadline,
            baseCredits: baseCredits,
            credits: credits,
            status: status,
            output: output,
            extras: extras,
            createdAt: createdAt,
            lastUpdatedAt: lastUpdatedAt,
          ),
          createCompanionCallback: ({
            Value<BigInt> id = const Value.absent(),
            required BigInt taskId,
            Value<BigInt?> groupId = const Value.absent(),
            required String input,
            Value<BigInt?> inputFileId = const Value.absent(),
            Value<DateTime?> deadline = const Value.absent(),
            required double baseCredits,
            required double credits,
            required String status,
            Value<String?> output = const Value.absent(),
            Value<String?> extras = const Value.absent(),
            required DateTime createdAt,
            required DateTime lastUpdatedAt,
          }) =>
              MicroTaskRecordsCompanion.insert(
            id: id,
            taskId: taskId,
            groupId: groupId,
            input: input,
            inputFileId: inputFileId,
            deadline: deadline,
            baseCredits: baseCredits,
            credits: credits,
            status: status,
            output: output,
            extras: extras,
            createdAt: createdAt,
            lastUpdatedAt: lastUpdatedAt,
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
  Value<BigInt> id,
  required BigInt boxId,
  required BigInt localId,
  required BigInt microtaskId,
  required BigInt taskId,
  required BigInt workerId,
  Value<String?> wgroup,
  required DateTime sentToServerAt,
  Value<DateTime?> deadline,
  required String status,
  Value<DateTime?> completedAt,
  Value<String?> output,
  Value<BigInt?> outputFileId,
  Value<String?> logs,
  Value<DateTime?> submittedToBoxAt,
  Value<DateTime?> submittedToServerAt,
  Value<DateTime?> verifiedAt,
  Value<String?> report,
  required double maxBaseCredits,
  required double baseCredits,
  required double maxCredits,
  Value<double?> credits,
  Value<String?> extras,
  required DateTime createdAt,
  required DateTime lastUpdatedAt,
});
typedef $$MicroTaskAssignmentRecordsTableUpdateCompanionBuilder
    = MicroTaskAssignmentRecordsCompanion Function({
  Value<BigInt> id,
  Value<BigInt> boxId,
  Value<BigInt> localId,
  Value<BigInt> microtaskId,
  Value<BigInt> taskId,
  Value<BigInt> workerId,
  Value<String?> wgroup,
  Value<DateTime> sentToServerAt,
  Value<DateTime?> deadline,
  Value<String> status,
  Value<DateTime?> completedAt,
  Value<String?> output,
  Value<BigInt?> outputFileId,
  Value<String?> logs,
  Value<DateTime?> submittedToBoxAt,
  Value<DateTime?> submittedToServerAt,
  Value<DateTime?> verifiedAt,
  Value<String?> report,
  Value<double> maxBaseCredits,
  Value<double> baseCredits,
  Value<double> maxCredits,
  Value<double?> credits,
  Value<String?> extras,
  Value<DateTime> createdAt,
  Value<DateTime> lastUpdatedAt,
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
  ColumnFilters<BigInt> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<BigInt> get boxId => $composableBuilder(
      column: $table.boxId, builder: (column) => ColumnFilters(column));

  ColumnFilters<BigInt> get localId => $composableBuilder(
      column: $table.localId, builder: (column) => ColumnFilters(column));

  ColumnFilters<BigInt> get microtaskId => $composableBuilder(
      column: $table.microtaskId, builder: (column) => ColumnFilters(column));

  ColumnFilters<BigInt> get taskId => $composableBuilder(
      column: $table.taskId, builder: (column) => ColumnFilters(column));

  ColumnFilters<BigInt> get workerId => $composableBuilder(
      column: $table.workerId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get wgroup => $composableBuilder(
      column: $table.wgroup, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get sentToServerAt => $composableBuilder(
      column: $table.sentToServerAt,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get deadline => $composableBuilder(
      column: $table.deadline, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get output => $composableBuilder(
      column: $table.output, builder: (column) => ColumnFilters(column));

  ColumnFilters<BigInt> get outputFileId => $composableBuilder(
      column: $table.outputFileId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get logs => $composableBuilder(
      column: $table.logs, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get submittedToBoxAt => $composableBuilder(
      column: $table.submittedToBoxAt,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get submittedToServerAt => $composableBuilder(
      column: $table.submittedToServerAt,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get verifiedAt => $composableBuilder(
      column: $table.verifiedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get report => $composableBuilder(
      column: $table.report, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get maxBaseCredits => $composableBuilder(
      column: $table.maxBaseCredits,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get baseCredits => $composableBuilder(
      column: $table.baseCredits, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get maxCredits => $composableBuilder(
      column: $table.maxCredits, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get credits => $composableBuilder(
      column: $table.credits, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get extras => $composableBuilder(
      column: $table.extras, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastUpdatedAt => $composableBuilder(
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
  ColumnOrderings<BigInt> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<BigInt> get boxId => $composableBuilder(
      column: $table.boxId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<BigInt> get localId => $composableBuilder(
      column: $table.localId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<BigInt> get microtaskId => $composableBuilder(
      column: $table.microtaskId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<BigInt> get taskId => $composableBuilder(
      column: $table.taskId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<BigInt> get workerId => $composableBuilder(
      column: $table.workerId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get wgroup => $composableBuilder(
      column: $table.wgroup, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get sentToServerAt => $composableBuilder(
      column: $table.sentToServerAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get deadline => $composableBuilder(
      column: $table.deadline, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get output => $composableBuilder(
      column: $table.output, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<BigInt> get outputFileId => $composableBuilder(
      column: $table.outputFileId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get logs => $composableBuilder(
      column: $table.logs, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get submittedToBoxAt => $composableBuilder(
      column: $table.submittedToBoxAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get submittedToServerAt => $composableBuilder(
      column: $table.submittedToServerAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get verifiedAt => $composableBuilder(
      column: $table.verifiedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get report => $composableBuilder(
      column: $table.report, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get maxBaseCredits => $composableBuilder(
      column: $table.maxBaseCredits,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get baseCredits => $composableBuilder(
      column: $table.baseCredits, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get maxCredits => $composableBuilder(
      column: $table.maxCredits, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get credits => $composableBuilder(
      column: $table.credits, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get extras => $composableBuilder(
      column: $table.extras, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastUpdatedAt => $composableBuilder(
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
  GeneratedColumn<BigInt> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<BigInt> get boxId =>
      $composableBuilder(column: $table.boxId, builder: (column) => column);

  GeneratedColumn<BigInt> get localId =>
      $composableBuilder(column: $table.localId, builder: (column) => column);

  GeneratedColumn<BigInt> get microtaskId => $composableBuilder(
      column: $table.microtaskId, builder: (column) => column);

  GeneratedColumn<BigInt> get taskId =>
      $composableBuilder(column: $table.taskId, builder: (column) => column);

  GeneratedColumn<BigInt> get workerId =>
      $composableBuilder(column: $table.workerId, builder: (column) => column);

  GeneratedColumn<String> get wgroup =>
      $composableBuilder(column: $table.wgroup, builder: (column) => column);

  GeneratedColumn<DateTime> get sentToServerAt => $composableBuilder(
      column: $table.sentToServerAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deadline =>
      $composableBuilder(column: $table.deadline, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => column);

  GeneratedColumn<String> get output =>
      $composableBuilder(column: $table.output, builder: (column) => column);

  GeneratedColumn<BigInt> get outputFileId => $composableBuilder(
      column: $table.outputFileId, builder: (column) => column);

  GeneratedColumn<String> get logs =>
      $composableBuilder(column: $table.logs, builder: (column) => column);

  GeneratedColumn<DateTime> get submittedToBoxAt => $composableBuilder(
      column: $table.submittedToBoxAt, builder: (column) => column);

  GeneratedColumn<DateTime> get submittedToServerAt => $composableBuilder(
      column: $table.submittedToServerAt, builder: (column) => column);

  GeneratedColumn<DateTime> get verifiedAt => $composableBuilder(
      column: $table.verifiedAt, builder: (column) => column);

  GeneratedColumn<String> get report =>
      $composableBuilder(column: $table.report, builder: (column) => column);

  GeneratedColumn<double> get maxBaseCredits => $composableBuilder(
      column: $table.maxBaseCredits, builder: (column) => column);

  GeneratedColumn<double> get baseCredits => $composableBuilder(
      column: $table.baseCredits, builder: (column) => column);

  GeneratedColumn<double> get maxCredits => $composableBuilder(
      column: $table.maxCredits, builder: (column) => column);

  GeneratedColumn<double> get credits =>
      $composableBuilder(column: $table.credits, builder: (column) => column);

  GeneratedColumn<String> get extras =>
      $composableBuilder(column: $table.extras, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastUpdatedAt => $composableBuilder(
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
            Value<BigInt> id = const Value.absent(),
            Value<BigInt> boxId = const Value.absent(),
            Value<BigInt> localId = const Value.absent(),
            Value<BigInt> microtaskId = const Value.absent(),
            Value<BigInt> taskId = const Value.absent(),
            Value<BigInt> workerId = const Value.absent(),
            Value<String?> wgroup = const Value.absent(),
            Value<DateTime> sentToServerAt = const Value.absent(),
            Value<DateTime?> deadline = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<DateTime?> completedAt = const Value.absent(),
            Value<String?> output = const Value.absent(),
            Value<BigInt?> outputFileId = const Value.absent(),
            Value<String?> logs = const Value.absent(),
            Value<DateTime?> submittedToBoxAt = const Value.absent(),
            Value<DateTime?> submittedToServerAt = const Value.absent(),
            Value<DateTime?> verifiedAt = const Value.absent(),
            Value<String?> report = const Value.absent(),
            Value<double> maxBaseCredits = const Value.absent(),
            Value<double> baseCredits = const Value.absent(),
            Value<double> maxCredits = const Value.absent(),
            Value<double?> credits = const Value.absent(),
            Value<String?> extras = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> lastUpdatedAt = const Value.absent(),
          }) =>
              MicroTaskAssignmentRecordsCompanion(
            id: id,
            boxId: boxId,
            localId: localId,
            microtaskId: microtaskId,
            taskId: taskId,
            workerId: workerId,
            wgroup: wgroup,
            sentToServerAt: sentToServerAt,
            deadline: deadline,
            status: status,
            completedAt: completedAt,
            output: output,
            outputFileId: outputFileId,
            logs: logs,
            submittedToBoxAt: submittedToBoxAt,
            submittedToServerAt: submittedToServerAt,
            verifiedAt: verifiedAt,
            report: report,
            maxBaseCredits: maxBaseCredits,
            baseCredits: baseCredits,
            maxCredits: maxCredits,
            credits: credits,
            extras: extras,
            createdAt: createdAt,
            lastUpdatedAt: lastUpdatedAt,
          ),
          createCompanionCallback: ({
            Value<BigInt> id = const Value.absent(),
            required BigInt boxId,
            required BigInt localId,
            required BigInt microtaskId,
            required BigInt taskId,
            required BigInt workerId,
            Value<String?> wgroup = const Value.absent(),
            required DateTime sentToServerAt,
            Value<DateTime?> deadline = const Value.absent(),
            required String status,
            Value<DateTime?> completedAt = const Value.absent(),
            Value<String?> output = const Value.absent(),
            Value<BigInt?> outputFileId = const Value.absent(),
            Value<String?> logs = const Value.absent(),
            Value<DateTime?> submittedToBoxAt = const Value.absent(),
            Value<DateTime?> submittedToServerAt = const Value.absent(),
            Value<DateTime?> verifiedAt = const Value.absent(),
            Value<String?> report = const Value.absent(),
            required double maxBaseCredits,
            required double baseCredits,
            required double maxCredits,
            Value<double?> credits = const Value.absent(),
            Value<String?> extras = const Value.absent(),
            required DateTime createdAt,
            required DateTime lastUpdatedAt,
          }) =>
              MicroTaskAssignmentRecordsCompanion.insert(
            id: id,
            boxId: boxId,
            localId: localId,
            microtaskId: microtaskId,
            taskId: taskId,
            workerId: workerId,
            wgroup: wgroup,
            sentToServerAt: sentToServerAt,
            deadline: deadline,
            status: status,
            completedAt: completedAt,
            output: output,
            outputFileId: outputFileId,
            logs: logs,
            submittedToBoxAt: submittedToBoxAt,
            submittedToServerAt: submittedToServerAt,
            verifiedAt: verifiedAt,
            report: report,
            maxBaseCredits: maxBaseCredits,
            baseCredits: baseCredits,
            maxCredits: maxCredits,
            credits: credits,
            extras: extras,
            createdAt: createdAt,
            lastUpdatedAt: lastUpdatedAt,
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
