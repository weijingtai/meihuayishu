import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/meihua_service.dart';
import '../services/dictionary_stroke_service.dart';
import '../services/text_divination_calculator.dart';
import '../models/divination_result.dart';
import '../models/text_divination_method.dart';
import '../widgets/gua_display_widget.dart';
import '../widgets/gua_selector_widget.dart';
import '../widgets/yao_selector_widget.dart';
import '../utils/pinyin_tone_converter.dart';

class MeiHuaDivinationPage extends StatefulWidget {
  const MeiHuaDivinationPage({super.key});

  @override
  State<MeiHuaDivinationPage> createState() => _MeiHuaDivinationPageState();
}

class _MeiHuaDivinationPageState extends State<MeiHuaDivinationPage>
    with SingleTickerProviderStateMixin {
  DivinationResult? _result;
  late TabController _tabController;

  // 手动起卦状态
  int? _selectedUpperGua;
  int? _selectedLowerGua;
  int? _selectedYao;

  // 报数起卦状态
  String _inputNumber = '';

  // 文字起卦状态
  String _inputText = '';
  // 用户修改的音调映射 (字符 -> 音调 1-4)
  Map<String, int> _toneOverrides = {};
  // 长文本阈值 N
  int _longTextThreshold = 10;
  // 选中的文字起卦方法
  TextDivinationMethod _selectedTextMethod = TextDivinationMethod.byStroke;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadLongTextThreshold();
  }

  // 从本地存储加载长文本阈值
  Future<void> _loadLongTextThreshold() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _longTextThreshold = prefs.getInt('long_text_threshold') ?? 10;
    });
  }

  // 保存长文本阈值到本地存储
  Future<void> _saveLongTextThreshold(int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('long_text_threshold', value);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('梅花易数'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '时空'),
            Tab(text: '报数'),
            Tab(text: '文字'),
            Tab(text: '手动'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTimeTab(),
          _buildNumberTab(),
          _buildTextTab(),
          _buildManualTab(),
        ],
      ),
    );
  }

  /// 时空起卦Tab
  Widget _buildTimeTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text(
                    '时空起卦',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '根据当前时间自动起卦',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _generateGuaByTime,
                    icon: const Icon(Icons.access_time),
                    label: const Text('一键起卦'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          if (_result != null) GuaDisplayWidget(result: _result!),
        ],
      ),
    );
  }

  /// 报数起卦Tab
  Widget _buildNumberTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text(
                    '报数起卦',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _inputNumber.isEmpty ? '请输入数字...' : _inputNumber,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color:
                            _inputNumber.isEmpty ? Colors.grey : Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  GridView.count(
                    shrinkWrap: true,
                    crossAxisCount: 3,
                    childAspectRatio: 1.5,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    children: [
                      for (int i = 1; i <= 9; i++) _buildNumberButton('$i'),
                      _buildActionButton('清除', () {
                        setState(() => _inputNumber = '');
                      }),
                      _buildNumberButton('0'),
                      _buildActionButton('删除', () {
                        if (_inputNumber.isNotEmpty) {
                          setState(() {
                            _inputNumber = _inputNumber.substring(
                                0, _inputNumber.length - 1);
                          });
                        }
                      }),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed:
                        _inputNumber.isNotEmpty ? _generateGuaByNumber : null,
                    child: const Text('起卦'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          if (_result != null) GuaDisplayWidget(result: _result!),
        ],
      ),
    );
  }

  Widget _buildNumberButton(String number) {
    return ElevatedButton(
      onPressed: () {
        setState(() => _inputNumber += number);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),
      child: Text(number, style: const TextStyle(fontSize: 20)),
    );
  }

  Widget _buildActionButton(String label, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey.shade200,
        foregroundColor: Colors.black87,
      ),
      child: Text(label),
    );
  }

  /// 文字起卦Tab
  Widget _buildTextTab() {
    final strokeService = DictionaryStrokeService();
    final calculator = TextDivinationCalculator();
    final textController = TextEditingController();

    return StatefulBuilder(
      builder: (context, setLocalState) {
        String inputText = '';
        List<int> strokeCounts = [];
        List<String> pinyinWithTones = [];
        int totalStrokes = 0;
        bool isLoading = false;
        // 句子分析结果
        Map<String, dynamic>? sentenceAnalysis;

        // 计算非标点符号的文字数量
        int countNonPunctuation(String text) {
          final punctuationPattern = RegExp(r'[\p{P}\p{S}\s]', unicode: true);
          return text.replaceAll(punctuationPattern, '').length;
        }

        // 判断是否为长文本
        bool isLongText(String text) {
          return countNonPunctuation(text) > _longTextThreshold;
        }

        Future<void> updateAnalysis(String value) async {
          if (value.isEmpty) {
            setLocalState(() {
              inputText = '';
              strokeCounts = [];
              pinyinWithTones = [];
              totalStrokes = 0;
              isLoading = false;
              sentenceAnalysis = null;
            });
            return;
          }

          setLocalState(() {
            isLoading = true;
          });

          final isLong = isLongText(value);

          // 获取句子分析（始终获取）
          final analysis = calculator.getSentenceAnalysis(value);

          if (isLong) {
            // 长文本：只获取句子分析，不计算笔画和音调
            setLocalState(() {
              inputText = value;
              strokeCounts = [];
              pinyinWithTones = [];
              totalStrokes = 0;
              isLoading = false;
              sentenceAnalysis = analysis;
            });
          } else {
            // 短文本：获取笔画数和拼音
            final counts = await strokeService.getStrokeCounts(value);
            final total = await strokeService.getTotalStrokeCount(value);

            final List<String> pinyins = [];
            for (var char in value.split('')) {
              final pinyin = await strokeService.getPinyinWithToneNumber(char);
              pinyins.add(pinyin ?? char);
            }

            setLocalState(() {
              inputText = value;
              strokeCounts = counts;
              pinyinWithTones = pinyins;
              totalStrokes = total;
              isLoading = false;
              sentenceAnalysis = analysis;
            });
          }

          // 重置音调修改
          setState(() {
            _toneOverrides = {};
          });
        }

        final isLong = isLongText(inputText);

        // 可用的起卦方法
        final availableMethods = isLong
            ? TextDivinationMethod.values
                .where((m) =>
                    m.isLongTextRecommended ||
                    m == TextDivinationMethod.byCharCount)
                .toList()
            : TextDivinationMethod.values;

        // 如果当前方法在长文本模式下不可用，自动切换
        if (isLong && !availableMethods.contains(_selectedTextMethod)) {
          _selectedTextMethod = TextDivinationMethod.bySentenceCount;
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text(
                        '文字起卦',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        isLong
                            ? '长文本模式 (超过 $_longTextThreshold 字)'
                            : '输入文字，根据笔画/音调起卦',
                        style: TextStyle(
                            color: isLong ? Colors.orange : Colors.grey),
                      ),
                      const SizedBox(height: 12),
                      // 长文本阈值设置
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('长文本阈值: '),
                          SizedBox(
                            width: 60,
                            child: TextField(
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              controller: TextEditingController(
                                  text: _longTextThreshold.toString()),
                              decoration: const InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 8),
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (value) {
                                final n = int.tryParse(value);
                                if (n != null && n > 0) {
                                  setState(() {
                                    _longTextThreshold = n;
                                  });
                                  _saveLongTextThreshold(n);
                                  // 重新分析
                                  updateAnalysis(inputText);
                                }
                              },
                            ),
                          ),
                          const Text(' 字'),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // 起卦方式选择
                      DropdownButtonFormField<TextDivinationMethod>(
                        value: _selectedTextMethod,
                        decoration: const InputDecoration(
                          labelText: '起卦方式',
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                        items: availableMethods.map((method) {
                          return DropdownMenuItem(
                            value: method,
                            child: Text(method.displayName,
                                style: const TextStyle(fontSize: 14)),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _selectedTextMethod = value;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 4),
                      // 方法说明
                      Text(
                        _selectedTextMethod.description,
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey.shade600),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: textController,
                        maxLines: isLong ? 4 : 1,
                        decoration: InputDecoration(
                          labelText: '输入文字',
                          hintText: isLong ? '请输入长文本...' : '请输入汉字',
                          border: const OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          updateAnalysis(value);
                        },
                      ),
                      const SizedBox(height: 16),
                      if (isLoading)
                        const CircularProgressIndicator()
                      else if (inputText.isNotEmpty) ...[
                        // 长文本模式：显示句子分析
                        if (isLong && sentenceAnalysis != null) ...[
                          _buildSentenceAnalysisCard(sentenceAnalysis!),
                        ],
                        // 短文本模式：显示每个字的详细信息
                        if (!isLong) ...[
                          _buildCharacterAnalysisCard(
                            inputText: inputText,
                            strokeCounts: strokeCounts,
                            pinyinWithTones: pinyinWithTones,
                            totalStrokes: totalStrokes,
                          ),
                        ],
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: inputText.isNotEmpty && !isLoading
                              ? () {
                                  _generateGuaByTextWithMethod(
                                      inputText, _selectedTextMethod);
                                }
                              : null,
                          child: Text(isLong ? '长文本起卦' : '起卦'),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              if (_result != null) GuaDisplayWidget(result: _result!),
            ],
          ),
        );
      },
    );
  }

  /// 构建句子分析卡片
  Widget _buildSentenceAnalysisCard(Map<String, dynamic> analysis) {
    final sentenceCount = analysis['sentenceCount'] as int;
    final sentences = analysis['sentences'] as List<String>;
    final charCounts = analysis['charCounts'] as List<int>;
    final totalChars = analysis['totalChars'] as int;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '句子分析',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade700,
                ),
              ),
              Text(
                '共 $totalChars 字',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '共 $sentenceCount 句',
            style: const TextStyle(fontSize: 13),
          ),
          const SizedBox(height: 4),
          // 显示每句字数
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: List.generate(sentenceCount, (index) {
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  children: [
                    Text(
                      '第${index + 1}句',
                      style:
                          TextStyle(fontSize: 10, color: Colors.grey.shade600),
                    ),
                    Text(
                      '${charCounts[index]}字',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  /// 构建字符分析卡片（短文本）
  Widget _buildCharacterAnalysisCard({
    required String inputText,
    required List<int> strokeCounts,
    required List<String> pinyinWithTones,
    required int totalStrokes,
  }) {
    return Column(
      children: [
        // 每个字的详细信息卡片
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: inputText.split('').asMap().entries.map((entry) {
            final index = entry.key;
            final char = entry.value;
            final strokes =
                index < strokeCounts.length ? strokeCounts[index] : 0;
            final pinyin =
                index < pinyinWithTones.length ? pinyinWithTones[index] : char;

            // 获取用户修改后的音调
            final originalTone = pinyin.isNotEmpty
                ? (int.tryParse(pinyin[pinyin.length - 1]) ?? 0)
                : 0;
            final currentTone = _toneOverrides[char] ?? originalTone;
            final isPing = currentTone == 1 || currentTone == 2;

            // 获取无声调拼音
            final basePinyin = pinyin.isNotEmpty
                ? pinyin.substring(
                    0, pinyin.length - (originalTone > 0 ? 1 : 0))
                : char;
            final displayPinyin = _toneOverrides.containsKey(char)
                ? PinyinToneConverter.convertTone(basePinyin, currentTone)
                : pinyin;

            return Container(
              width: 100,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    char,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$strokes画',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // 拼音和音调在同一行
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        displayPinyin,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.blue.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _toneOverrides[char] = (currentTone % 4) + 1;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: Colors.blue.shade200),
                          ),
                          child: Text(
                            '$currentTone',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.blue.shade700,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: isPing ? Colors.blue.shade50 : Colors.red.shade50,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      isPing ? '平' : '仄',
                      style: TextStyle(
                        fontSize: 12,
                        color:
                            isPing ? Colors.blue.shade700 : Colors.red.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        // 总笔画数
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '总笔画数: ',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '$totalStrokes',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _generateGuaByTextWithMethod(
      String text, TextDivinationMethod method) async {
    if (text.isEmpty) return;

    final calculator = TextDivinationCalculator();
    final result = await calculator.calculate(text, method);

    setState(() {
      _result = result;
    });
  }

  /// 手动起卦Tab
  Widget _buildManualTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GuaSelectorWidget(
            title: '选择上卦',
            selectedGua: _selectedUpperGua,
            onGuaSelected: (num) {
              setState(() => _selectedUpperGua = num);
            },
          ),
          const SizedBox(height: 24),
          GuaSelectorWidget(
            title: '选择下卦',
            selectedGua: _selectedLowerGua,
            onGuaSelected: (num) {
              setState(() => _selectedLowerGua = num);
            },
          ),
          const SizedBox(height: 24),
          YaoSelectorWidget(
            title: '选择动爻',
            selectedYao: _selectedYao,
            onYaoSelected: (yao) {
              setState(() => _selectedYao = yao);
            },
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _canGenerateManual ? _generateManualGua : null,
            child: const Text('起卦'),
          ),
          const SizedBox(height: 24),
          if (_result != null) GuaDisplayWidget(result: _result!),
        ],
      ),
    );
  }

  bool get _canGenerateManual =>
      _selectedUpperGua != null &&
      _selectedLowerGua != null &&
      _selectedYao != null;

  void _generateGuaByTime() {
    final service = context.read<MeiHuaService>();
    final now = DateTime.now();
    setState(() {
      _result = service.xianTianDivination(
        [now.year, now.month, now.day, now.hour],
      );
    });
  }

  void _generateGuaByNumber() {
    if (_inputNumber.isEmpty) return;

    final numbers = _inputNumber.split('').map(int.parse).toList();
    final service = context.read<MeiHuaService>();
    setState(() {
      _result = service.xianTianDivination(numbers);
    });
  }

  Future<void> _generateGuaByText(String text) async {
    if (text.isEmpty) return;

    final strokeService = DictionaryStrokeService();
    final service = context.read<MeiHuaService>();
    final strokeCounts = await strokeService.getStrokeCounts(text);

    // 根据笔画数起卦
    setState(() {
      _result = service.xianTianDivination(strokeCounts);
    });
  }

  void _generateManualGua() {
    if (!_canGenerateManual) return;

    final service = context.read<MeiHuaService>();
    setState(() {
      _result = service.manualDivination(
        upperGuaNum: _selectedUpperGua!,
        lowerGuaNum: _selectedLowerGua!,
        changingYao: _selectedYao!,
      );
    });
  }
}
