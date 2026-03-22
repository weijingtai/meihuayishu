import 'package:flutter/material.dart';

/// 八卦选择器组件
class GuaSelectorWidget extends StatelessWidget {
  /// 当前选中的卦
  final int? selectedGua;

  /// 选择回调
  final ValueChanged<int>? onGuaSelected;

  /// 标题
  final String? title;

  /// 是否是先天卦模式
  final bool isXianTian;

  const GuaSelectorWidget({
    super.key,
    this.selectedGua,
    this.onGuaSelected,
    this.title,
    this.isXianTian = true,
  });

  /// 先天八卦数据（乾1兑2离3震4巽5坎6艮7坤8）
  static const List<Map<String, dynamic>> xianTianGuaList = [
    {'num': 1, 'name': '乾', 'symbol': '☰', 'nature': '天'},
    {'num': 2, 'name': '兑', 'symbol': '☱', 'nature': '泽'},
    {'num': 3, 'name': '离', 'symbol': '☲', 'nature': '火'},
    {'num': 4, 'name': '震', 'symbol': '☳', 'nature': '雷'},
    {'num': 5, 'name': '巽', 'symbol': '☴', 'nature': '风'},
    {'num': 6, 'name': '坎', 'symbol': '☵', 'nature': '水'},
    {'num': 7, 'name': '艮', 'symbol': '☶', 'nature': '山'},
    {'num': 8, 'name': '坤', 'symbol': '☷', 'nature': '地'},
  ];

  /// 后天八卦数据（按后天方位数：坎1坤2震3巽4乾6兑7艮8离9）
  static const List<Map<String, dynamic>> houTianGuaList = [
    {'num': 1, 'name': '坎', 'symbol': '☵', 'nature': '水', 'position': 7},
    {'num': 2, 'name': '坤', 'symbol': '☷', 'nature': '地', 'position': 2},
    {'num': 3, 'name': '震', 'symbol': '☳', 'nature': '雷', 'position': 3},
    {'num': 4, 'name': '巽', 'symbol': '☴', 'nature': '风', 'position': 0},
    {'num': 6, 'name': '乾', 'symbol': '☰', 'nature': '天', 'position': 8},
    {'num': 7, 'name': '兑', 'symbol': '☱', 'nature': '泽', 'position': 5},
    {'num': 8, 'name': '艮', 'symbol': '☶', 'nature': '山', 'position': 6},
    {'num': 9, 'name': '离', 'symbol': '☲', 'nature': '火', 'position': 1},
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title != null) ...[
              Text(
                title!,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
            ],
            isXianTian ? _buildXianTianLayout() : _buildHouTianLayout(),
          ],
        ),
      ),
    );
  }

  /// 先天卦布局：横排 1-8
  Widget _buildXianTianLayout() {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: xianTianGuaList.map((gua) {
        final isSelected = selectedGua == gua['num'];
        return _buildCompactGuaButton(gua, isSelected);
      }).toList(),
    );
  }

  /// 后天卦布局：3x3 井字格
  /// 后天八卦方位：
  /// 巽4  离9  坤2
  /// 震3  (中) 兑7
  /// 艮8  坎1  乾6
  Widget _buildHouTianLayout() {
    // 创建3x3网格，按位置填充
    final grid = List<Map<String, dynamic>?>.filled(9, null);
    for (final gua in houTianGuaList) {
      final position = gua['position'] as int;
      if (position >= 0 && position < 9) {
        grid[position] = gua;
      }
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int row = 0; row < 3; row++)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int col = 0; col < 3; col++) ...[
                if (col > 0) const SizedBox(width: 6),
                SizedBox(
                  width: 70,
                  height: 60,
                  child: _buildGridCell(grid[row * 3 + col]),
                ),
              ],
            ],
          ),
      ],
    );
  }

  /// 构建网格单元
  Widget _buildGridCell(Map<String, dynamic>? gua) {
    if (gua == null) {
      // 中心位置（空）
      return Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.transparent, width: 2),
        ),
        child: const Center(
          child: Text(
            '中',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ),
      );
    }

    final isSelected = selectedGua == gua['num'];
    return GestureDetector(
      onTap: () => onGuaSelected?.call(gua['num']),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.shade100 : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey.shade300,
            width: 2, // 固定2px边框，避免选中时溢出
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              gua['symbol'],
              style: TextStyle(
                fontSize: 20,
                color: isSelected ? Colors.blue.shade700 : Colors.black87,
              ),
            ),
            Text(
              gua['name'],
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Colors.blue.shade700 : Colors.grey.shade700,
              ),
            ),
            Text(
              '${gua['num']}',
              style: TextStyle(
                fontSize: 9,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建紧凑型卦按钮
  Widget _buildCompactGuaButton(Map<String, dynamic> gua, bool isSelected) {
    return GestureDetector(
      onTap: () => onGuaSelected?.call(gua['num']),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 70,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.shade100 : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey.shade300,
            width: 2, // 固定2px边框
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              gua['symbol'],
              style: TextStyle(
                fontSize: 20,
                color: isSelected ? Colors.blue.shade700 : Colors.black87,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              gua['name'],
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Colors.blue.shade700 : Colors.grey.shade700,
              ),
            ),
            Text(
              '${gua['num']}',
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
