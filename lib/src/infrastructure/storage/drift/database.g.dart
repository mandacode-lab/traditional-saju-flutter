// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $UserInfoTableTable extends UserInfoTable
    with TableInfo<$UserInfoTableTable, UserInfoTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserInfoTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _genderMeta = const VerificationMeta('gender');
  @override
  late final GeneratedColumn<String> gender = GeneratedColumn<String>(
    'gender',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _jobStatusMeta = const VerificationMeta(
    'jobStatus',
  );
  @override
  late final GeneratedColumn<String> jobStatus = GeneratedColumn<String>(
    'job_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _datingStatusMeta = const VerificationMeta(
    'datingStatus',
  );
  @override
  late final GeneratedColumn<String> datingStatus = GeneratedColumn<String>(
    'dating_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _birthdateMeta = const VerificationMeta(
    'birthdate',
  );
  @override
  late final GeneratedColumn<DateTime> birthdate = GeneratedColumn<DateTime>(
    'birthdate',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _permanentMeta = const VerificationMeta(
    'permanent',
  );
  @override
  late final GeneratedColumn<bool> permanent = GeneratedColumn<bool>(
    'permanent',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("permanent" IN (0, 1))',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    gender,
    jobStatus,
    datingStatus,
    birthdate,
    permanent,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_info_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserInfoTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('gender')) {
      context.handle(
        _genderMeta,
        gender.isAcceptableOrUnknown(data['gender']!, _genderMeta),
      );
    } else if (isInserting) {
      context.missing(_genderMeta);
    }
    if (data.containsKey('job_status')) {
      context.handle(
        _jobStatusMeta,
        jobStatus.isAcceptableOrUnknown(data['job_status']!, _jobStatusMeta),
      );
    } else if (isInserting) {
      context.missing(_jobStatusMeta);
    }
    if (data.containsKey('dating_status')) {
      context.handle(
        _datingStatusMeta,
        datingStatus.isAcceptableOrUnknown(
          data['dating_status']!,
          _datingStatusMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_datingStatusMeta);
    }
    if (data.containsKey('birthdate')) {
      context.handle(
        _birthdateMeta,
        birthdate.isAcceptableOrUnknown(data['birthdate']!, _birthdateMeta),
      );
    } else if (isInserting) {
      context.missing(_birthdateMeta);
    }
    if (data.containsKey('permanent')) {
      context.handle(
        _permanentMeta,
        permanent.isAcceptableOrUnknown(data['permanent']!, _permanentMeta),
      );
    } else if (isInserting) {
      context.missing(_permanentMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  UserInfoTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserInfoTableData(
      gender: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gender'],
      )!,
      jobStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}job_status'],
      )!,
      datingStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dating_status'],
      )!,
      birthdate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}birthdate'],
      )!,
      permanent: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}permanent'],
      )!,
    );
  }

  @override
  $UserInfoTableTable createAlias(String alias) {
    return $UserInfoTableTable(attachedDatabase, alias);
  }
}

