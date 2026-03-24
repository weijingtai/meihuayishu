# 梅花易数 - UI整合文档

## 1. 概述

### 1.1 设计理念

采用中国风设计风格，融合传统元素与现代交互，提供优雅的占卜体验。

### 1.2 设计原则

| 原则 | 说明 |
|------|------|
| **中国风** | 使用传统颜色、字体和样式 |
| **简洁性** | 清晰的布局，避免信息过载 |
| **一致性** | 统一的组件样式和交互模式 |
| **响应式** | 适配不同屏幕尺寸 |

---

## 2. 色彩规范

### 2.1 中国传统色

```dart
// 宣纸白 - 主背景
static const Color paperWhite = Color(0xFFF7F5F0);

// 墨黑 - 主文字
static const Color inkBlack = Color(0xFF2C2C2C);

// 朱砂红 - 强调色
static const Color cinnabarRed = Color(0xFFE63946);

// 翠绿 - 主色调
static const Color jadeGreen = Color(0xFF2A9D8F);

// 金黄 - 辅助色
static const Color goldYellow = Color(0xFFF4A261);

// 天青 - 辅助色
static const Color skyBlue = Color(0xFF457B9D);
```

### 2.2 颜色使用场景

| 颜色 | 使用场景 |
|------|----------|
| 宣纸白 | 页面背景、卡片背景 |
| 墨黑 | 主要文字、标题 |
| 朱砂红 | 强调按钮、错误提示 |
| 翠绿 | 主按钮、成功提示 |
| 金黄 | 四柱卡片、特殊标记 |
| 天青 | 链接、次要按钮 |

### 2.3 十天干颜色

| 天干 | 颜色 | 色值 |
|------|------|------|
| 甲 | 铜绿 | #2A9D8F |
| 乙 | 铜绿 | #2A9D8F |
| 丙 | 西瓜红 | #E63946 |
| 丁 | 西瓜红 | #E63946 |
| 戊 | 驼色 | #C4A35A |
| 己 | 驼色 | #C4A35A |
| 庚 | 黄金叶 | #F4A261 |
| 辛 | 黄金叶 | #F4A261 |
| 壬 | 景泰蓝 | #457B9D |
| 癸 | 景泰蓝 | #457B9D |

### 2.4 十二地支颜色

| 地支 | 颜色 | 色值 |
|------|------|------|
| 子 | 天青色 | #457B9D |
| 丑 | 茶色 | #8B7355 |
| 寅 | 豆绿 | #2A9D8F |
| 卯 | 豆绿 | #2A9D8F |
| 辰 | 麦秸黄 | #F4A261 |
| 巳 | 丹橙 | #E63946 |
| 午 | 丹橙 | #E63946 |
| 未 | 沙棕 | #C4A35A |
| 申 | 赤金 | #D4AF37 |
| 酉 | 赤金 | #D4AF37 |
| 戌 | 赭色 | #8B7355 |
| 亥 | 天青色 | #457B9D |

---

## 3. 字体规范

### 3.1 字体选择

```dart
// 使用 Google Fonts 的思源黑体
import 'package:google_fonts/google_fonts.dart';

// 主要字体
final notoSansSc = GoogleFonts.notoSansSc();

// 书法字体（用于特殊展示）
final longCang = GoogleFonts.longCang();      // 龙藏体 - 地支
final maShanZheng = GoogleFonts.maShanZheng(); // 马善政体 - 天干
```

### 3.2 字体大小

| 类型 | 大小 | 用途 |
|------|------|------|
| 标题 | 20px | 页面标题 |
| 子标题 | 18px | 卡片标题 |
| 正文 | 16px | 主要内容 |
| 辅助文字 | 14px | 说明文字 |
| 小字 | 12px | 标签、时间 |

### 3.3 字体粗细

| 粗细 | 用途 |
|------|------|
| FontWeight.bold | 标题、强调 |
| FontWeight.w500 | 子标题 |
| FontWeight.normal | 正文 |

---

## 4. 组件规范

### 4.1 卡片组件

```dart
Card(
  elevation: 2,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
  ),
  child: Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 标题行
        Row(
          children: [
            Icon(Icons.icon_name, color: Colors.color.shade700),
            const SizedBox(width: 8),
            Text(
              '标题',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.color.shade700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // 内容
      ],
    ),
  ),
)
```

### 4.2 按钮组件

#### 主按钮（ElevatedButton）

