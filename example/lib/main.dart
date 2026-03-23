import 'package:flutter/material.dart';
import 'package:meihuayishu/meihuayishu.dart';
import 'package:provider/provider.dart';

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
                    Icons.access_time,
                    size: 48,
                    color: Colors.deepPurple,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '时空起卦',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _generateGuaByTime,
                      icon: const Icon(Icons.auto_awesome),
                      label: const Text('一键起卦'),
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
    final isLongText = _inputText.length > 10;

    // 可用的起卦方法
    final availableMethods = isLongText
        ? [TextDivinationMethod.byCharCount]
        : TextDivinationMethod.values;

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
                  const Text(
                    '输入文字，选择起卦方式\n适用于测字、姓名、成语等',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    decoration: InputDecoration(
                      labelText: '输入文字',
                      hintText: '请输入汉字',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.edit),
                    ),
                    onChanged: (value) async {
                      setState(() {
                        _inputText = value;
                        _isTextLoading = true;
                        _toneOverrides = {}; // 重置音调修改
                      });

                      if (value.isNotEmpty) {
                        try {
                          final result = await calculator.analyzeText(value);
                          setState(() {
                            _textAnalysisSummary = result;
                            _isTextLoading = false;
                          });
                        } catch (e) {
                          print('分析文本失败: $e');
                          setState(() {
                            _isTextLoading = false;
                          });
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
                    if (isLongText)
                      const Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Text(
                          '（长文本仅支持按字数起卦）',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ),
                    const SizedBox(height: 8),
                    ...availableMethods.map((method) {
                      return RadioListTile<TextDivinationMethod>(
                        title: Text(method.displayName),
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

          // 字符分析卡片 - 显示笔画、拼音、平仄
          if (_textAnalysisSummary != null && !_isTextLoading) ...[
            const SizedBox(height: 16),
            _buildCharacterAnalysisCard(
              _textAnalysisSummary!,
              isLongText: isLongText,
            ),
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
                label: const Text('起卦'),
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

    return Card(
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
                  _buildGuaColumn('互卦', huGua, showChangingIndicator: false),
                _buildGuaColumn('变卦', changedGua, showChangingIndicator: false),
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
                  _buildInfoRow('本卦', '${gua.upperGuaName}${gua.lowerGuaName}'),
                  _buildInfoRow(
                    '变卦',
                    '${changedGua.upperGuaName}${changedGua.lowerGuaName}',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
    const indicatorSize = 8.0;

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

    // 构建指示器
    Widget? indicatorWidget;
    if (isChanging && indicator.type != ChangingYaoIndicatorType.none) {
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
      children: [
        // 左侧固定宽度容器（用于指示器）
        SizedBox(
          width: indicatorWidth,
          height: 10,
          child: indicatorWidget != null
              ? Center(child: indicatorWidget)
              : null,
        ),
        // 爻本体
        yaoBody,
        // 右侧固定宽度容器（保持对称）
        const SizedBox(width: indicatorWidth),
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
      _result = service.xianTianDivination([
        now.year,
        now.month,
        now.day,
        now.hour,
        now.minute,
      ]);
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
      result = await calculator.calculate(_inputText, method);
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
