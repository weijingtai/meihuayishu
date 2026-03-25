import 'package:flutter/material.dart';

import '../models/divination_result.dart';
import '../services/yijing_data_service.dart';
import '../utils/gua_calculator.dart';
import 'gua_ci_card_widget.dart';
import 'six_yao_widget.dart';
import 'yao_ci_list_widget.dart';

/// 卦象展示卡片（含爻辞卦辞）
class GuaDisplayWidget extends StatefulWidget {
  final DivinationResult result;
  final bool showDetails;

  const GuaDisplayWidget({
    super.key,
    required this.result,
    this.showDetails = true,
  });

  @override
  State<GuaDisplayWidget> createState() => _GuaDisplayWidgetState();
}

class _GuaDisplayWidgetState extends State<GuaDisplayWidget> {
  final YijingDataService _yijingService = YijingDataService();
  bool _isLoading = true;
  String? _error;

  GuaFullData? _originalGuaData;
  GuaFullData? _huGuaData;
  GuaFullData? _changedGuaData;

  @override
  void initState() {
    super.initState();
    _loadYijingData();
  }

  Future<void> _loadYijingData() async {
    try {
      print('=== 开始加载易经数据 ===');
      await _yijingService.init();
      print('易经服务初始化完成');

      // 本卦（有动爻）
      final binary = widget.result.originalGua.toBinaryString();
      print('加载本卦数据: $binary, 动爻: ${widget.result.originalGua.changingYao}');
      _originalGuaData = await _yijingService.getGuaFullData(
        widget.result.originalGua,
      );
      print(
          '本卦数据结果: ${_originalGuaData?.fullname}, 卦辞: ${_originalGuaData?.guaCi}');

      // 互卦（无动爻）
      if (widget.result.huGua != null) {
        final huBinary = widget.result.huGua!.toBinaryString();
        print('加载互卦数据: $huBinary');
        _huGuaData = await _yijingService.getGuaFullData(widget.result.huGua!);
        print('互卦数据结果: ${_huGuaData?.fullname}');
      }

      // 变卦（无动爻）
      final changedBinary = widget.result.changedGua.toBinaryString();
      print('加载变卦数据: $changedBinary');
      _changedGuaData = await _yijingService.getGuaFullData(
        widget.result.changedGua,
      );
      print('变卦数据结果: ${_changedGuaData?.fullname}');

      print('=== 易经数据加载完成 ===');
      print('_originalGuaData: ${_originalGuaData != null}');
      print('_huGuaData: ${_huGuaData != null}');
      print('_changedGuaData: ${_changedGuaData != null}');

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

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
            if (widget.showDetails) ...[
              const SizedBox(height: 16),
              _buildDetails(),
            ],
            // 易经爻辞卦辞区域
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            _buildYijingSection(),
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
          widget.result.method.displayName,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          _formatTime(widget.result.timestamp),
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildGuaSequence() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildGuaColumn('本卦', widget.result.originalGua, hasChangingYao: true),
        if (widget.result.huGua != null)
          _buildGuaColumn('互卦', widget.result.huGua!, hasChangingYao: false),
        _buildGuaColumn('变卦', widget.result.changedGua, hasChangingYao: false),
      ],
    );
  }

  Widget _buildGuaColumn(String title, gua, {required bool hasChangingYao}) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Text(
          gua.fullName,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        SixYaoWidget(
          upperGuaName: gua.upperGuaName,
          lowerGuaName: gua.lowerGuaName,
          changingYao: hasChangingYao ? gua.changingYao : 0,
          yaoSize: const Size(50, 6),
        ),
      ],
    );
  }

  Widget _buildDetails() {
    final gua = widget.result.originalGua;
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
            child: Text(label, style: TextStyle(color: Colors.grey[600])),
          ),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildYijingSection() {
    if (_isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_error != null) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          '加载易经数据失败: $_error',
          style: TextStyle(color: Colors.red.shade700),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 标题
        Row(
          children: [
            Icon(Icons.auto_stories, size: 20, color: Colors.brown.shade700),
            const SizedBox(width: 8),
            Text(
              '易经解析',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.brown.shade700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // 本卦卦辞
        if (_originalGuaData != null) ...[
          GuaCiCardWidget(guaData: _originalGuaData!, title: '本卦'),
          const SizedBox(height: 12),
          // 本卦爻辞（显示动爻高亮）
          YaoCiListWidget(
            guaData: _originalGuaData!,
            showChangingHighlight: true,
          ),
        ],

        // 互卦卦辞（无动爻高亮）
        if (_huGuaData != null) ...[
          const SizedBox(height: 16),
          GuaCiCardWidget(guaData: _huGuaData!, title: '互卦'),
          const SizedBox(height: 12),
          YaoCiListWidget(guaData: _huGuaData!, showChangingHighlight: false),
        ],

        // 变卦卦辞（无动爻高亮）
        if (_changedGuaData != null) ...[
          const SizedBox(height: 16),
          GuaCiCardWidget(guaData: _changedGuaData!, title: '变卦'),
          const SizedBox(height: 12),
          YaoCiListWidget(
            guaData: _changedGuaData!,
            showChangingHighlight: false,
          ),
        ],
      ],
    );
  }

  String _formatTime(DateTime time) {
    return '${time.year}-${time.month.toString().padLeft(2, '0')}-${time.day.toString().padLeft(2, '0')} '
        '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}
