# xuan_meihuayishu

梅花易数 (Plum Blossom Numerology) 占卜模块，用于 xuan 项目。

## 概述

本模块实现了传统的中国占卜方法"梅花易数"，该方法基于数字学和易经系统。

## 功能特性

- **数字起卦**: 基于数字生成卦象
- **时间起卦**: 基于当前时间生成卦象
- **随机起卦**: 生成随机卦象
- **变卦计算**: 计算变卦
- **卦象显示**: 卦象的可视化显示

## 快速开始

### 依赖项

本模块依赖于以下 xuan 包：
- `common` - 核心工具和共享组件
- `persistence_core` - 数据持久化层

### 使用方法

```dart
import 'package:xuan_meihuayishu/xuan_meihuayishu.dart';

// 初始化模块
await MeiHuaYiShuModule.init();

// 获取主页组件
Widget homePage = MeiHuaYiShuModule.getHomePage();
```

### 服务使用

```dart
import 'package:xuan_meihuayishu/services/meihua_service.dart';

final service = MeiHuaService();

// 通过数字生成卦象
Map<String, dynamic> gua = service.generateGuaByNumber(123);

// 通过时间生成卦象
Map<String, dynamic> timeGua = service.generateGuaByTime(DateTime.now());

// 生成随机卦象
Map<String, dynamic> randomGua = service.generateRandomGua();
```

## 项目结构

```
lib/
├── xuan_meihuayishu.dart      # 模块入口文件
├── pages/
│   └── meihua_divination_page.dart  # 主占卜页面
├── services/
│   └── meihua_service.dart    # 核心占卜逻辑
├── models/                    # 数据模型
├── utils/                     # 工具函数
└── widgets/                   # 可重用组件
```

## 测试

运行测试：
```bash
flutter test
```

## 构建

这是一个 Flutter 包模块。要将其集成到主 xuan 项目中，请在主项目的 `pubspec.yaml` 中将其添加为依赖项。

## 许可证

属于 xuan 项目。详情请参阅主项目许可证。