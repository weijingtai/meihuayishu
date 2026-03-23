/// 文字起卦方法枚举
enum TextDivinationMethod {
  /// 按字数起卦（平分字数法）
  byCharCount('按字数', '平分字数，适用于长文本'),

  /// 按笔画起卦（精细方案）
  byStroke('按笔画', '根据笔画数起卦，适用于短文本'),

  /// 按现代四声起卦
  byModernTone('现代四声', '根据普通话四声起卦'),

  /// 按古代平仄起卦
  byAncientTone('古代平仄', '根据平仄声调起卦'),

  /// 按句数起卦（长文本推荐）
  bySentenceCount('按句数', '按标点分句，以句数起卦，长文本推荐'),

  /// 按句子字数起卦
  bySentenceLength('按句子字数', '按标点分句，以每句字数起卦，保留文本结构');

  final String displayName;
  final String description;

  const TextDivinationMethod(this.displayName, this.description);

  /// 是否适用于长文本
  bool get isLongTextOnly => this == byCharCount || this == bySentenceCount;

  /// 是否需要拼音数据
  bool get needsPinyin => this == byModernTone || this == byAncientTone;

  /// 是否为长文本推荐方案
  bool get isLongTextRecommended =>
      this == bySentenceCount || this == bySentenceLength;
}
