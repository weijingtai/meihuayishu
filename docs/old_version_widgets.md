# 梅花易数 - 旧版 Widget 详细清单

> 基于 `example/lib/main.dart` 分析

---

## Widget 树总览

```
MyApp (StatelessWidget)
└── MaterialApp
    └── Provider<MeiHuaService>
        └── HomePage (StatefulWidget) [来自模块]
            ├── AppBar
            │   ├── Title: '梅花易数'
            │   └── SystemSwitch: [旧版] [新版]
            └── OldSystemPage (StatefulWidget)
                ├── TabBar
                │   ├── Tab 1: 时空 (access_time)
                │   ├── Tab 2: 报数 (numbers)
                │   ├── Tab 3: 文字 (text_fields)
                │   └── Tab 4: 手动 (touch_app)
                └── TabBarView
                    ├── _buildTimeTab()
                    ├── _buildNumberTab()
                    ├── _buildTextTab()
                    └── _buildManualTab()
```

---

## 一、时空起卦 Tab (_buildTimeTab)

### Widget 树结构

```
StatefulBuilder
└── SingleChildScrollView
    ├── Card: 当前时间起卦
    │   ├── Icon (access_time, 48px)
    │   ├── Text '当前时间起卦' (24px, bold)
    │   ├── Text '根据当前时间自动起卦...' (grey)
    │   ├── Container (时间显示)
    │   │   ├── Text '2024年3月23日'
    │   │   └── Text '14:30:25' (20px, bold)
    │   └── Row
    │       ├── ElevatedButton.icon '一键起卦'
    │       │   ├── Icon (auto_awesome)
    │       │   └── Text '一键起卦'
    │       └── ElevatedButton.icon '一键农历'
    │           ├── Icon (brightness_3)
    │           └── Text '一键农历'
    │
    ├── Card: 农历起卦
    │   ├── Icon (calendar_month, 48px, orange)
    │   ├── Text '农历起卦' (24px, bold)
    │   ├── Text '输入农历年月日时起卦...' (grey)
    │   ├── _buildLunarSelector: 年（地支）
    │   │   ├── Text '年（地支）' (label)
    │   │   └── Container
    │   │       └── DropdownButton<int>
    │   │           └── DropdownMenuItem [子1, 丑2, ..., 亥12]
    │   ├── _buildLunarSelector: 月（农历）
    │   │   ├── Text '月（农历）' (label)
    │   │   └── DropdownButton<int>
    │   │       └── DropdownMenuItem [1月, 2月, ..., 12月]
    │   ├── _buildLunarSelector: 日（农历）
    │   │   ├── Text '日（农历）' (label)
    │   │   └── DropdownButton<int>
    │   │       └── DropdownMenuItem [初1, 初2, ..., 30]
    │   ├── _buildLunarSelector: 时（地支）
    │   │   ├── Text '时（地支）' (label)
    │   │   └── DropdownButton<int>
    │   │       └── DropdownMenuItem [子1, 丑2, ..., 亥12]
    │   ├── Container (公式说明, orange背景)
    │   │   ├── Text '起卦公式：' (bold)
    │   │   ├── Text '上卦 = (年 + 月 + 日) ÷ 8 取余'
    │   │   ├── Text '下卦 = (年 + 月 + 日 + 时) ÷ 8 取余'
    │   │   └── Text '动爻 = (年 + 月 + 日 + 时) ÷ 6 取余'
    │   └── ElevatedButton.icon '农历起卦' (orange)
    │       ├── Icon (auto_awesome)
    │       └── Text '农历起卦'
    │
    └── _buildResultSection() (if _result != null)
```

### Widget 详细说明

| Widget | 类型 | 用途 | 位置 |
|--------|------|------|------|
| `StatefulBuilder` | StatefulBuilder | 局部状态管理，支持农历选择器刷新 | 外层容器 |
| `SingleChildScrollView` | SingleChildScrollView | 使内容可滚动 | 主容器 |
| `Card` (x2) | Card | 分组显示当前时间起卦和农历起卦 | 两个主要区域 |
| `Icon` (x3) | Icon | 时间、农历图标，提供视觉提示 | 卡片头部 |
| `Text` (x8) | Text | 标题、说明文字、公式、时间显示 | 各处 |
| `Container` (x5) | Container | 时间显示、公式说明的背景容器 | 时间和公式区域 |
| `Row` (x1) | Row | 水平排列一键起卦和一键农历按钮 | 当前时间卡片 |
| `ElevatedButton.icon` (x3) | ElevatedButton | 触发起卦操作 | 按钮区域 |
| `DropdownButton<int>` (x4) | DropdownButton | 选择年月日时 | 农历选择器 |
| `DropdownMenuItem` (x48) | DropdownMenuItem | 下拉选项（12+12+30+12） | 下拉列表 |

