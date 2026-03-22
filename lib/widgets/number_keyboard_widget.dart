import 'package:flutter/material.dart';

/// 数字键盘组件
class NumberKeyboardWidget extends StatelessWidget {
  /// 数字输入回调
  final ValueChanged<String>? onNumberPressed;

  /// 删除回调
  final VoidCallback? onDelete;

  /// 清除回调
  final VoidCallback? onClear;

  /// 确认回调
  final VoidCallback? onConfirm;

  /// 当前输入的数字
  final String currentNumber;

  const NumberKeyboardWidget({
    super.key,
    this.onNumberPressed,
    this.onDelete,
    this.onClear,
    this.onConfirm,
    this.currentNumber = '',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 显示当前输入
        _buildDisplay(),
        const SizedBox(height: 16),
        // 数字键盘
        _buildKeyboard(),
      ],
    );
  }

  Widget _buildDisplay() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '输入数字',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            currentNumber.isEmpty ? '请输入...' : currentNumber,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: currentNumber.isEmpty ? Colors.grey : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeyboard() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      childAspectRatio: 1.5,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      children: [
        _buildKeyButton('1'),
        _buildKeyButton('2'),
        _buildKeyButton('3'),
        _buildKeyButton('4'),
        _buildKeyButton('5'),
        _buildKeyButton('6'),
        _buildKeyButton('7'),
        _buildKeyButton('8'),
        _buildKeyButton('9'),
        _buildActionButton('清除', onClear, Colors.orange),
        _buildKeyButton('0'),
        _buildActionButton('删除', onDelete, Colors.red),
      ],
    );
  }

  Widget _buildKeyButton(String number) {
    return ElevatedButton(
      onPressed: () => onNumberPressed?.call(number),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 2,
      ),
      child: Text(
        number,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildActionButton(
      String label, VoidCallback? onPressed, Color color) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withOpacity(0.1),
        foregroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 2,
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
