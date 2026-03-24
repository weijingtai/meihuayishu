// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meihua_database.dart';

// ignore_for_file: type=lint
class $MeiHuaGuaInfosTable extends MeiHuaGuaInfos
    with TableInfo<$MeiHuaGuaInfosTable, MeiHuaGuaInfo> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MeiHuaGuaInfosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _uuidMeta = const VerificationMeta('uuid');
  @override
  late final GeneratedColumn<String> uuid =
      GeneratedColumn<String>('uuid', aliasedName, false,
          additionalChecks: GeneratedColumn.checkTextLength(
            minTextLength: 1,
          ),
          type: DriftSqlType.string,
          requiredDuringInsert: true);
  static const VerificationMeta _divinationUuidMeta =
      const VerificationMeta('divinationUuid');
  @override
  late final GeneratedColumn<String> divinationUuid = GeneratedColumn<String>(
      'divination_uuid', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _questionMeta =
      const VerificationMeta('question');
  @override
  late final GeneratedColumn<String> question = GeneratedColumn<String>(
      'question', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _originalUpperGuaMeta =
      const VerificationMeta('originalUpperGua');
  @override
  late final GeneratedColumn<int> originalUpperGua = GeneratedColumn<int>(
      'original_upper_gua', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _originalLowerGuaMeta =
      const VerificationMeta('originalLowerGua');
  @override
  late final GeneratedColumn<int> originalLowerGua = GeneratedColumn<int>(
      'original_lower_gua', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _changingYaoMeta =
      const VerificationMeta('changingYao');
  @override
  late final GeneratedColumn<int> changingYao = GeneratedColumn<int>(
      'changing_yao', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _changedUpperGuaMeta =
      const VerificationMeta('changedUpperGua');
  @override
  late final GeneratedColumn<int> changedUpperGua = GeneratedColumn<int>(
      'changed_upper_gua', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _changedLowerGuaMeta =
      const VerificationMeta('changedLowerGua');
  @override
  late final GeneratedColumn<int> changedLowerGua = GeneratedColumn<int>(
      'changed_lower_gua', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _huUpperGuaMeta =
      const VerificationMeta('huUpperGua');
  @override
  late final GeneratedColumn<int> huUpperGua = GeneratedColumn<int>(
      'hu_upper_gua', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _huLowerGuaMeta =
      const VerificationMeta('huLowerGua');
  @override
  late final GeneratedColumn<int> huLowerGua = GeneratedColumn<int>(
      'hu_lower_gua', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _methodMeta = const VerificationMeta('method');
  @override
  late final GeneratedColumn<String> method = GeneratedColumn<String>(
      'method', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _paramsJsonMeta =
      const VerificationMeta('paramsJson');
  @override
  late final GeneratedColumn<String> paramsJson = GeneratedColumn<String>(
      'params_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _deletedAtMeta =
      const VerificationMeta('deletedAt');
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        uuid,
        divinationUuid,
        question,
        originalUpperGua,
        originalLowerGua,
        changingYao,
        changedUpperGua,
        changedLowerGua,
        huUpperGua,
        huLowerGua,
        method,
        paramsJson,
        createdAt,
        updatedAt,
        deletedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 't_meihua_gua_info';
  @override
  VerificationContext validateIntegrity(Insertable<MeiHuaGuaInfo> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('uuid')) {
      context.handle(
          _uuidMeta, uuid.isAcceptableOrUnknown(data['uuid']!, _uuidMeta));
    } else if (isInserting) {
      context.missing(_uuidMeta);
    }
    if (data.containsKey('divination_uuid')) {
      context.handle(
          _divinationUuidMeta,
          divinationUuid.isAcceptableOrUnknown(
              data['divination_uuid']!, _divinationUuidMeta));
    } else if (isInserting) {
      context.missing(_divinationUuidMeta);
    }
    if (data.containsKey('question')) {
      context.handle(_questionMeta,
          question.isAcceptableOrUnknown(data['question']!, _questionMeta));
    }
    if (data.containsKey('original_upper_gua')) {
      context.handle(
          _originalUpperGuaMeta,
          originalUpperGua.isAcceptableOrUnknown(
              data['original_upper_gua']!, _originalUpperGuaMeta));
    } else if (isInserting) {
      context.missing(_originalUpperGuaMeta);
    }
    if (data.containsKey('original_lower_gua')) {
      context.handle(
          _originalLowerGuaMeta,
          originalLowerGua.isAcceptableOrUnknown(
              data['original_lower_gua']!, _originalLowerGuaMeta));
    } else if (isInserting) {
      context.missing(_originalLowerGuaMeta);
    }
    if (data.containsKey('changing_yao')) {
      context.handle(
          _changingYaoMeta,
          changingYao.isAcceptableOrUnknown(
              data['changing_yao']!, _changingYaoMeta));
    } else if (isInserting) {
      context.missing(_changingYaoMeta);
    }
    if (data.containsKey('changed_upper_gua')) {
      context.handle(
          _changedUpperGuaMeta,
          changedUpperGua.isAcceptableOrUnknown(
              data['changed_upper_gua']!, _changedUpperGuaMeta));
    } else if (isInserting) {
      context.missing(_changedUpperGuaMeta);
    }
    if (data.containsKey('changed_lower_gua')) {
      context.handle(
          _changedLowerGuaMeta,
          changedLowerGua.isAcceptableOrUnknown(
              data['changed_lower_gua']!, _changedLowerGuaMeta));
    } else if (isInserting) {
      context.missing(_changedLowerGuaMeta);
    }
    if (data.containsKey('hu_upper_gua')) {
      context.handle(
          _huUpperGuaMeta,
          huUpperGua.isAcceptableOrUnknown(
              data['hu_upper_gua']!, _huUpperGuaMeta));
    } else if (isInserting) {
      context.missing(_huUpperGuaMeta);
    }
    if (data.containsKey('hu_lower_gua')) {
      context.handle(
          _huLowerGuaMeta,
          huLowerGua.isAcceptableOrUnknown(
              data['hu_lower_gua']!, _huLowerGuaMeta));
    } else if (isInserting) {
      context.missing(_huLowerGuaMeta);
    }
    if (data.containsKey('method')) {
      context.handle(_methodMeta,
          method.isAcceptableOrUnknown(data['method']!, _methodMeta));
    } else if (isInserting) {
      context.missing(_methodMeta);
    }
    if (data.containsKey('params_json')) {
      context.handle(
          _paramsJsonMeta,
          paramsJson.isAcceptableOrUnknown(
              data['params_json']!, _paramsJsonMeta));
    } else if (isInserting) {
      context.missing(_paramsJsonMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {uuid};
  @override
  MeiHuaGuaInfo map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MeiHuaGuaInfo(
      uuid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}uuid'])!,
      divinationUuid: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}divination_uuid'])!,
      question: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}question']),
      originalUpperGua: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}original_upper_gua'])!,
      originalLowerGua: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}original_lower_gua'])!,
      changingYao: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}changing_yao'])!,
      changedUpperGua: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}changed_upper_gua'])!,
      changedLowerGua: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}changed_lower_gua'])!,
      huUpperGua: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}hu_upper_gua'])!,
      huLowerGua: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}hu_lower_gua'])!,
      method: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}method'])!,
      paramsJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}params_json'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}deleted_at']),
    );
  }

  @override
  $MeiHuaGuaInfosTable createAlias(String alias) {
    return $MeiHuaGuaInfosTable(attachedDatabase, alias);
  }
}

