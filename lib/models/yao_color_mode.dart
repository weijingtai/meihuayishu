import 'package:flutter/material.dart';

/// 爻颜色模式枚举
enum YaoColorMode {
  /// 纯色模式 - 统一颜色显示阴阳爻
  solid('纯色模式', '使用统一颜色显示所有爻'),

  /// 黑白模式 - 阳爻白色，阴爻黑色
  bw('黑白模式', '阳爻白色，阴爻黑色'),

  /// 阴阳色模式 - 阳爻暖色，阴爻冷色
  yinyang('阴阳色', '阳爻暖色，阴爻冷色'),

  /// 彩色模式 - 根据五行属性染色
  colorful('五行彩色', '根据卦的五行属性显示不同颜色');

  final String displayName;
  final String description;

  const YaoColorMode(this.displayName, this.description);
}

/// 五行枚举
enum WuXing {
  jin('金', Color(0xFFFFD700)), // 金色
  mu('木', Color(0xFF228B22)), // 青色
  shui('水', Color(0xFF1E90FF)), // 蓝色
  huo('火', Color(0xFFDC143C)), // 红色
  tu('土', Color(0xFFDAA520)); // 土黄

  final String name;
  final Color defaultColor;

  const WuXing(this.name, this.defaultColor);

  /// 根据卦名获取五行
  static WuXing fromGuaName(String guaName) {
    switch (guaName) {
      case '乾':
      case '兑':
        return jin;
      case '震':
      case '巽':
        return mu;
      case '坎':
        return shui;
      case '离':
        return huo;
      case '艮':
      case '坤':
        return tu;
      default:
        return tu;
    }
  }
}
