import '../models/divination_result.dart';
import '../models/divination_method.dart';
import '../models/text_divination_method.dart';
import '../models/character_analysis.dart';
import '../models/gua.dart';
import '../services/dictionary_stroke_service.dart';
import '../services/text_tone_service.dart';
import '../utils/gua_calculator.dart';

/// 文字起卦计算器
class TextDivinationCalculator {
  final DictionaryStrokeService _strokeService = DictionaryStrokeService();
  final TextToneService _toneService = TextToneService();

  /// 分析文本
  Future<TextAnalysisSummary> analyzeText(String text) async {
    print('开始分析文本: $text');
    final chars = text.split('');
    final strokeCounts = await _strokeService.getStrokeCounts(text);
    print('获取到笔画数: $strokeCounts');

    final analyses = <CharacterAnalysis>[];
    for (int i = 0; i < chars.length; i++) {
      final char = chars[i];
      final stroke = strokeCounts[i];

      // 从数据库获取拼音（带声调标记）和声调编号
      final dbPinyin = await _strokeService.database.getPinyin(char);
      final pinyinWithToneNumber =
          await _strokeService.getPinyinWithToneNumber(char);

      // 解析拼音和声调编号（如 "ni 3" -> pinyin="ni", tone=3）
      String displayPinyin = dbPinyin ?? char;
      int tone = 0;

      if (pinyinWithToneNumber != null) {
        final parts = pinyinWithToneNumber.split(' ');
        if (parts.length == 2) {
          tone = int.tryParse(parts[1]) ?? 0;
        }
      }

      // 如果没有声调编号，使用 lpinyin 库作为备用
      if (tone == 0) {
        final pinyinInfo = _toneService.getFullPinyinInfo(char);
        displayPinyin = pinyinInfo.pinyinWithTone;
        tone = pinyinInfo.tone;
      }

      print('字符: $char, 笔画: $stroke, 拼音: $displayPinyin, 声调: $tone');

      analyses.add(CharacterAnalysis(
        character: char,
        strokeCount: stroke > 0 ? stroke : 1,
        modernTone: tone > 0 ? tone : 1,
        pinyinWithTone: displayPinyin,
        pinyinWithoutTone: _toneService.getPinyinWithoutTone(char),
        isPing: tone == 1 || tone == 2,
      ));
    }

    print('分析完成，共 ${analyses.length} 个字符');
    return TextAnalysisSummary(characters: analyses);
  }

