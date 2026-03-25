import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import 'models/yao_theme_config.dart';
import 'pages/meihua_divination_page.dart';
import 'services/meihua_service.dart';
import 'database/meihua_database.dart';
import 'services/divination_record_service.dart';
import 'services/four_zhu_service.dart';
import 'services/jie_qi_service.dart';

// 导出模型
export 'models/yao_color_mode.dart';
export 'models/yao_theme_config.dart';
export 'models/divination_result.dart';
export 'models/divination_method.dart';
export 'models/text_divination_method.dart';
export 'models/character_analysis.dart';
export 'models/gua.dart';

// 导出页面
export 'pages/theme_edit_page.dart';
export 'pages/divination_result_page.dart';
export 'pages/meihua_history_page.dart';
export 'pages/home_page.dart';

// 导出组件
export 'widgets/settings_button.dart';
export 'widgets/gua_selector_widget.dart';
export 'widgets/yao_selector_widget.dart';
export 'widgets/divination_flow_display.dart';
export 'widgets/four_zhu_card_wrapper.dart';
export 'widgets/gua_ci_card_widget.dart';
export 'widgets/yao_ci_list_widget.dart';
export 'widgets/gua_display_widget.dart';

// 导出服务
export 'services/meihua_service.dart';
export 'services/text_divination_calculator.dart';
export 'services/divination_record_service.dart';
export 'services/four_zhu_service.dart';
export 'services/jie_qi_service.dart';
export 'services/yijing_data_service.dart';

// 导出工具
export 'utils/pinyin_tone_converter.dart';

// 导出数据库
export 'database/meihua_database.dart';

// 导出主题
export 'themes/meihua_theme.dart';

class MeiHuaYiShuModule {
  static final Logger _logger = Logger();

  /// 当前主题配置
  static YaoThemeConfig _themeConfig = YaoThemeConfig.defaultTheme;

  /// 数据库实例
  static MeiHuaDatabase? _database;

  /// 获取当前主题配置
  static YaoThemeConfig get themeConfig => _themeConfig;

  /// 设置主题配置
  static void setThemeConfig(YaoThemeConfig config) {
    _themeConfig = config;
  }

  /// 获取数据库实例
  static MeiHuaDatabase get database {
    _database ??= MeiHuaDatabase();
    return _database!;
  }

  /// 获取起卦记录服务
  static DivinationRecordService get recordService {
    return DivinationRecordService(database);
  }

  /// 获取四柱计算服务
  static FourZhuService get fourZhuService {
    return FourZhuService();
  }

  /// 获取物候计算服务
  static JieQiService get jieQiService {
    return JieQiService();
  }

  static Future<void> init() async {
    _logger.i("Mei Hua Yi Shu module initialized");
    // 初始化数据库
    _database = MeiHuaDatabase();
  }

  static Widget getHomePage() {
    return MultiProvider(
      providers: [
        Provider<MeiHuaService>(create: (_) => MeiHuaService()),
        Provider<MeiHuaDatabase>(create: (_) => database),
        Provider<DivinationRecordService>(create: (_) => recordService),
        Provider<FourZhuService>(create: (_) => fourZhuService),
        Provider<JieQiService>(create: (_) => jieQiService),
      ],
      child: const MeiHuaDivinationPage(),
    );
  }
}
