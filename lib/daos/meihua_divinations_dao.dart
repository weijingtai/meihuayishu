import 'package:drift/drift.dart';

import '../database/meihua_database.dart';
import '../database/tables/meihua_gua_infos.dart';

part 'meihua_divinations_dao.g.dart';

/// 梅花易数起卦记录 DAO
@DriftAccessor(tables: [MeiHuaGuaInfos])
class MeiHuaDivinationsDao extends DatabaseAccessor<MeiHuaDatabase>
    with _$MeiHuaDivinationsDaoMixin {
  MeiHuaDivinationsDao(super.db);

  /// 获取所有起卦记录
  Future<List<MeiHuaGuaInfo>> getAllRecords() {
    return (select(db.meiHuaGuaInfos)
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();
  }

  /// 监听起卦记录变化
  Stream<List<MeiHuaGuaInfo>> watchAllRecords() {
    return (select(db.meiHuaGuaInfos)
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .watch();
  }

  /// 根据 UUID 获取起卦记录
  Future<MeiHuaGuaInfo?> getRecordByUuid(String uuid) {
    return (select(db.meiHuaGuaInfos)..where((t) => t.uuid.equals(uuid)))
        .getSingleOrNull();
  }

  /// 根据占卜 UUID 获取起卦记录
  Future<MeiHuaGuaInfo?> getRecordByDivinationUuid(String divinationUuid) {
    return (select(db.meiHuaGuaInfos)
          ..where((t) => t.divinationUuid.equals(divinationUuid))
          ..where((t) => t.deletedAt.isNull()))
        .getSingleOrNull();
  }

  /// 插入起卦记录
  Future<int> insertRecord(MeiHuaGuaInfosCompanion companion) {
    return into(db.meiHuaGuaInfos).insert(companion);
  }

  /// 更新起卦记录
  Future<bool> updateRecord(String uuid, MeiHuaGuaInfosCompanion companion) {
    return (update(db.meiHuaGuaInfos)..where((t) => t.uuid.equals(uuid)))
        .write(companion)
        .then((count) => count > 0);
  }

  /// 软删除起卦记录
  Future<int> softDeleteRecord(String uuid) {
    return (update(db.meiHuaGuaInfos)..where((t) => t.uuid.equals(uuid)))
        .write(MeiHuaGuaInfosCompanion(deletedAt: Value(DateTime.now())));
  }

  /// 监听指定记录变化
  Stream<MeiHuaGuaInfo?> watchRecordByDivinationUuid(String divinationUuid) {
    return (select(db.meiHuaGuaInfos)
          ..where((t) => t.divinationUuid.equals(divinationUuid))
          ..where((t) => t.deletedAt.isNull()))
        .watchSingleOrNull();
  }
}
