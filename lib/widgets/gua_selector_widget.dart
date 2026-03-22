import 'package:flutter/material.dart';

/// 八卦选择器组件
class GuaSelectorWidget extends StatelessWidget {
  /// 当前选中的卦 (1-8)
  final int? selectedGua;

  /// 选择回调
  final ValueChanged<int>? onGuaSelected;

  /// 标题
  final String? title;

  const GuaSelectorWidget({
    super.key,
    this.selectedGua,
    this.onGuaSelected,
    this.title,
  });

  /// 八卦数据
  static const List<Map<String, dynamic>> guaList = [
    {'num': 1, 'name': '乾', 'symbol': '☰', 'nature': '天'},
    {'num': 2, 'name': '兑', 'symbol': '☱', 'nature': '泽'},
    {'num': 3, 'name': '离', 'symbol': '☲', 'nature': '火'},
    {'num': 4, 'name': '震', 'symbol': '☳', 'nature': '雷'},
    {'num': 5, 'name': '巽', 'symbol': '☴', 'nature': '风'},
    {'num': 6, 'name': '坎', 'symbol': '☵', 'nature': '水'},
    {'num': 7, 'name': '艮', 'symbol': '☶', 'nature': '山'},
    {'num': 8, 'name': '坤', 'symbol': '☷', 'nature': '地'},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Text(
            title!,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
        ],
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            childAspectRatio: 1.2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: guaList.length,
          itemBuilder: (context, index) {
            final gua = guaList[index];
            final isSelected = selectedGua == gua['num'];
            return _buildGuaButton(gua, isSelected);
          },
        ),
      ],
    );
  }

  Widget _buildGuaButton(Map<String, dynamic> gua, bool isSelected) {
    return GestureDetector(
      onTap: () => onGuaSelected?.call(gua['num']),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.shade100 : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              gua['symbol'],
              style: TextStyle(
                fontSize: 28,
                color: isSelected ? Colors.blue.shade700 : Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${gua['name']}(${gua['nature']})',
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Colors.blue.shade700 : Colors.grey.shade700,
              ),
            ),
            Text(
              '先天数: ${gua['num']}',
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
