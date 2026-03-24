import 'dart:convert';

import 'package:logger/logger.dart';

import '../database/meihua_database.dart';
import '../database/tables/meihua_gua_infos.dart';
import '../models/divination_result.dart';
import '../repositories/meihua_divination_repository.dart';

/// 起卦记录服务
class DivinationRecordService {
  final Logger _logger = Logger();
  final MeiHuaDatabase _database;
  late final MeiHuaDivinationRepository _repository;

  DivinationRecordService(this._database) {
    _repository = MeiHuaDivinationRepository(_database);
  }

  /// 保存起卦记录
  Future<String> saveDivination({
    required DivinationResult result,
    String? question,
  }) async {
    try {
      final uuid = await _repository.saveDivinationRecord(
        result: result,
        question: question,
      );
      _logger.i('起卦记录保存成功: $uuid');
      return uuid;
    } catch (e) {
      _logger.e('保存起卦记录失败: $e');
      rethrow;
    }
  }

  /// 获取所有起卦记录
  Future<List<MeiHuaGuaInfo>> getAllRecords() {
    return _repository.getAllRecords();
  }

  /// 监听起卦记录变化
  Stream<List<MeiHuaGuaInfo>> watchAllRecords() {
    return _repository.watchAllRecords();
  }

  /// 获取起卦记录详情
  Future<DivinationRecordDetail?> getRecordDetail(String uuid) async {
    final record = await _repository.getRecordByUuid(uuid);
    if (record == null) return null;

    return DivinationRecordDetail(record: record);
  }

  /// 监听起卦记录详情变化
  Stream<DivinationRecordDetail?> watchRecordDetail(String uuid) async* {
    await for (final record
        in _repository.watchRecordByDivinationUuid(uuid)) {
      if (record == null) {
        yield null;
      } else {
        yield DivinationRecordDetail(record: record);
      }
    }
  }

  /// 删除起卦记录
  Future<bool> deleteRecord(String uuid) {
    return _repository.softDeleteRecord(uuid);
  }
}

/// 起卦记录详情
class DivinationRecordDetail {
  final MeiHuaGuaInfo record;

  DivinationRecordDetail({required this.record});

  /// 获取卜问内容
  String? get question => record.question;

  /// 获取创建时间
  DateTime get createdAt => record.createdAt;

  /// 获取起卦方法
  String get method => record.method;

  /// 获取起卦参数
  Map<String, dynamic>? get params {
    try {
      return jsonDecode(record.paramsJson) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }

  /// 获取本卦信息
  Map<String, int> get originalGua => {
        'upper': record.originalUpperGua,
        'lower': record.originalLowerGua,
        'changingYao': record.changingYao,
      };

  /// 获取变卦信息
  Map<String, int> get changedGua => {
        'upper': record.changedUpperGua,
        'lower': record.changedLowerGua,
      };

  /// 获取互卦信息
  Map<String, int> get huGua => {
        'upper': record.huUpperGua,
        'lower': record.huLowerGua,
      };
}
