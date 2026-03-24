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
import 'divination_result_page.dart';
import 'meihua_history_page.dart';

class MeiHuaDivinationPage extends StatefulWidget {
  const MeiHuaDivinationPage({super.key});

  @override
  State<MeiHuaDivinationPage> createState() => _MeiHuaDivinationPageState();
}

class _MeiHuaDivinationPageState extends State<MeiHuaDivinationPage>
    with SingleTickerProviderStateMixin {
  DivinationResult? _result;
  late TabController _tabController;

  // 卜问输入
  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _detailController = TextEditingController();
  String? _question;
  String? _detail;
  bool _isExpanded = false;

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
    _questionController.dispose();
    _detailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('梅花易数'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MeiHuaHistoryPage(),
                ),
              );
            },
            tooltip: '历史记录',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 卜问输入区域
            _buildQuestionInput(),

            const SizedBox(height: 16),

            // 起卦方案选择区域
            Card(
              elevation: 2,
              child: Column(
                children: [
                  TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    tabs: const [
                      Tab(text: '时空'),
                      Tab(text: '报数'),
                      Tab(text: '文字'),
                      Tab(text: '手动'),
                    ],
                  ),
                  SizedBox(
                    height: 400,
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildTimeTab(),
                        _buildNumberTab(),
                        _buildTextTab(),
                        _buildManualTab(),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 起卦按钮
            ElevatedButton.icon(
              onPressed: _result != null ? _navigateToResultPage : null,
              icon: const Icon(Icons.auto_awesome),
              label: const Text('查看结果'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建卜问输入区域
  Widget _buildQuestionInput() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.help_outline, color: Colors.blue.shade700),
                const SizedBox(width: 8),
                Text(
                  '卜问内容',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _questionController,
              maxLength: 24,
              decoration: InputDecoration(
                labelText: '占测问题',
                hintText: '请输入您要占测的问题（0-24字）',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixIcon: _questionController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _questionController.clear();
                            _question = null;
                          });
                        },
                      )
                    : null,
              ),
              onChanged: (value) {
                setState(() {
                  _question = value.isNotEmpty ? value : null;
                });
              },
            ),
            const SizedBox(height: 8),
            // 展开/折叠按钮
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _isExpanded ? Icons.expand_less : Icons.expand_more,
                          size: 16,
                          color: Colors.blue.shade700,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _isExpanded ? '收起' : '添加详细描述',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.blue.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // 详细描述输入框
            if (_isExpanded) ...[
              const SizedBox(height: 12),
              TextField(
                controller: _detailController,
                maxLength: 240,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: '详细描述（可选）',
                  hintText: '请输入详细描述（0-240字）',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _detail = value.isNotEmpty ? value : null;
                  });
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// 导航到结果页面
  void _navigateToResultPage() {
    if (_result == null) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DivinationResultPage(
          result: _result!,
          question: _question,
        ),
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
          const SizedBox(height: 16),
          if (_result != null)
            Text(
              '已起卦，点击下方按钮查看结果',
              style: TextStyle(color: Colors.green.shade700),
            ),
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
                color: _inputNumber.isEmpty ? Colors.grey : Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
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
            onPressed: _inputNumber.isNotEmpty ? _generateGuaByNumber : null,
            child: const Text('起卦'),
          ),
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
        Map<String, dynamic>? sentenceAnalysis;

        int countNonPunctuation(String text) {
          const punctuationChars = '。！？，、；：""'
              '（）【】《》…—·～'
              '.,!?;:\'\"()[]{}<>@#\$%^&*_-+=|\\\\/~`\s';
          final punctuationPattern = RegExp('[$punctuationChars]');
          return text.replaceAll(punctuationPattern, '').length;
        }

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
          final analysis = calculator.getSentenceAnalysis(value);

          if (isLong) {
            setLocalState(() {
              inputText = value;
              strokeCounts = [];
              pinyinWithTones = [];
              totalStrokes = 0;
              isLoading = false;
              sentenceAnalysis = analysis;
            });
          } else {
            final counts = await strokeService.getStrokeCounts(value);
            final total = await strokeService.getTotalStrokeCount(value);

            final List<String> pinyins = [];
            for (var char in value.split('')) {
              final pinyin =
                  await strokeService.getPinyinWithToneNumber(char);
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

          setState(() {
            _toneOverrides = {};
          });
        }

        final isLong = isLongText(inputText);
        final availableMethods = TextDivinationMethod.values;

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                '文字起卦',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
          ),
        );
      },
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
          const Text(
            '手动起卦',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          GuaSelectorWidget(
            title: '选择上卦',
            selectedGua: _selectedUpperGua,
            onGuaSelected: (num) {
              setState(() => _selectedUpperGua = num);
            },
          ),
          const SizedBox(height: 16),
          GuaSelectorWidget(
            title: '选择下卦',
            selectedGua: _selectedLowerGua,
            onGuaSelected: (num) {
              setState(() => _selectedLowerGua = num);
            },
          ),
          const SizedBox(height: 16),
          YaoSelectorWidget(
            title: '选择动爻',
            selectedYao: _selectedYao,
            onYaoSelected: (yao) {
              setState(() => _selectedYao = yao);
            },
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _canGenerateManual ? _generateManualGua : null,
            child: const Text('起卦'),
          ),
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
