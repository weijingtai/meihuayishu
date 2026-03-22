/// 字符分析结果
class CharacterAnalysis {
  /// 字符
  final String character;

  /// 笔画数
  final int strokeCount;

  /// 现代四声 (1-4)
  final int modernTone;

  /// 拼音（带音标）如：lǚ, mā, má
  final String pinyinWithTone;

  /// 拼音（无声调）如：lu, ma
  final String pinyinWithoutTone;

  /// 是否平声（1、2声为平，3、4声为仄）
  final bool isPing;

  /// 平仄数值（平=1，仄=2）
  int get pingZeValue => isPing ? 1 : 2;

  /// 四声显示文本
  String get toneDisplay {
    const toneNames = ['', '阴平', '阳平', '上声', '去声'];
    if (modernTone >= 1 && modernTone <= 4) {
      return toneNames[modernTone];
    }
    return '未知';
  }

  /// 平仄显示文本
  String get pingZeDisplay => isPing ? '平' : '仄';

  /// 拼音显示（带声调编号）
  String get pinyinDisplay => '$pinyinWithTone$modernTone';

  const CharacterAnalysis({
    required this.character,
    required this.strokeCount,
    required this.modernTone,
    required this.pinyinWithTone,
    required this.pinyinWithoutTone,
    required this.isPing,
  });

  @override
  String toString() {
    return 'CharacterAnalysis(char: $character, stroke: $strokeCount, tone: $modernTone, pingZe: $pingZeDisplay)';
  }
}

/// 文字分析汇总
class TextAnalysisSummary {
  /// 所有字符分析
  final List<CharacterAnalysis> characters;

  /// 总笔画数
  int get totalStrokes => characters.fold(0, (sum, c) => sum + c.strokeCount);

  /// 平声数量
  int get pingCount => characters.where((c) => c.isPing).length;

  /// 仄声数量
  int get zeCount => characters.where((c) => !c.isPing).length;

  /// 四声值列表
  List<int> get toneValues => characters.map((c) => c.modernTone).toList();

  /// 平仄值列表
  List<int> get pingZeValues => characters.map((c) => c.pingZeValue).toList();

  /// 总四声值
  int get totalToneValue => toneValues.fold(0, (sum, v) => sum + v);

  /// 总平仄值
  int get totalPingZeValue => pingZeValues.fold(0, (sum, v) => sum + v);

  const TextAnalysisSummary({required this.characters});

  /// 字数
  int get charCount => characters.length;

  /// 前半字符
  List<CharacterAnalysis> get firstHalf {
    if (characters.isEmpty) return [];
    final mid = (characters.length / 2).ceil();
    return characters.sublist(0, mid);
  }

  /// 后半字符
  List<CharacterAnalysis> get secondHalf {
    if (characters.isEmpty) return [];
    final mid = (characters.length / 2).ceil();
    return characters.sublist(mid);
  }

  /// 前半笔画总和
  int get firstHalfStrokes =>
      firstHalf.fold(0, (sum, c) => sum + c.strokeCount);

  /// 后半笔画总和
  int get secondHalfStrokes =>
      secondHalf.fold(0, (sum, c) => sum + c.strokeCount);

  /// 前半四声值总和
  int get firstHalfTones => firstHalf.fold(0, (sum, c) => sum + c.modernTone);

  /// 后半四声值总和
  int get secondHalfTones => secondHalf.fold(0, (sum, c) => sum + c.modernTone);

  /// 前半平仄值总和
  int get firstHalfPingZe => firstHalf.fold(0, (sum, c) => sum + c.pingZeValue);

  /// 后半平仄值总和
  int get secondHalfPingZe =>
      secondHalf.fold(0, (sum, c) => sum + c.pingZeValue);
}