class MeiHuaGuaInfo extends DataClass implements Insertable<MeiHuaGuaInfo> {
  /// 主键 UUID
  final String uuid;

  /// 占卜记录 UUID（关联到 common 的 t_divinations 表）
  final String divinationUuid;

  /// 卜问内容
  final String? question;

  /// 本卦信息
  final int originalUpperGua;
  final int originalLowerGua;
  final int changingYao;

  /// 变卦信息
  final int changedUpperGua;
  final int changedLowerGua;

  /// 互卦信息
  final int huUpperGua;
  final int huLowerGua;

  /// 起卦方法
  final String method;

  /// 起卦参数 JSON
  final String paramsJson;

  /// 时间戳
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  const MeiHuaGuaInfo(
      {required this.uuid,
      required this.divinationUuid,
      this.question,
      required this.originalUpperGua,
      required this.originalLowerGua,
      required this.changingYao,
      required this.changedUpperGua,
      required this.changedLowerGua,
      required this.huUpperGua,
      required this.huLowerGua,
      required this.method,
      required this.paramsJson,
      required this.createdAt,
      required this.updatedAt,
      this.deletedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['uuid'] = Variable<String>(uuid);
    map['divination_uuid'] = Variable<String>(divinationUuid);
    if (!nullToAbsent || question != null) {
      map['question'] = Variable<String>(question);
    }
    map['original_upper_gua'] = Variable<int>(originalUpperGua);
    map['original_lower_gua'] = Variable<int>(originalLowerGua);
    map['changing_yao'] = Variable<int>(changingYao);
    map['changed_upper_gua'] = Variable<int>(changedUpperGua);
    map['changed_lower_gua'] = Variable<int>(changedLowerGua);
    map['hu_upper_gua'] = Variable<int>(huUpperGua);
    map['hu_lower_gua'] = Variable<int>(huLowerGua);
    map['method'] = Variable<String>(method);
    map['params_json'] = Variable<String>(paramsJson);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  MeiHuaGuaInfosCompanion toCompanion(bool nullToAbsent) {
    return MeiHuaGuaInfosCompanion(
      uuid: Value(uuid),
      divinationUuid: Value(divinationUuid),
      question: question == null && nullToAbsent
          ? const Value.absent()
          : Value(question),
      originalUpperGua: Value(originalUpperGua),
      originalLowerGua: Value(originalLowerGua),
      changingYao: Value(changingYao),
      changedUpperGua: Value(changedUpperGua),
      changedLowerGua: Value(changedLowerGua),
      huUpperGua: Value(huUpperGua),
      huLowerGua: Value(huLowerGua),
      method: Value(method),
      paramsJson: Value(paramsJson),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory MeiHuaGuaInfo.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MeiHuaGuaInfo(
      uuid: serializer.fromJson<String>(json['uuid']),
      divinationUuid: serializer.fromJson<String>(json['divinationUuid']),
      question: serializer.fromJson<String?>(json['question']),
      originalUpperGua: serializer.fromJson<int>(json['originalUpperGua']),
      originalLowerGua: serializer.fromJson<int>(json['originalLowerGua']),
      changingYao: serializer.fromJson<int>(json['changingYao']),
      changedUpperGua: serializer.fromJson<int>(json['changedUpperGua']),
      changedLowerGua: serializer.fromJson<int>(json['changedLowerGua']),
      huUpperGua: serializer.fromJson<int>(json['huUpperGua']),
      huLowerGua: serializer.fromJson<int>(json['huLowerGua']),
      method: serializer.fromJson<String>(json['method']),
      paramsJson: serializer.fromJson<String>(json['paramsJson']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'uuid': serializer.toJson<String>(uuid),
      'divinationUuid': serializer.toJson<String>(divinationUuid),
      'question': serializer.toJson<String?>(question),
      'originalUpperGua': serializer.toJson<int>(originalUpperGua),
      'originalLowerGua': serializer.toJson<int>(originalLowerGua),
      'changingYao': serializer.toJson<int>(changingYao),
      'changedUpperGua': serializer.toJson<int>(changedUpperGua),
      'changedLowerGua': serializer.toJson<int>(changedLowerGua),
      'huUpperGua': serializer.toJson<int>(huUpperGua),
      'huLowerGua': serializer.toJson<int>(huLowerGua),
      'method': serializer.toJson<String>(method),
      'paramsJson': serializer.toJson<String>(paramsJson),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  MeiHuaGuaInfo copyWith(
          {String? uuid,
          String? divinationUuid,
          Value<String?> question = const Value.absent(),
          int? originalUpperGua,
          int? originalLowerGua,
          int? changingYao,
          int? changedUpperGua,
          int? changedLowerGua,
          int? huUpperGua,
          int? huLowerGua,
          String? method,
          String? paramsJson,
          DateTime? createdAt,
          DateTime? updatedAt,
          Value<DateTime?> deletedAt = const Value.absent()}) =>
      MeiHuaGuaInfo(
        uuid: uuid ?? this.uuid,
        divinationUuid: divinationUuid ?? this.divinationUuid,
        question: question.present ? question.value : this.question,
        originalUpperGua: originalUpperGua ?? this.originalUpperGua,
        originalLowerGua: originalLowerGua ?? this.originalLowerGua,
        changingYao: changingYao ?? this.changingYao,
        changedUpperGua: changedUpperGua ?? this.changedUpperGua,
        changedLowerGua: changedLowerGua ?? this.changedLowerGua,
        huUpperGua: huUpperGua ?? this.huUpperGua,
        huLowerGua: huLowerGua ?? this.huLowerGua,
        method: method ?? this.method,
        paramsJson: paramsJson ?? this.paramsJson,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
      );
  MeiHuaGuaInfo copyWithCompanion(MeiHuaGuaInfosCompanion data) {
    return MeiHuaGuaInfo(
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      divinationUuid: data.divinationUuid.present
          ? data.divinationUuid.value
          : this.divinationUuid,
      question: data.question.present ? data.question.value : this.question,
      originalUpperGua: data.originalUpperGua.present
          ? data.originalUpperGua.value
          : this.originalUpperGua,
      originalLowerGua: data.originalLowerGua.present
          ? data.originalLowerGua.value
          : this.originalLowerGua,
      changingYao:
          data.changingYao.present ? data.changingYao.value : this.changingYao,
      changedUpperGua: data.changedUpperGua.present
          ? data.changedUpperGua.value
          : this.changedUpperGua,
      changedLowerGua: data.changedLowerGua.present
          ? data.changedLowerGua.value
          : this.changedLowerGua,
      huUpperGua:
          data.huUpperGua.present ? data.huUpperGua.value : this.huUpperGua,
      huLowerGua:
          data.huLowerGua.present ? data.huLowerGua.value : this.huLowerGua,
      method: data.method.present ? data.method.value : this.method,
      paramsJson:
          data.paramsJson.present ? data.paramsJson.value : this.paramsJson,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MeiHuaGuaInfo(')
          ..write('uuid: $uuid, ')
          ..write('divinationUuid: $divinationUuid, ')
          ..write('question: $question, ')
          ..write('originalUpperGua: $originalUpperGua, ')
          ..write('originalLowerGua: $originalLowerGua, ')
          ..write('changingYao: $changingYao, ')
          ..write('changedUpperGua: $changedUpperGua, ')
          ..write('changedLowerGua: $changedLowerGua, ')
          ..write('huUpperGua: $huUpperGua, ')
          ..write('huLowerGua: $huLowerGua, ')
          ..write('method: $method, ')
          ..write('paramsJson: $paramsJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      uuid,
      divinationUuid,
      question,
      originalUpperGua,
      originalLowerGua,
      changingYao,
      changedUpperGua,
      changedLowerGua,
      huUpperGua,
      huLowerGua,
      method,
      paramsJson,
      createdAt,
      updatedAt,
      deletedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MeiHuaGuaInfo &&
          other.uuid == this.uuid &&
          other.divinationUuid == this.divinationUuid &&
          other.question == this.question &&
          other.originalUpperGua == this.originalUpperGua &&
          other.originalLowerGua == this.originalLowerGua &&
          other.changingYao == this.changingYao &&
          other.changedUpperGua == this.changedUpperGua &&
          other.changedLowerGua == this.changedLowerGua &&
          other.huUpperGua == this.huUpperGua &&
          other.huLowerGua == this.huLowerGua &&
          other.method == this.method &&
          other.paramsJson == this.paramsJson &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class MeiHuaGuaInfosCompanion extends UpdateCompanion<MeiHuaGuaInfo> {
  final Value<String> uuid;
  final Value<String> divinationUuid;
  final Value<String?> question;
  final Value<int> originalUpperGua;
  final Value<int> originalLowerGua;
  final Value<int> changingYao;
  final Value<int> changedUpperGua;
  final Value<int> changedLowerGua;
  final Value<int> huUpperGua;
  final Value<int> huLowerGua;
  final Value<String> method;
  final Value<String> paramsJson;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const MeiHuaGuaInfosCompanion({
    this.uuid = const Value.absent(),
    this.divinationUuid = const Value.absent(),
    this.question = const Value.absent(),
    this.originalUpperGua = const Value.absent(),
    this.originalLowerGua = const Value.absent(),
    this.changingYao = const Value.absent(),
    this.changedUpperGua = const Value.absent(),
    this.changedLowerGua = const Value.absent(),
    this.huUpperGua = const Value.absent(),
    this.huLowerGua = const Value.absent(),
    this.method = const Value.absent(),
    this.paramsJson = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MeiHuaGuaInfosCompanion.insert({
    required String uuid,
    required String divinationUuid,
    this.question = const Value.absent(),
    required int originalUpperGua,
    required int originalLowerGua,
    required int changingYao,
    required int changedUpperGua,
    required int changedLowerGua,
    required int huUpperGua,
    required int huLowerGua,
    required String method,
    required String paramsJson,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : uuid = Value(uuid),
        divinationUuid = Value(divinationUuid),
        originalUpperGua = Value(originalUpperGua),
        originalLowerGua = Value(originalLowerGua),
        changingYao = Value(changingYao),
        changedUpperGua = Value(changedUpperGua),
        changedLowerGua = Value(changedLowerGua),
        huUpperGua = Value(huUpperGua),
        huLowerGua = Value(huLowerGua),
        method = Value(method),
        paramsJson = Value(paramsJson),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<MeiHuaGuaInfo> custom({
    Expression<String>? uuid,
    Expression<String>? divinationUuid,
    Expression<String>? question,
    Expression<int>? originalUpperGua,
    Expression<int>? originalLowerGua,
    Expression<int>? changingYao,
    Expression<int>? changedUpperGua,
    Expression<int>? changedLowerGua,
    Expression<int>? huUpperGua,
    Expression<int>? huLowerGua,
    Expression<String>? method,
    Expression<String>? paramsJson,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (uuid != null) 'uuid': uuid,
      if (divinationUuid != null) 'divination_uuid': divinationUuid,
      if (question != null) 'question': question,
      if (originalUpperGua != null) 'original_upper_gua': originalUpperGua,
      if (originalLowerGua != null) 'original_lower_gua': originalLowerGua,
      if (changingYao != null) 'changing_yao': changingYao,
      if (changedUpperGua != null) 'changed_upper_gua': changedUpperGua,
      if (changedLowerGua != null) 'changed_lower_gua': changedLowerGua,
      if (huUpperGua != null) 'hu_upper_gua': huUpperGua,
      if (huLowerGua != null) 'hu_lower_gua': huLowerGua,
      if (method != null) 'method': method,
      if (paramsJson != null) 'params_json': paramsJson,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MeiHuaGuaInfosCompanion copyWith(
      {Value<String>? uuid,
      Value<String>? divinationUuid,
      Value<String?>? question,
      Value<int>? originalUpperGua,
      Value<int>? originalLowerGua,
      Value<int>? changingYao,
      Value<int>? changedUpperGua,
      Value<int>? changedLowerGua,
      Value<int>? huUpperGua,
      Value<int>? huLowerGua,
      Value<String>? method,
      Value<String>? paramsJson,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<DateTime?>? deletedAt,
      Value<int>? rowid}) {
    return MeiHuaGuaInfosCompanion(
      uuid: uuid ?? this.uuid,
      divinationUuid: divinationUuid ?? this.divinationUuid,
      question: question ?? this.question,
      originalUpperGua: originalUpperGua ?? this.originalUpperGua,
      originalLowerGua: originalLowerGua ?? this.originalLowerGua,
      changingYao: changingYao ?? this.changingYao,
      changedUpperGua: changedUpperGua ?? this.changedUpperGua,
      changedLowerGua: changedLowerGua ?? this.changedLowerGua,
      huUpperGua: huUpperGua ?? this.huUpperGua,
      huLowerGua: huLowerGua ?? this.huLowerGua,
      method: method ?? this.method,
      paramsJson: paramsJson ?? this.paramsJson,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
    }
    if (divinationUuid.present) {
      map['divination_uuid'] = Variable<String>(divinationUuid.value);
    }
    if (question.present) {
      map['question'] = Variable<String>(question.value);
    }
    if (originalUpperGua.present) {
      map['original_upper_gua'] = Variable<int>(originalUpperGua.value);
    }
    if (originalLowerGua.present) {
      map['original_lower_gua'] = Variable<int>(originalLowerGua.value);
    }
    if (changingYao.present) {
      map['changing_yao'] = Variable<int>(changingYao.value);
    }
    if (changedUpperGua.present) {
      map['changed_upper_gua'] = Variable<int>(changedUpperGua.value);
    }
    if (changedLowerGua.present) {
      map['changed_lower_gua'] = Variable<int>(changedLowerGua.value);
    }
    if (huUpperGua.present) {
      map['hu_upper_gua'] = Variable<int>(huUpperGua.value);
    }
    if (huLowerGua.present) {
      map['hu_lower_gua'] = Variable<int>(huLowerGua.value);
    }
    if (method.present) {
      map['method'] = Variable<String>(method.value);
    }
    if (paramsJson.present) {
      map['params_json'] = Variable<String>(paramsJson.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MeiHuaGuaInfosCompanion(')
          ..write('uuid: $uuid, ')
          ..write('divinationUuid: $divinationUuid, ')
          ..write('question: $question, ')
          ..write('originalUpperGua: $originalUpperGua, ')
          ..write('originalLowerGua: $originalLowerGua, ')
          ..write('changingYao: $changingYao, ')
          ..write('changedUpperGua: $changedUpperGua, ')
          ..write('changedLowerGua: $changedLowerGua, ')
          ..write('huUpperGua: $huUpperGua, ')
          ..write('huLowerGua: $huLowerGua, ')
          ..write('method: $method, ')
          ..write('paramsJson: $paramsJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$MeiHuaDatabase extends GeneratedDatabase {
  _$MeiHuaDatabase(QueryExecutor e) : super(e);
  $MeiHuaDatabaseManager get managers => $MeiHuaDatabaseManager(this);
  late final $MeiHuaGuaInfosTable meiHuaGuaInfos = $MeiHuaGuaInfosTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [meiHuaGuaInfos];
}

typedef $$MeiHuaGuaInfosTableCreateCompanionBuilder = MeiHuaGuaInfosCompanion
    Function({
  required String uuid,
  required String divinationUuid,
  Value<String?> question,
  required int originalUpperGua,
  required int originalLowerGua,
  required int changingYao,
  required int changedUpperGua,
  required int changedLowerGua,
  required int huUpperGua,
  required int huLowerGua,
  required String method,
  required String paramsJson,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<DateTime?> deletedAt,
  Value<int> rowid,
});
typedef $$MeiHuaGuaInfosTableUpdateCompanionBuilder = MeiHuaGuaInfosCompanion
    Function({
  Value<String> uuid,
  Value<String> divinationUuid,
  Value<String?> question,
  Value<int> originalUpperGua,
  Value<int> originalLowerGua,
  Value<int> changingYao,
  Value<int> changedUpperGua,
  Value<int> changedLowerGua,
  Value<int> huUpperGua,
  Value<int> huLowerGua,
  Value<String> method,
  Value<String> paramsJson,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<int> rowid,
});

class $$MeiHuaGuaInfosTableFilterComposer
    extends Composer<_$MeiHuaDatabase, $MeiHuaGuaInfosTable> {
  $$MeiHuaGuaInfosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get uuid => $composableBuilder(
      column: $table.uuid, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get divinationUuid => $composableBuilder(
      column: $table.divinationUuid,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get question => $composableBuilder(
      column: $table.question, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get originalUpperGua => $composableBuilder(
      column: $table.originalUpperGua,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get originalLowerGua => $composableBuilder(
      column: $table.originalLowerGua,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get changingYao => $composableBuilder(
      column: $table.changingYao, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get changedUpperGua => $composableBuilder(
      column: $table.changedUpperGua,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get changedLowerGua => $composableBuilder(
      column: $table.changedLowerGua,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get huUpperGua => $composableBuilder(
      column: $table.huUpperGua, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get huLowerGua => $composableBuilder(
      column: $table.huLowerGua, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get method => $composableBuilder(
      column: $table.method, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get paramsJson => $composableBuilder(
      column: $table.paramsJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnFilters(column));
}

class $$MeiHuaGuaInfosTableOrderingComposer
    extends Composer<_$MeiHuaDatabase, $MeiHuaGuaInfosTable> {
  $$MeiHuaGuaInfosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get uuid => $composableBuilder(
      column: $table.uuid, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get divinationUuid => $composableBuilder(
      column: $table.divinationUuid,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get question => $composableBuilder(
      column: $table.question, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get originalUpperGua => $composableBuilder(
      column: $table.originalUpperGua,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get originalLowerGua => $composableBuilder(
      column: $table.originalLowerGua,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get changingYao => $composableBuilder(
      column: $table.changingYao, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get changedUpperGua => $composableBuilder(
      column: $table.changedUpperGua,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get changedLowerGua => $composableBuilder(
      column: $table.changedLowerGua,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get huUpperGua => $composableBuilder(
      column: $table.huUpperGua, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get huLowerGua => $composableBuilder(
      column: $table.huLowerGua, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get method => $composableBuilder(
      column: $table.method, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get paramsJson => $composableBuilder(
      column: $table.paramsJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnOrderings(column));
}

class $$MeiHuaGuaInfosTableAnnotationComposer
    extends Composer<_$MeiHuaDatabase, $MeiHuaGuaInfosTable> {
  $$MeiHuaGuaInfosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => column);

  GeneratedColumn<String> get divinationUuid => $composableBuilder(
      column: $table.divinationUuid, builder: (column) => column);

  GeneratedColumn<String> get question =>
      $composableBuilder(column: $table.question, builder: (column) => column);

  GeneratedColumn<int> get originalUpperGua => $composableBuilder(
      column: $table.originalUpperGua, builder: (column) => column);

  GeneratedColumn<int> get originalLowerGua => $composableBuilder(
      column: $table.originalLowerGua, builder: (column) => column);

  GeneratedColumn<int> get changingYao => $composableBuilder(
      column: $table.changingYao, builder: (column) => column);

  GeneratedColumn<int> get changedUpperGua => $composableBuilder(
      column: $table.changedUpperGua, builder: (column) => column);

  GeneratedColumn<int> get changedLowerGua => $composableBuilder(
      column: $table.changedLowerGua, builder: (column) => column);

  GeneratedColumn<int> get huUpperGua => $composableBuilder(
      column: $table.huUpperGua, builder: (column) => column);

  GeneratedColumn<int> get huLowerGua => $composableBuilder(
      column: $table.huLowerGua, builder: (column) => column);

  GeneratedColumn<String> get method =>
      $composableBuilder(column: $table.method, builder: (column) => column);

  GeneratedColumn<String> get paramsJson => $composableBuilder(
      column: $table.paramsJson, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);
}

class $$MeiHuaGuaInfosTableTableManager extends RootTableManager<
    _$MeiHuaDatabase,
    $MeiHuaGuaInfosTable,
    MeiHuaGuaInfo,
    $$MeiHuaGuaInfosTableFilterComposer,
    $$MeiHuaGuaInfosTableOrderingComposer,
    $$MeiHuaGuaInfosTableAnnotationComposer,
    $$MeiHuaGuaInfosTableCreateCompanionBuilder,
    $$MeiHuaGuaInfosTableUpdateCompanionBuilder,
    (
      MeiHuaGuaInfo,
      BaseReferences<_$MeiHuaDatabase, $MeiHuaGuaInfosTable, MeiHuaGuaInfo>
    ),
    MeiHuaGuaInfo,
    PrefetchHooks Function()> {
  $$MeiHuaGuaInfosTableTableManager(
      _$MeiHuaDatabase db, $MeiHuaGuaInfosTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MeiHuaGuaInfosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MeiHuaGuaInfosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MeiHuaGuaInfosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> uuid = const Value.absent(),
            Value<String> divinationUuid = const Value.absent(),
            Value<String?> question = const Value.absent(),
            Value<int> originalUpperGua = const Value.absent(),
            Value<int> originalLowerGua = const Value.absent(),
            Value<int> changingYao = const Value.absent(),
            Value<int> changedUpperGua = const Value.absent(),
            Value<int> changedLowerGua = const Value.absent(),
            Value<int> huUpperGua = const Value.absent(),
            Value<int> huLowerGua = const Value.absent(),
            Value<String> method = const Value.absent(),
            Value<String> paramsJson = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MeiHuaGuaInfosCompanion(
            uuid: uuid,
            divinationUuid: divinationUuid,
            question: question,
            originalUpperGua: originalUpperGua,
            originalLowerGua: originalLowerGua,
            changingYao: changingYao,
            changedUpperGua: changedUpperGua,
            changedLowerGua: changedLowerGua,
            huUpperGua: huUpperGua,
            huLowerGua: huLowerGua,
            method: method,
            paramsJson: paramsJson,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String uuid,
            required String divinationUuid,
            Value<String?> question = const Value.absent(),
            required int originalUpperGua,
            required int originalLowerGua,
            required int changingYao,
            required int changedUpperGua,
            required int changedLowerGua,
            required int huUpperGua,
            required int huLowerGua,
            required String method,
            required String paramsJson,
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MeiHuaGuaInfosCompanion.insert(
            uuid: uuid,
            divinationUuid: divinationUuid,
            question: question,
            originalUpperGua: originalUpperGua,
            originalLowerGua: originalLowerGua,
            changingYao: changingYao,
            changedUpperGua: changedUpperGua,
            changedLowerGua: changedLowerGua,
            huUpperGua: huUpperGua,
            huLowerGua: huLowerGua,
            method: method,
            paramsJson: paramsJson,
            createdAt: createdAt,
            updatedAt: updatedAt,
            deletedAt: deletedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$MeiHuaGuaInfosTableProcessedTableManager = ProcessedTableManager<
    _$MeiHuaDatabase,
    $MeiHuaGuaInfosTable,
    MeiHuaGuaInfo,
    $$MeiHuaGuaInfosTableFilterComposer,
    $$MeiHuaGuaInfosTableOrderingComposer,
    $$MeiHuaGuaInfosTableAnnotationComposer,
    $$MeiHuaGuaInfosTableCreateCompanionBuilder,
    $$MeiHuaGuaInfosTableUpdateCompanionBuilder,
    (
      MeiHuaGuaInfo,
      BaseReferences<_$MeiHuaDatabase, $MeiHuaGuaInfosTable, MeiHuaGuaInfo>
    ),
    MeiHuaGuaInfo,
    PrefetchHooks Function()>;

class $MeiHuaDatabaseManager {
  final _$MeiHuaDatabase _db;
  $MeiHuaDatabaseManager(this._db);
  $$MeiHuaGuaInfosTableTableManager get meiHuaGuaInfos =>
      $$MeiHuaGuaInfosTableTableManager(_db, _db.meiHuaGuaInfos);
}