  /// 按字数起卦
  Future<DivinationResult> calculateByCharCount(String text) async {
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
  Future<DivinationResult> calculateByStroke(String text) async {
    final summary = await analyzeText(text);
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
  Future<DivinationResult> calculateByModernTone(String text) async {
    final summary = await analyzeText(text);

    final upperValue = summary.firstHalfTones;
    final lowerValue = summary.secondHalfTones;
    final changingYao = summary.totalToneValue % 6;

    return _createResult(
      upperValue: upperValue,
      lowerValue: lowerValue,
      changingYao: changingYao,
    );
  }

  /// 按现代四声起卦（支持音调覆盖）
  Future<DivinationResult> calculateByModernToneWithOverrides(
    String text,
    Map<String, int> toneOverrides,
  ) async {
    final summary = await analyzeText(text);

    // 使用覆盖的音调计算
    int firstHalfTones = 0;
    int secondHalfTones = 0;
    final mid = (summary.characters.length / 2).ceil();

    for (int i = 0; i < summary.characters.length; i++) {
      final char = summary.characters[i];
      final tone = toneOverrides[char.character] ?? char.modernTone;
      if (i < mid) {
        firstHalfTones += tone;
      } else {
        secondHalfTones += tone;
      }
    }

    final totalToneValue = firstHalfTones + secondHalfTones;
    final changingYao = totalToneValue % 6;

    return _createResult(
      upperValue: firstHalfTones,
      lowerValue: secondHalfTones,
      changingYao: changingYao,
    );
  }

  /// 按古代平仄起卦
  Future<DivinationResult> calculateByAncientTone(String text) async {
    final summary = await analyzeText(text);

    final upperValue = summary.firstHalfPingZe;
    final lowerValue = summary.secondHalfPingZe;
    final changingYao = summary.totalPingZeValue % 6;

    return _createResult(
      upperValue: upperValue,
      lowerValue: lowerValue,
      changingYao: changingYao,
    );
  }

  /// 按标点分句，返回句子列表
  List<String> _splitByPunctuation(String text) {
    // 匹配中英文标点符号作为分隔符
    final punctuationPattern = RegExp(r'[。！？!?；;，,、\.\s]+');
    final sentences = text
        .split(punctuationPattern)
        .where((s) => s.trim().isNotEmpty)
        .map((s) => s.trim())
        .toList();
    return sentences.isNotEmpty ? sentences : [text];
  }

  /// 按句数起卦（长文本推荐）
  Future<DivinationResult> calculateBySentenceCount(String text) async {
    final sentences = _splitByPunctuation(text);
    final sentenceCount = sentences.length;

    int upperValue, lowerValue;

    if (sentenceCount % 2 == 0) {
      // 偶数：平分
      final half = sentenceCount ~/ 2;
      upperValue = half;
      lowerValue = half;
    } else {
      // 奇数：天轻地重
      upperValue = (sentenceCount - 1) ~/ 2;
      lowerValue = (sentenceCount + 1) ~/ 2;
    }

    final changingYao = sentenceCount % 6;

    return _createResult(
      upperValue: upperValue,
      lowerValue: lowerValue,
      changingYao: changingYao,
    );
  }

  /// 按句子中文字数起卦
  Future<DivinationResult> calculateBySentenceLength(String text) async {
    final sentences = _splitByPunctuation(text);

    // 计算每个句子的字数（去除标点和空格）
    final charCounts = sentences.map((sentence) {
      final cleanSentence =
          sentence.replaceAll(RegExp(r'[\p{P}\p{S}\s]', unicode: true), '');
      return cleanSentence.length;
    }).toList();

    // 使用字数数组起卦
    int totalChars = charCounts.fold(0, (sum, count) => sum + count);

    // 上卦 = 前半部分字数之和
    // 下卦 = 后半部分字数之和
    int upperValue = 0;
    int lowerValue = 0;
    final mid = (charCounts.length / 2).ceil();

    for (int i = 0; i < charCounts.length; i++) {
      if (i < mid) {
        upperValue += charCounts[i];
      } else {
        lowerValue += charCounts[i];
      }
    }

    // 如果只有一个句子，上下卦相同
    if (charCounts.length == 1) {
      lowerValue = upperValue;
    }

    final changingYao = totalChars % 6;

    return _createResult(
      upperValue: upperValue,
      lowerValue: lowerValue,
      changingYao: changingYao,
    );
  }

  /// 获取句子分割结果（用于UI展示）
  Map<String, dynamic> getSentenceAnalysis(String text) {
    final sentences = _splitByPunctuation(text);
    final charCounts = sentences.map((sentence) {
      final cleanSentence =
          sentence.replaceAll(RegExp(r'[\p{P}\p{S}\s]', unicode: true), '');
      return cleanSentence.length;
    }).toList();

    return {
      'sentenceCount': sentences.length,
      'sentences': sentences,
      'charCounts': charCounts,
      'totalChars': charCounts.fold(0, (sum, count) => sum + count),
    };
  }

  /// 根据方法起卦
  Future<DivinationResult> calculate(
      String text, TextDivinationMethod method) async {
    switch (method) {
      case TextDivinationMethod.byCharCount:
        return await calculateByCharCount(text);
      case TextDivinationMethod.byStroke:
        return await calculateByStroke(text);
      case TextDivinationMethod.byModernTone:
        return await calculateByModernTone(text);
      case TextDivinationMethod.byAncientTone:
        return await calculateByAncientTone(text);
      case TextDivinationMethod.bySentenceCount:
        return await calculateBySentenceCount(text);
      case TextDivinationMethod.bySentenceLength:
        return await calculateBySentenceLength(text);
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
