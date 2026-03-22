# xuan_meihuayishu

梅花易数 (Plum Blossom Numerology) divination module for the xuan project.

## Overview

This module implements the traditional Chinese divination method known as "Mei Hua Yi Shu" (梅花易数), which is based on numerology and the I Ching (易经) system.

## Features

- **数字起卦**: Generate hexagrams based on numbers
- **时间起卦**: Generate hexagrams based on the current time
- **随机起卦**: Generate random hexagrams
- **变卦计算**: Calculate changing hexagrams
- **卦象显示**: Visual display of hexagrams

## Getting Started

### Dependencies

This module depends on the following xuan packages:
- `common` - Core utilities and shared components
- `persistence_core` - Data persistence layer

### Usage

```dart
import 'package:xuan_meihuayishu/xuan_meihuayishu.dart';

// Initialize the module
await MeiHuaYiShuModule.init();

// Get the main page widget
Widget homePage = MeiHuaYiShuModule.getHomePage();
```

### Service Usage

```dart
import 'package:xuan_meihuayishu/services/meihua_service.dart';

final service = MeiHuaService();

// Generate hexagram by number
Map<String, dynamic> gua = service.generateGuaByNumber(123);

// Generate hexagram by time
Map<String, dynamic> timeGua = service.generateGuaByTime(DateTime.now());

// Generate random hexagram
Map<String, dynamic> randomGua = service.generateRandomGua();
```

## Project Structure

```
lib/
├── xuan_meihuayishu.dart      # Module entry point
├── pages/
│   └── meihua_divination_page.dart  # Main divination page
├── services/
│   └── meihua_service.dart    # Core divination logic
├── models/                    # Data models
├── utils/                     # Utility functions
└── widgets/                   # Reusable widgets
```

## Testing

Run tests with:
```bash
flutter test
```

## Building

This is a Flutter package module. To integrate it into the main xuan project, add it as a dependency in the main project's `pubspec.yaml`.

## License

Part of the xuan project. See main project license for details.