---

## 二、报数起卦 Tab (_buildNumberTab)

### Widget 树结构

```
SingleChildScrollView
└── Card
    ├── Icon (numbers, 48px)
    ├── Text '报数起卦' (24px, bold)
    ├── Text '输入数字起卦...' (grey)
    ├── Container (数字显示区)
    │   ├── Text '输入数字' (12px, grey)
    │   └── Text '请输入...' 或 '12345' (28px, bold)
    ├── GridView.count (3列数字键盘)
    │   ├── _buildNumberButton '1'
    │   ├── _buildNumberButton '2'
    │   ├── _buildNumberButton '3'
    │   ├── _buildNumberButton '4'
    │   ├── _buildNumberButton '5'
    │   ├── _buildNumberButton '6'
    │   ├── _buildNumberButton '7'
    │   ├── _buildNumberButton '8'
    │   ├── _buildNumberButton '9'
    │   ├── _buildActionButton '清除' (orange)
    │   ├── _buildNumberButton '0'
    │   └── _buildActionButton '删除' (red)
    └── ElevatedButton.icon '起卦'
        ├── Icon (casino)
        └── Text '起卦'
    └── _buildResultSection() (if _result != null)
```

### Widget 详细说明

| Widget | 类型 | 用途 | 位置 |
|--------|------|------|------|
| `SingleChildScrollView` | SingleChildScrollView | 支持滚动 | 主容器 |
| `Card` | Card | 分组显示报数起卦区域 | 外层 |
| `Icon` | Icon | 数字图标 | 卡片头部 |
| `Text` (x3) | Text | 标题、说明、数字显示 | 各处 |
| `Container` | Container | 数字输入显示区域，带边框 | 数字显示 |
| `GridView.count` | GridView | 3x4数字键盘布局 | 键盘区域 |
| `_buildNumberButton` | ElevatedButton | 单个数字按钮(0-9)，点击追加数字 | 键盘 |
| `_buildActionButton` | ElevatedButton | 清除/删除按钮，带颜色标识 | 键盘 |
| `ElevatedButton.icon` | ElevatedButton | 起卦按钮，禁用态判断 | 底部 |

### 数字按钮详情

```
_buildNumberButton(String number):
├── ElevatedButton
│   ├── onPressed: setState(() => _inputNumber += number)
│   ├── style: 白色背景，黑色文字，圆角8px
│   └── child: Text(number, 24px, bold)

_buildActionButton(String label, Color color, VoidCallback):
├── ElevatedButton
│   ├── onPressed: callback
│   ├── style: 颜色浅色背景，颜色文字，圆角8px
│   └── child: Text(label, 16px)
```

---

## 三、文字起卦 Tab (_buildTextTab)

### Widget 树结构

