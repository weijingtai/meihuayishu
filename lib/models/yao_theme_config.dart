import 'package:flutter/material.dart';
import 'yao_color_mode.dart';

/// 变爻指示器类型
enum ChangingYaoIndicatorType {
  /// 文本指示（如 ⭕️）
  text('文本'),

  /// 图片指示
  image('图片'),

  /// 无指示
  none('无');

  final String displayName;
  const ChangingYaoIndicatorType(this.displayName);
}

/// 变爻指示器配置
class ChangingYaoIndicator {
  /// 指示器类型
  final ChangingYaoIndicatorType type;

  /// 文本内容（用于文本类型）
  final String text;

  /// 文本颜色
  final Color textColor;

  /// 图片路径（用于图片类型）
  final String? imagePath;

  /// 指示器大小
  final double size;

  /// 位置偏移
  final Offset offset;

  const ChangingYaoIndicator({
    this.type = ChangingYaoIndicatorType.text,
    this.text = '⭕️',
    this.textColor = const Color(0xFFFF0000),
    this.imagePath,
    this.size = 16,
    this.offset = const Offset(8, 0),
  });

  ChangingYaoIndicator copyWith({
    ChangingYaoIndicatorType? type,
    String? text,
    Color? textColor,
    String? imagePath,
    double? size,
    Offset? offset,
  }) {
    return ChangingYaoIndicator(
      type: type ?? this.type,
      text: text ?? this.text,
      textColor: textColor ?? this.textColor,
      imagePath: imagePath ?? this.imagePath,
      size: size ?? this.size,
      offset: offset ?? this.offset,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type.name,
      'text': text,
      'textColor': textColor.toARGB32(),
      'imagePath': imagePath,
      'size': size,
      'offset': {'dx': offset.dx, 'dy': offset.dy},
    };
  }

  factory ChangingYaoIndicator.fromMap(Map<String, dynamic> map) {
    return ChangingYaoIndicator(
      type: ChangingYaoIndicatorType.values.byName(map['type'] ?? 'text'),
      text: map['text'] ?? '⭕️',
      textColor: Color(map['textColor'] ?? 0xFFFF0000),
      imagePath: map['imagePath'],
      size: (map['size'] ?? 16).toDouble(),
      offset: Offset(
        (map['offset']?['dx'] ?? 8).toDouble(),
        (map['offset']?['dy'] ?? 0).toDouble(),
      ),
    );
  }
}

/// 爻主题配置模型
class YaoThemeConfig {
  /// 颜色模式
  final YaoColorMode mode;

  /// 纯色模式的颜色
  final Color solidColor;

  /// 阳爻颜色（黑白/阴阳模式）
  final Color yangColor;

  /// 阴爻颜色（黑白/阴阳模式）
  final Color yinColor;

  /// 五行颜色映射
  final Map<WuXing, Color> wuXingColors;

  /// 变爻指示器配置
  final ChangingYaoIndicator changingIndicator;

  const YaoThemeConfig({
    required this.mode,
    this.solidColor = const Color(0xFF000000),
    this.yangColor = const Color(0xFFFFFFFF),
    this.yinColor = const Color(0xFF000000),
    Map<WuXing, Color>? wuXingColors,
    this.changingIndicator = const ChangingYaoIndicator(),
  }) : wuXingColors = wuXingColors ?? _defaultWuXingColors;

  /// 默认五行颜色
  static const Map<WuXing, Color> _defaultWuXingColors = {
    WuXing.jin: Color(0xFFFFD700), // 金色
    WuXing.mu: Color(0xFF228B22), // 青色
    WuXing.shui: Color(0xFF1E90FF), // 蓝色
    WuXing.huo: Color(0xFFDC143C), // 红色
    WuXing.tu: Color(0xFFDAA520), // 土黄
  };

  /// 默认主题
  static YaoThemeConfig get defaultTheme => const YaoThemeConfig(
        mode: YaoColorMode.solid,
        solidColor: Color(0xFF000000),
      );

  /// 黑白主题
  static YaoThemeConfig get bwTheme => const YaoThemeConfig(
        mode: YaoColorMode.bw,
        yangColor: Color(0xFFFFFFFF),
        yinColor: Color(0xFF000000),
      );

