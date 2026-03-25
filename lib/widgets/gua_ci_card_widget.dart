import 'package:flutter/material.dart';

import '../services/yijing_data_service.dart';

/// 卦辞卡片展示组件
/// 显示卦辞、彖辞、象辞
class GuaCiCardWidget extends StatelessWidget {
  /// 卦象完整数据
  final GuaFullData guaData;

  /// 卡片标题（如"本卦"、"互卦"、"变卦"）
  final String title;

  const GuaCiCardWidget({
    super.key,
    required this.guaData,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 卦名标题
          _buildHeader(),
          const SizedBox(height: 12),
          // 卦辞
          if (guaData.guaCi != null && guaData.guaCi!.isNotEmpty)
            _buildCiSection('卦辞', guaData.guaCi!, Colors.blue.shade700),
          // 彖辞
          if (guaData.tuanCi != null && guaData.tuanCi!.isNotEmpty)
            _buildCiSection('彖曰', guaData.tuanCi!, Colors.purple.shade700),
          // 象辞
          if (guaData.xiangCi != null && guaData.xiangCi!.isNotEmpty)
            _buildCiSection('象曰', guaData.xiangCi!, Colors.green.shade700),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        // 卦序
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.blue.shade100,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            '第${guaData.seq}卦',
            style: TextStyle(
              fontSize: 12,
              color: Colors.blue.shade800,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(width: 8),
        // 卦名
        Text(
          guaData.fullname,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 8),
        // 标签（本卦/互卦/变卦）
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            title,
            style: TextStyle(fontSize: 11, color: Colors.grey.shade700),
          ),
        ),
      ],
    );
  }

  Widget _buildCiSection(String label, String content, Color labelColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标签
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: labelColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: labelColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 8),
          // 内容
          Expanded(
            child: Text(
              content,
              style: const TextStyle(fontSize: 14, height: 1.6),
            ),
          ),
        ],
      ),
    );
  }
}
