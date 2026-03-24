import 'package:flutter/material.dart';
import 'package:meihuayishu/meihuayishu.dart';
import 'package:provider/provider.dart';
import 'package:common/database/app_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MeiHuaYiShuModule.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '梅花易数',
      debugShowCheckedModeBanner: false,
      theme: MeiHuaTheme.lightTheme,
      darkTheme: MeiHuaTheme.darkTheme,
      themeMode: ThemeMode.light,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          // 使用新的模块化起卦页面
          MeiHuaYiShuModule.getHomePage(),
          // 历史记录页面
          const MeiHuaHistoryPage(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.auto_awesome),
            selectedIcon: Icon(Icons.auto_awesome, color: Colors.white),
            label: '起卦',
          ),
          NavigationDestination(
            icon: Icon(Icons.history),
            selectedIcon: Icon(Icons.history, color: Colors.white),
            label: '历史',
          ),
        ],
      ),
    );
  }
}
