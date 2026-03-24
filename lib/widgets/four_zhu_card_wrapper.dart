import 'package:flutter/material.dart';
import 'package:common/widgets/four_zhu_eight_chars_card.dart';
import 'package:common/themes/editable_four_zhu_card_theme.dart';

/// 四柱卡片包装器
/// 预留主题配置接口，方便后续完善
class FourZhuCardWrapper extends StatelessWidget {
  /// 四柱八字数据
  final dynamic eightChars;

  /// 胎元模型
  final dynamic taiYuan;

  /// 预留主题接口
  final ValueNotifier<EditableFourZhuCardTheme>? themeNotifier;

  /// 显示选项
  final bool showTaiYuan;
  final bool showXunShou;
  final bool showNaYin;
  final bool showKongWang;
  final bool showKe;

  const FourZhuCardWrapper({
    super.key,
    required this.eightChars,
    required this.taiYuan,
    this.themeNotifier,
    this.showTaiYuan = true,
    this.showXunShou = true,
    this.showNaYin = true,
    this.showKongWang = true,
    this.showKe = false,
  });

  @override
  Widget build(BuildContext context) {
    // 使用默认主题或传入的主题
    return FourZhuEightCharsCard(
      eightChars: eightChars,
      taiYuan: taiYuan,
      showTaiYuan: showTaiYuan,
      showXunShou: showXunShou,
      showNaYin: showNaYin,
      showKongWang: showKongWang,
      showKe: showKe,
    );
  }
}
