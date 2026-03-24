import 'package:flutter/material.dart';
import 'package:meihuayishu/meihuayishu.dart';
import 'package:provider/provider.dart';
import 'package:lunar/lunar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MeiHuaYiShuModule.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '梅花易数演示',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Provider<MeiHuaService>(
        create: (_) => MeiHuaService(),
        child: const HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  DivinationResult? _result;

  // 手动起卦状态
  int? _selectedUpperGua;
  int? _selectedLowerGua;
  int? _selectedYao;
  bool _isXianTianGua = true; // true=先天卦, false=后天卦

  // 报数起卦状态
  String _inputNumber = '';

  // 文字起卦状态
  String _inputText = '';
  TextDivinationMethod _selectedTextMethod = TextDivinationMethod.byStroke;
  TextAnalysisSummary? _textAnalysisSummary;
  bool _isTextLoading = false;
  // 用户修改的音调映射 (字符 -> 音调 1-4)
  Map<String, int> _toneOverrides = {};
  // 长文本阈值
  int _longTextThreshold = 10;
  // 用户修改的句子字数映射 (句子索引 -> 字数)
  Map<int, int> _sentenceCountOverrides = {};
  // 流程显示状态
  bool _showFlow = false;
  // 是否为农历起卦
  bool _isLunarDivination = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
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
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('梅花易数'),
        actions: [
          SettingsButton(
            currentConfig: MeiHuaYiShuModule.themeConfig,
            onConfigChanged: (config) {
              MeiHuaYiShuModule.setThemeConfig(config);
              setState(() {});
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(icon: Icon(Icons.access_time), text: '时空'),
            Tab(icon: Icon(Icons.numbers), text: '报数'),
            Tab(icon: Icon(Icons.text_fields), text: '文字'),
            Tab(icon: Icon(Icons.touch_app), text: '手动'),
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
    final now = DateTime.now();
    // 地支名称
    const zhiNames = [
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
      '亥',
    ];

    return StatefulBuilder(
      builder: (context, setLocalState) {
        // 农历起卦输入值
        int selectedYearZhi = 1; // 默认子年
        int selectedMonth = 1; // 默认正月
        int selectedDay = 1; // 默认初一
        int selectedHourZhi = 1; // 默认子时

        void generateLunarGua() {
          final service = context.read<MeiHuaService>();
          setState(() {
            _result = service.timeDivination(
              yearZhiNum: selectedYearZhi,
              lunarMonth: selectedMonth,
              lunarDay: selectedDay,
              hourZhiNum: selectedHourZhi,
            );
          });
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 当前时间起卦
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 48,
                        color: Colors.deepPurple,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        '当前时间起卦',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '根据当前时间自动起卦\n先天起卦法：先得数，再由数定卦',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            Text(
                              '${now.year}年${now.month}月${now.day}日',
                              style: const TextStyle(fontSize: 16),
                            ),
                            Text(
                              '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _generateGuaByTime,
                              icon: const Icon(Icons.auto_awesome),
                              label: const Text('一键起卦'),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _generateGuaByLunarTime,
                              icon: const Icon(Icons.brightness_3),
                              label: const Text('一键农历'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 农历起卦
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.calendar_month,
                        size: 48,
                        color: Colors.orange,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        '农历起卦',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '输入农历年月日时起卦\n年取地支序数，月日取农历数，时取地支序数',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 16),

                      // 年地支选择
                      _buildLunarSelector(
                        label: '年（地支）',
                        items: List.generate(
                          12,
                          (i) => '${zhiNames[i]}${i + 1}',
                        ),
                        onChanged: (value) {
                          setLocalState(() {
                            selectedYearZhi = value + 1;
                          });
                        },
                      ),
                      const SizedBox(height: 12),

                      // 月选择
                      _buildLunarSelector(
                        label: '月（农历）',
                        items: List.generate(12, (i) => '${i + 1}月'),
                        onChanged: (value) {
                          setLocalState(() {
                            selectedMonth = value + 1;
                          });
                        },
                      ),
                      const SizedBox(height: 12),

                      // 日选择
                      _buildLunarSelector(
                        label: '日（农历）',
                        items: List.generate(30, (i) => '初${i + 1}'),
                        onChanged: (value) {
                          setLocalState(() {
                            selectedDay = value + 1;
                          });
                        },
                      ),
                      const SizedBox(height: 12),

                      // 时地支选择
                      _buildLunarSelector(
                        label: '时（地支）',
                        items: List.generate(
                          12,
                          (i) => '${zhiNames[i]}${i + 1}',
                        ),
                        onChanged: (value) {
                          setLocalState(() {
                            selectedHourZhi = value + 1;
                          });
                        },
                      ),
                      const SizedBox(height: 16),

                      // 公式说明
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.orange.shade200),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '起卦公式：',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange.shade700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '上卦 = (年 + 月 + 日) ÷ 8 取余',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.orange.shade700,
                              ),
                            ),
                            Text(
                              '下卦 = (年 + 月 + 日 + 时) ÷ 8 取余',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.orange.shade700,
                              ),
                            ),
                            Text(
                              '动爻 = (年 + 月 + 日 + 时) ÷ 6 取余',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.orange.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: generateLunarGua,
                          icon: const Icon(Icons.auto_awesome),
                          label: const Text('农历起卦'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              if (_result != null) _buildResultSection(),
            ],
          ),
        );
      },
    );
  }

  /// 构建农历选择器
  Widget _buildLunarSelector({
    required String label,
    required List<String> items,
    required ValueChanged<int> onChanged,
  }) {
    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(label, style: const TextStyle(fontSize: 14)),
        ),
        Expanded(
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                isExpanded: true,
                value: 0,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                items: List.generate(items.length, (i) {
                  return DropdownMenuItem(value: i, child: Text(items[i]));
                }),
                onChanged: (value) {
                  if (value != null) onChanged(value);
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// 报数起卦Tab
  Widget _buildNumberTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const Icon(Icons.numbers, size: 48, color: Colors.deepPurple),
                  const SizedBox(height: 16),
                  const Text(
                    '报数起卦',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '输入数字起卦\n适用于他人报数、偶遇数字、手机号等',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '输入数字',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _inputNumber.isEmpty ? '请输入...' : _inputNumber,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: _inputNumber.isEmpty
                                ? Colors.grey
                                : Colors.black,
                          ),
                        ),
                      ],
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
                      _buildActionButton('清除', Colors.orange, () {
                        setState(() => _inputNumber = '');
                      }),
                      _buildNumberButton('0'),
                      _buildActionButton('删除', Colors.red, () {
                        if (_inputNumber.isNotEmpty) {
                          setState(() {
                            _inputNumber = _inputNumber.substring(
                              0,
                              _inputNumber.length - 1,
                            );
                          });
                        }
                      }),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _inputNumber.isNotEmpty
                          ? _generateGuaByNumber
                          : null,
                      icon: const Icon(Icons.casino),
                      label: const Text('起卦'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          if (_result != null) _buildResultSection(),
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(
        number,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildActionButton(String label, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withValues(alpha: 0.1),
        foregroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(label, style: const TextStyle(fontSize: 16)),
    );
  }

  /// 文字起卦Tab
  Widget _buildTextTab() {
    final calculator = TextDivinationCalculator();

    // 计算非标点符号的文字数量
    int countNonPunctuation(String text) {
      const punctuationChars =
          '。！？，、；：""'
          '（）【】《》…—·～'
          '.,!?;:\'\"()[]{}<>@#\$%^&*_-+=|\\\\/~`\s';
      final punctuationPattern = RegExp('[$punctuationChars]');
      return text.replaceAll(punctuationPattern, '').length;
    }

    // 判断是否为长文本
    bool isLongText(String text) {
      return countNonPunctuation(text) > _longTextThreshold;
    }

    final isLong = isLongText(_inputText);

    // 句子分析
    Map<String, dynamic>? sentenceAnalysis;
    if (_inputText.isNotEmpty) {
      sentenceAnalysis = calculator.getSentenceAnalysis(_inputText);
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const Icon(
                    Icons.text_fields,
                    size: 48,
                    color: Colors.deepPurple,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '文字起卦',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isLong
                        ? '长文本模式 (超过 $_longTextThreshold 字)'
                        : '输入文字，选择起卦方式\n适用于测字、姓名、成语等',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isLong ? Colors.orange : Colors.grey,
                    ),
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
                            text: _longTextThreshold.toString(),
                          ),
                          decoration: const InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 8,
                            ),
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            final n = int.tryParse(value);
                            if (n != null && n > 0) {
                              setState(() {
                                _longTextThreshold = n;
                              });
                            }
                          },
                        ),
                      ),
                      const Text(' 字'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    maxLines: isLong ? 4 : 1,
                    decoration: InputDecoration(
                      labelText: '输入文字',
                      hintText: isLong ? '请输入长文本...' : '请输入汉字',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.edit),
                    ),
                    onChanged: (value) async {
                      setState(() {
                        _inputText = value;
                        _isTextLoading = true;
                        _toneOverrides = {};
                      });

                      if (value.isNotEmpty) {
                        // 长文本跳过字符分析
                        if (isLongText(value)) {
                          setState(() {
                            _textAnalysisSummary = null;
                            _isTextLoading = false;
                          });
                        } else {
                          try {
                            final result = await calculator.analyzeText(value);
                            setState(() {
                              _textAnalysisSummary = result;
                              _isTextLoading = false;
                            });
                          } catch (e) {
                            setState(() {
                              _isTextLoading = false;
                            });
                          }
                        }
                      } else {
                        setState(() {
                          _textAnalysisSummary = null;
                          _isTextLoading = false;
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
          ),

          // 起卦方式选择
          if (_inputText.isNotEmpty) ...[
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '起卦方式',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...TextDivinationMethod.values.map((method) {
                      final isRecommended =
                          method.isLongTextRecommended ||
                          method == TextDivinationMethod.byCharCount;
                      return RadioListTile<TextDivinationMethod>(
                        title: Row(
                          children: [
                            Text(method.displayName),
                            if (isLong && isRecommended) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.orange.shade100,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  '推荐',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.orange.shade700,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        subtitle: Text(
                          method.description,
                          style: const TextStyle(fontSize: 12),
                        ),
                        value: method,
                        groupValue: _selectedTextMethod,
                        onChanged: (value) {
                          setState(() => _selectedTextMethod = value!);
                        },
                        dense: true,
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],

          // 加载指示器
          if (_isTextLoading) ...[
            const SizedBox(height: 16),
            const Center(child: CircularProgressIndicator()),
          ],

          // 长文本模式：显示句子分析
          if (isLong && !_isTextLoading && sentenceAnalysis != null) ...[
            const SizedBox(height: 16),
            _buildSentenceAnalysisCard(sentenceAnalysis),
          ],

          // 短文本模式：显示字符分析
          if (!isLong && _textAnalysisSummary != null && !_isTextLoading) ...[
            const SizedBox(height: 16),
            _buildCharacterAnalysisCard(_textAnalysisSummary!),
          ],

          // 起卦按钮
          if (_inputText.isNotEmpty && !_isTextLoading) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () =>
                    _generateGuaByTextWithMethod(_selectedTextMethod),
                icon: const Icon(Icons.auto_awesome),
                label: Text(isLong ? '长文本起卦' : '起卦'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],

          const SizedBox(height: 24),
          if (_result != null) _buildResultSection(),
        ],
      ),
    );
  }

  /// 构建句子分析卡片
  Widget _buildSentenceAnalysisCard(Map<String, dynamic> analysis) {
    final sentenceCount = analysis['sentenceCount'] as int;
    final sentences = analysis['sentences'] as List<String>;
    final charCounts = analysis['charCounts'] as List<int>;
    // 计算总字数（使用修改后的字数）
    int totalChars = 0;
    for (int i = 0; i < sentenceCount; i++) {
      totalChars += _sentenceCountOverrides[i] ?? charCounts[i];
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '句子分析',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  '共 $totalChars 字',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text('共 $sentenceCount 句', style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 12),
            // 显示每句内容和可编辑字数
            ...List.generate(sentenceCount, (index) {
              final sentence = sentences[index];
              final originalCount = charCounts[index];
              final currentCount =
                  _sentenceCountOverrides[index] ?? originalCount;
              final isModified = _sentenceCountOverrides.containsKey(index);

              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '· ',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        sentence,
                        style: const TextStyle(fontSize: 14),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    // 可编辑的字数输入框
                    SizedBox(
                      width: 50,
                      height: 32,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        controller: TextEditingController(
                          text: currentCount.toString(),
                        ),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isModified ? Colors.orange : Colors.blue,
                        ),
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 4,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: BorderSide(
                              color: isModified
                                  ? Colors.orange
                                  : Colors.blue.shade200,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: BorderSide(
                              color: isModified
                                  ? Colors.orange
                                  : Colors.blue.shade200,
                            ),
                          ),
                          filled: true,
                          fillColor: isModified
                              ? Colors.orange.shade50
                              : Colors.white,
                        ),
                        onChanged: (value) {
                          final n = int.tryParse(value);
                          if (n != null && n >= 0) {
                            setState(() {
                              _sentenceCountOverrides[index] = n;
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  /// 构建字符分析卡片
  Widget _buildCharacterAnalysisCard(
    TextAnalysisSummary summary, {
    bool isLongText = false,
  }) {
    final displayCharacters = isLongText && summary.characters.length > 10
        ? summary.characters.sublist(0, 10)
        : summary.characters;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  '字符分析',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                if (isLongText)
                  Text(
                    ' (显示前10个字)',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
              ],
            ),
            const SizedBox(height: 12),

            // 字符展示
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: displayCharacters.map((analysis) {
                // 获取用户修改后的音调，如果没有修改则使用原始音调
                final currentTone =
                    _toneOverrides[analysis.character] ?? analysis.modernTone;
                // 判断平仄 (1-2声为平，3-4声为仄)
                final isPing = currentTone == 1 || currentTone == 2;

                // 根据当前音调显示正确的拼音声调标记
                final displayPinyin =
                    _toneOverrides.containsKey(analysis.character)
                    ? PinyinToneConverter.convertTone(
                        analysis.pinyinWithoutTone,
                        currentTone,
                      )
                    : analysis.pinyinWithTone;

                return Container(
                  width: 80,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Column(
                    children: [
                      Text(
                        analysis.character,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${analysis.strokeCount}画',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
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
                              fontSize: 12,
                              color: Colors.blue.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 4),
                          // 可点击的音调按钮
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                // 音调在 1-4 之间循环
                                _toneOverrides[analysis.character] =
                                    (currentTone % 4) + 1;
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
                      // 平仄标签
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: isPing
                              ? Colors.blue.shade100
                              : Colors.red.shade100,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          isPing ? '平' : '仄',
                          style: TextStyle(
                            fontSize: 10,
                            color: isPing
                                ? Colors.blue.shade700
                                : Colors.red.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),

            // 统计信息
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('总笔画', '${summary.totalStrokes}'),
                _buildStatItem('平声', '${summary.pingCount}声'),
                _buildStatItem('仄声', '${summary.zeCount}声'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
          ),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  /// 手动起卦Tab
  Widget _buildManualTab() {
    final upperGuaName = _selectedUpperGua != null
        ? _getGuaName(_selectedUpperGua!)
        : null;
    final lowerGuaName = _selectedLowerGua != null
        ? _getGuaName(_selectedLowerGua!)
        : null;
    final isGuaComplete =
        _selectedUpperGua != null && _selectedLowerGua != null;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 标题卡片
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const Icon(
                    Icons.touch_app,
                    size: 48,
                    color: Colors.deepPurple,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '手动起卦',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '手动选择上下卦和动爻\n适用于进阶用户、手动录入已知卦象',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // 先天/后天卦切换
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _isXianTianGua ? '先天卦' : '后天卦',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _isXianTianGua ? '乾1兑2离3震4巽5坎6艮7坤8' : '离南坎北震东兑西',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  Switch(
                    value: _isXianTianGua,
                    onChanged: (value) {
                      setState(() {
                        _isXianTianGua = value;
                        // 切换模式时重置选择
                        _selectedUpperGua = null;
                        _selectedLowerGua = null;
                        _selectedYao = null;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // 上卦选择
          GuaSelectorWidget(
            title: '选择上卦',
            selectedGua: _selectedUpperGua,
            isXianTian: _isXianTianGua,
            onGuaSelected: (guaNum) {
              setState(() {
                _selectedUpperGua = guaNum;
                _selectedYao = null; // 重置动爻选择
              });
            },
          ),

          const SizedBox(height: 16),

          // 下卦选择
          GuaSelectorWidget(
            title: '选择下卦',
            selectedGua: _selectedLowerGua,
            isXianTian: _isXianTianGua,
            onGuaSelected: (guaNum) {
              setState(() {
                _selectedLowerGua = guaNum;
                _selectedYao = null; // 重置动爻选择
              });
            },
          ),

          const SizedBox(height: 16),

          // 动爻选择（显示真实爻）
          _buildYaoSelector(upperGuaName, lowerGuaName, isGuaComplete),

          const SizedBox(height: 24),

          // 起卦按钮
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _canGenerateManual ? _generateManualGua : null,
              icon: const Icon(Icons.casino),
              label: const Text('起卦'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),

          const SizedBox(height: 24),
          if (_result != null) _buildResultSection(),
        ],
      ),
    );
  }

  /// 获取卦名（支持先天卦和后天卦）
  String _getGuaName(int guaNum) {
    if (_isXianTianGua) {
      // 先天卦：乾1兑2离3震4巽5坎6艮7坤8
      const names = ['乾', '兑', '离', '震', '巽', '坎', '艮', '坤'];
      return names[(guaNum - 1) % 8];
    } else {
      // 后天卦：坎1坤2震3巽4乾6兑7艮8离9
      const houTianNames = {
        1: '坎',
        2: '坤',
        3: '震',
        4: '巽',
        6: '乾',
        7: '兑',
        8: '艮',
        9: '离',
      };
      return houTianNames[guaNum] ?? '未知';
    }
  }

  /// 获取卦的二进制表示（仅先天卦有二进制）
  String _getGuaBinary(int guaNum) {
    if (_isXianTianGua) {
      const binaries = ['111', '110', '101', '100', '011', '010', '001', '000'];
      return binaries[(guaNum - 1) % 8];
    } else {
      // 后天卦使用先天卦数映射
      const houTianToXianTian = {
        1: 6,
        2: 8,
        3: 4,
        4: 5,
        6: 1,
        7: 2,
        8: 7,
        9: 3,
      };
      final xianTianNum = houTianToXianTian[guaNum] ?? 1;
      const binaries = ['111', '110', '101', '100', '011', '010', '001', '000'];
      return binaries[(xianTianNum - 1) % 8];
    }
  }

  /// 构建动爻选择器（显示真实爻）
  Widget _buildYaoSelector(
    String? upperGuaName,
    String? lowerGuaName,
    bool isGuaComplete,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  '选择动爻',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                if (!isGuaComplete) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade100,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '请先选择上下卦',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.orange.shade700,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 16),

            if (!isGuaComplete)
              // 未完成上下卦选择时显示占位
              Container(
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: const Center(
                  child: Text(
                    '请先选择上卦和下卦',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              )
            else
              // 显示真实六爻
              _buildRealYaoDisplay(upperGuaName!, lowerGuaName!),
          ],
        ),
      ),
    );
  }

  /// 构建真实六爻显示
  Widget _buildRealYaoDisplay(String upperGuaName, String lowerGuaName) {
    final upperBinary = _getGuaBinary(_selectedUpperGua!);
    final lowerBinary = _getGuaBinary(_selectedLowerGua!);

    // 完整六爻（从下往上）
    final fullBinary = lowerBinary + upperBinary;
    final yaoList = fullBinary.split('');

    return Column(
      children: [
        // 上卦名称
        Text(
          '上卦: $upperGuaName',
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 8),

        // 上卦三爻（从上往下显示：6、5、4爻）
        ...List.generate(3, (index) {
          final yaoPosition = 6 - index; // 6, 5, 4
          final yaoIndex = 5 - index; // 数组索引
          final isYang = yaoList[yaoIndex] == '1';
          final isSelected = _selectedYao == yaoPosition;

          return _buildYaoButton(yaoPosition, isYang, isSelected);
        }),

        const SizedBox(height: 8),
        const Divider(),
        const SizedBox(height: 8),

        // 下卦三爻（从上往下显示：3、2、1爻）
        ...List.generate(3, (index) {
          final yaoPosition = 3 - index; // 3, 2, 1
          final yaoIndex = 2 - index; // 数组索引
          final isYang = yaoList[yaoIndex] == '1';
          final isSelected = _selectedYao == yaoPosition;

          return _buildYaoButton(yaoPosition, isYang, isSelected);
        }),

        const SizedBox(height: 8),

        // 下卦名称
        Text(
          '下卦: $lowerGuaName',
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }

  /// 构建单个爻按钮
  Widget _buildYaoButton(int yaoPosition, bool isYang, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() => _selectedYao = yaoPosition);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.deepPurple.shade100 : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Colors.deepPurple : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '第$yaoPosition爻',
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Colors.deepPurple : Colors.black87,
              ),
            ),
            const SizedBox(width: 16),
            // 显示爻的形状
            _buildYaoShape(isYang),
          ],
        ),
      ),
    );
  }

  /// 构建爻的形状
  Widget _buildYaoShape(bool isYang) {
    if (isYang) {
      // 阳爻：实线
      return Container(
        width: 40,
        height: 6,
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(3),
        ),
      );
    } else {
      // 阴爻：断线
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 16,
            height: 6,
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 16,
            height: 6,
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        ],
      );
    }
  }

  bool get _canGenerateManual =>
      _selectedUpperGua != null &&
      _selectedLowerGua != null &&
      _selectedYao != null;

  /// 构建结果展示区域
  Widget _buildResultSection() {
    final gua = _result!.originalGua;
    final changedGua = _result!.changedGua;
    final huGua = _result!.huGua;

    return Column(
      children: [
        Card(
          elevation: 4,
          color: Colors.deepPurple.shade50,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                // 标题和颜色模式切换器
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '卦象结果',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    _buildColorModeSwitcher(),
                  ],
                ),
                const SizedBox(height: 20),
                // 卦象展示（只有本卦显示变爻指示器）
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildGuaColumn('本卦', gua, showChangingIndicator: true),
                    if (huGua != null)
                      _buildGuaColumn(
                        '互卦',
                        huGua,
                        showChangingIndicator: false,
                      ),
                    _buildGuaColumn(
                      '变卦',
                      changedGua,
                      showChangingIndicator: false,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      _buildInfoRow('起卦方式', _result!.method.displayName),
                      _buildInfoRow('动爻位置', '第${gua.changingYao}爻'),
                      _buildInfoRow(
                        '本卦',
                        '${gua.upperGuaName}${gua.lowerGuaName}',
                      ),
                      _buildInfoRow(
                        '变卦',
                        '${changedGua.upperGuaName}${changedGua.lowerGuaName}',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                // 显示起卦流程按钮
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _showFlow = !_showFlow;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: _showFlow
                          ? Colors.deepPurple.shade100
                          : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _showFlow
                            ? Colors.deepPurple
                            : Colors.grey.shade300,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _showFlow ? Icons.expand_less : Icons.expand_more,
                          size: 18,
                          color: _showFlow
                              ? Colors.deepPurple
                              : Colors.grey.shade600,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '显示起卦流程',
                          style: TextStyle(
                            fontSize: 13,
                            color: _showFlow
                                ? Colors.deepPurple
                                : Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // 流程显示区域
        if (_showFlow) _buildFlowSection(),
      ],
    );
  }

  /// 构建流程展示区域
  Widget _buildFlowSection() {
    final gua = _result!.originalGua;
    final method = _result!.method;

    // 根据起卦方法生成流程
    Widget flowWidget;
    switch (method) {
      case DivinationMethod.time:
        // 判断是农历起卦还是普通时间起卦
        if (_isLunarDivination) {
          final yearZhiNum = _result!.params?['yearZhiNum'] ?? 1;
          final lunarMonth = _result!.params?['lunarMonth'] ?? 1;
          final lunarDay = _result!.params?['lunarDay'] ?? 1;
          final hourZhiNum = _result!.params?['hourZhiNum'] ?? 1;

          flowWidget = DivinationFlowFactory.lunarDivinationFlow(
            yearZhiNum: yearZhiNum,
            yearZhiName: DivinationFlowFactory.zhiNames[yearZhiNum - 1],
            lunarMonth: lunarMonth,
            lunarMonthName: lunarMonth <= 12
                ? DivinationFlowFactory.lunarMonthNames[lunarMonth - 1]
                : '$lunarMonth月',
            lunarDay: lunarDay,
            lunarDayName: DivinationFlowFactory.getLunarDayName(lunarDay),
            hourZhiNum: hourZhiNum,
            hourZhiName: DivinationFlowFactory.zhiNames[hourZhiNum - 1],
            upperGuaNum: gua.upperNumber,
            lowerGuaNum: gua.lowerNumber,
            changingYao: gua.changingYao,
          );
        } else {
          flowWidget = DivinationFlowFactory.timeDivinationFlow(
            yearZhiNum: _result!.params?['yearZhiNum'] ?? 1,
            lunarMonth: _result!.params?['lunarMonth'] ?? 1,
            lunarDay: _result!.params?['lunarDay'] ?? 1,
            hourZhiNum: _result!.params?['hourZhiNum'] ?? 1,
            upperGuaNum: gua.upperNumber,
            lowerGuaNum: gua.lowerNumber,
            changingYao: gua.changingYao,
          );
        }
        break;
      case DivinationMethod.number:
        final numbers =
            (_result!.params?['numbers'] as List?)?.cast<int>() ?? [1];
        flowWidget = DivinationFlowFactory.numberDivinationFlow(
          numbers: numbers,
          upperGuaNum: gua.upperNumber,
          lowerGuaNum: gua.lowerNumber,
          changingYao: gua.changingYao,
        );
        break;
      case DivinationMethod.manual:
        flowWidget = DivinationFlowFactory.manualFlow(
          upperGuaNum: gua.upperNumber,
          lowerGuaNum: gua.lowerNumber,
          changingYao: gua.changingYao,
        );
        break;
      default:
        // 文字起卦或其他方法
        flowWidget = DivinationFlowFactory.charCountFlow(
          text: _inputText.isNotEmpty ? _inputText : '示例文字',
          charCount: _inputText.isNotEmpty ? _inputText.length : 4,
          upperGuaNum: gua.upperNumber,
          lowerGuaNum: gua.lowerNumber,
          changingYao: gua.changingYao,
        );
    }

    return Padding(padding: const EdgeInsets.only(top: 12), child: flowWidget);
  }

  /// 构建颜色模式切换器
  Widget _buildColorModeSwitcher() {
    final currentMode = MeiHuaYiShuModule.themeConfig.mode;

    return PopupMenuButton<YaoColorMode>(
      initialValue: currentMode,
      onSelected: (mode) {
        final newConfig = _getConfigForMode(mode);
        MeiHuaYiShuModule.setThemeConfig(newConfig);
        setState(() {});
      },
      itemBuilder: (context) {
        return YaoColorMode.values.map((mode) {
          return PopupMenuItem(
            value: mode,
            child: Row(
              children: [
                Icon(
                  currentMode == mode ? Icons.check : Icons.circle_outlined,
                  size: 18,
                  color: currentMode == mode ? Colors.deepPurple : Colors.grey,
                ),
                const SizedBox(width: 8),
                Text(mode.displayName),
              ],
            ),
          );
        }).toList();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.deepPurple.shade100,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.palette, size: 16, color: Colors.deepPurple),
            const SizedBox(width: 4),
            Text(
              currentMode.displayName,
              style: const TextStyle(fontSize: 12, color: Colors.deepPurple),
            ),
            const Icon(
              Icons.arrow_drop_down,
              size: 16,
              color: Colors.deepPurple,
            ),
          ],
        ),
      ),
    );
  }

  /// 获取指定模式的默认配置
  YaoThemeConfig _getConfigForMode(YaoColorMode mode) {
    final currentIndicator = MeiHuaYiShuModule.themeConfig.changingIndicator;
    switch (mode) {
      case YaoColorMode.solid:
        return YaoThemeConfig.defaultTheme.copyWith(
          changingIndicator: currentIndicator,
        );
      case YaoColorMode.bw:
        return YaoThemeConfig.bwTheme.copyWith(
          changingIndicator: currentIndicator,
        );
      case YaoColorMode.yinyang:
        return YaoThemeConfig.yinyangTheme.copyWith(
          changingIndicator: currentIndicator,
        );
      case YaoColorMode.colorful:
        return YaoThemeConfig.colorfulTheme.copyWith(
          changingIndicator: currentIndicator,
        );
    }
  }

  Widget _buildGuaColumn(
    String title,
    gua, {
    bool showChangingIndicator = false,
  }) {
    final themeConfig = MeiHuaYiShuModule.themeConfig;
    final indicator = themeConfig.changingIndicator;

    // 获取二进制表示
    final service = context.read<MeiHuaService>();
    final upperBinary = service.getGuaBinary(gua.upperGua);
    final lowerBinary = service.getGuaBinary(gua.lowerGua);

    return HoverableContainer(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.deepPurple,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            gua.fullName,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          // 显示五行属性（彩色模式）
          if (themeConfig.mode == YaoColorMode.colorful)
            Text(
              '${WuXing.fromGuaName(gua.upperGuaName).name}·${WuXing.fromGuaName(gua.lowerGuaName).name}',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
          const SizedBox(height: 8),
          // 上卦（三爻）
          _buildThreeYao(
            upperBinary,
            gua.upperGuaName,
            showChangingIndicator ? gua.changingYao : -1,
            startOffset: 3,
            themeConfig: themeConfig,
            indicator: indicator,
            showIndicator: showChangingIndicator,
          ),
          const SizedBox(height: 4),
          // 下卦（三爻）
          _buildThreeYao(
            lowerBinary,
            gua.lowerGuaName,
            showChangingIndicator ? gua.changingYao : -1,
            startOffset: 0,
            themeConfig: themeConfig,
            indicator: indicator,
            showIndicator: showChangingIndicator,
          ),
        ],
      ),
    );
  }

  /// 构建三爻卦
  Widget _buildThreeYao(
    String binary,
    String guaName,
    int changingYao, {
    required int startOffset,
    required YaoThemeConfig themeConfig,
    required ChangingYaoIndicator indicator,
    bool showIndicator = true,
  }) {
    final yaoList = binary.split('').reversed.toList(); // 从上往下

    return HoverableContainer(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      borderRadius: BorderRadius.circular(8),
      child: Column(
        children: List.generate(3, (index) {
          final isYang = yaoList[index] == '1';
          final yaoPosition = startOffset + (2 - index) + 1; // 1-6
          final isChanging = changingYao > 0 && yaoPosition == changingYao;

          // 根据主题模式获取颜色
          Color color;
          switch (themeConfig.mode) {
            case YaoColorMode.solid:
              color = themeConfig.solidColor;
              break;
            case YaoColorMode.bw:
            case YaoColorMode.yinyang:
              color = isYang ? themeConfig.yangColor : themeConfig.yinColor;
              break;
            case YaoColorMode.colorful:
              final wuxing = WuXing.fromGuaName(guaName);
              color = themeConfig.wuXingColors[wuxing] ?? wuxing.defaultColor;
              break;
          }

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: _buildSingleYao(
              isYang: isYang,
              color: color,
              isChanging: isChanging,
              indicator: indicator,
              showIndicator: showIndicator,
            ),
          );
        }),
      ),
    );
  }

  /// 构建单个爻
  Widget _buildSingleYao({
    required bool isYang,
    required Color color,
    required bool isChanging,
    required ChangingYaoIndicator indicator,
    bool showIndicator = true,
  }) {
    // 根据阴爻/阳爻和颜色模式决定是否使用反色
    Color displayColor = color;
    if (!isYang &&
        (MeiHuaYiShuModule.themeConfig.mode == YaoColorMode.bw ||
            MeiHuaYiShuModule.themeConfig.mode == YaoColorMode.yinyang)) {
      displayColor = MeiHuaYiShuModule.themeConfig.yinColor;
    }

    // 爻的宽度
    const yaoWidth = 50.0;
    const indicatorWidth = 12.0;
    const indicatorSize = 7.0;

    // 构建爻本体
    Widget yaoBody;
    if (isYang) {
      // 阳爻：实线
      yaoBody = Container(
        width: yaoWidth,
        height: 6,
        decoration: BoxDecoration(
          color: displayColor,
          borderRadius: BorderRadius.circular(3),
        ),
      );
    } else {
      // 阴爻：断线
      yaoBody = SizedBox(
        width: yaoWidth,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 21,
              height: 6,
              decoration: BoxDecoration(
                color: displayColor,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 21,
              height: 6,
              decoration: BoxDecoration(
                color: displayColor,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ],
        ),
      );
    }

    // 构建指示器（仅本卦显示）
    Widget? indicatorWidget;
    if (showIndicator &&
        isChanging &&
        indicator.type != ChangingYaoIndicatorType.none) {
      if (indicator.type == ChangingYaoIndicatorType.text) {
        indicatorWidget = Text(
          indicator.text,
          style: TextStyle(color: indicator.textColor, fontSize: indicatorSize),
        );
      } else if (indicator.type == ChangingYaoIndicatorType.image) {
        indicatorWidget = Icon(
          Icons.star,
          color: indicator.textColor,
          size: indicatorSize,
        );
      }
    }

    // 使用左右 SizedBox 保持爻居中对齐
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // 左侧固定宽度容器（用于指示器）
        SizedBox(
          width: indicatorWidth,
          height: 12,
          child: indicatorWidget != null
              ? Center(child: indicatorWidget)
              : null,
        ),
        const SizedBox(width: 4), // 增加4px间距
        // 爻本体
        yaoBody,
        const SizedBox(width: 4), // 增加4px间距
        // 右侧固定宽度容器（保持对称）
        const SizedBox(width: indicatorWidth + 4),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey.shade600)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  void _generateGuaByTime() {
    final service = context.read<MeiHuaService>();
    final now = DateTime.now();
    setState(() {
      _isLunarDivination = false;
      _result = service.xianTianDivination([
        now.year,
        now.month,
        now.day,
        now.hour,
        now.minute,
      ]);
    });
  }

  void _generateGuaByLunarTime() {
    final service = context.read<MeiHuaService>();
    final now = DateTime.now();

    // 将阳历转换为农历
    final solar = Solar.fromYmd(now.year, now.month, now.day);
    final lunar = solar.getLunar();

    // 获取农历年地支序数 (子=1, 丑=2, ..., 亥=12)
    final yearZhiIndex = lunar.getYearZhiIndex() + 1;

    // 获取农历月 (1-12)
    final lunarMonth = lunar.getMonth();

    // 获取农历日 (1-30)
    final lunarDay = lunar.getDay();

    // 获取时辰地支序数 (子=1, 丑=2, ..., 亥=12)
    final timeZhiIndex = (now.hour + 1) ~/ 2;
    final hourZhiNum = timeZhiIndex == 0 ? 12 : timeZhiIndex;

    setState(() {
      _isLunarDivination = true;
      _result = service.timeDivination(
        yearZhiNum: yearZhiIndex,
        lunarMonth: lunarMonth,
        lunarDay: lunarDay,
        hourZhiNum: hourZhiNum,
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

  Future<void> _generateGuaByTextWithMethod(TextDivinationMethod method) async {
    if (_inputText.isEmpty) return;
    final calculator = TextDivinationCalculator();

    // 如果有音调覆盖且是音调相关的方法，使用覆盖的音调
    DivinationResult result;
    if (_toneOverrides.isNotEmpty &&
        (method == TextDivinationMethod.byModernTone ||
            method == TextDivinationMethod.byAncientTone)) {
      // 使用覆盖的音调计算
      if (method == TextDivinationMethod.byModernTone) {
        result = await calculator.calculateByModernToneWithOverrides(
          _inputText,
          _toneOverrides,
        );
      } else {
        // 平仄方法也需要处理覆盖的音调
        final summary = await calculator.analyzeText(_inputText);
        int firstHalfPingZe = 0;
        int secondHalfPingZe = 0;
        final mid = (summary.characters.length / 2).ceil();

        for (int i = 0; i < summary.characters.length; i++) {
          final char = summary.characters[i];
          final tone = _toneOverrides[char.character] ?? char.modernTone;
          final isPing = tone == 1 || tone == 2;
          final pingZeValue = isPing ? 1 : 2;
          if (i < mid) {
            firstHalfPingZe += pingZeValue;
          } else {
            secondHalfPingZe += pingZeValue;
          }
        }

        final totalPingZeValue = firstHalfPingZe + secondHalfPingZe;
        final changingYao = totalPingZeValue % 6;

        final originalGua = Gua.fromNumbers(
          firstHalfPingZe % 8 == 0 ? 8 : firstHalfPingZe % 8,
          secondHalfPingZe % 8 == 0 ? 8 : secondHalfPingZe % 8,
          changingYao == 0 ? 6 : changingYao,
        );

        result = DivinationResult(
          method: DivinationMethod.text,
          originalGua: originalGua,
          changedGua: MeiHuaService()
              .manualDivination(
                upperGuaNum: originalGua.upperNumber,
                lowerGuaNum: originalGua.lowerNumber,
                changingYao: originalGua.changingYao,
              )
              .changedGua,
          huGua: MeiHuaService()
              .manualDivination(
                upperGuaNum: originalGua.upperNumber,
                lowerGuaNum: originalGua.lowerNumber,
                changingYao: originalGua.changingYao,
              )
              .huGua,
          timestamp: DateTime.now(),
          params: {
            'upperValue': firstHalfPingZe,
            'lowerValue': secondHalfPingZe,
            'changingYao': changingYao,
          },
        );
      }
    } else {
      // 如果是按句子字数起卦且有字数覆盖，使用覆盖的字数
      if (method == TextDivinationMethod.bySentenceLength &&
          _sentenceCountOverrides.isNotEmpty) {
        final calculator2 = TextDivinationCalculator();
        final analysis = calculator2.getSentenceAnalysis(_inputText);
        final originalCounts = analysis['charCounts'] as List<int>;
        final List<int> finalCounts = [];
        for (int i = 0; i < originalCounts.length; i++) {
          finalCounts.add(_sentenceCountOverrides[i] ?? originalCounts[i]);
        }
        result = await calculator.calculateBySentenceLengthWithOverrides(
          finalCounts,
        );
      } else {
        result = await calculator.calculate(_inputText, method);
      }
    }

    setState(() {
      _result = result;
    });
  }

  void _generateManualGua() {
    if (!_canGenerateManual) return;
    final service = context.read<MeiHuaService>();

    int upperNum = _selectedUpperGua!;
    int lowerNum = _selectedLowerGua!;

    // 如果是后天卦模式，需要转换为先天卦数字
    if (!_isXianTianGua) {
      // 后天卦 → 先天卦 映射
      const houTianToXianTian = {
        1: 6, // 坎
        2: 8, // 坤
        3: 4, // 震
        4: 5, // 巽
        6: 1, // 乾
        7: 2, // 兑
        8: 7, // 艮
        9: 3, // 离
      };
      upperNum = houTianToXianTian[upperNum] ?? upperNum;
      lowerNum = houTianToXianTian[lowerNum] ?? lowerNum;
    }

    setState(() {
      _result = service.manualDivination(
        upperGuaNum: upperNum,
        lowerGuaNum: lowerNum,
        changingYao: _selectedYao!,
      );
    });
  }
}

/// 可 hover 的容器组件
class HoverableContainer extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;

  const HoverableContainer({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius,
  });

  @override
  State<HoverableContainer> createState() => _HoverableContainerState();
}

class _HoverableContainerState extends State<HoverableContainer> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: widget.padding ?? const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: _isHovered ? Colors.white : Colors.transparent,
          borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
          border: _isHovered
              ? Border.all(color: Colors.deepPurple.shade200, width: 1)
              : Border.all(color: Colors.transparent, width: 1),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: Colors.deepPurple.withValues(alpha: 0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: widget.child,
      ),
    );
  }
}
