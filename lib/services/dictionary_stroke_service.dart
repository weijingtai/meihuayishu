import 'dart:convert';
import 'package:logger/logger.dart';

import '../database/dictionary/dictionary_database.dart';

/// 基于字典数据库的笔画服务
class DictionaryStrokeService {
  static final DictionaryStrokeService _instance =
      DictionaryStrokeService._internal();
  factory DictionaryStrokeService() => _instance;
  DictionaryStrokeService._internal();

  final Logger _logger = Logger();
  DictionaryDatabase? _database;

  /// 获取数据库实例
  DictionaryDatabase get database {
    _database ??= DictionaryDatabase();
    return _database!;
  }

  /// 获取单个字的笔画数
  Future<int> getStrokeCount(String character) async {
    if (character.isEmpty) return 0;

    try {
      final char = await database.queryCharacter(character);
      if (char == null) {
        print('未找到字 "$character" 的记录');
        return 7; // 默认7画作为fallback
      }
      if (char.matchesJson == null) {
        print('字 "$character" 的 matchesJson 为空');
        return 7; // 默认7画作为fallback
      }

      // 解析JSON数组，计算长度作为笔画数
      final List<dynamic> matches = jsonDecode(char.matchesJson!);
      print('字 "$character" 笔画数: ${matches.length}');
      return matches.length;
    } catch (e) {
      print('获取字 "$character" 笔画数失败: $e');
      return 7;
    }
  }

  /// 获取多个字的笔画总数
  Future<int> getTotalStrokeCount(String text) async {
    int total = 0;
    for (var char in text.split('')) {
      total += await getStrokeCount(char);
    }
    return total;
  }

  /// 获取字符串中每个字的笔画数列表
  Future<List<int>> getStrokeCounts(String text) async {
    final List<int> counts = [];
    for (var char in text.split('')) {
      counts.add(await getStrokeCount(char));
    }
    return counts;
  }

  /// 检查是否所有字都有笔画数据
  Future<bool> hasAllStrokes(String text) async {
    try {
      for (var char in text.split('')) {
        final charData = await database.queryCharacter(char);
        if (charData == null || charData.matchesJson == null) {
          return false;
        }
      }
      return true;
    } catch (e) {
      _logger.e('检查笔画数据失败: $e');
      return false;
    }
  }

  /// 获取缺失笔画数据的字列表
  Future<List<String>> getMissingCharacters(String text) async {
    final List<String> missing = [];
    try {
      for (var char in text.split('')) {
        final charData = await database.queryCharacter(char);
        if (charData == null || charData.matchesJson == null) {
          missing.add(char);
        }
      }
    } catch (e) {
      _logger.e('获取缺失笔画字符失败: $e');
    }
    return missing;
  }

  /// 查询单个汉字的完整信息
  Future<Map<String, dynamic>?> queryCharacter(String character) async {
    try {
      final char = await database.queryCharacter(character);
      if (char == null) return null;

      final pinyinList = await database.queryPinyins(char.id);
      final pinyins = pinyinList.map((p) => p.pinyin).join(', ');

      return {
        'character': char.character,
        'definition': char.definition,
        'radical': char.radical,
        'decomposition': char.decomposition,
        'matches_json': char.matchesJson,
        'pinyins': pinyins,
      };
    } catch (e) {
      _logger.e('查询字 "$character" 信息失败: $e');
      return null;
    }
  }

  /// 批量获取笔画数（更高效）
  Future<Map<String, int>> batchGetStrokeCounts(List<String> characters) async {
    final Map<String, int> result = {};
    if (characters.isEmpty) return result;

    try {
      for (var char in characters) {
        final strokeCount = await getStrokeCount(char);
        result[char] = strokeCount;
      }
    } catch (e) {
      _logger.e('批量获取笔画数失败: $e');
      // 出错时返回默认值
      for (var char in characters) {
        result[char] = 7;
      }
    }

    return result;
  }

  /// 获取汉字的拼音带声调编号（如 "hao 3"）
  Future<String?> getPinyinWithToneNumber(String character) async {
    return await database.getPinyinWithToneNumber(character);
  }

  /// 获取汉字的所有拼音带声调编号
  Future<List<String>> getAllPinyinWithToneNumber(String character) async {
    return await database.getAllPinyinWithToneNumber(character);
  }

  /// 关闭数据库
  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}