```dart
ElevatedButton.icon(
  onPressed: () {},
  icon: const Icon(Icons.icon_name),
  label: const Text('按钮文字'),
  style: ElevatedButton.styleFrom(
    backgroundColor: jadeGreen,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(vertical: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
)
```

#### 次要按钮（OutlinedButton）

```dart
OutlinedButton.icon(
  onPressed: () {},
  icon: const Icon(Icons.icon_name),
  label: const Text('按钮文字'),
  style: OutlinedButton.styleFrom(
    foregroundColor: inkBlack,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
)
```

### 4.3 输入框组件

```dart
TextField(
  decoration: InputDecoration(
    labelText: '标签',
    hintText: '提示文字',
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
)
```

### 4.4 标签组件

```dart
Container(
  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
  decoration: BoxDecoration(
    color: Colors.color.shade50,
    borderRadius: BorderRadius.circular(4),
  ),
  child: Text(
    '标签文字',
    style: TextStyle(
      fontSize: 12,
      color: Colors.color.shade700,
    ),
  ),
)
```

---

## 5. 页面布局

### 5.1 起卦页面

#### 布局结构

```
┌─────────────────────────────────────┐
│  AppBar: 梅花易数                    │
│  Actions: [历史记录按钮]             │
├─────────────────────────────────────┤
│  SingleChildScrollView               │
│  ┌─────────────────────────────┐    │
│  │ Card: 卜问输入区域          │    │
│  │ ┌───────────────────────┐  │    │
│  │ │ DivinationQuestion    │  │    │
│  │ │ Widget                │  │    │
│  │ └───────────────────────┘  │    │
│  └─────────────────────────────┘    │
│  ┌─────────────────────────────┐    │
│  │ Card: 起卦方案选择          │    │
│  │ ┌───────────────────────┐  │    │
│  │ │ TabBar: 时空|报数|    │  │    │
│  │ │        文字|手动       │  │    │
│  │ ├───────────────────────┤  │    │
│  │ │ TabBarView            │  │    │
│  │ │ - 时空起卦Tab         │  │    │
│  │ │ - 报数起卦Tab         │  │    │
│  │ │ - 文字起卦Tab         │  │    │
│  │ │ - 手动起卦Tab         │  │    │
│  │ └───────────────────────┘  │    │
│  └─────────────────────────────┘    │
│  ┌─────────────────────────────┐    │
│  │ ElevatedButton: 查看结果    │    │
│  └─────────────────────────────┘    │
└─────────────────────────────────────┘
```

#### 关键代码

```dart
@override
Widget build(BuildContext context) {
  final screenWidth = MediaQuery.of(context).size.width;

  return Scaffold(
    appBar: AppBar(
      title: const Text('梅花易数'),
      actions: [
        IconButton(
          icon: const Icon(Icons.history),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const MeiHuaHistoryPage(),
            ),
          ),
        ),
      ],
    ),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // 卜问输入区域
          Card(...),
          
          // 起卦方案选择区域
          Card(
            child: Column(
              children: [
                TabBar(...),
                SizedBox(
                  height: 400,
                  child: TabBarView(...),
                ),
              ],
            ),
          ),
          
          // 查看结果按钮
          ElevatedButton.icon(...),
        ],
      ),
    ),
  );
}
```

### 5.2 结果展示页面

#### 布局结构

```
┌─────────────────────────────────────┐
│  AppBar: 起卦结果                    │
│  Actions: [保存按钮]                 │
├─────────────────────────────────────┤
│  SingleChildScrollView               │
│  ┌─────────────────────────────┐    │
│  │ Card: 卜问内容（如有）      │    │
│  │ - 图标 + 标题               │    │
│  │ - 问题内容                  │    │
│  └─────────────────────────────┘    │
│  ┌─────────────────────────────┐    │
│  │ Card: 四柱信息（预留）      │    │
│  │ - 图标 + 标题               │    │
│  │ - 占位容器                  │    │
│  └─────────────────────────────┘    │
│  ┌─────────────────────────────┐    │
│  │ Card: 物候信息（预留）      │    │
│  │ - 图标 + 标题               │    │
│  │ - 占位容器                  │    │
│  └─────────────────────────────┘    │
│  ┌─────────────────────────────┐    │
│  │ GuaDisplayWidget: 卦象     │    │
│  │ - 本卦                      │    │
│  │ - 变卦                      │    │
│  │ - 互卦                      │    │
│  └─────────────────────────────┘    │
│  ┌─────────────────────────────┐    │
│  │ ExpansionTile: 起卦算法    │    │
│  │ - 起卦方法                  │    │
│  │ - 起卦时间                  │    │
│  │ - 起卦参数                  │    │
│  └─────────────────────────────┘    │
├─────────────────────────────────────┤
│  BottomBar: [返回] [保存]           │
└─────────────────────────────────────┘
```

