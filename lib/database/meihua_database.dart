import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'tables/meihua_gua_infos.dart';

part 'meihua_database.g.dart';

/// 梅花易数数据库
/// 只包含梅花易数专用表
@DriftDatabase(tables: [
  MeiHuaGuaInfos,
])
class MeiHuaDatabase extends _$MeiHuaDatabase {
  MeiHuaDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        // 版本迁移逻辑
      },
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'meihua_divination.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
