import 'package:flutter/material.dart';

/// 六爻选择器组件
class YaoSelectorWidget extends StatelessWidget {
  /// 当前选中的动爻 (1-6)
  final int? selectedYao;

  /// 选择回调
  final ValueChanged<int>? onYaoSelected;

  /// 标题
  final String? title;

  const YaoSelectorWidget({
    super.key,
    this.selectedYao,
    this.onYaoSelected,
    this.title,
  });

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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(6, (index) {
            final yaoNum = index + 1;
            final isSelected = selectedYao == yaoNum;
            return _buildYaoButton(yaoNum, isSelected);
          }),
        ),
      ],
    );
  }

  Widget _buildYaoButton(int yaoNum, bool isSelected) {
    return GestureDetector(
      onTap: () => onYaoSelected?.call(yaoNum),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 48,
        height: 64,
        decoration: BoxDecoration(
          color: isSelected ? Colors.red.shade100 : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Colors.red : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _getYaoName(yaoNum),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.red.shade700 : Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              width: 32,
              height: 4,
              decoration: BoxDecoration(
                color: isSelected ? Colors.red.shade700 : Colors.grey.shade600,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              '$yaoNum',
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

  String _getYaoName(int yaoNum) {
    const names = ['初', '二', '三', '四', '五', '上'];
    return names[yaoNum - 1];
  }
}
