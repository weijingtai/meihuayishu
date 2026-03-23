import 'package:flutter/material.dart';

/// 起卦流程数据模型
class DivinationFlowStep {
  final String title;
  final String description;
  final Map<String, dynamic> variables;
  final String? formula;

  const DivinationFlowStep({
    required this.title,
    required this.description,
    this.variables = const {},
    this.formula,
  });
}

/// 起卦流程展示组件
class DivinationFlowDisplay extends StatelessWidget {
  final String methodName;
  final List<DivinationFlowStep> steps;
  final Map<String, dynamic>? finalResult;

  const DivinationFlowDisplay({
    super.key,
    required this.methodName,
    required this.steps,
    this.finalResult,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 方法名称
            Row(
              children: [
                Icon(Icons.auto_awesome, color: Colors.deepPurple.shade400),
                const SizedBox(width: 8),
                Text(
                  methodName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            // 流程步骤
            ...steps.asMap().entries.map((entry) {
              final index = entry.key;
              final step = entry.value;
              return _buildStep(index + 1, step);
            }),
            // 最终结果
            if (finalResult != null) ...[
              const Divider(height: 24),
              _buildFinalResult(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStep(int stepNum, DivinationFlowStep step) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 步骤编号
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: Colors.deepPurple.shade100,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$stepNum',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple.shade700,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // 步骤内容
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 步骤标题
                Text(
                  step.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                // 步骤描述
                Text(
                  step.description,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade700,
                  ),
                ),
                // 变量值
                if (step.variables.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  _buildVariables(step.variables),
                ],
                // 公式
                if (step.formula != null) ...[
                  const SizedBox(height: 8),
                  _buildFormula(step.formula!),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVariables(Map<String, dynamic> variables) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: variables.entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              children: [
                Text(
                  '${entry.key}: ',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.blue.shade700,
                  ),
                ),
                Text(
                  '${entry.value}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFormula(String formula) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange.shade100),
      ),
      child: Row(
        children: [
          Icon(Icons.functions, size: 16, color: Colors.orange.shade700),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              formula,
              style: TextStyle(
                fontSize: 12,
                fontFamily: 'monospace',
                color: Colors.orange.shade800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinalResult() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '最终结果',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.green.shade200),
          ),
          child: Column(
            children: finalResult!.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      entry.key,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.green.shade700,
                      ),
                    ),
                    Text(
                      '${entry.value}',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade800,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

/// 起卦流程工厂类 - 提供各种起卦方法的流程数据
class DivinationFlowFactory {
  /// 地支名称
  static const List<String> zhiNames = [
    '子',
    '丑',
    '寅',
    '卯',
    '辰',
    '巳',
    '午',
    '未',
    '申',
    '酉',
    '戌',
    '亥'
  ];

  /// 农历月份名称
  static const List<String> lunarMonthNames = [
    '正月',
    '二月',
    '三月',
    '四月',
    '五月',
    '六月',
    '七月',
    '八月',
    '九月',
    '十月',
    '冬月',
    '腊月'
  ];

  /// 农历日名称
  static String getLunarDayName(int day) {
    const prefix = ['初', '十', '廿', '三'];
    const digits = ['一', '二', '三', '四', '五', '六', '七', '八', '九', '十'];

    if (day <= 10) {
      return '初${digits[day - 1]}';
    } else if (day < 20) {
      return '十${digits[day - 11]}';
    } else if (day == 20) {
      return '二十';
    } else if (day < 30) {
      return '廿${digits[day - 21]}';
    } else if (day == 30) {
      return '三十';
    }
    return '$day';
  }

  /// 农历起卦流程（带详细转换）
  static DivinationFlowDisplay lunarDivinationFlow({
    required int yearZhiNum,
    required String yearZhiName,
    required int lunarMonth,
    required String lunarMonthName,
    required int lunarDay,
    required String lunarDayName,
    required int hourZhiNum,
    required String hourZhiName,
    required int upperGuaNum,
    required int lowerGuaNum,
    required int changingYao,
  }) {
    final upperSum = yearZhiNum + lunarMonth + lunarDay;
    final lowerSum = upperSum + hourZhiNum;

    return DivinationFlowDisplay(
      methodName: '农历起卦',
      steps: [
        const DivinationFlowStep(
          title: '获取农历时间',
          description: '获取或输入农历年月日时',
        ),
        DivinationFlowStep(
          title: '年 → 地支序数',
          description: '取生肖地支序数',
          variables: {
            '地支': yearZhiName,
            '序数': yearZhiNum,
          },
          formula: '$yearZhiName → $yearZhiNum',
        ),
        DivinationFlowStep(
          title: '月 → 农历月数',
          description: '取农历月份',
          variables: {
            '农历月': lunarMonthName,
            '月数': lunarMonth,
          },
          formula: '$lunarMonthName → $lunarMonth',
        ),
        DivinationFlowStep(
          title: '日 → 农历日数',
          description: '取农历日数',
          variables: {
            '农历日': lunarDayName,
            '日数': lunarDay,
          },
          formula: '$lunarDayName → $lunarDay',
        ),
        DivinationFlowStep(
          title: '时 → 时辰序数',
          description: '取时辰地支序数',
          variables: {
            '时辰': hourZhiName,
            '序数': hourZhiNum,
          },
          formula: '$hourZhiName → $hourZhiNum',
        ),
        DivinationFlowStep(
          title: '计算上卦',
          description: '(年 + 月 + 日) ÷ 8 取余',
          variables: {
            '总和': '$yearZhiNum + $lunarMonth + $lunarDay = $upperSum',
          },
          formula:
              '上卦 = ($upperSum) % 8 = ${upperGuaNum == 0 ? 8 : upperGuaNum}',
        ),
        DivinationFlowStep(
          title: '计算下卦',
          description: '(年 + 月 + 日 + 时) ÷ 8 取余',
          variables: {
            '总和': '$upperSum + $hourZhiNum = $lowerSum',
          },
          formula:
              '下卦 = ($lowerSum) % 8 = ${lowerGuaNum == 0 ? 8 : lowerGuaNum}',
        ),
        DivinationFlowStep(
          title: '计算动爻',
          description: '(年 + 月 + 日 + 时) ÷ 6 取余',
          formula: '动爻 = ($lowerSum) % 6 = $changingYao',
        ),
      ],
      finalResult: {
        '上卦数': upperGuaNum,
        '下卦数': lowerGuaNum,
        '动爻': changingYao,
      },
    );
  }

  /// 时间起卦流程
  static DivinationFlowDisplay timeDivinationFlow({
    required int yearZhiNum,
    required int lunarMonth,
    required int lunarDay,
    required int hourZhiNum,
    required int upperGuaNum,
    required int lowerGuaNum,
    required int changingYao,
  }) {
    final upperSum = yearZhiNum + lunarMonth + lunarDay;
    final lowerSum = upperSum + hourZhiNum;

    return DivinationFlowDisplay(
      methodName: '时间起卦',
      steps: [
        const DivinationFlowStep(
          title: '获取用户输入',
          description: '输入或自动获取当前时间（农历年月日时）',
        ),
        DivinationFlowStep(
          title: '转换为数字变量',
          description: '将时间转换为对应的数字',
          variables: {
            '年支数': yearZhiNum,
            '农历月': lunarMonth,
            '农历日': lunarDay,
            '时支数': hourZhiNum,
          },
        ),
        DivinationFlowStep(
          title: '计算上卦',
          description: '前三个数之和取余',
          variables: {
            '总和': '$yearZhiNum + $lunarMonth + $lunarDay = $upperSum',
          },
          formula:
              '上卦 = ($upperSum) % 8 = ${upperGuaNum == 0 ? 8 : upperGuaNum}',
        ),
        DivinationFlowStep(
          title: '计算下卦',
          description: '四个数之和取余',
          variables: {
            '总和': '$upperSum + $hourZhiNum = $lowerSum',
          },
          formula:
              '下卦 = ($lowerSum) % 8 = ${lowerGuaNum == 0 ? 8 : lowerGuaNum}',
        ),
        DivinationFlowStep(
          title: '计算动爻',
          description: '四个数之和除以6取余',
          formula: '动爻 = ($lowerSum) % 6 = $changingYao',
        ),
      ],
      finalResult: {
        '上卦数': upperGuaNum,
        '下卦数': lowerGuaNum,
        '动爻': changingYao,
      },
    );
  }

  /// 报数起卦流程
  static DivinationFlowDisplay numberDivinationFlow({
    required List<int> numbers,
    required int upperGuaNum,
    required int lowerGuaNum,
    required int changingYao,
  }) {
    final mid = (numbers.length / 2).ceil();
    final upperNumbers = numbers.sublist(0, mid);
    final lowerNumbers = numbers.length > mid ? numbers.sublist(mid) : <int>[];
    final upperSum = upperNumbers.fold(0, (a, b) => a + b);
    final lowerSum = lowerNumbers.isNotEmpty
        ? lowerNumbers.fold(0, (a, b) => a + b)
        : upperSum;
    final totalSum = upperSum + lowerSum;

    return DivinationFlowDisplay(
      methodName: '报数起卦',
      steps: [
        DivinationFlowStep(
          title: '获取用户输入',
          description: '用户输入数字序列',
          variables: {
            '数字序列': numbers.join(', '),
          },
        ),
        DivinationFlowStep(
          title: '分割数字',
          description: '将数字序列平分为两组',
          variables: {
            '上卦数字': upperNumbers.join(', '),
            '下卦数字': lowerNumbers.isNotEmpty ? lowerNumbers.join(', ') : '同上卦',
          },
        ),
        DivinationFlowStep(
          title: '计算上卦',
          description: '上半部分数字之和取余',
          variables: {
            '上卦和': upperSum,
          },
          formula:
              '上卦 = ($upperSum) % 8 = ${upperGuaNum == 0 ? 8 : upperGuaNum}',
        ),
        DivinationFlowStep(
          title: '计算下卦',
          description: '下半部分数字之和取余',
          variables: {
            '下卦和': lowerSum,
          },
          formula:
              '下卦 = ($lowerSum) % 8 = ${lowerGuaNum == 0 ? 8 : lowerGuaNum}',
        ),
        DivinationFlowStep(
          title: '计算动爻',
          description: '所有数字之和除以6取余',
          variables: {
            '总和': totalSum,
          },
          formula: '动爻 = ($totalSum) % 6 = $changingYao',
        ),
      ],
      finalResult: {
        '上卦数': upperGuaNum,
        '下卦数': lowerGuaNum,
        '动爻': changingYao,
      },
    );
  }

  /// 按字数起卦流程
  static DivinationFlowDisplay charCountFlow({
    required String text,
    required int charCount,
    required int upperGuaNum,
    required int lowerGuaNum,
    required int changingYao,
  }) {
    final isEven = charCount % 2 == 0;
    final half = charCount ~/ 2;

    return DivinationFlowDisplay(
      methodName: '按字数起卦',
      steps: [
        DivinationFlowStep(
          title: '获取用户输入',
          description: '输入文字内容',
          variables: {
            '输入文字': text,
          },
        ),
        DivinationFlowStep(
          title: '统计字数',
          description: '计算文字的总字数（去除标点）',
          variables: {
            '总字数': charCount,
            '奇偶性': isEven ? '偶数' : '奇数',
          },
        ),
        DivinationFlowStep(
          title: '计算上下卦',
          description: isEven ? '偶数：平分字数' : '奇数：天轻地重',
          variables: isEven
              ? {
                  '上卦值': half,
                  '下卦值': half,
                }
              : {
                  '上卦值': (charCount - 1) ~/ 2,
                  '下卦值': (charCount + 1) ~/ 2,
                },
          formula: isEven
              ? '上卦 = 下卦 = $half % 8 = $upperGuaNum'
              : '上卦 = (${(charCount - 1) ~/ 2}) % 8, 下卦 = (${(charCount + 1) ~/ 2}) % 8',
        ),
        DivinationFlowStep(
          title: '计算动爻',
          description: '总字数除以6取余',
          formula: '动爻 = $charCount % 6 = $changingYao',
        ),
      ],
      finalResult: {
        '上卦数': upperGuaNum,
        '下卦数': lowerGuaNum,
        '动爻': changingYao,
      },
    );
  }

  /// 按笔画起卦流程
  static DivinationFlowDisplay strokeFlow({
    required String text,
    required List<int> strokeCounts,
    required int totalStrokes,
    required int upperGuaNum,
    required int lowerGuaNum,
    required int changingYao,
  }) {
    final mid = (strokeCounts.length / 2).ceil();
    final firstHalf = strokeCounts.sublist(0, mid);
    final secondHalf =
        strokeCounts.length > mid ? strokeCounts.sublist(mid) : <int>[];
    final firstSum = firstHalf.fold(0, (a, b) => a + b);
    final secondSum =
        secondHalf.isNotEmpty ? secondHalf.fold(0, (a, b) => a + b) : firstSum;

    return DivinationFlowDisplay(
      methodName: '按笔画起卦',
      steps: [
        DivinationFlowStep(
          title: '获取用户输入',
          description: '输入文字内容',
          variables: {
            '输入文字': text,
          },
        ),
        DivinationFlowStep(
          title: '查询笔画数',
          description: '从字典数据库查询每个字的笔画数',
          variables: {
            '笔画数组': strokeCounts.join(', '),
            '总笔画': totalStrokes,
          },
        ),
        DivinationFlowStep(
          title: '计算上卦',
          description: '前半部分笔画之和取余',
          variables: {
            '前半笔画': firstHalf.join(' + '),
            '前半和': firstSum,
          },
          formula:
              '上卦 = ($firstSum) % 8 = ${upperGuaNum == 0 ? 8 : upperGuaNum}',
        ),
        DivinationFlowStep(
          title: '计算下卦',
          description: '后半部分笔画之和取余',
          variables: {
            '后半笔画': secondHalf.isNotEmpty ? secondHalf.join(' + ') : '同上卦',
            '后半和': secondSum,
          },
          formula:
              '下卦 = ($secondSum) % 8 = ${lowerGuaNum == 0 ? 8 : lowerGuaNum}',
        ),
        DivinationFlowStep(
          title: '计算动爻',
          description: '总笔画除以6取余',
          formula: '动爻 = $totalStrokes % 6 = $changingYao',
        ),
      ],
      finalResult: {
        '上卦数': upperGuaNum,
        '下卦数': lowerGuaNum,
        '动爻': changingYao,
      },
    );
  }

  /// 按音调起卦流程（现代四声）
  static DivinationFlowDisplay toneFlow({
    required String text,
    required List<int> tones,
    required int upperSum,
    required int lowerSum,
    required int totalTone,
    required int upperGuaNum,
    required int lowerGuaNum,
    required int changingYao,
  }) {
    return DivinationFlowDisplay(
      methodName: '按现代四声起卦',
      steps: [
        DivinationFlowStep(
          title: '获取用户输入',
          description: '输入文字内容',
          variables: {
            '输入文字': text,
          },
        ),
        DivinationFlowStep(
          title: '获取音调',
          description: '从数据库查询每个字的声调（1-4声）',
          variables: {
            '音调数组': tones.join(', '),
          },
        ),
        DivinationFlowStep(
          title: '计算上卦',
          description: '前半部分音调之和取余',
          variables: {
            '上卦和': upperSum,
          },
          formula:
              '上卦 = ($upperSum) % 8 = ${upperGuaNum == 0 ? 8 : upperGuaNum}',
        ),
        DivinationFlowStep(
          title: '计算下卦',
          description: '后半部分音调之和取余',
          variables: {
            '下卦和': lowerSum,
          },
          formula:
              '下卦 = ($lowerSum) % 8 = ${lowerGuaNum == 0 ? 8 : lowerGuaNum}',
        ),
        DivinationFlowStep(
          title: '计算动爻',
          description: '所有音调之和除以6取余',
          variables: {
            '总音调': totalTone,
          },
          formula: '动爻 = ($totalTone) % 6 = $changingYao',
        ),
      ],
      finalResult: {
        '上卦数': upperGuaNum,
        '下卦数': lowerGuaNum,
        '动爻': changingYao,
      },
    );
  }

  /// 按句数起卦流程
  static DivinationFlowDisplay sentenceCountFlow({
    required String text,
    required List<String> sentences,
    required int sentenceCount,
    required int upperGuaNum,
    required int lowerGuaNum,
    required int changingYao,
  }) {
    final isEven = sentenceCount % 2 == 0;

    return DivinationFlowDisplay(
      methodName: '按句数起卦',
      steps: [
        DivinationFlowStep(
          title: '获取用户输入',
          description: '输入长文本内容',
          variables: {
            '输入文字': text.length > 20 ? '${text.substring(0, 20)}...' : text,
          },
        ),
        DivinationFlowStep(
          title: '标点分句',
          description: '按标点符号分割为多个句子',
          variables: {
            '句子数量': sentenceCount,
            '句子列表': sentences.map((s) => '"$s"').join(', '),
          },
        ),
        DivinationFlowStep(
          title: '计算上下卦',
          description: isEven ? '偶数：平分句数' : '奇数：天轻地重',
          formula: isEven
              ? '上卦 = 下卦 = ${sentenceCount ~/ 2} % 8 = $upperGuaNum'
              : '上卦 = ${(sentenceCount - 1) ~/ 2} % 8, 下卦 = ${(sentenceCount + 1) ~/ 2} % 8',
        ),
        DivinationFlowStep(
          title: '计算动爻',
          description: '句数除以6取余',
          formula: '动爻 = $sentenceCount % 6 = $changingYao',
        ),
      ],
      finalResult: {
        '上卦数': upperGuaNum,
        '下卦数': lowerGuaNum,
        '动爻': changingYao,
      },
    );
  }

  /// 按句子字数起卦流程
  static DivinationFlowDisplay sentenceLengthFlow({
    required String text,
    required List<String> sentences,
    required List<int> charCounts,
    required int upperSum,
    required int lowerSum,
    required int totalChars,
    required int upperGuaNum,
    required int lowerGuaNum,
    required int changingYao,
  }) {
    return DivinationFlowDisplay(
      methodName: '按句子字数起卦',
      steps: [
        DivinationFlowStep(
          title: '获取用户输入',
          description: '输入长文本内容',
          variables: {
            '输入文字': text.length > 20 ? '${text.substring(0, 20)}...' : text,
          },
        ),
        DivinationFlowStep(
          title: '标点分句',
          description: '按标点符号分割为多个句子',
          variables: {
            '句子数量': sentences.length,
          },
        ),
        DivinationFlowStep(
          title: '统计每句字数',
          description: '去除标点后统计每句的字数',
          variables: {
            '字数数组': charCounts.join(', '),
            '总字数': totalChars,
          },
        ),
        DivinationFlowStep(
          title: '计算上卦',
          description: '前半部分句子字数之和取余',
          variables: {
            '上卦和': upperSum,
          },
          formula:
              '上卦 = ($upperSum) % 8 = ${upperGuaNum == 0 ? 8 : upperGuaNum}',
        ),
        DivinationFlowStep(
          title: '计算下卦',
          description: '后半部分句子字数之和取余',
          variables: {
            '下卦和': lowerSum,
          },
          formula:
              '下卦 = ($lowerSum) % 8 = ${lowerGuaNum == 0 ? 8 : lowerGuaNum}',
        ),
        DivinationFlowStep(
          title: '计算动爻',
          description: '所有句子字数之和除以6取余',
          formula: '动爻 = ($totalChars) % 6 = $changingYao',
        ),
      ],
      finalResult: {
        '上卦数': upperGuaNum,
        '下卦数': lowerGuaNum,
        '动爻': changingYao,
      },
    );
  }

  /// 手动起卦流程
  static DivinationFlowDisplay manualFlow({
    required int upperGuaNum,
    required int lowerGuaNum,
    required int changingYao,
  }) {
    return DivinationFlowDisplay(
      methodName: '手动起卦',
      steps: [
        const DivinationFlowStep(
          title: '获取用户输入',
          description: '用户手动选择上卦、下卦和动爻',
        ),
        DivinationFlowStep(
          title: '直接赋值',
          description: '用户选择的卦数和动爻直接作为起卦参数',
          variables: {
            '上卦': upperGuaNum,
            '下卦': lowerGuaNum,
            '动爻': changingYao,
          },
        ),
      ],
      finalResult: {
        '上卦数': upperGuaNum,
        '下卦数': lowerGuaNum,
        '动爻': changingYao,
      },
    );
  }
}
