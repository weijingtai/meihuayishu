# 梅花易数 - 实现计划 (Plans)

## 1. 开发阶段

### Phase 1: 核心基础 (Week 1)

#### 1.1 数据模型
- [ ] `Gua` 模型完善（已完成基础）
- [ ] `DivinationResult` 起卦结果模型
- [ ] `DivinationMethod` 起卦方法枚举

#### 1.2 核心服务
- [ ] `MeiHuaService` 完善
  - 先天起卦算法
  - 后天起卦算法
  - 互卦计算
  - 变卦计算

#### 1.3 基础组件
- [ ] 集成 xuan-common 的 `EightGuaWidget`
- [ ] 创建 `SixYaoWidget` 六爻完整卦象组件

---

### Phase 2: 时空起卦 (Week 2)

#### 2.1 时间处理
- [ ] 集成 `tyme` 包进行农历转换
- [ ] 获取年月日时干支
- [ ] 地支数映射

#### 2.2 UI实现
- [ ] `TimeDivinationTab` 页面
- [ ] 时间显示卡片
- [ ] 一键起卦交互

---

### Phase 3: 手动起卦 (Week 2-3)

#### 3.1 八卦选择器
- [ ] `GuaSelectorWidget` 组件
- [ ] 八卦图标按钮（2x4网格）
- [ ] 先天数映射

#### 3.2 六爻选择器
- [ ] `YaoSelectorWidget` 组件
- [ ] 动爻点选交互

#### 3.3 UI实现
- [ ] `ManualDivinationTab` 页面

---

### Phase 4: 报数起卦 (Week 3)

#### 4.1 数字处理
- [ ] 分段算法实现
- [ ] 多种分段规则支持

#### 4.2 UI实现
- [ ] `NumberDivinationTab` 页面
- [ ] 数字键盘组件
- [ ] 分段预览

---

### Phase 5: 文字起卦 (Week 4)

#### 5.1 笔画处理
- [ ] 繁体字笔画库（或API）
- [ ] 笔画计算服务
- [ ] 繁简转换

#### 5.2 UI实现
- [ ] `TextDivinationTab` 页面
- [ ] 文本输入框
- [ ] 笔画数实时显示

---

## 2. 文件结构

```
lib/
├── meihuayishu.dart              # 模块入口
├── models/
│   ├── gua.dart                  # 卦象模型 ✓
│   ├── divination_result.dart    # 起卦结果
│   └── divination_method.dart    # 起卦方法枚举
├── services/
│   ├── meihua_service.dart       # 核心服务 ✓
│   ├── lunar_service.dart        # 农历服务
│   └── stroke_service.dart       # 笔画服务
├── pages/
│   ├── meihua_divination_page.dart   # 主页面 ✓
│   ├── tabs/
│   │   ├── time_divination_tab.dart  # 时空Tab
│   │   ├── number_divination_tab.dart # 报数Tab
│   │   ├── text_divination_tab.dart   # 文字Tab
│   │   └── manual_divination_tab.dart # 手动Tab
│   └── gua_result_page.dart          # 卦象结果页
├── widgets/
│   ├── gua_display_widget.dart       # 卦象展示
│   ├── gua_selector_widget.dart      # 八卦选择器
│   ├── yao_selector_widget.dart      # 六爻选择器
│   └── number_keyboard_widget.dart   # 数字键盘
└── utils/
    ├── gua_calculator.dart           # 卦象计算工具
    └── stroke_counter.dart           # 笔画计算工具
```

---

## 3. 核心算法实现

### 3.1 先天起卦算法

```dart
class XianTianDivination {
  /// 根据数字数组起卦
  static DivinationResult calculate(List<int> numbers) {
    // 1. 将数字分成两组
    int mid = (numbers.length / 2).ceil();
    List<int> upperNumbers = numbers.sublist(0, mid);
    List<int> lowerNumbers = numbers.sublist(mid);
    
    // 2. 计算上下卦
    int upperSum = upperNumbers.fold(0, (a, b) => a + b);
    int lowerSum = lowerNumbers.fold(0, (a, b) => a + b);
    
    int upperGuaNum = upperSum % 8;
    int lowerGuaNum = lowerSum % 8;
    
    // 3. 计算动爻
    int totalSum = upperSum + lowerSum;
    int changingYao = totalSum % 6;
    
    // 4. 转换为卦象
    return DivinationResult(
      originalGua: Gua.fromNumbers(upperGuaNum, lowerGuaNum, changingYao),
      // ... 其他字段
    );
  }
}
```

