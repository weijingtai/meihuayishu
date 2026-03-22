# 卦爻主题样式编辑器 - 实现计划

## 当前阶段：基础功能

### 目标
实现 SettingsButton + ThemeEditPage，提供四种卦爻颜色模式的管理功能。

---

## 一、数据模型

### 1.1 YaoColorMode 枚举

| 模式 | 名称 | 说明 |
|------|------|------|
| solid | 纯色模式 | 统一颜色显示阴阳爻 |
| bw | 黑白模式 | 阳爻白色，阴爻黑色 |
| yinyang | 阴阳色 | 阳爻暖色，阴爻冷色 |
| colorful | 彩色模式 | 根据五行属性染色 |

### 1.2 YaoThemeConfig 配置

```dart
class YaoThemeConfig {
  final YaoColorMode mode;
  final Color solidColor;       // 纯色模式颜色
  final Color yangColor;        // 阳爻颜色
  final Color yinColor;         // 阴爻颜色
  final Map<String, Color> wuXingColors; // 五行颜色
}
```

---

## 二、UI 组件

### 2.1 SettingsButton
- 位置：AppBar 右上角
- 图标：Icons.settings
- 功能：点击跳转到 ThemeEditPage

### 2.2 ThemeEditPage
- 四种颜色模式切换（Radio 或 SegmentedButton）
- 每种模式的颜色配置
- 使用 showAppPalettePickerDialog 选择颜色
- 预览区域显示效果

---

## 三、颜色预设

### 3.1 默认值

| 模式 | 阳爻 | 阴爻 |
|------|------|------|
| solid | #000000 | #000000 |
| bw | #FFFFFF | #000000 |
| yinyang | #FFF8DC | #1C1C1C |
| colorful | 按五行 | 按五行 |

### 3.2 五行颜色

| 五行 | 默认色 |
|------|--------|
| 金 | #FFD700 |
| 木 | #228B22 |
| 水 | #1E90FF |
| 火 | #DC143C |
| 土 | #DAA520 |

---

## 四、文件结构

```
lib/
├── models/
│   ├── yao_color_mode.dart      # 颜色模式枚举
│   └── yao_theme_config.dart    # 主题配置模型
├── pages/
│   └── theme_edit_page.dart     # 主题编辑页面
├── widgets/
│   └── settings_button.dart     # 设置按钮
└── services/
    └── theme_service.dart       # 主题服务（暂用内存存储）
```

---

## 五、后续扩展计划

- [ ] 集成 xuan-storage 持久化
- [ ] 爻样式编辑（宽高、圆角、阴影）
- [ ] 变爻指示器配置
- [ ] 主题导入/导出
- [ ] 中国风预设主题
