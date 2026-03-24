import 'package:drift/drift.dart';

/// 梅花卦象信息表
/// 存储梅花易数特有的卦象信息
@DataClassName('MeiHuaGuaInfo')
class MeiHuaGuaInfos extends Table {
  @override
  String get tableName => 't_meihua_gua_info';

  /// 主键 UUID
  TextColumn get uuid => text().withLength(min: 1).named('uuid')();

  /// 占卜记录 UUID（关联到 common 的 t_divinations 表）
  TextColumn get divinationUuid =>
      text().named('divination_uuid')();

  /// 卜问内容
  TextColumn get question => text().nullable().named('question')();

  /// 本卦信息
  IntColumn get originalUpperGua => integer().named('original_upper_gua')();
  IntColumn get originalLowerGua => integer().named('original_lower_gua')();
  IntColumn get changingYao => integer().named('changing_yao')();

  /// 变卦信息
  IntColumn get changedUpperGua => integer().named('changed_upper_gua')();
  IntColumn get changedLowerGua => integer().named('changed_lower_gua')();

  /// 互卦信息
  IntColumn get huUpperGua => integer().named('hu_upper_gua')();
  IntColumn get huLowerGua => integer().named('hu_lower_gua')();

  /// 起卦方法
  TextColumn get method => text().named('method')();

  /// 起卦参数 JSON
  TextColumn get paramsJson => text().named('params_json')();

  /// 时间戳
  DateTimeColumn get createdAt => dateTime().named('created_at')();
  DateTimeColumn get updatedAt => dateTime().named('updated_at')();
  DateTimeColumn get deletedAt => dateTime().nullable().named('deleted_at')();

  @override
  Set<Column> get primaryKey => {uuid};
}
