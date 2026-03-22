import 'package:flutter/material.dart';
import '../models/divination_result.dart';
import '../utils/gua_calculator.dart';
import 'six_yao_widget.dart';

/// 卦象展示卡片
class GuaDisplayWidget extends StatelessWidget {
  final DivinationResult result;
  final bool showDetails;

  const GuaDisplayWidget({
    super.key,
    required this.result,
    this.showDetails = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(),
            const SizedBox(height: 16),
            _buildGuaSequence(),
            if (showDetails) ...[
              const SizedBox(height: 16),
              _buildDetails(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          result.method.displayName,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          _formatTime(result.timestamp),
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildGuaSequence() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildGuaColumn('本卦', result.originalGua),
        if (result.huGua != null) _buildGuaColumn('互卦', result.huGua!),
        _buildGuaColumn('变卦', result.changedGua),
      ],
    );
  }

  Widget _buildGuaColumn(String title, gua) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          gua.fullName,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        SixYaoWidget(
          upperGuaName: gua.upperGuaName,
          lowerGuaName: gua.lowerGuaName,
          changingYao: gua.changingYao,
          yaoSize: const Size(50, 6),
        ),
      ],
    );
  }

  Widget _buildDetails() {
    final gua = result.originalGua;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        const SizedBox(height: 8),
        _buildInfoRow('变爻', '第${gua.changingYao}爻'),
        _buildInfoRow('五行', GuaCalculator.getWuXing(gua.upperGuaName)),
        _buildInfoRow('方位', GuaCalculator.getDirection(gua.upperGuaName)),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.year}-${time.month.toString().padLeft(2, '0')}-${time.day.toString().padLeft(2, '0')} '
        '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}