class UserInfoTableData extends DataClass
    implements Insertable<UserInfoTableData> {
  final String gender;
  final String jobStatus;
  final String datingStatus;
  final DateTime birthdate;
  final bool permanent;
  const UserInfoTableData({
    required this.gender,
    required this.jobStatus,
    required this.datingStatus,
    required this.birthdate,
    required this.permanent,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['gender'] = Variable<String>(gender);
    map['job_status'] = Variable<String>(jobStatus);
    map['dating_status'] = Variable<String>(datingStatus);
    map['birthdate'] = Variable<DateTime>(birthdate);
    map['permanent'] = Variable<bool>(permanent);
    return map;
  }

  UserInfoTableCompanion toCompanion(bool nullToAbsent) {
    return UserInfoTableCompanion(
      gender: Value(gender),
      jobStatus: Value(jobStatus),
      datingStatus: Value(datingStatus),
      birthdate: Value(birthdate),
      permanent: Value(permanent),
    );
  }

  factory UserInfoTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserInfoTableData(
      gender: serializer.fromJson<String>(json['gender']),
      jobStatus: serializer.fromJson<String>(json['jobStatus']),
      datingStatus: serializer.fromJson<String>(json['datingStatus']),
      birthdate: serializer.fromJson<DateTime>(json['birthdate']),
      permanent: serializer.fromJson<bool>(json['permanent']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'gender': serializer.toJson<String>(gender),
      'jobStatus': serializer.toJson<String>(jobStatus),
      'datingStatus': serializer.toJson<String>(datingStatus),
      'birthdate': serializer.toJson<DateTime>(birthdate),
      'permanent': serializer.toJson<bool>(permanent),
    };
  }

  UserInfoTableData copyWith({
    String? gender,
    String? jobStatus,
    String? datingStatus,
    DateTime? birthdate,
    bool? permanent,
  }) => UserInfoTableData(
    gender: gender ?? this.gender,
    jobStatus: jobStatus ?? this.jobStatus,
    datingStatus: datingStatus ?? this.datingStatus,
    birthdate: birthdate ?? this.birthdate,
    permanent: permanent ?? this.permanent,
  );
  UserInfoTableData copyWithCompanion(UserInfoTableCompanion data) {
    return UserInfoTableData(
      gender: data.gender.present ? data.gender.value : this.gender,
      jobStatus: data.jobStatus.present ? data.jobStatus.value : this.jobStatus,
      datingStatus: data.datingStatus.present
          ? data.datingStatus.value
          : this.datingStatus,
      birthdate: data.birthdate.present ? data.birthdate.value : this.birthdate,
      permanent: data.permanent.present ? data.permanent.value : this.permanent,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserInfoTableData(')
          ..write('gender: $gender, ')
          ..write('jobStatus: $jobStatus, ')
          ..write('datingStatus: $datingStatus, ')
          ..write('birthdate: $birthdate, ')
          ..write('permanent: $permanent')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(gender, jobStatus, datingStatus, birthdate, permanent);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserInfoTableData &&
          other.gender == this.gender &&
          other.jobStatus == this.jobStatus &&
          other.datingStatus == this.datingStatus &&
          other.birthdate == this.birthdate &&
          other.permanent == this.permanent);
}

class UserInfoTableCompanion extends UpdateCompanion<UserInfoTableData> {
  final Value<String> gender;
  final Value<String> jobStatus;
  final Value<String> datingStatus;
  final Value<DateTime> birthdate;
  final Value<bool> permanent;
  final Value<int> rowid;
  const UserInfoTableCompanion({
    this.gender = const Value.absent(),
    this.jobStatus = const Value.absent(),
    this.datingStatus = const Value.absent(),
    this.birthdate = const Value.absent(),
    this.permanent = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UserInfoTableCompanion.insert({
    required String gender,
    required String jobStatus,
    required String datingStatus,
    required DateTime birthdate,
    required bool permanent,
    this.rowid = const Value.absent(),
  }) : gender = Value(gender),
       jobStatus = Value(jobStatus),
       datingStatus = Value(datingStatus),
       birthdate = Value(birthdate),
       permanent = Value(permanent);
  static Insertable<UserInfoTableData> custom({
    Expression<String>? gender,
    Expression<String>? jobStatus,
    Expression<String>? datingStatus,
    Expression<DateTime>? birthdate,
    Expression<bool>? permanent,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (gender != null) 'gender': gender,
      if (jobStatus != null) 'job_status': jobStatus,
      if (datingStatus != null) 'dating_status': datingStatus,
      if (birthdate != null) 'birthdate': birthdate,
      if (permanent != null) 'permanent': permanent,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UserInfoTableCompanion copyWith({
    Value<String>? gender,
    Value<String>? jobStatus,
    Value<String>? datingStatus,
    Value<DateTime>? birthdate,
    Value<bool>? permanent,
    Value<int>? rowid,
  }) {
    return UserInfoTableCompanion(
      gender: gender ?? this.gender,
      jobStatus: jobStatus ?? this.jobStatus,
      datingStatus: datingStatus ?? this.datingStatus,
      birthdate: birthdate ?? this.birthdate,
      permanent: permanent ?? this.permanent,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (gender.present) {
      map['gender'] = Variable<String>(gender.value);
    }
    if (jobStatus.present) {
      map['job_status'] = Variable<String>(jobStatus.value);
    }
    if (datingStatus.present) {
      map['dating_status'] = Variable<String>(datingStatus.value);
    }
    if (birthdate.present) {
      map['birthdate'] = Variable<DateTime>(birthdate.value);
    }
    if (permanent.present) {
      map['permanent'] = Variable<bool>(permanent.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserInfoTableCompanion(')
          ..write('gender: $gender, ')
          ..write('jobStatus: $jobStatus, ')
          ..write('datingStatus: $datingStatus, ')
          ..write('birthdate: $birthdate, ')
          ..write('permanent: $permanent, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UserInfoTableTable userInfoTable = $UserInfoTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [userInfoTable];
}

typedef $$UserInfoTableTableCreateCompanionBuilder =
    UserInfoTableCompanion Function({
      required String gender,
      required String jobStatus,
      required String datingStatus,
      required DateTime birthdate,
      required bool permanent,
      Value<int> rowid,
    });
typedef $$UserInfoTableTableUpdateCompanionBuilder =
    UserInfoTableCompanion Function({
      Value<String> gender,
      Value<String> jobStatus,
      Value<String> datingStatus,
      Value<DateTime> birthdate,
      Value<bool> permanent,
      Value<int> rowid,
    });

class $$UserInfoTableTableFilterComposer
    extends Composer<_$AppDatabase, $UserInfoTableTable> {
  $$UserInfoTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get gender => $composableBuilder(
    column: $table.gender,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get jobStatus => $composableBuilder(
    column: $table.jobStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get datingStatus => $composableBuilder(
    column: $table.datingStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get birthdate => $composableBuilder(
    column: $table.birthdate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get permanent => $composableBuilder(
    column: $table.permanent,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserInfoTableTableOrderingComposer
    extends Composer<_$AppDatabase, $UserInfoTableTable> {
  $$UserInfoTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get gender => $composableBuilder(
    column: $table.gender,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get jobStatus => $composableBuilder(
    column: $table.jobStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get datingStatus => $composableBuilder(
    column: $table.datingStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get birthdate => $composableBuilder(
    column: $table.birthdate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get permanent => $composableBuilder(
    column: $table.permanent,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserInfoTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserInfoTableTable> {
  $$UserInfoTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get gender =>
      $composableBuilder(column: $table.gender, builder: (column) => column);

  GeneratedColumn<String> get jobStatus =>
      $composableBuilder(column: $table.jobStatus, builder: (column) => column);

  GeneratedColumn<String> get datingStatus => $composableBuilder(
    column: $table.datingStatus,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get birthdate =>
      $composableBuilder(column: $table.birthdate, builder: (column) => column);

  GeneratedColumn<bool> get permanent =>
      $composableBuilder(column: $table.permanent, builder: (column) => column);
}

class $$UserInfoTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserInfoTableTable,
          UserInfoTableData,
          $$UserInfoTableTableFilterComposer,
          $$UserInfoTableTableOrderingComposer,
          $$UserInfoTableTableAnnotationComposer,
          $$UserInfoTableTableCreateCompanionBuilder,
          $$UserInfoTableTableUpdateCompanionBuilder,
          (
            UserInfoTableData,
            BaseReferences<
              _$AppDatabase,
              $UserInfoTableTable,
              UserInfoTableData
            >,
          ),
          UserInfoTableData,
          PrefetchHooks Function()
        > {
  $$UserInfoTableTableTableManager(_$AppDatabase db, $UserInfoTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserInfoTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserInfoTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserInfoTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> gender = const Value.absent(),
                Value<String> jobStatus = const Value.absent(),
                Value<String> datingStatus = const Value.absent(),
                Value<DateTime> birthdate = const Value.absent(),
                Value<bool> permanent = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserInfoTableCompanion(
                gender: gender,
                jobStatus: jobStatus,
                datingStatus: datingStatus,
                birthdate: birthdate,
                permanent: permanent,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String gender,
                required String jobStatus,
                required String datingStatus,
                required DateTime birthdate,
                required bool permanent,
                Value<int> rowid = const Value.absent(),
              }) => UserInfoTableCompanion.insert(
                gender: gender,
                jobStatus: jobStatus,
                datingStatus: datingStatus,
                birthdate: birthdate,
                permanent: permanent,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserInfoTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserInfoTableTable,
      UserInfoTableData,
      $$UserInfoTableTableFilterComposer,
      $$UserInfoTableTableOrderingComposer,
      $$UserInfoTableTableAnnotationComposer,
      $$UserInfoTableTableCreateCompanionBuilder,
      $$UserInfoTableTableUpdateCompanionBuilder,
      (
        UserInfoTableData,
        BaseReferences<_$AppDatabase, $UserInfoTableTable, UserInfoTableData>,
      ),
      UserInfoTableData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UserInfoTableTableTableManager get userInfoTable =>
      $$UserInfoTableTableTableManager(_db, _db.userInfoTable);
}
