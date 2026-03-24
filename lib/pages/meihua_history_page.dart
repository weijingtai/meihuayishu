import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../database/meihua_database.dart';
import '../database/tables/meihua_gua_infos.dart';
import '../services/divination_record_service.dart';

/// 梅花易数历史记录页面
class MeiHuaHistoryPage extends StatefulWidget {
  const MeiHuaHistoryPage({super.key});

  @override
  State<MeiHuaHistoryPage> createState() => _MeiHuaHistoryPageState();
}

class _MeiHuaHistoryPageState extends State<MeiHuaHistoryPage> {
  late Stream<List<MeiHuaGuaInfo>> _recordsStream;

  @override
  void initState() {
    super.initState();
    final service = context.read<DivinationRecordService>();
    _recordsStream = service.watchAllRecords();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('起卦历史记录'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: StreamBuilder<List<MeiHuaGuaInfo>>(
        stream: _recordsStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('错误: ${snapshot.error}'),
                ],
              ),
            );
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final records = snapshot.data!;

          if (records.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox, size: 64, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text(
                    '暂无起卦记录',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '起卦后记录将显示在这里',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: records.length,
            itemBuilder: (context, index) {
              final record = records[index];
              return _buildRecordCard(record);
            },
          );
        },
      ),
    );
  }

  Widget _buildRecordCard(MeiHuaGuaInfo record) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _viewRecordDetail(record),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 问题和时间
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      record.question ?? '未注明问题',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: record.question != null
                            ? Colors.black87
                            : Colors.grey,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _formatDateTime(record.createdAt),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // 卦象信息
              Row(
                children: [
                  _buildGuaChip('本卦', record.originalUpperGua,
                      record.originalLowerGua),
                  const SizedBox(width: 8),
                  _buildGuaChip(
                      '变卦', record.changedUpperGua, record.changedLowerGua),
                  const SizedBox(width: 8),
                  _buildGuaChip('互卦', record.huUpperGua, record.huLowerGua),
                ],
              ),
              const SizedBox(height: 8),

              // 起卦方法
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  _getMethodDisplayName(record.method),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.blue.shade700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGuaChip(String label, int upper, int lower) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        '$label: $upper/$lower',
        style: const TextStyle(fontSize: 12),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return '刚刚';
        }
        return '${difference.inMinutes}分钟前';
      }
      return '${difference.inHours}小时前';
    } else if (difference.inDays == 1) {
      return '昨天';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}天前';
    } else {
      return '${dateTime.month}月${dateTime.day}日';
    }
  }

  String _getMethodDisplayName(String method) {
    switch (method) {
      case 'time':
        return '时空起卦';
      case 'number':
        return '报数起卦';
      case 'text':
        return '文字起卦';
      case 'manual':
        return '手动起卦';
      case 'random':
        return '随机起卦';
      default:
        return method;
    }
  }

  void _viewRecordDetail(MeiHuaGuaInfo record) {
    // TODO: 导航到记录详情页面
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('查看记录: ${record.question ?? "未注明"}')),
    );
  }
}