```
SingleChildScrollView
├── Card: 文字输入
│   ├── Icon (text_fields, 48px)
│   ├── Text '文字起卦' (24px, bold)
│   ├── Text (长文本模式提示 或 普通提示)
│   ├── Row (长文本阈值设置)
│   │   ├── Text '长文本阈值: '
│   │   ├── TextField (数字输入, 60px)
│   │   └── Text ' 字'
│   └── TextField (文字输入)
│       ├── labelText: '输入文字'
│       ├── hintText: '请输入汉字' 或 '请输入长文本...'
│       ├── prefixIcon: Icon(edit)
│       └── maxLines: 1 (短) 或 4 (长)
│
├── Card: 起卦方式选择 (if _inputText.isNotEmpty)
│   ├── Text '起卦方式' (16px, bold)
│   └── RadioListTile<TextDivinationMethod> (x4)
│       ├── byStroke: 按笔画起卦
│       ├── byModernTone: 按现代四声起卦
│       ├── byAncientTone: 按古代平仄起卦
│       └── bySentenceLength: 按句子字数起卦 [推荐]
│
├── CircularProgressIndicator (if _isTextLoading)
│
├── _buildSentenceAnalysisCard (长文本模式)
│   ├── Card
│   │   ├── Row
│   │   │   ├── Text '句子分析' (bold)
│   │   │   └── Text '共 X 字'
│   │   ├── Text '共 Y 句'
│   │   └── List.generate (每句)
│   │       ├── Text '· '
│   │       ├── Expanded: Text(句子内容)
│   │       └── TextField (可编辑字数, 50px)
│
├── _buildCharacterAnalysisCard (短文本模式)
│   ├── Card
│   │   ├── Text '字符分析' (bold)
│   │   ├── Wrap (字符卡片列表)
│   │   │   └── Container (每字)
│   │   │       ├── Text (汉字, 20px, bold)
│   │   │       ├── Text '7画' (12px, grey)
│   │   │       ├── Row
│   │   │       │   ├── Text (拼音, blue)
│   │   │       │   └── GestureDetector (音调按钮)
│   │   │       │       └── Container
│   │   │       │           └── Text (音调数字)
│   │   │       └── Container (平仄标签)
│   │   │           └── Text '平' 或 '仄'
│   │   ├── Divider
│   │   └── Row (统计信息)
│   │       ├── _buildStatItem '总笔画'
│   │       ├── _buildStatItem '平声'
│   │       └── _buildStatItem '仄声'
│
└── ElevatedButton.icon '起卦' 或 '长文本起卦'
    ├── Icon (auto_awesome)
    └── Text
└── _buildResultSection() (if _result != null)
```

### Widget 详细说明

| Widget | 类型 | 用途 | 位置 |
|--------|------|------|------|
| `SingleChildScrollView` | SingleChildScrollView | 支持长内容滚动 | 主容器 |
| `Card` (x3) | Card | 分组：输入、方式选择、分析结果 | 各区域 |
| `Icon` | Icon | 文字图标 | 卡片头部 |
| `Text` (x10+) | Text | 标题、说明、统计等 | 各处 |
| `Row` | Row | 阈值设置行 | 阈值区域 |
| `TextField` (x2) | TextField | 阈值输入、文字输入 | 输入区域 |
| `RadioListTile` (x4) | RadioListTile | 起卦方式选择 | 方式选择 |
| `CircularProgressIndicator` | CircularProgressIndicator | 加载指示器 | 加载时 |
| `Container` (xN) | Container | 字符卡片容器 | 分析卡片 |
| `Wrap` | Wrap | 自动换行显示字符 | 字符列表 |
| `GestureDetector` | GestureDetector | 音调点击事件 | 音调按钮 |
| `Divider` | Divider | 分割线 | 统计区域 |
| `ElevatedButton.icon` | ElevatedButton | 起卦按钮 | 底部 |

### 字符分析卡片详情

```
_buildCharacterAnalysisCard(TextAnalysisSummary):
├── Card
│   ├── Row
│   │   └── Text '字符分析' (16px, bold)
│   ├── Wrap
│   │   └── Container (每字卡片, 80px宽)
│   │       ├── Text (汉字)
│   │       ├── Text '7画'
│   │       ├── Row
│   │       │   ├── Text (拼音)
│   │       │   └── GestureDetector
│   │       │       └── Container (音调按钮, 可点击切换1-4)
│   │       │           └── Text (当前音调)
│   │       └── Container (平/仄标签)
│   ├── Divider
│   └── Row
│       ├── Column: Text(总笔画值) + Text('总笔画')
│       ├── Column: Text(平声数) + Text('平声')
│       └── Column: Text(仄声数) + Text('仄声')
```

### 句子分析卡片详情

```
_buildSentenceAnalysisCard(Map<String, dynamic>):
├── Card
│   ├── Row
│   │   ├── Text '句子分析' (16px, bold)
│   │   └── Text '共 X 字'
│   ├── Text '共 Y 句'
│   └── List.generate(句子数)
│       └── Row
│           ├── Text '· '
│           ├── Expanded: Text(句子内容, maxLines: 2)
│           └── TextField (可编辑字数, 50x32px)
│               ├── 修改后: 橙色背景/边框
│               └── 未修改: 白色背景/蓝色边框
```

---

## 四、手动起卦 Tab (_buildManualTab)

### Widget 树结构

