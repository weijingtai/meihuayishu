import 'package:flutter/material.dart';

import '../services/yijing_data_service.dart';

/// 爻辞列表展示组件
/// 显示6爻的爻辞和象辞，动爻高亮显示
class YaoCiListWidget extends StatelessWidget {
  /// 卦象完整数据
  final GuaFullData guaData;

  /// 是否显示动爻高亮
  final bool showChangingHighlight;

  const YaoCiListWidget({
    super.key,
    required this.guaData,
    this.showChangingHighlight = true,
  });

  @override
  Widget build(BuildContext context) {
    if (guaData.yaoCiList.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 标题
        Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Row(
            children: [
              Icon(
                Icons.format_list_numbered,
                size: 18,
                color: Colors.indigo.shade700,
              ),
              const SizedBox(width: 6),
              Text(
                '六爻爻辞',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo.shade700,
                ),
              ),
            ],
          ),
        ),
        // 爻辞列表（从初爻到上爻）
        ...List.generate(6, (index) {
          final position = index + 1;
          final yaoItem = guaData.getYaoAt(position);
          if (yaoItem == null) return const SizedBox.shrink();

          final isChanging =
              showChangingHighlight && guaData.isChangingYao(position);
          return _buildYaoItem(context, yaoItem, position, isChanging);
        }),
      ],
    );
  }

  Widget _buildYaoItem(
    BuildContext context,
    YaoCiItem yaoItem,
    int position,
    bool isChanging,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: isChanging ? Colors.amber.shade50 : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isChanging ? Colors.amber.shade400 : Colors.grey.shade300,
          width: isChanging ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 爻名行
          Row(
            children: [
              // 爻名
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: isChanging
                      ? Colors.amber.shade200
                      : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  yaoItem.yaoName,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isChanging
                        ? Colors.amber.shade900
                        : Colors.grey.shade800,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // 动爻标记
              if (isChanging) ...[
                Icon(Icons.star, size: 16, color: Colors.amber.shade700),
                const SizedBox(width: 4),
                Text(
                  '动爻',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.amber.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),
          // 爻辞内容
          if (yaoItem.yaoCi != null && yaoItem.yaoCi!.isNotEmpty)
            _buildTextSection('爻辞', yaoItem.yaoCi!),
          // 象辞内容
          if (yaoItem.xiangCi != null && yaoItem.xiangCi!.isNotEmpty) ...[
            const SizedBox(height: 4),
            _buildTextSection('象曰', yaoItem.xiangCi!),
          ],
        ],
      ),
    );
  }

  Widget _buildTextSection(String label, String content) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label：',
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
        Expanded(
          child: Text(
            content,
            style: const TextStyle(fontSize: 13, height: 1.5),
          ),
        ),
      ],
    );
  }
}
