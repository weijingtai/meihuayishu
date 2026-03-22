import 'dart:math';
import 'package:logger/logger.dart';

import '../models/gua.dart';
import '../models/divination_result.dart';
import '../models/divination_method.dart';
import '../utils/gua_calculator.dart';

/// 梅花易数核心服务
class MeiHuaService {
  final Logger _logger = Logger();

  /// 先天起卦法：根据数字数组起卦
  DivinationResult xianTianDivination(
    List<int> numbers, {
    DivinationMethod method = DivinationMethod.number,
    String? question,
  }) {
    if (numbers.isEmpty) {
      throw ArgumentError('数字数组不能为空');
    }

    // 将数字分成两组
    int mid = (numbers.length / 2).ceil();
    List<int> upperNumbers = numbers.sublist(0, mid);
    List<int> lowerNumbers = numbers.sublist(mid);

    // 计算上下卦
    int upperSum = upperNumbers.fold(0, (a, b) => a + b);
    int lowerSum = lowerNumbers.fold(0, (a, b) => a + b);

    // 如果只有一组数字，则用总和计算
    if (lowerNumbers.isEmpty) {
      lowerSum = upperSum;
    }

    // 计算动爻（总和除以6）
    int totalSum = upperSum + lowerSum;
    int changingYao = totalSum % 6;
    if (changingYao == 0) changingYao = 6;

    // 创建本卦
    Gua originalGua = Gua.fromNumbers(upperSum, lowerSum, changingYao);

    // 计算变卦和互卦
    Gua changedGua = GuaCalculator.calculateChangedGua(originalGua);
    Gua huGua = GuaCalculator.calculateHuGua(originalGua);

    return DivinationResult(
      method: method,
      originalGua: originalGua,
      changedGua: changedGua,
      huGua: huGua,
      timestamp: DateTime.now(),
      params: {'numbers': numbers, 'upperSum': upperSum, 'lowerSum': lowerSum},
      question: question,
    );
  }

  /// 后天起卦法：根据物象和时辰起卦
  DivinationResult houTianDivination({
    required int upperGuaNum,
    required int lowerGuaNum,
    required int timeZhiNum,
    DivinationMethod method = DivinationMethod.text,
    String? question,
  }) {
    // 后天起卦动爻 = (上卦数 + 下卦数 + 时辰数) % 6
    int changingYao = (upperGuaNum + lowerGuaNum + timeZhiNum) % 6;
    if (changingYao == 0) changingYao = 6;

    // 创建本卦
    Gua originalGua = Gua.fromNumbers(upperGuaNum, lowerGuaNum, changingYao);

    // 计算变卦和互卦
    Gua changedGua = GuaCalculator.calculateChangedGua(originalGua);
    Gua huGua = GuaCalculator.calculateHuGua(originalGua);

    return DivinationResult(
      method: method,
      originalGua: originalGua,
      changedGua: changedGua,
      huGua: huGua,
      timestamp: DateTime.now(),
      params: {
        'upperGuaNum': upperGuaNum,
        'lowerGuaNum': lowerGuaNum,
        'timeZhiNum': timeZhiNum,
      },
      question: question,
    );
  }

  /// 时间起卦（先天法）
  DivinationResult timeDivination({
    required int yearZhiNum,
    required int lunarMonth,
    required int lunarDay,
    required int hourZhiNum,
    String? question,
  }) {
    // 上卦 = (年支数 + 农历月 + 农历日) % 8
    int upperSum = yearZhiNum + lunarMonth + lunarDay;
    int upperGuaNum = upperSum % 8;
    if (upperGuaNum == 0) upperGuaNum = 8;

    // 下卦 = (年支数 + 农历月 + 农历日 + 时支数) % 8
    int lowerSum = upperSum + hourZhiNum;
    int lowerGuaNum = lowerSum % 8;
    if (lowerGuaNum == 0) lowerGuaNum = 8;

    // 动爻 = (年支数 + 农历月 + 农历日 + 时支数) % 6
    int changingYao = lowerSum % 6;
    if (changingYao == 0) changingYao = 6;

    // 创建本卦
    Gua originalGua = Gua.fromNumbers(upperGuaNum, lowerGuaNum, changingYao);

    // 计算变卦和互卦
    Gua changedGua = GuaCalculator.calculateChangedGua(originalGua);
    Gua huGua = GuaCalculator.calculateHuGua(originalGua);

    return DivinationResult(
      method: DivinationMethod.time,
      originalGua: originalGua,
      changedGua: changedGua,
      huGua: huGua,
      timestamp: DateTime.now(),
      params: {
        'yearZhiNum': yearZhiNum,
        'lunarMonth': lunarMonth,
        'lunarDay': lunarDay,
        'hourZhiNum': hourZhiNum,
      },
      question: question,
    );
  }

  /// 手动起卦
  DivinationResult manualDivination({
    required int upperGuaNum,
    required int lowerGuaNum,
    required int changingYao,
    String? question,
  }) {
    // 创建本卦
    Gua originalGua = Gua.fromNumbers(upperGuaNum, lowerGuaNum, changingYao);

    // 计算变卦和互卦
    Gua changedGua = GuaCalculator.calculateChangedGua(originalGua);
    Gua huGua = GuaCalculator.calculateHuGua(originalGua);

    return DivinationResult(
      method: DivinationMethod.manual,
      originalGua: originalGua,
      changedGua: changedGua,
      huGua: huGua,
      timestamp: DateTime.now(),
      params: {
        'upperGuaNum': upperGuaNum,
        'lowerGuaNum': lowerGuaNum,
        'changingYao': changingYao,
      },
      question: question,
    );
  }

  /// 随机起卦
  DivinationResult randomDivination({String? question}) {
    final random = Random();
    int upperGuaNum = random.nextInt(8) + 1;
    int lowerGuaNum = random.nextInt(8) + 1;
    int changingYao = random.nextInt(6) + 1;

    // 创建本卦
    Gua originalGua = Gua.fromNumbers(upperGuaNum, lowerGuaNum, changingYao);

    // 计算变卦和互卦
    Gua changedGua = GuaCalculator.calculateChangedGua(originalGua);
    Gua huGua = GuaCalculator.calculateHuGua(originalGua);

    return DivinationResult(
      method: DivinationMethod.random,
      originalGua: originalGua,
      changedGua: changedGua,
      huGua: huGua,
      timestamp: DateTime.now(),
      params: {
        'upperGuaNum': upperGuaNum,
        'lowerGuaNum': lowerGuaNum,
        'changingYao': changingYao,
      },
      question: question,
    );
  }

  /// 获取卦的二进制表示
  String getGuaBinary(int guaNumber) {
    const guaBinaries = [
      '111', // 乾
      '110', // 兑
      '101', // 离
      '100', // 震
      '011', // 巽
      '010', // 坎
      '001', // 艮
      '000', // 坤
    ];
    return guaBinaries[guaNumber % 8];
  }
}
