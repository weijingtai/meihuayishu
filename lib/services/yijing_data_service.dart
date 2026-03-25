import 'package:logger/logger.dart';
import 'package:yijing/yijing_api.dart';

import '../models/gua.dart';

/// 易经数据服务
/// 适配 xuan-yijing 的 API，提供卦辞、爻辞等数据查询
class YijingDataService {
  final Logger _logger = Logger();
  final YijingApi _api = YijingApi();
  bool _initialized = false;

  /// 初始化服务
  Future<void> init() async {
    if (_initialized) return;
    try {
      await _api.init();
      _initialized = true;
      _logger.i('YijingDataService initialized');
    } catch (e) {
      _logger.e('Failed to initialize YijingDataService: $e');
      rethrow;
    }
  }

  /// 检查是否已初始化
  void _checkInitialized() {
    if (!_initialized) {
      throw StateError('YijingDataService not initialized. Call init() first.');
    }
  }

  /// 根据卦象获取完整数据
  /// [gua] 梅花易数卦象模型
  /// [hasChangingYao] 是否有动爻（本卦为true，互卦变卦为false）
  Future<GuaFullData?> getGuaFullData(Gua gua) async {
    _checkInitialized();
    try {
      final binary = gua.toBinaryString();
      final response = await _api.getFullGuaData(binary);
      if (response.code != 200 || response.data == null) {
        _logger.w('Failed to get gua data: ${response.error}');
        return null;
      }
      return GuaFullData.fromApiData(response.data!, gua.changingYao);
    } catch (e) {
      _logger.e('Error getting gua full data: $e');
      return null;
    }
  }

  /// 批量获取卦象数据
  /// 返回 Map<卦二进制编码, GuaFullData>
  Future<Map<String, GuaFullData>> getMultipleGuaData(List<Gua> guaList) async {
    _checkInitialized();
    final result = <String, GuaFullData>{};
    for (final gua in guaList) {
      final data = await getGuaFullData(gua);
      if (data != null) {
        result[gua.toBinaryString()] = data;
      }
    }
    return result;
  }

  /// 释放资源
  Future<void> dispose() async {
    if (_initialized) {
      await _api.dispose();
      _initialized = false;
    }
  }
}

/// 卦象完整数据（包含爻辞信息）
class GuaFullData {
  final String binary;
  final int seq;
  final String name;
  final String fullname;
  final String? guaCi; // 卦辞
  final String? tuanCi; // 彖辞
  final String? xiangCi; // 象辞
  final List<YaoCiItem> yaoCiList; // 爻辞列表
  final int? changingYao; // 动爻位置（1-6），null表示无动爻

  const GuaFullData({
    required this.binary,
    required this.seq,
    required this.name,
    required this.fullname,
    this.guaCi,
    this.tuanCi,
    this.xiangCi,
    required this.yaoCiList,
    this.changingYao,
  });

  factory GuaFullData.fromApiData(GuaData apiData, int changingYao) {
    return GuaFullData(
      binary: apiData.binary,
      seq: apiData.seq,
      name: apiData.name,
      fullname: apiData.fullname,
      guaCi: apiData.guaCi,
      tuanCi: apiData.tuanCi,
      xiangCi: apiData.xiangCi,
      yaoCiList:
          apiData.yaoCi?.map((y) => YaoCiItem.fromApiData(y)).toList() ?? [],
      changingYao: changingYao,
    );
  }

  /// 是否有动爻
  bool get hasChangingYao => changingYao != null;

  /// 获取指定位置的爻辞（1-6）
  YaoCiItem? getYaoAt(int position) {
    if (position < 1 || position > 6) return null;
    final index = position - 1;
    if (index >= yaoCiList.length) return null;
    return yaoCiList[index];
  }

  /// 检查指定位置是否为动爻
  bool isChangingYao(int position) => changingYao == position;
}

/// 爻辞数据项
class YaoCiItem {
  final int seqInGua; // 爻在卦中的序号（1-6）
  final String yaoName; // 爻名（如"初九"、"六二"）
  final String? yaoCi; // 爻辞
  final String? xiangCi; // 象辞

  const YaoCiItem({
    required this.seqInGua,
    required this.yaoName,
    this.yaoCi,
    this.xiangCi,
  });

  factory YaoCiItem.fromApiData(YaoData apiData) {
    return YaoCiItem(
      seqInGua: apiData.seqInGua,
      yaoName: apiData.yaoName,
      yaoCi: apiData.yaoCi,
      xiangCi: apiData.xiangCi,
    );
  }
}
