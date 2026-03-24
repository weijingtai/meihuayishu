# 梅花易数 - 起卦记录保存功能实施计划

## 1. 项目概述

### 1.1 目标

整合 xuan-common 和 xuan-storage，实现起卦记录的持久化保存，提升用户体验。

### 1.2 范围

- **包含**：卜问输入、起卦记录保存、历史记录查看
- **不包含**：四柱计算、物候计算、云端同步

---

## 2. 技术方案

### 2.1 数据库设计

#### 表结构

```sql
CREATE TABLE t_meihua_gua_info (
  uuid TEXT PRIMARY KEY,
  divination_uuid TEXT NOT NULL,
  question TEXT,
  original_upper_gua INTEGER NOT NULL,
  original_lower_gua INTEGER NOT NULL,
  changing_yao INTEGER NOT NULL,
  changed_upper_gua INTEGER NOT NULL,
  changed_lower_gua INTEGER NOT NULL,
  hu_upper_gua INTEGER NOT NULL,
  hu_lower_gua INTEGER NOT NULL,
  method TEXT NOT NULL,
  params_json TEXT NOT NULL,
  created_at DATETIME NOT NULL,
  updated_at DATETIME NOT NULL,
  deleted_at DATETIME
);
```

#### 设计要点

1. **独立表设计**：不依赖 common 的数据库，使用独立的 SQLite 数据库
2. **软删除**：使用 `deleted_at` 字段实现软删除
3. **JSON存储**：使用 JSON 存储起卦参数，便于扩展
4. **UUID主键**：使用 UUID 作为业务主键

### 2.2 架构设计

#### 分层架构

```
UI Layer (Page/Widget)
    ↓
Service Layer (DivinationRecordService)
    ↓
Repository Layer (MeiHuaDivinationRepository)
    ↓
DAO Layer (MeiHuaDivinationsDao)
    ↓
Database Layer (MeiHuaDatabase)
```

#### 各层职责

| 层 | 职责 | 文件 |
|----|------|------|
| UI | 用户交互、数据展示 | `meihua_divination_page.dart`, `divination_result_page.dart`, `meihua_history_page.dart` |
| Service | 业务逻辑、异常处理 | `divination_record_service.dart` |
| Repository | 数据访问抽象 | `meihua_divination_repository.dart` |
| DAO | 数据库操作 | `meihua_divinations_dao.dart` |
| Database | 数据库定义 | `meihua_database.dart` |

### 2.3 组件集成

#### 引入的公共组件

| 组件 | 来源 | 用途 |
|------|------|------|
| `DivinationQuestionWidget` | xuan-common | 卜问输入 |
| `FourZhuEightCharsCard` | xuan-common | 四柱卡片（预留） |
| `JieQiRiseSetCard` | xuan-common | 物候卡片（预留） |
| `DevEnterPageViewModel` | xuan-common | 卜问数据管理 |

#### 预留接口

```dart
// 四柱主题配置接口
final ValueNotifier<EditableFourZhuCardTheme>? fourZhuThemeNotifier;

// 四柱卡片包装器
class FourZhuCardWrapper extends StatelessWidget {
  final ValueNotifier<EditableFourZhuCardTheme>? themeNotifier;
  // ...
}
```

---

## 3. 实施步骤

### 阶段 1：数据库层（已完成）

1. ✅ 创建数据库表定义 (`meihua_gua_infos.dart`)
2. ✅ 创建数据库定义 (`meihua_database.dart`)
3. ✅ 创建 DAO 层 (`meihua_divinations_dao.dart`)
4. ✅ 运行 build_runner 生成代码

### 阶段 2：数据访问层（已完成）

5. ✅ 创建 Repository 层 (`meihua_divination_repository.dart`)
6. ✅ 创建 Service 层 (`divination_record_service.dart`)

### 阶段 3：UI 层（已完成）

7. ✅ 重构起卦页面 (`meihua_divination_page.dart`)
8. ✅ 创建结果展示页面 (`divination_result_page.dart`)
9. ✅ 创建历史记录页面 (`meihua_history_page.dart`)
10. ✅ 创建四柱卡片包装器 (`four_zhu_card_wrapper.dart`)

### 阶段 4：主题和样式（已完成）

11. ✅ 创建中国风主题 (`meihua_theme.dart`)

### 阶段 5：集成和测试（已完成）

12. ✅ 更新模块入口 (`meihuayishu.dart`)
13. ✅ 更新依赖 (`pubspec.yaml`)
14. ✅ 代码生成和验证

---

## 4. 文件清单

### 4.1 新增文件

```
lib/
├── database/
│   ├── meihua_database.dart
│   ├── meihua_database.g.dart
│   └── tables/
│       └── meihua_gua_infos.dart
├── daos/
│   ├── meihua_divinations_dao.dart
│   └── meihua_divinations_dao.g.dart
├── repositories/
│   └── meihua_divination_repository.dart
├── services/
│   └── divination_record_service.dart
├── pages/
│   ├── divination_result_page.dart
│   └── meihua_history_page.dart
├── widgets/
│   └── four_zhu_card_wrapper.dart
└── themes/
    └── meihua_theme.dart
```

### 4.2 修改文件

```
lib/
├── meihuayishu.dart                    # 更新导出
└── pages/
    └── meihua_divination_page.dart     # 重构
pubspec.yaml                            # 添加 uuid 依赖
```

---

## 5. 依赖关系

### 5.1 外部依赖

```yaml
dependencies:
  common:
    path: ../xuan-common
  persistence_core:
    git:
      url: https://github.com/weijingtai/xuan-storage.git
      path: core
  uuid: ^4.2.1

dev_dependencies:
  drift_dev: ^2.30.1
  build_runner: ^2.10.5
  persistence_drift:
    git:
      url: https://github.com/weijingtai/xuan-storage.git
      path: drift
```

### 5.2 内部依赖

```
MeiHuaDivinationPage
  ├── DivinationQuestionWidget (common)
  ├── MeiHuaService
  └── DevEnterPageViewModel (common)

DivinationResultPage
  ├── GuaDisplayWidget
  ├── FourZhuCardWrapper (预留)
  ├── JieQiRiseSetCard (预留)
  └── DivinationRecordService

MeiHuaHistoryPage
  └── DivinationRecordService

DivinationRecordService
  └── MeiHuaDivinationRepository

MeiHuaDivinationRepository
  └── MeiHuaDivinationsDao

MeiHuaDivinationsDao
  └── MeiHuaDatabase
```

---

## 6. 风险和缓解

### 6.1 技术风险

| 风险 | 影响 | 缓解措施 |
|------|------|----------|
| Drift 代码生成失败 | 阻塞开发 | 检查表定义语法，参考 common 实现 |
| 数据库迁移问题 | 数据丢失 | 使用软删除，支持数据恢复 |
| 性能问题 | 用户体验差 | 使用索引，优化查询 |

### 6.2 集成风险

| 风险 | 影响 | 缓解措施 |
|------|------|----------|
| common 组件不兼容 | 功能受限 | 预留接口，支持自定义实现 |
| 主题冲突 | 界面不一致 | 使用独立主题，支持主题切换 |

---

## 7. 后续迭代

### 7.1 短期（1-2周）

- [ ] 集成四柱计算服务
- [ ] 集成物候计算服务
- [ ] 完善历史记录详情页面

### 7.2 中期（1个月）

- [ ] 支持记录编辑和删除
- [ ] 支持记录导出
- [ ] 支持记录搜索和筛选

### 7.3 长期（3个月）

- [ ] 集成云端同步（xuan-storage）
- [ ] 支持多设备同步
- [ ] 支持数据统计和分析
