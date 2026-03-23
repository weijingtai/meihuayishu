/// 拼音声调转换工具
class PinyinToneConverter {
  /// 声调标记映射 (无声调元音 -> 带声调元音)
  static const Map<String, List<String>> _toneVowels = {
    'a': ['ā', 'á', 'ǎ', 'à'],
    'e': ['ē', 'é', 'ě', 'è'],
    'i': ['ī', 'í', 'ǐ', 'ì'],
    'o': ['ō', 'ó', 'ǒ', 'ò'],
    'u': ['ū', 'ú', 'ǔ', 'ù'],
    'v': ['ǖ', 'ǘ', 'ǚ', 'ǜ'],
    'A': ['Ā', 'Á', 'Ǎ', 'À'],
    'E': ['Ē', 'É', 'Ě', 'È'],
    'I': ['Ī', 'Í', 'Ǐ', 'Ì'],
    'O': ['Ō', 'Ó', 'Ǒ', 'Ò'],
    'U': ['Ū', 'Ú', 'Ǔ', 'Ù'],
  };

  /// 带声调元音到无声调元音的反向映射
  static final Map<String, String> _vowelFromToned = _buildReverseMap();

  static Map<String, String> _buildReverseMap() {
    final map = <String, String>{};
    for (final entry in _toneVowels.entries) {
      for (final toned in entry.value) {
        map[toned] = entry.key;
      }
    }
    return map;
  }

  /// 移除拼音中的声调标记，返回无声调拼音
  static String removeToneMark(String pinyin) {
    final buffer = StringBuffer();
    for (final char in pinyin.split('')) {
      buffer.write(_vowelFromToned[char] ?? char);
    }
    return buffer.toString();
  }

  /// 为无声调拼音添加声调标记
  /// [pinyin] 无声调拼音，如 "hao", "ni"
  /// [tone] 声调 1-4
  static String addToneMark(String pinyin, int tone) {
    if (tone < 1 || tone > 4) return pinyin;

    // 先移除已有的声调标记
    final cleanPinyin = removeToneMark(pinyin);
    final toneIndex = tone - 1;

    // 声调标记的优先级：a > o > e > i > u > v
    const priority = ['a', 'o', 'e', 'i', 'u', 'v'];

    for (final vowel in priority) {
      final index = cleanPinyin.indexOf(vowel);
      if (index != -1) {
        // 找到需要加声调的元音
        final tonedVowel = _toneVowels[vowel]?[toneIndex];
        if (tonedVowel != null) {
          return cleanPinyin.substring(0, index) +
              tonedVowel +
              cleanPinyin.substring(index + 1);
        }
      }
    }

    // 特殊处理：iu 组合时，声调加在 u 上
    if (cleanPinyin.contains('iu')) {
      final index = cleanPinyin.lastIndexOf('u');
      final tonedVowel = _toneVowels['u']?[toneIndex];
      if (tonedVowel != null) {
        return cleanPinyin.substring(0, index) +
            tonedVowel +
            cleanPinyin.substring(index + 1);
      }
    }

    return cleanPinyin;
  }

  /// 获取带指定声调的拼音
  /// [originalPinyin] 原始拼音（可能带声调标记）
  /// [tone] 目标声调 1-4
  static String convertTone(String originalPinyin, int tone) {
    // 先移除原有声调，再添加新声调
    final cleanPinyin = removeToneMark(originalPinyin);
    return addToneMark(cleanPinyin, tone);
  }

  /// 从带声调拼音中提取声调编号
  static int extractTone(String pinyin) {
    for (final char in pinyin.split('')) {
      for (final entry in _toneVowels.entries) {
        final index = entry.value.indexOf(char);
        if (index != -1) {
          return index + 1;
        }
      }
    }
    return 0; // 无声调
  }
}