#### 关键代码

```dart
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('起卦结果'),
      actions: [
        IconButton(
          icon: const Icon(Icons.save),
          onPressed: _saveResult,
        ),
      ],
    ),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // 卜问内容卡片
          if (widget.question != null) _buildQuestionCard(),
          
          // 四柱卡片区域
          _buildFourZhuSection(),
          
          // 物候信息区域
          _buildJieQiSection(),
          
          // 卦象展示区域
          GuaDisplayWidget(result: widget.result),
          
          // 起卦算法区域
          _buildAlgorithmSection(),
        ],
      ),
    ),
    bottomNavigationBar: _buildBottomBar(),
  );
}
```

### 5.3 历史记录页面

#### 布局结构

```
┌─────────────────────────────────────┐
│  AppBar: 起卦历史记录                │
├─────────────────────────────────────┤
│  StreamBuilder<List<MeiHuaGuaInfo>> │
│  ┌─────────────────────────────┐    │
│  │ 记录卡片 1                  │    │
│  │ - 问题（或"未注明问题"）    │    │
│  │ - 相对时间                  │    │
│  │ - 卦象摘要                  │    │
│  │ - 起卦方法标签              │    │
│  └─────────────────────────────┘    │
│  ┌─────────────────────────────┐    │
│  │ 记录卡片 2                  │    │
│  │ ...                         │    │
│  └─────────────────────────────┘    │
│  ...                                │
└─────────────────────────────────────┘
```

#### 关键代码

```dart
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('起卦历史记录'),
    ),
    body: StreamBuilder<List<MeiHuaGuaInfo>>(
      stream: _recordsStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final records = snapshot.data!;
        
        if (records.isEmpty) {
          return _buildEmptyState();
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: records.length,
          itemBuilder: (context, index) {
            return _buildRecordCard(records[index]);
          },
        );
      },
    ),
  );
}
```

---

## 6. 交互流程

### 6.1 起卦流程

```
用户打开应用
    ↓
显示起卦页面
    ↓
┌─────────────────────────────────┐
│ 输入卜问内容（可选）            │
│ - 占测人昵称                    │
│ - 性别选择                      │
│ - 生年干支                      │
│ - 占测问题（必填）              │
│ - 详细描述（可展开）            │
└─────────────────────────────────┘
    ↓
┌─────────────────────────────────┐
│ 选择起卦方式                    │
│ - 时空起卦                      │
│ - 报数起卦                      │
│ - 文字起卦                      │
│ - 手动起卦                      │
└─────────────────────────────────┘
    ↓
执行起卦
    ↓
点击"查看结果"
    ↓
跳转到结果页面
    ↓
┌─────────────────────────────────┐
│ 查看起卦结果                    │
│ - 卜问内容                      │
│ - 四柱信息（预留）              │
│ - 物候信息（预留）              │
│ - 卦象展示                      │
│ - 起卦算法（可折叠）            │
└─────────────────────────────────┘
    ↓
点击"保存"
    ↓
保存到本地数据库
    ↓
显示保存成功提示
```

### 6.2 历史记录查看流程

```
点击历史记录按钮
    ↓
跳转到历史记录页面
    ↓
┌─────────────────────────────────┐
│ 显示记录列表                    │
│ - Stream 实时更新               │
│ - 卡片式展示                    │
│ - 相对时间显示                  │
└─────────────────────────────────┘
    ↓
点击记录卡片
    ↓
跳转到记录详情（待实现）
```

---

## 7. 响应式设计

### 7.1 断点设置

| 断点 | 宽度 | 设备 |
|------|------|------|
| 小屏 | < 600px | 手机 |
| 中屏 | 600-900px | 平板竖屏 |
| 大屏 | > 900px | 平板横屏、桌面 |

### 7.2 布局适配