```
SingleChildScrollView
├── Card: 标题
│   ├── Icon (touch_app, 48px)
│   ├── Text '手动起卦' (24px, bold)
│   └── Text '手动选择上下卦和动爻...' (grey)
│
├── Card: 先天/后天切换
│   └── Row
│       ├── Column
│       │   ├── Text '先天卦' 或 '后天卦' (16px, bold)
│       │   └── Text '乾1兑2...' 或 '离南坎北...' (12px, grey)
│       └── Switch
│
├── GuaSelectorWidget: 上卦选择
│   ├── title: '选择上卦'
│   ├── selectedGua: _selectedUpperGua
│   ├── isXianTian: _isXianTianGua
│   └── onGuaSelected: callback
│
├── GuaSelectorWidget: 下卦选择
│   ├── title: '选择下卦'
│   ├── selectedGua: _selectedLowerGua
│   ├── isXianTian: _isXianTianGua
│   └── onGuaSelected: callback
│
├── _buildYaoSelector: 动爻选择
│   ├── Card
│   │   ├── Row
│   │   │   ├── Text '选择动爻' (16px, bold)
│   │   │   └── Container '请先选择上下卦' (if !isGuaComplete)
│   │   ├── Container (占位, if !isGuaComplete)
│   │   │   └── Text '请先选择上卦和下卦'
│   │   └── _buildRealYaoDisplay (if isGuaComplete)
│   │       ├── Text '上卦: XXX'
│   │       ├── _buildYaoButton x3 (6,5,4爻)
│   │       ├── Divider
│   │       ├── _buildYaoButton x3 (3,2,1爻)
│   │       └── Text '下卦: XXX'
│
└── ElevatedButton.icon '起卦'
    ├── Icon (casino)
    └── Text '起卦'
└── _buildResultSection() (if _result != null)
```

### Widget 详细说明

| Widget | 类型 | 用途 | 位置 |
|--------|------|------|------|
| `SingleChildScrollView` | SingleChildScrollView | 支持滚动 | 主容器 |
| `Card` (x3) | Card | 标题、切换、动爻选择 | 各区域 |
| `Icon` | Icon | 手动图标 | 标题卡片 |
| `Text` (x6) | Text | 标题、说明、卦名等 | 各处 |
| `Row` | Row | 切换开关行 | 切换卡片 |
| `Column` | Column | 模式名称和说明 | 切换卡片 |
| `Switch` | Switch | 先天/后天卦切换 | 切换卡片 |
| `GuaSelectorWidget` (x2) | 自定义Widget | 上下卦选择 | 卦选择区域 |
| `Container` | Container | 占位提示 | 动爻区域 |
| `Divider` | Divider | 分隔上下卦爻 | 动爻显示 |
| `_buildYaoButton` (x6) | GestureDetector | 爻按钮，可点击选择 | 动爻显示 |
| `ElevatedButton.icon` | ElevatedButton | 起卦按钮 | 底部 |

### 动爻按钮详情

```
_buildYaoButton(int yaoPosition, bool isYang, bool isSelected):
├── GestureDetector
│   ├── onTap: setState(() => _selectedYao = yaoPosition)
│   └── Container (选中样式)
│       ├── 选中: deepPurple背景, 2px边框
│       └── 未选中: 透明背景, 1px灰色边框
│       └── Row
│           ├── Text '第N爻'
│           └── _buildYaoShape(isYang)
│
_buildYaoShape(bool isYang):
├── 阳爻 (isYang=true):
│   └── Container (40x6, 黑色, 圆角3)
└── 阴爻 (isYang=false):
    └── Row
        ├── Container (16x6, 黑色, 圆角3)
        ├── SizedBox (8px间距)
        └── Container (16x6, 黑色, 圆角3)
```

---

## 五、结果展示 (_buildResultSection)

### Widget 树结构

```
Card (deepPurple浅色背景)
├── Row (标题行)
│   ├── Text '卦象结果' (20px, bold, deepPurple)
│   └── _buildColorModeSwitcher
│       └── PopupMenuButton<YaoColorMode>
│           ├── Container (触发器)
│           │   ├── Icon (palette)
│           │   ├── Text (当前模式名)
│           │   └── Icon (arrow_drop_down)
│           └── PopupMenuItem (x4)
│               ├── 纯色模式
│               ├── 黑白模式
│               ├── 阴阳模式
│               └── 彩色模式
│
├── Row (卦象列)
│   ├── _buildGuaColumn '本卦'
│   │   ├── Text (标题)
│   │   ├── Text (卦名, 28px, bold)
│   │   ├── Text (五行, 彩色模式)
│   │   ├── _buildThreeYao (上卦三爻)
│   │   │   └── _buildSingleYao x3
│   │   └── _buildThreeYao (下卦三爻)
│   │       └── _buildSingleYao x3
│   ├── _buildGuaColumn '互卦' (if exists)
│   └── _buildGuaColumn '变卦'
│
├── Container (信息区, 白色背景)
│   ├── _buildInfoRow '起卦方式'
│   ├── _buildInfoRow '动爻位置'
│   ├── _buildInfoRow '本卦'
│   └── _buildInfoRow '变卦'
│
└── GestureDetector (流程切换)
    └── Container
        ├── Icon (expand_less/more)
        └── Text '显示起卦流程'
```

