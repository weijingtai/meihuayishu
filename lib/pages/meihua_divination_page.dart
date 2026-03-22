import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/meihua_service.dart';
import '../services/stroke_service.dart';
import '../models/divination_result.dart';
import '../widgets/gua_display_widget.dart';
import '../widgets/gua_selector_widget.dart';
import '../widgets/yao_selector_widget.dart';

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
    final strokeService = StrokeService();
    final textController = TextEditingController();

    return StatefulBuilder(
      builder: (context, setLocalState) {
        String inputText = '';
        List<int> strokeCounts = [];
        int totalStrokes = 0;

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
                      const Text(
                        '输入文字，根据笔画数起卦',
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: textController,
                        decoration: const InputDecoration(
                          labelText: '输入文字',
                          hintText: '请输入汉字',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          setLocalState(() {
                            inputText = value;
                            if (value.isNotEmpty) {
                              strokeCounts =
                                  strokeService.getStrokeCounts(value);
                              totalStrokes =
                                  strokeService.getTotalStrokeCount(value);
                            } else {
                              strokeCounts = [];
                              totalStrokes = 0;
                            }
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      if (inputText.isNotEmpty) ...[
                        Wrap(
                          spacing: 8,
                          children:
                              inputText.split('').asMap().entries.map((entry) {
                            final index = entry.key;
                            final char = entry.value;
                            final strokes = index < strokeCounts.length
                                ? strokeCounts[index]
                                : 0;
                            return Chip(
                              label: Text('$char ($strokes画)'),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '总笔画数: $totalStrokes',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: inputText.isNotEmpty
                            ? () {
                                _generateGuaByText(inputText);
                              }
                            : null,
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
      },
    );
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

  void _generateGuaByText(String text) {
    if (text.isEmpty) return;

    final strokeService = StrokeService();
    final service = context.read<MeiHuaService>();
    final strokeCounts = strokeService.getStrokeCounts(text);

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
