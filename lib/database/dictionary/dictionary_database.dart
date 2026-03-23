import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'dictionary_tables.dart';

part 'dictionary_database.g.dart';

/// 字典数据库
@DriftDatabase(tables: [Characters, Pinyins, Etymologies])
class DictionaryDatabase extends _$DictionaryDatabase {
  DictionaryDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  /// 从 assets 复制数据库并打开连接
  static QueryExecutor _openConnection() {
    return LazyDatabase(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, 'dictionary.db'));

      if (!await file.exists()) {
        // 尝试已知的资产路径
        ByteData? blob;
        const assetPaths = [
          'assets/sql/dictionary.db',
          'packages/meihuayishu/assets/sql/dictionary.db',
        ];

        for (final path in assetPaths) {
          try {
            blob = await rootBundle.load(path);
            print('成功加载资产: $path');
            break;
          } catch (e) {
            print('加载资产失败: $path - $e');
          }
        }

        if (blob != null) {
          await file.writeAsBytes(
            blob.buffer.asUint8List(blob.offsetInBytes, blob.lengthInBytes),
            flush: true,
          );
          print('数据库文件已复制到: ${file.path}');
        } else {
          print('警告: 无法加载数据库资产文件');
        }
      } else {
        print('数据库文件已存在: ${file.path}');
      }

      return NativeDatabase.createInBackground(file);
    });
  }

  /// 查询单个汉字
  Future<DictionaryCharacter?> queryCharacter(String character) {
    return (select(characters)..where((c) => c.character.equals(character)))
        .getSingleOrNull();
  }

  /// 查询汉字的所有拼音
  Future<List<DictionaryPinyin>> queryPinyins(int characterId) {
    return (select(pinyins)..where((p) => p.characterId.equals(characterId)))
        .get();
  }

  /// 根据汉字查询拼音
  Future<List<DictionaryPinyin>> queryPinyinsByCharacter(
      String character) async {
    final char = await queryCharacter(character);
    if (char == null) return [];
    return queryPinyins(char.id);
  }

  /// 查询汉字的字源信息
  Future<List<DictionaryEtymology>> queryEtymology(int characterId) {
    return (select(etymologies)
          ..where((e) => e.characterId.equals(characterId)))
        .get();
  }

  /// 获取汉字的笔画数（通过计算 matches_json 数组长度）
  Future<int?> getStrokeCount(String character) async {
    final char = await queryCharacter(character);
    if (char == null || char.matchesJson == null) return null;

    try {
      // 计算 JSON 数组中的元素数量作为笔画数
      final json = char.matchesJson!;
      // 简单的计数方式：统计逗号数量 + 1
      int count = 1;
      for (int i = 0; i < json.length; i++) {
        if (json[i] == ',') count++;
      }
      return count;
    } catch (e) {
      return null;
    }
  }

  /// 获取汉字的拼音（带声调标记，如 "hǎo"）
  Future<String?> getPinyin(String character) async {
    final pinyinList = await queryPinyinsByCharacter(character);
    if (pinyinList.isEmpty) return null;
    return pinyinList.first.pinyin;
  }

  /// 获取汉字的拼音带声调编号（如 "hao 3"）
  Future<String?> getPinyinWithToneNumber(String character) async {
    final pinyinList = await queryPinyinsByCharacter(character);
    if (pinyinList.isEmpty) return null;
    return pinyinList.first.pinyinWithToneNumber;
  }

  /// 获取汉字的所有拼音带声调编号
  Future<List<String>> getAllPinyinWithToneNumber(String character) async {
    final pinyinList = await queryPinyinsByCharacter(character);
    return pinyinList
        .where((p) => p.pinyinWithToneNumber != null)
        .map((p) => p.pinyinWithToneNumber!)
        .toList();
  }

  /// 批量获取笔画数
  Future<Map<String, int>> batchGetStrokeCounts(List<String> characters) async {
    final Map<String, int> result = {};

    for (final char in characters) {
      final strokeCount = await getStrokeCount(char);
      result[char] = strokeCount ?? 7; // 默认7画
    }

    return result;
  }
}