  /// 阴阳主题
  static YaoThemeConfig get yinyangTheme => const YaoThemeConfig(
        mode: YaoColorMode.yinyang,
        yangColor: Color(0xFFFFF8DC), // 暖白色
        yinColor: Color(0xFF1C1C1C), // 冷黑色
      );

  /// 五行彩色主题
  static YaoThemeConfig get colorfulTheme => const YaoThemeConfig(
        mode: YaoColorMode.colorful,
      );

  /// 获取阳爻颜色
  Color getYangColor({String? guaName}) {
    switch (mode) {
      case YaoColorMode.solid:
        return solidColor;
      case YaoColorMode.bw:
      case YaoColorMode.yinyang:
        return yangColor;
      case YaoColorMode.colorful:
        if (guaName != null) {
          final wuxing = WuXing.fromGuaName(guaName);
          return wuXingColors[wuxing] ?? wuxing.defaultColor;
        }
        return yangColor;
    }
  }

  /// 获取阴爻颜色
  Color getYinColor({String? guaName}) {
    switch (mode) {
      case YaoColorMode.solid:
        return solidColor;
      case YaoColorMode.bw:
      case YaoColorMode.yinyang:
        return yinColor;
      case YaoColorMode.colorful:
        if (guaName != null) {
          final wuxing = WuXing.fromGuaName(guaName);
          return wuXingColors[wuxing] ?? wuxing.defaultColor;
        }
        return yinColor;
    }
  }

  /// 复制并修改
  YaoThemeConfig copyWith({
    YaoColorMode? mode,
    Color? solidColor,
    Color? yangColor,
    Color? yinColor,
    Map<WuXing, Color>? wuXingColors,
    ChangingYaoIndicator? changingIndicator,
  }) {
    return YaoThemeConfig(
      mode: mode ?? this.mode,
      solidColor: solidColor ?? this.solidColor,
      yangColor: yangColor ?? this.yangColor,
      yinColor: yinColor ?? this.yinColor,
      wuXingColors: wuXingColors ?? this.wuXingColors,
      changingIndicator: changingIndicator ?? this.changingIndicator,
    );
  }

  /// 转换为 Map
  Map<String, dynamic> toMap() {
    return {
      'mode': mode.name,
      'solidColor': solidColor.toARGB32(),
      'yangColor': yangColor.toARGB32(),
      'yinColor': yinColor.toARGB32(),
      'wuXingColors': wuXingColors.map(
        (key, value) => MapEntry(key.name, value.toARGB32()),
      ),
      'changingIndicator': changingIndicator.toMap(),
    };
  }

  /// 从 Map 创建
  factory YaoThemeConfig.fromMap(Map<String, dynamic> map) {
    final mode = YaoColorMode.values.byName(map['mode'] ?? 'solid');
    final wuXingColorsMap = map['wuXingColors'] as Map<String, dynamic>?;

    Map<WuXing, Color> wuXingColors = {};
    if (wuXingColorsMap != null) {
      for (final entry in wuXingColorsMap.entries) {
        final wuxing = WuXing.values.byName(entry.key);
        wuXingColors[wuxing] = Color(entry.value);
      }
    }

    return YaoThemeConfig(
      mode: mode,
      solidColor: Color(map['solidColor'] ?? 0xFF000000),
      yangColor: Color(map['yangColor'] ?? 0xFFFFFFFF),
      yinColor: Color(map['yinColor'] ?? 0xFF000000),
      wuXingColors: wuXingColors.isEmpty ? null : wuXingColors,
      changingIndicator: map['changingIndicator'] != null
          ? ChangingYaoIndicator.fromMap(map['changingIndicator'])
          : const ChangingYaoIndicator(),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is YaoThemeConfig &&
        other.mode == mode &&
        other.solidColor == solidColor &&
        other.yangColor == yangColor &&
        other.yinColor == yinColor &&
        other.changingIndicator == changingIndicator;
  }

  @override
  int get hashCode {
    return mode.hashCode ^
        solidColor.hashCode ^
        yangColor.hashCode ^
        yinColor.hashCode ^
        changingIndicator.hashCode;
  }
}