### Widget 详细说明

| Widget | 类型 | 用途 | 位置 |
|--------|------|------|------|
| `Card` | Card | 结果展示主容器 | 外层 |
| `Row` (x3) | Row | 标题行、卦象列、信息行 | 各处 |
| `Text` (x10+) | Text | 标题、卦名、五行、信息等 | 各处 |
| `PopupMenuButton` | PopupMenuButton | 颜色模式选择菜单 | 切换器 |
| `PopupMenuItem` (x4) | PopupMenuItem | 4种颜色模式选项 | 菜单 |
| `Container` (x2) | Container | 触发器、信息区 | 各处 |
| `Icon` (x3) | Icon | 调色板、箭头 | 切换器 |
| `_buildGuaColumn` (x3) | Column | 卦象列展示 | 卦象区 |
| `_buildThreeYao` (x6) | Column | 三爻展示 | 卦象列 |
| `_buildSingleYao` (x18) | Row | 单爻展示 | 三爻中 |
| `GestureDetector` | GestureDetecto | 流程切换点击 | 底部 |

### 单爻详情

```
_buildSingleYao(bool isYang, Color color, bool isChanging, ChangingYaoIndicator):
├── Row
│   ├── SizedBox (指示器区域, 12px宽)
│   │   └── Text/Icon (变爻标记, if isChanging)
│   ├── SizedBox (4px间距)
│   ├── yaoBody
│   │   ├── 阳爻: Container (50x6, color, 圆角3)
│   │   └── 阴爻: Row
│   │       ├── Container (21x6)
│   │       ├── SizedBox (8px)
│   │       └── Container (21x6)
│   ├── SizedBox (4px间距)
│   └── SizedBox (16px, 对称占位)
```

---

## 六、主题编辑页 (ThemeEditPage)

### Widget 树结构

```
Scaffold
├── AppBar
│   ├── Title: '卦爻主题设置'
│   └── TextButton '重置'
└── SingleChildScrollView
    ├── _buildModeSelector (颜色模式选择)
    │   ├── Card
    │   │   ├── Text '颜色模式' (18px, bold)
    │   │   ├── Wrap
    │   │   │   └── ChoiceChip (x4)
    │   │   │       ├── 纯色模式
    │   │   │       ├── 黑白模式
    │   │   │       ├── 阴阳模式
    │   │   │       └── 彩色模式
    │   │   └── Text (模式说明)
    │
    ├── _buildModeConfig (模式配置)
    │   ├── 纯色: _buildSolidModeConfig
    │   │   └── Card
    │   │       ├── Text '纯色设置'
    │   │       └── _buildColorPicker (爻颜色)
    │   ├── 阴阳: _buildYinYangModeConfig
    │   │   └── Card
    │   │       ├── Text '阴阳色设置'
    │   │       ├── _buildColorPicker (阳爻颜色)
    │   │       └── _buildColorPicker (阴爻颜色)
    │   └── 彩色: _buildColorfulModeConfig
    │       └── Card
    │           ├── Text '五行颜色设置'
    │           └── _buildColorPicker x5 (金木水火土)
    │
    ├── _buildChangingIndicatorConfig (变爻指示器)
    │   ├── Card
    │   │   ├── Text '变爻指示器'
    │   │   ├── Wrap
    │   │   │   └── ChoiceChip (x3: 无/文本/图片)
    │   │   ├── TextField (文本配置, if type=text)
    │   │   ├── _buildColorPicker (文本颜色)
    │   │   └── Slider (指示器大小, 8-32)
    │
    └── _buildPreview (预览)
        └── Card
            ├── Text '预览'
            └── Row
                ├── _buildPreviewGua '乾' (阳阳阳)
                ├── _buildPreviewGua '坤' (阴阴阴)
                └── _buildPreviewGua '离' (阴阳阳)
```

### Widget 详细说明

