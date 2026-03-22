import 'package:flutter/material.dart';
import 'package:common/widgets/style_editor/widgets/app_palette_picker_dialog.dart';

import '../models/yao_color_mode.dart';
import '../models/yao_theme_config.dart';

/// 主题编辑页面
class ThemeEditPage extends StatefulWidget {
  final YaoThemeConfig initialConfig;
  final ValueChanged<YaoThemeConfig>? onConfigChanged;

  const ThemeEditPage({
    super.key,
    required this.initialConfig,
    this.onConfigChanged,
  });

  @override
  State<ThemeEditPage> createState() => _ThemeEditPageState();
}

class _ThemeEditPageState extends State<ThemeEditPage> {
  late YaoThemeConfig _config;

  @override
  void initState() {
    super.initState();
    _config = widget.initialConfig;
  }

  void _updateConfig(YaoThemeConfig newConfig) {
    setState(() {
      _config = newConfig;
    });
    widget.onConfigChanged?.call(newConfig);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('卦爻主题设置'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          TextButton(
            onPressed: () {
              _updateConfig(YaoThemeConfig.defaultTheme);
            },
            child: const Text('重置'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildModeSelector(),
            const SizedBox(height: 16),
            _buildModeConfig(),
            const SizedBox(height: 16),
            _buildChangingIndicatorConfig(),
            const SizedBox(height: 16),
            _buildPreview(),
          ],
        ),
      ),
    );
  }

  /// 构建颜色模式选择器
  Widget _buildModeSelector() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '颜色模式',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: YaoColorMode.values.map((mode) {
                final isSelected = _config.mode == mode;
                return ChoiceChip(
                  label: Text(mode.displayName),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      _updateConfig(_getConfigForMode(mode));
                    }
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 8),
            Text(
              _config.mode.description,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  /// 获取指定模式的默认配置
  YaoThemeConfig _getConfigForMode(YaoColorMode mode) {
    final currentIndicator = _config.changingIndicator;
    switch (mode) {
      case YaoColorMode.solid:
        return YaoThemeConfig.defaultTheme
            .copyWith(changingIndicator: currentIndicator);
      case YaoColorMode.bw:
        return YaoThemeConfig.bwTheme
            .copyWith(changingIndicator: currentIndicator);
      case YaoColorMode.yinyang:
        return YaoThemeConfig.yinyangTheme
            .copyWith(changingIndicator: currentIndicator);
      case YaoColorMode.colorful:
        return YaoThemeConfig.colorfulTheme
            .copyWith(changingIndicator: currentIndicator);
    }
  }

  /// 构建模式配置区域
  Widget _buildModeConfig() {
    switch (_config.mode) {
      case YaoColorMode.solid:
        return _buildSolidModeConfig();
      case YaoColorMode.bw:
      case YaoColorMode.yinyang:
        return _buildYinYangModeConfig();
      case YaoColorMode.colorful:
        return _buildColorfulModeConfig();
    }
  }

  /// 纯色模式配置
  Widget _buildSolidModeConfig() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '纯色设置',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildColorPicker(
              label: '爻颜色',
              color: _config.solidColor,
              onColorChanged: (color) {
                _updateConfig(_config.copyWith(solidColor: color));
              },
            ),
          ],
        ),
      ),
    );
  }

  /// 阴阳色模式配置
  Widget _buildYinYangModeConfig() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '阴阳色设置',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildColorPicker(
              label: '阳爻颜色',
              color: _config.yangColor,
              onColorChanged: (color) {
                _updateConfig(_config.copyWith(yangColor: color));
              },
            ),
            const SizedBox(height: 12),
            _buildColorPicker(
              label: '阴爻颜色',
              color: _config.yinColor,
              onColorChanged: (color) {
                _updateConfig(_config.copyWith(yinColor: color));
              },
            ),
          ],
        ),
      ),
    );
  }

  /// 彩色模式配置
  Widget _buildColorfulModeConfig() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '五行颜色设置',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...WuXing.values.map((wuxing) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: _buildColorPicker(
                  label: '${wuxing.name} (${_getWuXingGuaNames(wuxing)})',
                  color: _config.wuXingColors[wuxing] ?? wuxing.defaultColor,
                  onColorChanged: (color) {
                    final newColors =
                        Map<WuXing, Color>.from(_config.wuXingColors);
                    newColors[wuxing] = color;
                    _updateConfig(_config.copyWith(wuXingColors: newColors));
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  /// 获取五行对应的卦名
  String _getWuXingGuaNames(WuXing wuxing) {
    switch (wuxing) {
      case WuXing.jin:
        return '乾、兑';
      case WuXing.mu:
        return '震、巽';
      case WuXing.shui:
        return '坎';
      case WuXing.huo:
        return '离';
      case WuXing.tu:
        return '艮、坤';
    }
  }

  /// 构建变爻指示器配置
  Widget _buildChangingIndicatorConfig() {
    final indicator = _config.changingIndicator;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '变爻指示器',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            // 指示器类型选择
            Wrap(
              spacing: 8,
              children: ChangingYaoIndicatorType.values.map((type) {
                final isSelected = indicator.type == type;
                return ChoiceChip(
                  label: Text(type.displayName),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      _updateConfig(_config.copyWith(
                        changingIndicator: indicator.copyWith(type: type),
                      ));
                    }
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            // 根据类型显示配置
            if (indicator.type == ChangingYaoIndicatorType.text) ...[
              // 文本配置
              TextField(
                decoration: const InputDecoration(
                  labelText: '指示器文本',
                  hintText: '输入变爻指示文本，如 ⭕️',
                  border: OutlineInputBorder(),
                ),
                controller: TextEditingController(text: indicator.text),
                onChanged: (value) {
                  _updateConfig(_config.copyWith(
                    changingIndicator: indicator.copyWith(text: value),
                  ));
                },
              ),
              const SizedBox(height: 12),
              _buildColorPicker(
                label: '文本颜色',
                color: indicator.textColor,
                onColorChanged: (color) {
                  _updateConfig(_config.copyWith(
                    changingIndicator: indicator.copyWith(textColor: color),
                  ));
                },
              ),
            ],
            if (indicator.type == ChangingYaoIndicatorType.image) ...[
              // 图片配置（简化版，实际可添加图片选择器）
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.image, size: 48, color: Colors.grey),
                    const SizedBox(height: 8),
                    const Text('图片指示器功能开发中'),
                    const SizedBox(height: 8),
                    Text(
                      '当前路径: ${indicator.imagePath ?? "未设置"}',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 12),
            // 大小设置
            Row(
              children: [
                const Expanded(child: Text('指示器大小')),
                SizedBox(
                  width: 200,
                  child: Slider(
                    value: indicator.size,
                    min: 8,
                    max: 32,
                    divisions: 24,
                    label: '${indicator.size.toInt()}',
                    onChanged: (value) {
                      _updateConfig(_config.copyWith(
                        changingIndicator: indicator.copyWith(size: value),
                      ));
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 构建颜色选择器
  Widget _buildColorPicker({
    required String label,
    required Color color,
    required ValueChanged<Color> onColorChanged,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(label),
        ),
        InkWell(
          onTap: () => _showColorPicker(color, onColorChanged),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.grey.shade300,
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          onPressed: () => _showColorPicker(color, onColorChanged),
          icon: const Icon(Icons.colorize),
          tooltip: '选择颜色',
        ),
      ],
    );
  }

  /// 显示颜色选择器
  void _showColorPicker(
      Color initialColor, ValueChanged<Color> onColorChanged) async {
    final picked = await showAppPalettePickerDialog(
      context,
      initialColor: initialColor,
      title: '选择颜色',
    );
    if (picked != null) {
      onColorChanged(picked);
    }
  }

  /// 构建预览区域
  Widget _buildPreview() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '预览',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildPreviewGua('乾', [true, true, true], changingYao: 2),
                _buildPreviewGua('坤', [false, false, false], changingYao: 1),
                _buildPreviewGua('离', [true, false, true], changingYao: 3),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 构建预览卦象
  Widget _buildPreviewGua(String guaName, List<bool> yaoList,
      {int? changingYao}) {
    return Column(
      children: [
        Text(guaName, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Column(
          children: yaoList.reversed.toList().asMap().entries.map((entry) {
            final yaoIndex = entry.key;
            final isYang = entry.value;
            final yaoPosition = 3 - yaoIndex; // 从上往下：3,2,1
            final isChanging = yaoPosition == changingYao;

            final color = isYang
                ? _config.getYangColor(guaName: guaName)
                : _config.getYinColor(guaName: guaName);
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: _buildYao(isYang, color, isChanging: isChanging),
            );
          }).toList(),
        ),
      ],
    );
  }

  /// 构建单个爻
  Widget _buildYao(bool isYang, Color color, {bool isChanging = false}) {
    final indicator = _config.changingIndicator;

    // 爻的宽度
    const yaoWidth = 60.0;
    const indicatorWidth = 24.0;

    // 构建爻本体
    Widget yaoBody;
    if (isYang) {
      // 阳爻：实线
      yaoBody = Container(
        width: yaoWidth,
        height: 8,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(4),
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
              width: 26,
              height: 8,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 26,
              height: 8,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4),
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
          style: TextStyle(
            color: indicator.textColor,
            fontSize: indicator.size,
          ),
        );
      } else if (indicator.type == ChangingYaoIndicatorType.image) {
        indicatorWidget = Icon(
          Icons.star,
          color: indicator.textColor,
          size: indicator.size,
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
          height: 20,
          child:
              indicatorWidget != null ? Center(child: indicatorWidget) : null,
        ),
        // 爻本体
        yaoBody,
        // 右侧固定宽度容器（保持对称）
        const SizedBox(width: indicatorWidth),
      ],
    );
  }
}
