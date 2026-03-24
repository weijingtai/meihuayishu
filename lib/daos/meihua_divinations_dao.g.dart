// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meihua_divinations_dao.dart';

// ignore_for_file: type=lint
mixin _$MeiHuaDivinationsDaoMixin on DatabaseAccessor<MeiHuaDatabase> {
  $MeiHuaGuaInfosTable get meiHuaGuaInfos => attachedDatabase.meiHuaGuaInfos;
  MeiHuaDivinationsDaoManager get managers => MeiHuaDivinationsDaoManager(this);
}

class MeiHuaDivinationsDaoManager {
  final _$MeiHuaDivinationsDaoMixin _db;
  MeiHuaDivinationsDaoManager(this._db);
  $$MeiHuaGuaInfosTableTableManager get meiHuaGuaInfos =>
      $$MeiHuaGuaInfosTableTableManager(
          _db.attachedDatabase, _db.meiHuaGuaInfos);
}
