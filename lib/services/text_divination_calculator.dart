import '../models/divination_result.dart';
import '../models/divination_method.dart';
import '../models/text_divination_method.dart';
import '../models/character_analysis.dart';
import '../models/gua.dart';
import '../services/stroke_service.dart';
import '../services/text_tone_service.dart';
import '../utils/gua_calculator.dart';

/// 文字起卦计算器
class TextDivinationCalculator {
  final StrokeService _strokeService = StrokeService();
  final TextToneService _toneService = TextToneService();

  /// 分析文本
  TextAnalysisSummary analyzeText(String text) {
    final chars = text.split('');
    final analyses = chars.map((char) {
      final stroke = _strokeService.getStrokeCount(char);
      final pinyinInfo = _toneService.getFullPinyinInfo(char);

      return CharacterAnalysis(
        character: char,
        strokeCount: stroke > 0 ? stroke : 1, // 默认1画
        modernTone: pinyinInfo.tone > 0 ? pinyinInfo.tone : 1, // 默认1声
        pinyinWithTone: pinyinInfo.pinyinWithTone,
        pinyinWithoutTone: pinyinInfo.pinyinWithoutTone,
        isPing: pinyinInfo.tone == 1 || pinyinInfo.tone == 2,
      );
    }).toList();

    return TextAnalysisSummary(characters: analyses);
  }

  /// 按字数起卦
  DivinationResult calculateByCharCount(String text) {
    final chars = text.split('');
    final charCount = chars.length;

    int upperValue, lowerValue;

    if (charCount % 2 == 0) {
      // 偶数：平分
      final half = charCount ~/ 2;
      upperValue = half;
      lowerValue = half;
    } else {
      // 奇数：天轻地重
      upperValue = (charCount - 1) ~/ 2;
      lowerValue = (charCount + 1) ~/ 2;
    }

    final changingYao = charCount % 6;

    return _createResult(
      upperValue: upperValue,
      lowerValue: lowerValue,
      changingYao: changingYao,
    );
  }

  /// 按笔画起卦
  DivinationResult calculateByStroke(String text) {
    final summary = analyzeText(text);
    final charCount = summary.charCount;

    int upperValue, lowerValue;

    if (charCount == 1) {
      // 单字：使用总笔画作为上卦，时辰作为下卦
      upperValue = summary.totalStrokes;
      final now = DateTime.now();
      final hourZhi = _getHourZhi(now.hour);
      lowerValue = GuaCalculator.getDiZhiNumber(hourZhi);
    } else if (charCount % 2 == 0) {
      // 偶数：平分笔画
      upperValue = summary.firstHalfStrokes;
      lowerValue = summary.secondHalfStrokes;
    } else {
      // 奇数：前少后多
      upperValue = summary.firstHalfStrokes;
      lowerValue = summary.secondHalfStrokes;
    }

    final changingYao = summary.totalStrokes % 6;

    return _createResult(
      upperValue: upperValue,
      lowerValue: lowerValue,
      changingYao: changingYao,
    );
  }

  /// 按现代四声起卦
  DivinationResult calculateByModernTone(String text) {
    final summary = analyzeText(text);

    final upperValue = summary.firstHalfTones;
    final lowerValue = summary.secondHalfTones;
    final changingYao = summary.totalToneValue % 6;

    return _createResult(
      upperValue: upperValue,
      lowerValue: lowerValue,
      changingYao: changingYao,
    );
  }

  /// 按古代平仄起卦
  DivinationResult calculateByAncientTone(String text) {
    final summary = analyzeText(text);

    final upperValue = summary.firstHalfPingZe;
    final lowerValue = summary.secondHalfPingZe;
    final changingYao = summary.totalPingZeValue % 6;

    return _createResult(
      upperValue: upperValue,
      lowerValue: lowerValue,
      changingYao: changingYao,
    );
  }

  /// 根据方法起卦
  DivinationResult calculate(String text, TextDivinationMethod method) {
    switch (method) {
      case TextDivinationMethod.byCharCount:
        return calculateByCharCount(text);
      case TextDivinationMethod.byStroke:
        return calculateByStroke(text);
      case TextDivinationMethod.byModernTone:
        return calculateByModernTone(text);
      case TextDivinationMethod.byAncientTone:
        return calculateByAncientTone(text);
    }
  }

  /// 创建起卦结果
  DivinationResult _createResult({
    required int upperValue,
    required int lowerValue,
    required int changingYao,
  }) {
    final upperGuaNum = upperValue % 8;
    final lowerGuaNum = lowerValue % 8;
    final yao = changingYao % 6;

    final originalGua = Gua.fromNumbers(
      upperGuaNum == 0 ? 8 : upperGuaNum,
      lowerGuaNum == 0 ? 8 : lowerGuaNum,
      yao == 0 ? 6 : yao,
    );

    final changedGua = GuaCalculator.calculateChangedGua(originalGua);
    final huGua = GuaCalculator.calculateHuGua(originalGua);

    return DivinationResult(
      method: DivinationMethod.text,
      originalGua: originalGua,
      changedGua: changedGua,
      huGua: huGua,
      timestamp: DateTime.now(),
      params: {
        'upperValue': upperValue,
        'lowerValue': lowerValue,
        'changingYao': changingYao,
      },
    );
  }

  /// 获取时辰地支
  String _getHourZhi(int hour) {
    if (hour >= 23 || hour < 1) return '子';
    if (hour >= 1 && hour < 3) return '丑';
    if (hour >= 3 && hour < 5) return '寅';
    if (hour >= 5 && hour < 7) return '卯';
    if (hour >= 7 && hour < 9) return '辰';
    if (hour >= 9 && hour < 11) return '巳';
    if (hour >= 11 && hour < 13) return '午';
    if (hour >= 13 && hour < 15) return '未';
    if (hour >= 15 && hour < 17) return '申';
    if (hour >= 17 && hour < 19) return '酉';
    if (hour >= 19 && hour < 21) return '戌';
    if (hour >= 21 && hour < 23) return '亥';
    return '子';
  }
}
