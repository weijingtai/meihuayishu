import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../meihuayishu.dart';
import '../services/meihua_service.dart';
import '../database/meihua_database.dart';
import '../services/divination_record_service.dart';
import '../services/four_zhu_service.dart';
import '../services/jie_qi_service.dart';
import 'meihua_divination_page.dart';
import 'meihua_history_page.dart';

/// 主页 - 支持新旧系统切换
class HomePage extends StatefulWidget {
  final Widget Function()? oldSystemBuilder;
  final bool showSystemSwitch;

  const HomePage({
    super.key,
    this.oldSystemBuilder,
    this.showSystemSwitch = true,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _useNewSystem = true;
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('梅花易数'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          if (widget.showSystemSwitch) _buildSystemSwitch(),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  /// 构建系统切换按钮
  Widget _buildSystemSwitch() {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.deepPurple.shade200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildSwitchButton(
            label: '旧版',
            isSelected: !_useNewSystem,
            onTap: () => setState(() => _useNewSystem = false),
          ),
          _buildSwitchButton(
            label: '新版',
            isSelected: _useNewSystem,
            onTap: () => setState(() => _useNewSystem = true),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? Colors.deepPurple : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? Colors.white : Colors.deepPurple,
          ),
        ),
      ),
    );
  }

  /// 构建主内容
  Widget _buildBody() {
    if (!_useNewSystem && widget.oldSystemBuilder != null) {
      // 使用旧版系统
      return widget.oldSystemBuilder!();
    }

    // 使用新版系统
    return _buildNewSystemBody();
  }

  /// 构建新版系统内容
  Widget _buildNewSystemBody() {
    return IndexedStack(
      index: _selectedIndex,
      children: [
        // 起卦页面
        MultiProvider(
          providers: [
            Provider<MeiHuaService>(create: (_) => MeiHuaService()),
            Provider<MeiHuaDatabase>(create: (_) => MeiHuaYiShuModule.database),
            Provider<DivinationRecordService>(
              create: (ctx) =>
                  DivinationRecordService(ctx.read<MeiHuaDatabase>()),
            ),
            Provider<FourZhuService>(create: (_) => FourZhuService()),
            Provider<JieQiService>(create: (_) => JieQiService()),
          ],
          child: const MeiHuaDivinationPage(),
        ),
        // 历史记录页面
        MultiProvider(
          providers: [
            Provider<MeiHuaDatabase>(create: (_) => MeiHuaYiShuModule.database),
            Provider<DivinationRecordService>(
              create: (ctx) =>
                  DivinationRecordService(ctx.read<MeiHuaDatabase>()),
            ),
          ],
          child: const MeiHuaHistoryPage(),
        ),
      ],
    );
  }

  /// 构建底部导航
  Widget _buildBottomNav() {
    if (!_useNewSystem) {
      // 旧版系统不需要底部导航
      return const SizedBox.shrink();
    }

    return NavigationBar(
      selectedIndex: _selectedIndex,
      onDestinationSelected: (index) {
        setState(() => _selectedIndex = index);
      },
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.auto_awesome),
          selectedIcon: Icon(Icons.auto_awesome, color: Colors.deepPurple),
          label: '起卦',
        ),
        NavigationDestination(
          icon: Icon(Icons.history),
          selectedIcon: Icon(Icons.history, color: Colors.deepPurple),
          label: '历史',
        ),
      ],
    );
  }
}