| Widget | 类型 | 用途 | 位置 |
|--------|------|------|------|
| `Scaffold` | Scaffold | 页面主框架 | 根节点 |
| `AppBar` | AppBar | 顶部导航栏 | 顶部 |
| `TextButton` | TextButton | 重置按钮 | AppBar |
| `SingleChildScrollView` | ScrollView | 支持滚动 | Body |
| `Card` (x4) | Card | 各配置区域 | 各处 |
| `Text` (x10+) | Text | 标题、说明 | 各处 |
| `Wrap` (x2) | Wrap | ChoiceChip布局 | 选择区域 |
| `ChoiceChip` (x7) | ChoiceChip | 模式/类型选择 | 选择区域 |
| `TextField` | TextField | 指示器文本输入 | 配置区域 |
| `Slider` | Slider | 大小调节 | 配置区域 |
| `Row` | Row | 预览行 | 预览区域 |
| `_buildColorPicker` (x8) | Row | 颜色选择器 | 配置区域 |
| `_buildPreviewGua` (x3) | Column | 预览卦象 | 预览区域 |

### 颜色选择器详情

```
_buildColorPicker(String label, Color color, ValueChanged<Color>):
├── Row
│   ├── Expanded: Text(label)
│   ├── InkWell
│   │   └── Container (40x40, 颜色预览, 圆角8)
│   └── IconButton
│       ├── icon: Icon(colorize)
│       └── onPressed: _showColorPicker()
```

---

## 七、起卦流程展示 (DivinationFlowDisplay)

### Widget 树结构

```
DivinationFlowDisplay
└── Card
    ├── Row (方法名称)
    │   ├── Icon (auto_awesome)
    │   └── Text (methodName)
    ├── Divider
    ├── List.generate (步骤)
    │   └── _buildStep
    │       ├── Container (步骤编号圆形)
    │       │   └── Text (序号)
    │       └── Expanded
    │           ├── Text (步骤标题, bold)
    │           ├── Text (步骤描述)
    │           ├── _buildVariables (if 有变量)
    │           │   └── Container (蓝色背景)
    │           │       └── Text (变量: 值) xN
    │           └── _buildFormula (if 有公式)
    │               └── Container (橙色背景)
    │                   ├── Icon (functions)
    │                   └── Text (公式)
    └── _buildFinalResult (if 有结果)
        ├── Text '最终结果' (bold)
        └── Container (绿色背景)
            └── Text (结果: 值) xN
```

### 流程类型

| 类型 | 方法 | 用途 |
|------|------|------|
| `lunarDivinationFlow` | 农历起卦 | 显示农历时间转换过程 |
| `timeDivinationFlow` | 时间起卦 | 显示时间起卦计算过程 |
| `numberDivinationFlow` | 报数起卦 | 显示数字分割和计算过程 |
| `charCountFlow` | 字数起卦 | 显示字数统计和计算过程 |
| `strokeFlow` | 笔画起卦 | 显示笔画查询和计算过程 |
| `toneFlow` | 音调起卦 | 显示音调获取和计算过程 |
| `sentenceCountFlow` | 句数起卦 | 显示句子分割和计算过程 |
| `sentenceLengthFlow` | 句子字数 | 显示字数统计和计算过程 |
| `manualFlow` | 手动起卦 | 显示手动选择的参数 |

---

## 八、外部依赖 Widget

| Widget | 来源 | 用途 |
|--------|------|------|
| `SettingsButton` | meihuayishu | 主题设置按钮 |
| `GuaSelectorWidget` | meihuayishu | 卦选择器 |
| `YaoSelectorWidget` | meihuayishu | 爻选择器 |
| `PinyinToneConverter` | meihuayishu | 拼音声调转换 |
| `TextDivinationCalculator` | meihuayishu | 文字起卦计算器 |
| `DivinationFlowFactory` | meihuayishu | 流程显示工厂 |

---

## 九、Widget 统计

| 类别 | 数量 |
|------|------|
| StatelessWidget | 2 (MyApp, Text) |
| StatefulWidget | 1 (OldSystemPage) |
| Card | 12 |
| ElevatedButton | 8 |
| TextField | 3 |
| DropdownButton | 4 |
| RadioListTile | 4 |
| Switch | 1 |
| Container | 20+ |
| Row | 15+ |
| Column | 10+ |
| Text | 50+ |
| Icon | 10+ |
| **总计** | **100+** |
