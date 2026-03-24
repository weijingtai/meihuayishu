import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../database/meihua_database.dart';
import '../database/tables/meihua_gua_infos.dart';
import '../daos/meihua_divinations_dao.dart';
import '../models/divination_result.dart';

/// 梅花易数起卦记录仓库
class MeiHuaDivinationRepository {
  final MeiHuaDatabase _database;
  final MeiHuaDivinationsDao _dao;

  MeiHuaDivinationRepository(this._database)
      : _dao = MeiHuaDivinationsDao(_database);

  /// 保存起卦记录
  Future<String> saveDivinationRecord({
    required DivinationResult result,
    String? question,
  }) async {
    final uuid = const Uuid().v4();
    final now = DateTime.now();

    await _dao.insertRecord(
      MeiHuaGuaInfosCompanion(
        uuid: Value(uuid),
        divinationUuid: Value(uuid), // 使用相同的 UUID
        question: Value(question),
        originalUpperGua: Value(result.originalGua.upperNumber),
        originalLowerGua: Value(result.originalGua.lowerNumber),
        changingYao: Value(result.originalGua.changingYao),
        changedUpperGua: Value(result.changedGua.upperNumber),
        changedLowerGua: Value(result.changedGua.lowerNumber),
        huUpperGua: Value(result.huGua?.upperNumber ?? 0),
        huLowerGua: Value(result.huGua?.lowerNumber ?? 0),
        method: Value(result.method.name),
        paramsJson: Value(jsonEncode(result.params)),
        createdAt: Value(now),
        updatedAt: Value(now),
      ),
    );

    return uuid;
  }

  /// 获取所有起卦记录
  Future<List<MeiHuaGuaInfo>> getAllRecords() {
    return _dao.getAllRecords();
  }

  /// 监听起卦记录变化
  Stream<List<MeiHuaGuaInfo>> watchAllRecords() {
    return _dao.watchAllRecords();
  }

  /// 根据 UUID 获取起卦记录
  Future<MeiHuaGuaInfo?> getRecordByUuid(String uuid) {
    return _dao.getRecordByUuid(uuid);
  }

  /// 根据占卜 UUID 获取起卦记录
  Future<MeiHuaGuaInfo?> getRecordByDivinationUuid(String divinationUuid) {
    return _dao.getRecordByDivinationUuid(divinationUuid);
  }

  /// 监听指定记录变化
  Stream<MeiHuaGuaInfo?> watchRecordByDivinationUuid(String divinationUuid) {
    return _dao.watchRecordByDivinationUuid(divinationUuid);
  }

  /// 软删除起卦记录
  Future<bool> softDeleteRecord(String uuid) async {
    final count = await _dao.softDeleteRecord(uuid);
    return count > 0;
  }
}
