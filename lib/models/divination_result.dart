import 'gua.dart';
import 'divination_method.dart';

/// 起卦结果模型
class DivinationResult {
  /// 起卦方法
  final DivinationMethod method;

  /// 本卦
  final Gua originalGua;

  /// 变卦
  final Gua changedGua;

  /// 互卦
  final Gua? huGua;

  /// 起卦时间
  final DateTime timestamp;

  /// 起卦参数
  final Map<String, dynamic> params;

  /// 所问之事
  final String? question;

  const DivinationResult({
    required this.method,
    required this.originalGua,
    required this.changedGua,
    this.huGua,
    required this.timestamp,
    this.params = const {},
    this.question,
  });

  /// 从 Map 创建
  factory DivinationResult.fromMap(Map<String, dynamic> map) {
    return DivinationResult(
      method: DivinationMethod.values.byName(map['method']),
      originalGua: Gua.fromMap(map['originalGua']),
      changedGua: Gua.fromMap(map['changedGua']),
      huGua: map['huGua'] != null ? Gua.fromMap(map['huGua']) : null,
      timestamp: DateTime.parse(map['timestamp']),
      params: Map<String, dynamic>.from(map['params'] ?? {}),
      question: map['question'],
    );
  }

  /// 转换为 Map
  Map<String, dynamic> toMap() {
    return {
      'method': method.name,
      'originalGua': originalGua.toMap(),
      'changedGua': changedGua.toMap(),
      'huGua': huGua?.toMap(),
      'timestamp': timestamp.toIso8601String(),
      'params': params,
      'question': question,
    };
  }

  @override
  String toString() {
    return 'DivinationResult(method: ${method.displayName}, '
        'originalGua: $originalGua, changedGua: $changedGua, '
        'huGua: $huGua, timestamp: $timestamp)';
  }
}
