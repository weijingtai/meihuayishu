import 'package:flutter/material.dart';

import '../models/yao_theme_config.dart';
import '../pages/theme_edit_page.dart';

/// 设置按钮组件
class SettingsButton extends StatelessWidget {
  final YaoThemeConfig currentConfig;
  final ValueChanged<YaoThemeConfig>? onConfigChanged;

  const SettingsButton({
    super.key,
    required this.currentConfig,
    this.onConfigChanged,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.settings),
      tooltip: '主题设置',
      onPressed: () => _openThemeEditor(context),
    );
  }

  void _openThemeEditor(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ThemeEditPage(
          initialConfig: currentConfig,
          onConfigChanged: onConfigChanged,
        ),
      ),
    );
  }
}
