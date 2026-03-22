/// 起卦方法枚举
enum DivinationMethod {
  /// 时间起卦（先天法 - 自动）
  time('时空', '根据当前时间自动起卦'),

  /// 报数起卦（先天法 - 手动）
  number('报数', '根据数字起卦'),

  /// 文字起卦（后天法 - 笔画）
  text('文字', '根据文字笔画起卦'),

  /// 手动起卦（直接录入）
  manual('手动', '手动选择卦象'),

  /// 随机起卦（备用）
  random('随机', '随机生成卦象');

  final String displayName;
  final String description;

  const DivinationMethod(this.displayName, this.description);

  /// 是否为先天起卦法
  bool get isXianTian => this == time || this == number || this == random;

  /// 是否为后天起卦法
  bool get isHouTian => this == text;
}
