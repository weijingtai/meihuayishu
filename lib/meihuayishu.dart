import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import 'models/yao_theme_config.dart';
import 'pages/meihua_divination_page.dart';
import 'services/meihua_service.dart';

export 'models/yao_color_mode.dart';
export 'models/yao_theme_config.dart';
export 'models/divination_result.dart';
export 'models/divination_method.dart';
export 'models/text_divination_method.dart';
export 'models/character_analysis.dart';
export 'pages/theme_edit_page.dart';
export 'widgets/settings_button.dart';
export 'widgets/gua_selector_widget.dart';
export 'widgets/yao_selector_widget.dart';
export 'services/meihua_service.dart';
export 'services/text_divination_calculator.dart';

class MeiHuaYiShuModule {
  static final Logger _logger = Logger();

  /// 当前主题配置
  static YaoThemeConfig _themeConfig = YaoThemeConfig.defaultTheme;

  /// 获取当前主题配置
  static YaoThemeConfig get themeConfig => _themeConfig;

  /// 设置主题配置
  static void setThemeConfig(YaoThemeConfig config) {
    _themeConfig = config;
  }

  static Future<void> init() async {
    _logger.i("Mei Hua Yi Shu module initialized");
  }

  static Widget getHomePage() {
    return MultiProvider(
      providers: [Provider<MeiHuaService>(create: (_) => MeiHuaService())],
      child: const MeiHuaDivinationPage(),
    );
  }
}