```dart
// 获取屏幕宽度
final screenWidth = MediaQuery.of(context).size.width;

// 根据屏幕宽度调整布局
final isSmallScreen = screenWidth < 600;

return Container(
  width: isSmallScreen ? screenWidth - 32 : 600,
  child: ...
);
```

### 7.3 组件适配

```dart
// 卜问输入组件宽度
DivinationQuestionWidget(
  width: screenWidth - 64, // 考虑 padding
  ...
)

// 卡片内边距
padding: EdgeInsets.all(isSmallScreen ? 12 : 16)

// 字体大小
fontSize: isSmallScreen ? 14 : 16
```

---

## 8. 动画规范

### 8.1 页面转场

```dart
// 使用默认的 MaterialPageRoute 转场动画
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => DivinationResultPage(...),
  ),
);
```

### 8.2 组件动画

```dart
// 展开/折叠动画
ExpansionTile(
  title: Text('起卦算法'),
  children: [...],
)

// 交叉淡入动画
AnimatedCrossFade(
  firstChild: SizedBox(),
  secondChild: Column(...),
  crossFadeState: isExpanded 
    ? CrossFadeState.showSecond 
    : CrossFadeState.showFirst,
  duration: Duration(milliseconds: 300),
)
```

### 8.3 加载动画

```dart
// 加载指示器
CircularProgressIndicator()

// 按钮加载状态
ElevatedButton.icon(
  icon: _isSaving
    ? SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(strokeWidth: 2),
      )
    : Icon(Icons.save),
  label: Text(_isSaving ? '保存中...' : '保存'),
)
```

---

## 9. 图标使用

### 9.1 Material Icons

| 图标 | 用途 |
|------|------|
| `Icons.history` | 历史记录 |
| `Icons.save` | 保存 |
| `Icons.help_outline` | 卜问内容 |
| `Icons.calendar_today` | 四柱信息 |
| `Icons.wb_sunny` | 物候信息 |
| `Icons.code` | 起卦算法 |
| `Icons.access_time` | 时空起卦 |
| `Icons.auto_awesome` | 查看结果 |
| `Icons.arrow_back` | 返回 |

### 9.2 图标颜色

```dart
Icon(
  Icons.icon_name,
  color: Colors.color.shade700,  // 使用 shade700
)
```

---

## 10. 组件集成清单

### 10.1 来自 xuan-common 的组件

| 组件 | 用途 | 文件路径 |
|------|------|----------|
| `DivinationQuestionWidget` | 卜问输入 | `lib/widgets/divination_question_widget.dart` |
| `FourZhuEightCharsCard` | 四柱卡片（预留） | `lib/widgets/four_zhu_eight_chars_card.dart` |
| `JieQiRiseSetCard` | 物候卡片（预留） | `lib/widgets/jie_qi_rise_set_card.dart` |
| `DevEnterPageViewModel` | 卜问数据管理 | `lib/viewmodels/dev_enter_page_view_model.dart` |
| `GanZhiGuaColors` | 中国风颜色 | `lib/themes/gan_zhi_gua_colors.dart` |

### 10.2 自定义组件

| 组件 | 用途 | 文件路径 |
|------|------|----------|
| `GuaDisplayWidget` | 卦象展示 | `lib/widgets/gua_display_widget.dart` |
| `FourZhuCardWrapper` | 四柱卡片包装器 | `lib/widgets/four_zhu_card_wrapper.dart` |

### 10.3 页面

| 页面 | 用途 | 文件路径 |
|------|------|----------|
| `MeiHuaDivinationPage` | 起卦页面 | `lib/pages/meihua_divination_page.dart` |
| `DivinationResultPage` | 结果展示页面 | `lib/pages/divination_result_page.dart` |
| `MeiHuaHistoryPage` | 历史记录页面 | `lib/pages/meihua_history_page.dart` |

---

## 11. 待完善项

### 11.1 四柱卡片集成

- [ ] 集成四柱计算服务
- [ ] 获取起卦时间的四柱数据
- [ ] 使用 `FourZhuEightCharsCard` 展示

### 11.2 物候卡片集成

- [ ] 集成物候计算服务
- [ ] 获取节气和物候信息
- [ ] 使用 `JieQiRiseSetCard` 展示

### 11.3 历史记录详情

- [ ] 创建记录详情页面
- [ ] 展示完整起卦信息
- [ ] 支持编辑和删除

### 11.4 主题定制

- [ ] 支持主题切换
- [ ] 支持自定义颜色
- [ ] 支持字体大小调整
