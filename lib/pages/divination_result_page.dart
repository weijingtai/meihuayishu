import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:common/widgets/jie_qi_rise_set_card.dart';
import 'package:common/themes/editable_four_zhu_card_theme.dart';

import '../models/divination_result.dart';
import '../services/divination_record_service.dart';
import '../widgets/gua_display_widget.dart';
import '../widgets/four_zhu_card_wrapper.dart';

/// 起卦结果展示页面
/// 包含四柱卡片 + 物候信息 + 卦象展示 + 可隐藏的起卦算法
class DivinationResultPage extends StatefulWidget {
  /// 起卦结果
  final DivinationResult result;

  /// 卜问内容
  final String? question;

  /// 预留四柱主题接口
  final ValueNotifier<EditableFourZhuCardTheme>? fourZhuThemeNotifier;

  const DivinationResultPage({
    super.key,
    required this.result,
    this.question,
    this.fourZhuThemeNotifier,
  });

  @override
  State<DivinationResultPage> createState() => _DivinationResultPageState();
}

class _DivinationResultPageState extends State<DivinationResultPage> {
  bool _showAlgorithm = false;
  bool _isSaving = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('起卦结果'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: _isSaving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.save),
            onPressed: _isSaving ? null : _saveResult,
            tooltip: '保存',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 卜问内容卡片
            if (widget.question != null && widget.question!.isNotEmpty)
              _buildQuestionCard(),

            const SizedBox(height: 16),

            // 四柱卡片区域
            _buildFourZhuSection(),

            const SizedBox(height: 16),

            // 物候信息区域
            _buildJieQiSection(),

            const SizedBox(height: 16),

            // 卦象展示区域
            GuaDisplayWidget(result: widget.result),

            const SizedBox(height: 16),

            // 起卦算法（可折叠）
            _buildAlgorithmSection(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  /// 构建卜问内容卡片
  Widget _buildQuestionCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.help_outline, color: Colors.blue.shade700),
                const SizedBox(width: 8),
                Text(
                  '卜问内容',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              widget.question!,
              style: const TextStyle(fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建四柱卡片区域
  Widget _buildFourZhuSection() {
    // TODO: 集成四柱卡片
    // 需要从起卦时间计算四柱数据
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.calendar_today, color: Colors.orange.shade700),
                const SizedBox(width: 8),
                Text(
                  '四柱信息',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange.shade700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // 四柱卡片占位
            Container(
              height: 100,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text(
                  '四柱卡片（待集成）',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建物候信息区域
  Widget _buildJieQiSection() {
    // TODO: 集成物候信息卡片
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.wb_sunny, color: Colors.green.shade700),
                const SizedBox(width: 8),
                Text(
                  '物候信息',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // 物候信息卡片占位
            Container(
              height: 100,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text(
                  '物候信息卡片（待集成）',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建起卦算法区域（可折叠）
  Widget _buildAlgorithmSection() {
    return Card(
      elevation: 2,
      child: ExpansionTile(
        title: Row(
          children: [
            Icon(Icons.code, color: Colors.purple.shade700),
            const SizedBox(width: 8),
            Text(
              '起卦算法',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.purple.shade700,
              ),
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAlgorithmInfo('起卦方法', widget.result.method.displayName),
                _buildAlgorithmInfo('起卦时间', widget.result.timestamp.toString()),
                if (widget.result.params.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  const Text(
                    '起卦参数:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  ...widget.result.params.entries.map(
                    (e) => _buildAlgorithmInfo(e.key, e.value.toString()),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlgorithmInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  /// 构建底部操作栏
  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
              label: const Text('返回'),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _isSaving ? null : _saveResult,
              icon: _isSaving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.save),
              label: Text(_isSaving ? '保存中...' : '保存'),
            ),
          ),
        ],
      ),
    );
  }

  /// 保存结果
  Future<void> _saveResult() async {
    setState(() {
      _isSaving = true;
    });

    try {
      final service = context.read<DivinationRecordService>();
      final uuid = await service.saveDivination(
        result: widget.result,
        question: widget.question,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('保存成功: $uuid'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('保存失败: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }
}