### 3.2 后天起卦算法

```dart
class HouTianDivination {
  /// 根据物象和时辰起卦
  static DivinationResult calculate({
    required int upperGuaNum,  // 上卦先天数
    required int lowerGuaNum,  // 下卦先天数
    required int timeZhiNum,   // 时辰地支数
  }) {
    // 1. 计算动爻（必须包含时辰）
    int changingYao = (upperGuaNum + lowerGuaNum + timeZhiNum) % 6;
    
    // 2. 转换为卦象
    return DivinationResult(
      originalGua: Gua.fromNumbers(upperGuaNum, lowerGuaNum, changingYao),
      // ... 其他字段
    );
  }
}
```

### 3.3 互卦计算

```dart
/// 互卦：本卦2-4爻为下卦，3-5爻为上卦
Gua calculate互卦(Gua originalGua) {
  String binary = originalGua.toBinaryString();
  
  // 从下往上：第2,3,4爻组成下卦，第3,4,5爻组成上卦
  String lowerBinary = binary[1] + binary[2] + binary[3];  // 2,3,4爻
  String upperBinary = binary[2] + binary[3] + binary[4];  // 3,4,5爻
  
  return Gua.fromBinary(upperBinary, lowerBinary);
}
```

---

## 4. 技术要点

### 4.1 农历转换
使用 `tyme` 包：
```dart
import 'package:tyme/tyme.dart';

// 获取农历
Lunar lunar = Lunar.fromDate(DateTime.now());
// 获取干支
GanZhi ganZhi = lunar.getGanZhi();
```

### 4.2 笔画计算
两种方案：
1. **本地库**: 使用笔画数据文件
2. **在线API**: 调用汉字笔画服务

建议先使用本地库，确保离线可用。

### 4.3 复用 xuan-common 组件
- `EightGuaWidget`: 八卦显示
- `YaoWidget`: 单爻显示
- `HouTianGua`: 卦象枚举
- `YinYang`: 阴阳枚举

---

## 5. 测试计划

### 5.1 单元测试
- [ ] 先天起卦算法测试
- [ ] 后天起卦算法测试
- [ ] 互卦计算测试
- [ ] 变卦计算测试
- [ ] 分段逻辑测试

### 5.2 集成测试
- [ ] 时间起卦流程
- [ ] 报数起卦流程
- [ ] 文字起卦流程
- [ ] 手动起卦流程

### 5.3 测试用例

```dart
// 时间起卦测试
test('时间起卦 2024年1月1日子时', () {
  // 年支=辰(5), 月=1, 日=1, 时支=子(1)
  // 上卦 = (5+1+1) % 8 = 7 = 艮
  // 下卦 = (5+1+1+1) % 8 = 0 = 坤
  // 动爻 = (5+1+1+1) % 6 = 2 = 第二爻
});
```

---

## 6. 里程碑

| 里程碑 | 时间 | 交付物 |
|-------|------|-------|
| M1 | Week 1 | 核心模型和服务 |
| M2 | Week 2 | 时空起卦 + 手动起卦 |
| M3 | Week 3 | 报数起卦 |
| M4 | Week 4 | 文字起卦 |
| M5 | Week 5 | 测试和优化 |

---

## 7. 风险与依赖

### 7.1 风险
- 笔画数据的准确性
- 农历转换的精度

### 7.2 依赖
- `tyme` 包：农历干支
- `common` 包：八卦组件
- `xuan-storage`：数据持久化

---

## 8. 参考资料

- 《梅花易数》邵康节
- 先天八卦数：乾1兑2离3震4巽5坎6艮7坤8
- 后天八卦方位：离南坎北震东兑西
- 地支数：子1丑2寅3卯4辰5巳6午7未8申9酉10戌11亥12
