import 'package:flutter/material.dart';
import '../utils/gua_calculator.dart';

/// 六爻完整卦象组件
class SixYaoWidget extends StatelessWidget {
  /// 上卦名称
  final String upperGuaName;

  /// 下卦名称
  final String lowerGuaName;

  /// 动爻位置 (1-6)
  final int changingYao;

  /// 爻的尺寸
  final Size yaoSize;

  /// 爻间距
  final double yaoSpacing;

  /// 颜色
  final Color color;

  /// 动爻颜色
  final Color changingColor;

  const SixYaoWidget({
    super.key,
    required this.upperGuaName,
    required this.lowerGuaName,
    required this.changingYao,
    this.yaoSize = const Size(80, 10),
    this.yaoSpacing = 4,
    this.color = Colors.black87,
    this.changingColor = Colors.red,
  });

  @override
  Widget build(BuildContext context) {
    final upperBinary = _getBinary(upperGuaName);
    final lowerBinary = _getBinary(lowerGuaName);

    // 从下往上排列：下卦在下，上卦在上
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 上卦（4,5,6爻）
        _buildThreeYao(upperBinary, 4),
        SizedBox(height: yaoSpacing * 2),
        // 下卦（1,2,3爻）
        _buildThreeYao(lowerBinary, 1),
      ],
    );
  }

  Widget _buildThreeYao(String binary, int startYao) {
    // binary 是从下往上的顺序，需要反转显示
    final yaoList = binary.split('').reversed.toList();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        final yaoPosition = startYao + (2 - index);
        final isYang = yaoList[index] == '1';
        final isChanging = yaoPosition == changingYao;

        return Padding(
          padding: EdgeInsets.only(bottom: index < 2 ? yaoSpacing : 0),
          child: _buildSingleYao(isYang, isChanging),
        );
      }),
    );
  }

  Widget _buildSingleYao(bool isYang, bool isChanging) {
    final yaoColor = isChanging ? changingColor : color;

    if (isYang) {
      // 阳爻：实线
      return Container(
        width: yaoSize.width,
        height: yaoSize.height,
        decoration: BoxDecoration(
          color: yaoColor,
          borderRadius: BorderRadius.circular(yaoSize.height / 2),
        ),
      );
    } else {
      // 阴爻：断线
      return SizedBox(
        width: yaoSize.width,
        height: yaoSize.height,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: yaoSize.width * 0.44,
              height: yaoSize.height,
              decoration: BoxDecoration(
                color: yaoColor,
                borderRadius: BorderRadius.circular(yaoSize.height / 2),
              ),
            ),
            SizedBox(width: yaoSize.width * 0.12),
            Container(
              width: yaoSize.width * 0.44,
              height: yaoSize.height,
              decoration: BoxDecoration(
                color: yaoColor,
                borderRadius: BorderRadius.circular(yaoSize.height / 2),
              ),
            ),
          ],
        ),
      );
    }
  }

  String _getBinary(String guaName) {
    final guaNum = GuaCalculator.guaNameToNumber(guaName);
    const guaBinaries = [
      '111', // 乾
      '110', // 兑
      '101', // 离
      '100', // 震
      '011', // 巽
      '010', // 坎
      '001', // 艮
      '000', // 坤
    ];
    return guaBinaries[guaNum - 1];
  }
}
