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

  // 报数起卦状态
  String _inputNumber = '';

  // 文字起卦状态
  String _inputText = '';

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
                    '输入文字，根据笔画数起卦\n适用于测字、姓名、成语等',
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
                    onChanged: (value) {
                      setState(() => _inputText = value);
                    },
                  ),
                  if (_inputText.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _inputText.split('').map((char) {
                        return Chip(
                          avatar: CircleAvatar(
                            backgroundColor: Colors.deepPurple,
                            child: Text(
                              char,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          label: Text(char),
                        );
                      }).toList(),
                    ),
                  ],
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _inputText.isNotEmpty
                          ? _generateGuaByText
                          : null,
                      icon: const Icon(Icons.auto_awesome),
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

  /// 手动起卦Tab
  Widget _buildManualTab() {
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
          GuaSelectorWidget(
            title: '选择上卦',
            selectedGua: _selectedUpperGua,
            onGuaSelected: (guaNum) {
              setState(() => _selectedUpperGua = guaNum);
            },
          ),
          const SizedBox(height: 16),
          GuaSelectorWidget(
            title: '选择下卦',
            selectedGua: _selectedLowerGua,
            onGuaSelected: (guaNum) {
              setState(() => _selectedLowerGua = guaNum);
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
          const SizedBox(height: 24),
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

    return Column(
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
        // 上卦
        _buildThreeYao(
          upperBinary,
          gua.upperGuaName,
          showChangingIndicator ? gua.changingYao : -1, // 不显示变爻指示器
          startOffset: 3,
          themeConfig: themeConfig,
          indicator: indicator,
        ),
        const SizedBox(height: 8),
        // 下卦
        _buildThreeYao(
          lowerBinary,
          gua.lowerGuaName,
          showChangingIndicator ? gua.changingYao : -1, // 不显示变爻指示器
          startOffset: 0,
          themeConfig: themeConfig,
          indicator: indicator,
        ),
      ],
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

    return Column(
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

  void _generateGuaByText() {
    if (_inputText.isEmpty) return;
    // 简单的笔画映示例（实际应用需要完整笔画库）
    final strokes = _inputText
        .split('')
        .map((char) => char.codeUnitAt(0) % 10 + 1)
        .toList();
    final service = context.read<MeiHuaService>();
    setState(() {
      _result = service.xianTianDivination(strokes);
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
