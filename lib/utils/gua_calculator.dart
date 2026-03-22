import '../models/gua.dart';

/// 卦象计算工具类
class GuaCalculator {
  /// 先天八卦数映射 (数字 -> 卦名)
  static const Map<int, String> xianTianNumbers = {
    1: '乾',
    2: '兑',
    3: '离',
    4: '震',
    5: '巽',
    6: '坎',
    7: '艮',
    8: '坤',
  };

  /// 八卦数字映射 (卦名 -> 数字)
  static const Map<String, int> guaToNumber = {
    '乾': 1,
    '兑': 2,
    '离': 3,
    '震': 4,
    '巽': 5,
    '坎': 6,
    '艮': 7,
    '坤': 8,
  };

  /// 数字转卦名 (处理余数为0的情况)
  static String numberToGuaName(int number) {
    int n = number % 8;
    if (n == 0) n = 8;
    return xianTianNumbers[n] ?? '坤';
  }

  /// 卦名转数字
  static int guaNameToNumber(String name) {
    return guaToNumber[name] ?? 8;
  }

  /// 计算变卦
  static Gua calculateChangedGua(Gua original) {
    String binary = original.changedYaoBinary;
    String lowerBinary = binary.substring(0, 3);
    String upperBinary = binary.substring(3, 6);

    return Gua.fromBinary(upperBinary, lowerBinary, original.changingYao);
  }

  /// 计算互卦
  /// 互卦：本卦2-4爻为下卦，3-5爻为上卦
  static Gua calculateHuGua(Gua original) {
    String binary = original.toBinaryString();

    // 从下往上：第2,3,4爻组成下卦，第3,4,5爻组成上卦
    // 注意：binary字符串索引0是第1爻（最下面）
    String lowerBinary = binary[1] + binary[2] + binary[3]; // 2,3,4爻
    String upperBinary = binary[2] + binary[3] + binary[4]; // 3,4,5爻

    return Gua.fromBinary(upperBinary, lowerBinary, original.changingYao);
  }

  /// 地支数映射
  static const Map<String, int> diZhiNumbers = {
    '子': 1,
    '丑': 2,
    '寅': 3,
    '卯': 4,
    '辰': 5,
    '巳': 6,
    '午': 7,
    '未': 8,
    '申': 9,
    '酉': 10,
    '戌': 11,
    '亥': 12,
  };

  /// 获取地支对应的数字
  static int getDiZhiNumber(String diZhi) {
    return diZhiNumbers[diZhi] ?? 1;
  }

  /// 五行属性
  static const Map<String, String> guaWuXing = {
    '乾': '金',
    '兑': '金',
    '离': '火',
    '震': '木',
    '巽': '木',
    '坎': '水',
    '艮': '土',
    '坤': '土',
  };

  /// 获取卦的五行属性
  static String getWuXing(String guaName) {
    return guaWuXing[guaName] ?? '土';
  }

  /// 后天八卦方位
  static const Map<String, String> houTianDirection = {
    '乾': '西北',
    '兑': '西',
    '离': '南',
    '震': '东',
    '巽': '东南',
    '坎': '北',
    '艮': '东北',
    '坤': '西南',
  };

  /// 获取卦的方位
  static String getDirection(String guaName) {
    return houTianDirection[guaName] ?? '中';
  }
}
