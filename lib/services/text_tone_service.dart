import 'package:lpinyin/lpinyin.dart';
import 'package:logger/logger.dart';

/// 注音服务
/// 提供汉字的拼音、声调、平仄信息
class TextToneService {
  final Logger _logger = Logger();

  /// 获取字符的拼音（带音标）
  /// 如：lǚ, mā, má, mǎ, mà
  String getPinyinWithTone(String char) {
    if (char.isEmpty) return '';

    // 检查是否是汉字
    final code = char.codeUnitAt(0);
    if (code < 0x4E00 || code > 0x9FFF) {
      return char; // 非汉字直接返回
    }

    try {
      return PinyinHelper.getPinyinE(
        char,
        separator: '',
        defPinyin: char,
      );
    } catch (e) {
      _logger.w('获取拼音失败: $char, error: $e');
      return char;
    }
  }

  /// 获取字符的拼音（无声调）
  String getPinyinWithoutTone(String char) {
    if (char.isEmpty) return '';

    final code = char.codeUnitAt(0);
    if (code < 0x4E00 || code > 0x9FFF) {
      return char;
    }

    try {
      return PinyinHelper.getPinyinE(
        char,
        separator: '',
        format: PinyinFormat.WITHOUT_TONE,
        defPinyin: char,
      );
    } catch (e) {
      _logger.w('获取拼音失败: $char, error: $e');
      return char;
    }
  }

  /// 获取声调数字（1-4，0表示轻声）
  int getToneNumber(String char) {
    if (char.isEmpty) return 0;

    final code = char.codeUnitAt(0);
    if (code < 0x4E00 || code > 0x9FFF) {
      return 0;
    }

    try {
      final pinyin = PinyinHelper.getPinyinE(
        char,
        separator: '',
        defPinyin: char,
      );

      return _extractToneFromPinyin(pinyin);
    } catch (e) {
      _logger.w('获取声调失败: $char, error: $e');
      return 0;
    }
  }

  /// 从带音标拼音中提取声调数字
  int _extractToneFromPinyin(String pinyin) {
    // 带音标的元音及其声调
    const toneMap = {
      'ā': 1,
      'á': 2,
      'ǎ': 3,
      'à': 4,
      'ē': 1,
      'é': 2,
      'ě': 3,
      'è': 4,
      'ī': 1,
      'í': 2,
      'ǐ': 3,
      'ì': 4,
      'ō': 1,
      'ó': 2,
      'ǒ': 3,
      'ò': 4,
      'ū': 1,
      'ú': 2,
      'ǔ': 3,
      'ù': 4,
      'ǖ': 1,
      'ǘ': 2,
      'ǚ': 3,
      'ǜ': 4,
      'ü': 0,
      'Ā': 1,
      'Á': 2,
      'Ǎ': 3,
      'À': 4,
      'Ē': 1,
      'É': 2,
      'Ě': 3,
      'È': 4,
      'Ī': 1,
      'Í': 2,
      'Ǐ': 3,
      'Ì': 4,
      'Ō': 1,
      'Ó': 2,
      'Ǒ': 3,
      'Ò': 4,
      'Ū': 1,
      'Ú': 2,
      'Ǔ': 3,
      'Ù': 4,
    };

    for (final char in pinyin.split('')) {
      if (toneMap.containsKey(char)) {
        return toneMap[char]!;
      }
    }

    return 0; // 轻声或无声调
  }

  /// 判断是否平声（1、2声为平）
  bool isPingSheng(String char) {
    final tone = getToneNumber(char);
    return tone == 1 || tone == 2;
  }

  /// 获取平仄值（平=1，仄=2）
  int getPingZeValue(String char) {
    return isPingSheng(char) ? 1 : 2;
  }

  /// 获取完整的拼音信息
  ({
    String char,
    String pinyinWithTone,
    String pinyinWithoutTone,
    int tone,
    bool isPing
  }) getFullPinyinInfo(String char) {
    final pinyinWithTone = getPinyinWithTone(char);
    final pinyinWithoutTone = getPinyinWithoutTone(char);
    final tone = getToneNumber(char);

    return (
      char: char,
      pinyinWithTone: pinyinWithTone,
      pinyinWithoutTone: pinyinWithoutTone,
      tone: tone,
      isPing: tone == 1 || tone == 2,
    );
  }

  /// 批量获取分析结果
  List<
      ({
        String char,
        String pinyinWithTone,
        String pinyinWithoutTone,
        int tone,
        bool isPing
      })> analyzeText(String text) {
    return text.split('').map((char) {
      return getFullPinyinInfo(char);
    }).toList();
  }
}
