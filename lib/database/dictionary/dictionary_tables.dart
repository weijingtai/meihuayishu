import 'package:drift/drift.dart';

/// 汉字主表
@DataClassName('DictionaryCharacter')
class Characters extends Table {
  @override
  String get tableName => 'characters';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get character => text()();
  TextColumn get definition => text().nullable()();
  TextColumn get radical => text().nullable()();
  TextColumn get decomposition => text().nullable()();
  TextColumn get matchesJson => text().nullable()();
}

/// 拼音表
@DataClassName('DictionaryPinyin')
class Pinyins extends Table {
  @override
  String get tableName => 'pinyin';

  IntColumn get id => integer().autoIncrement()();
  IntColumn get characterId => integer()();
  TextColumn get pinyin => text()();
  TextColumn get pinyinWithToneNumber => text().nullable()();
}

/// 字源表
@DataClassName('DictionaryEtymology')
class Etymologies extends Table {
  @override
  String get tableName => 'etymology';

  IntColumn get id => integer().autoIncrement()();
  IntColumn get characterId => integer()();
  TextColumn get type => text().nullable()();
  TextColumn get hint => text().nullable()();
}
