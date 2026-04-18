# Phase 0 基建 Scaffold 实施计划

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 把 1.x 代码全部清出去，搭起 2.0 的工程骨架（pubspec / lint / CI / widgetbook / 文档），让后续 Phase 1+ 能在干净地基上开始。

**Architecture:** Phase 0 不涉及任何组件实现。它的成功指标是：`flutter pub get` + `flutter analyze --fatal-infos` 在全空 `lib/` 上通过；CI 在 GitHub Actions 跑绿；widgetbook gallery 子项目能 `flutter run -d chrome` 启动并显示空壳。

**Tech Stack:** Dart 3.10+、Flutter 3.38+、very_good_analysis 10.2.0、widgetbook 3.22.0、GitHub Actions。

**时间预算：** 2 周 / 约 15 小时（业余 5-10 小时/周）。

**上游 Spec：** `docs/superpowers/specs/2026-04-18-antdf-2.0-design.md`

---

## File Structure

Phase 0 结束时仓库长这样：

```
ant_design_flutter/
├── .github/
│   └── workflows/
│       └── ci.yml                        ← 新建
├── doc/
│   ├── DESIGN.md                         ← 新建（指向 spec）
│   ├── MIGRATION.md                      ← 新建（骨架）
│   ├── CONTRIBUTING.md                   ← 新建（骨架）
│   └── PROGRESS.md                       ← 新建（进度跟踪）
├── docs/
│   └── superpowers/                      ← 已存在（spec + 本 plan）
├── fonts/
│   └── .gitkeep                          ← 新建（字体 Phase 1 再放）
├── gallery/                              ← 新建子项目
│   ├── pubspec.yaml
│   ├── analysis_options.yaml
│   └── lib/
│       └── main.dart                     ← widgetbook 空壳
├── lib/
│   └── ant_design_flutter.dart           ← 重写（最小入口）
├── test/
│   └── smoke_test.dart                   ← 重写（最小烟雾测试）
├── example/
│   └── main.dart                         ← 重写（最小 runApp 验证）
├── .gitignore                            ← 修改（加几条）
├── analysis_options.yaml                 ← 重写
├── CHANGELOG.md                          ← 修改（加 2.0.0-dev.1 条目）
├── LICENSE                               ← 保留
├── pubspec.yaml                          ← 重写
└── README.md                             ← 重写

删除：
  .packages                               ← 已废弃
  .metadata                               ← 保留（Flutter 工具文件）
  lib/src/                                ← 整个删除（含 35 个 0 字节占位文件）
  pubspec.lock                            ← 已在 .gitignore，不提交；删除旧文件让 pub get 重建
```

---

## Task 1: 冻结 1.x 并清理旧源码

**Files:**
- Delete: `lib/src/` (整个目录，含 65 个 .dart 文件)
- Delete: `lib/ant_design_flutter.dart` (将在 Task 4 重建)
- Delete: `.packages`
- Delete: `pubspec.lock`
- Delete: `test/antdf_test.dart`
- Delete: `example/main.dart`
- Modify: `.gitignore`

- [ ] **Step 1: 确认当前 git 工作区干净**

Run: `git status`
Expected: "working tree clean"（允许 `.claude/` 之类的 untracked 文件；关键是 tracked 文件无改动）

如果有未提交改动，先让用户确认是否保留，再继续。

- [ ] **Step 2: 打 v1-legacy tag 冻结 1.x**

Run:
```bash
git tag -a v1-legacy -m "Freeze 1.x at 0.0.1+5 before 2.0 rewrite"
```

Expected: 无输出（成功创建 tag）

验证：`git tag --list 'v1-legacy'` 输出 `v1-legacy`

> **注意：** 是否 `git push --tags` 由用户自行决定，本 plan 不替用户执行。

- [ ] **Step 3: 删除 lib/ 下的旧源码**

Run:
```bash
rm -rf lib/src/
rm -f lib/ant_design_flutter.dart
```

Expected: `lib/` 变成空目录

验证：`ls lib/` 无输出

- [ ] **Step 4: 删除废弃的 .packages 和旧 pubspec.lock**

Run:
```bash
rm -f .packages pubspec.lock
```

Expected: 无输出

验证：`ls -a | grep -E '^\.packages$|^pubspec\.lock$'` 无输出

- [ ] **Step 5: 删除失效的 test 和 example 文件**

Run:
```bash
rm -f test/antdf_test.dart
rm -f example/main.dart
```

Expected: `test/` 和 `example/` 都变空目录

验证：`ls test/ example/` 均无输出

- [ ] **Step 6: 更新 .gitignore**

Edit `.gitignore`，在文件末尾加三行：

```gitignore
# Miscellaneous
*.class
*.log
*.pyc
*.swp
.DS_Store
.atom/
.buildlog/
.history
.svn/

# IntelliJ related
*.iml
*.ipr
*.iws
.idea/

# The .vscode folder contains launch configuration and tasks you configure in
# VS Code which you may wish to be included in version control, so this line
# is commented out by default.
#.vscode/

# Flutter/Dart/Pub related
# Libraries should not include pubspec.lock, per https://dart.dev/guides/libraries/private-files#pubspeclock.
/pubspec.lock
**/doc/api/
.dart_tool/
.packages
build/

# 2.0+
.claude/
gallery/pubspec.lock
gallery/.dart_tool/
```

验证：`tail -5 .gitignore` 显示上述三行新内容

- [ ] **Step 7: 检查 git status，确认清理范围符合预期**

Run: `git status`
Expected: 显示 65+ 个 deleted files (lib/src/**、lib/ant_design_flutter.dart、.packages、pubspec.lock、test/antdf_test.dart、example/main.dart)，modified: .gitignore

如果有意外文件被列入删除，停下来检查。

- [ ] **Step 8: 提交清理**

Run:
```bash
git add -A
git status   # 最后确认一次
git commit -m "chore: freeze 1.x at v1-legacy and remove legacy sources"
```

预期 commit message：
```
chore: freeze 1.x at v1-legacy and remove legacy sources
```

验证：`git log -1 --stat | head -5` 显示 commit 成功。

---

## Task 2: 重写 pubspec.yaml 至 2.0.0-dev.1

**Files:**
- Modify: `pubspec.yaml` (整文件重写)

- [ ] **Step 1: 完整替换 pubspec.yaml**

写入以下内容到 `pubspec.yaml`（注意 `flutter.fonts` 先以注释形式存在，字体文件 Phase 1 才会落地）：

```yaml
name: ant_design_flutter
description: >-
  A Flutter component library aligned with Ant Design v5, designed for web
  and desktop applications. Pure Dart with zero runtime dependencies.
version: 2.0.0-dev.1
homepage: https://github.com/CalsRanna/ant_design_flutter
repository: https://github.com/CalsRanna/ant_design_flutter
issue_tracker: https://github.com/CalsRanna/ant_design_flutter/issues

environment:
  sdk: ">=3.10.0 <4.0.0"
  flutter: ">=3.38.0"

dependencies:
  flutter:
    sdk: flutter

dev_dependencies:
  flutter_test:
    sdk: flutter
  very_good_analysis: ^10.2.0

flutter:
  # Font declaration is intentionally commented out in Phase 0.
  # Phase 1 will generate fonts/AntIcons.ttf and uncomment this block.
  # fonts:
  #   - family: AntIcons
  #     fonts:
  #       - asset: fonts/AntIcons.ttf
```

注意事项：
- **不要**添加 `flutter_lints`（被 `very_good_analysis` 替代）
- **不要**添加 `flutter_spinkit` / `dotted_border`（旧版遗留，2.0 零运行时依赖）
- **不要**添加 `widgetbook`（放到 gallery 子项目，避免污染主库依赖）
- **不要**取消 `flutter.fonts` 注释——没有真字体文件时 `flutter run` / gallery 会报 asset not found

- [ ] **Step 2: 创建 fonts/ 占位目录**

Run:
```bash
mkdir -p fonts
touch fonts/.gitkeep
```

验证：`ls -a fonts/` 显示 `.gitkeep`

- [ ] **Step 3: 运行 flutter pub get 验证 pubspec 合法**

Run: `flutter pub get`

Expected:
```
Resolving dependencies...
...
Got dependencies!
```

如果报错（常见：Flutter 版本不足、很多 lint 包冲突），记录错误并停下来和用户商量。

验证：`ls .dart_tool/` 出现 `package_config.json` 等文件

- [ ] **Step 4: 提交 pubspec 改动**

Run:
```bash
git add pubspec.yaml fonts/.gitkeep
git commit -m "feat(pubspec): bump to 2.0.0-dev.1 with zero runtime deps"
```

---

## Task 3: 配置严格 lint (analysis_options.yaml)

**Files:**
- Modify: `analysis_options.yaml` (整文件重写)

- [ ] **Step 1: 完整替换 analysis_options.yaml**

写入以下内容到 `analysis_options.yaml`：

```yaml
include: package:very_good_analysis/analysis_options.yaml

analyzer:
  exclude:
    - "**/*.g.dart"
    - "**/*.freezed.dart"
    - "build/**"
    - ".dart_tool/**"
  language:
    strict-casts: true
    strict-inference: true
    strict-raw-types: true
  errors:
    todo: info
    fixme: info

linter:
  rules:
    prefer_const_constructors: true
    prefer_const_constructors_in_immutables: true
    prefer_const_declarations: true
    prefer_const_literals_to_create_immutables: true
    unnecessary_lambdas: true
    avoid_positional_boolean_parameters: true
    sort_pub_dependencies: true
    # MVP 阶段关闭文档要求，beta 前重新打开
    public_member_api_docs: false
```

- [ ] **Step 2: 运行 flutter analyze 验证 lint 规则配置有效**

Run: `flutter analyze`

Expected (当前 lib/ 为空):
```
Analyzing ant_design_flutter...
No issues found!
```

如果 analyzer 报错（如 `include file not found`），说明 `very_good_analysis` 没装好，返回 Task 2 检查。

- [ ] **Step 3: 提交 analysis_options**

Run:
```bash
git add analysis_options.yaml
git commit -m "feat(lint): adopt very_good_analysis with strict type modes"
```

---

## Task 4: 建立最小 lib/ 入口 + 最小 test 验证工具链

**Files:**
- Create: `lib/ant_design_flutter.dart`
- Create: `test/smoke_test.dart`
- Create: `example/main.dart`

- [ ] **Step 1: 创建最小 lib 入口**

写入 `lib/ant_design_flutter.dart`：

```dart
/// ant_design_flutter 2.0 - Ant Design v5 aligned component library
/// for Flutter web and desktop applications.
///
/// This is the 2.0 rewrite scaffold. Components will land in subsequent
/// phases - see docs/superpowers/plans/ for the roadmap.
library ant_design_flutter;

// Phase 1 将在此处导出 foundation / theme / primitives
// Phase 2-6 将在此处导出各组件
```

- [ ] **Step 2: 创建最小 smoke test**

写入 `test/smoke_test.dart`：

```dart
import 'package:ant_design_flutter/ant_design_flutter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('library loads without error', () {
    // 2.0 scaffold smoke test - 只要 import 成功且文件编译过即视为通过。
    // Phase 1 起每个组件自带 widget test，届时替换此烟雾测试。
    expect(true, isTrue);
  });
}
```

- [ ] **Step 3: 创建最小 example**

写入 `example/main.dart`：

```dart
import 'package:flutter/widgets.dart';

/// Minimal scaffold example.
///
/// Real component demos will be added starting in Phase 3.
void main() {
  runApp(const _ScaffoldApp());
}

class _ScaffoldApp extends StatelessWidget {
  const _ScaffoldApp();

  @override
  Widget build(BuildContext context) {
    return const WidgetsApp(
      color: Color(0xFF1677FF),
      title: 'ant_design_flutter 2.0 scaffold',
      home: Center(
        child: Text(
          'ant_design_flutter 2.0 scaffold',
          textDirection: TextDirection.ltr,
          style: TextStyle(fontSize: 24, color: Color(0xFF1677FF)),
        ),
      ),
    );
  }
}
```

- [ ] **Step 4: 运行 flutter analyze 验证无 lint 错误**

Run: `flutter analyze`
Expected: `No issues found!`

如果报错（常见：`avoid_positional_boolean_parameters` / `prefer_const_constructors`），按提示修复。

- [ ] **Step 5: 运行 flutter test 验证测试框架可用**

Run: `flutter test`
Expected:
```
00:0X +1: All tests passed!
```

- [ ] **Step 6: 提交最小骨架**

Run:
```bash
git add lib/ test/ example/
git commit -m "feat(scaffold): minimal lib entry, smoke test, example stub"
```

---

## Task 5: GitHub Actions CI

**Files:**
- Create: `.github/workflows/ci.yml`

- [ ] **Step 1: 创建 CI workflow 文件**

写入 `.github/workflows/ci.yml`：

```yaml
name: CI

on:
  push:
    branches: [main, 'release/**']
  pull_request:
    branches: [main]

jobs:
  check:
    name: Analyze & Test
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.38.x'
          channel: 'stable'
          cache: true

      - name: Install dependencies
        run: flutter pub get

      - name: Verify formatting
        run: dart format --output=none --set-exit-if-changed .

      - name: Analyze project source
        run: flutter analyze --fatal-infos

      - name: Run tests
        run: flutter test

  gallery-check:
    name: Gallery Analyze
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.38.x'
          channel: 'stable'
          cache: true

      - name: Install gallery dependencies
        working-directory: gallery
        run: flutter pub get

      - name: Analyze gallery
        working-directory: gallery
        run: flutter analyze --fatal-infos
```

注意：
- `gallery-check` 依赖 Task 6 创建的 `gallery/` 子项目，但 CI 文件现在就写好
- Task 6 完成前 `gallery-check` 会失败——这没关系，本 Task 只提交 workflow 定义，不要求 CI 必须跑绿

- [ ] **Step 2: 本地静态检查 workflow 语法（可选，若安装了 act）**

如果用户安装了 [act](https://github.com/nektos/act)：
```bash
act -l
```
Expected: 列出 `check` 和 `gallery-check` 两个 job

如未安装 act，跳过此步；依赖 GitHub push 后的真实 CI 运行来验证。

- [ ] **Step 3: 本地运行 workflow 里的所有命令，确保 check job 会通过**

Run 每一条命令并确认：

```bash
flutter pub get                                        # ✓ Got dependencies
dart format --output=none --set-exit-if-changed .      # 若失败说明格式不一致，运行 dart format . 修复
flutter analyze --fatal-infos                          # ✓ No issues found!
flutter test                                           # ✓ All tests passed!
```

**如 `dart format --set-exit-if-changed` 报错：**
```bash
dart format .
git add -A
```
再重跑 `dart format --output=none --set-exit-if-changed .` 直到无变更。

- [ ] **Step 4: 提交 CI workflow**

Run:
```bash
git add .github/
git commit -m "ci: add GitHub Actions workflow for analyze, format, test"
```

---

## Task 6: Gallery (widgetbook) 子项目空壳

**Files:**
- Create: `gallery/pubspec.yaml`
- Create: `gallery/analysis_options.yaml`
- Create: `gallery/lib/main.dart`
- Create: `gallery/.gitignore`

**为什么是独立子项目：** widgetbook 依赖不进主 pubspec（spec 第 7.1 节声明主库零第三方运行时依赖），通过 `path: ../` 引用主库，这是 Flutter monorepo 的惯用写法。

- [ ] **Step 1: 创建 gallery/pubspec.yaml**

写入 `gallery/pubspec.yaml`：

```yaml
name: ant_design_flutter_gallery
description: Interactive widgetbook gallery for ant_design_flutter components.
publish_to: none
version: 0.1.0

environment:
  sdk: ">=3.10.0 <4.0.0"
  flutter: ">=3.38.0"

dependencies:
  flutter:
    sdk: flutter
  ant_design_flutter:
    path: ../
  widgetbook: ^3.22.0
  widgetbook_annotation: ^3.11.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  very_good_analysis: ^10.2.0
  build_runner: ^2.4.13
  widgetbook_generator: ^3.22.0

flutter:
  uses-material-design: false
```

- [ ] **Step 2: 创建 gallery/analysis_options.yaml**

写入：

```yaml
include: package:very_good_analysis/analysis_options.yaml

analyzer:
  exclude:
    - "**/*.g.dart"
    - "**/*.directories.g.dart"
    - "build/**"
    - ".dart_tool/**"

linter:
  rules:
    public_member_api_docs: false
```

- [ ] **Step 3: 创建 gallery/lib/main.dart 最小空壳**

写入 `gallery/lib/main.dart`：

```dart
import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';

void main() {
  runApp(const GalleryApp());
}

class GalleryApp extends StatelessWidget {
  const GalleryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Widgetbook(
      directories: const [
        WidgetbookCategory(
          name: 'Placeholder',
          children: [
            WidgetbookComponent(
              name: 'Empty',
              useCases: [
                WidgetbookUseCase(
                  name: 'Scaffold',
                  builder: _emptyUseCase,
                ),
              ],
            ),
          ],
        ),
      ],
      addons: const [],
    );
  }
}

Widget _emptyUseCase(BuildContext context) {
  return const Center(
    child: Text(
      'ant_design_flutter 2.0 gallery — add components here from Phase 1.',
      textDirection: TextDirection.ltr,
      style: TextStyle(fontSize: 16, color: Color(0xFF262626)),
    ),
  );
}
```

- [ ] **Step 4: 创建 gallery/.gitignore**

写入：

```gitignore
.dart_tool/
.packages
build/
pubspec.lock
*.g.dart
```

- [ ] **Step 5: 验证 gallery 能 pub get**

Run:
```bash
cd gallery
flutter pub get
cd ..
```

Expected: `Got dependencies!`

如果 widgetbook 3.22.0 不兼容本地 Flutter 3.38，查 pub.dev 获取最新可用版本并更新 `gallery/pubspec.yaml`。

- [ ] **Step 6: 验证 gallery 能 analyze 通过**

Run:
```bash
cd gallery && flutter analyze --fatal-infos && cd ..
```

Expected: `No issues found!`

如有警告，按提示修复（常见：`prefer_const_constructors`）。

- [ ] **Step 7: 验证 gallery 能跑起来（手动，可选）**

Run:
```bash
cd gallery
flutter run -d chrome
```

Expected: 浏览器打开，显示 widgetbook 界面，左侧树里有 `Placeholder > Empty > Scaffold` 节点，点击后显示 "ant_design_flutter 2.0 gallery..." 提示文字。

若 widgetbook UI 不渲染，查控制台错误。

手动终止：`Ctrl+C`

- [ ] **Step 8: 提交 gallery 子项目**

Run:
```bash
git add gallery/
git commit -m "feat(gallery): scaffold widgetbook subproject"
```

---

## Task 7: 文档骨架

**Files:**
- Create: `doc/DESIGN.md`
- Create: `doc/MIGRATION.md`
- Create: `doc/CONTRIBUTING.md`
- Create: `doc/PROGRESS.md`

- [ ] **Step 1: 创建 doc/DESIGN.md（指向 spec）**

写入 `doc/DESIGN.md`：

```markdown
# Design

Full 2.0 design specification lives at:

[docs/superpowers/specs/2026-04-18-antdf-2.0-design.md](../docs/superpowers/specs/2026-04-18-antdf-2.0-design.md)

Per-phase implementation plans live under:

[docs/superpowers/plans/](../docs/superpowers/plans/)

This file exists so developers landing in `doc/` can find the spec without
exploring the superpowers tooling convention.
```

- [ ] **Step 2: 创建 doc/MIGRATION.md 骨架**

写入 `doc/MIGRATION.md`：

```markdown
# Migration Guide: 1.x → 2.0

> Status: **draft skeleton**. Full migration guide will be completed before
> the 2.0.0 stable release.

## Breaking: complete API redesign

2.0 is a full rewrite. 1.x and 2.x share no API surface. Projects on 1.x
should stay on `ant_design_flutter: ^0.0.1+5` (tag `v1-legacy`) until they
are ready for the rewrite.

## What changed at a glance

| Area | 1.x | 2.0 |
| --- | --- | --- |
| Package name | `ant_design_flutter` | `ant_design_flutter` (same) |
| Version | `0.0.1+x` | `2.0.0+` |
| Minimum SDK | Flutter 1.17 | Flutter 3.38 / Dart 3.10 |
| Widget naming | `Button`, `Icon`, `Table`, ... | `AntButton`, `AntIcon`, `AntTable`, ... |
| Library export | `export 'package:flutter/widgets.dart' hide ...` (hijacks Flutter namespace) | Only exports this library's symbols |
| Theme | Hard-coded `Colors.blue_6` etc. | `AntTheme.of(context).alias.colorPrimary` via token system |
| Form | Each widget self-manages state | `AntFormController` + `AntFormItem` |
| Icons | Material Icons aliased | Bundled AntD icon font (`AntIcons.*`) |

## Component-by-component changes

_TODO: populate once components land starting Phase 3._

## Manual migration steps

_TODO: write when the component mapping above is concrete._

## Dropped features

_TODO: list widgets that did not make the MVP 17 and their 2.1+ timeline._
```

- [ ] **Step 3: 创建 doc/CONTRIBUTING.md 骨架**

写入 `doc/CONTRIBUTING.md`：

```markdown
# Contributing

Thanks for wanting to help! A full guide is under construction — below is the
working scaffold that reflects current state (Phase 0).

## Development setup

1. Flutter 3.38+ / Dart 3.10+ installed and on PATH
2. Clone the repo, then run from the repo root:
   ```bash
   flutter pub get
   flutter analyze --fatal-infos
   flutter test
   ```
3. To run the widgetbook gallery:
   ```bash
   cd gallery
   flutter pub get
   flutter run -d chrome
   ```

## Before you submit a PR

- `flutter analyze --fatal-infos` must be clean
- `flutter test` must pass
- `dart format --set-exit-if-changed .` must pass
- If your change affects the gallery, run `flutter analyze` in `gallery/` too
- CI will enforce all of the above

## Design alignment

Before proposing a new component or widget, check
[docs/superpowers/specs/2026-04-18-antdf-2.0-design.md](../docs/superpowers/specs/2026-04-18-antdf-2.0-design.md).
Components outside the MVP 17 belong on the 2.1+ roadmap and need a
design discussion before implementation.

## Phased development

Work is tracked in [doc/PROGRESS.md](PROGRESS.md) against the plans under
`docs/superpowers/plans/`. Each Phase has its own plan — ask before starting
cross-phase work.

## Commit style

Conventional Commits (`feat:`, `fix:`, `chore:`, `docs:`, `ci:`, `refactor:`,
`test:`). Scope with the affected area, e.g. `feat(button):`, `chore(pubspec):`.
```

- [ ] **Step 4: 创建 doc/PROGRESS.md**

写入 `doc/PROGRESS.md`：

```markdown
# 2.0 Development Progress

Lightweight running log so Phase work survives calendar gaps. Update the
"Last updated" line and the current Phase's checklist whenever you stop a
session.

**Last updated:** 2026-04-18

## Phase status

| Phase | Scope | Plan | Status |
| --- | --- | --- | --- |
| 0 | Scaffold (pubspec/lint/CI/gallery shell) | [plans/2026-04-18-phase-0-scaffold.md](../docs/superpowers/plans/2026-04-18-phase-0-scaffold.md) | in progress |
| 1 | Foundation + Theme | — | not started |
| 2 | Primitives (Interaction / Portal / Overlay) | — | not started |
| 3 | Round 1+2 atoms | — | not started |
| 4 | Round 3 feedback widgets | — | not started |
| 5 | Round 4 composites | — | not started |
| 6 | Form engine | — | not started |
| 7 | i18n + docs finalization | — | not started |
| 8 | RC soak + bug fixes | — | not started |

## Current session notes

_What you were working on when you last stopped. Makes coming back easy._

- 2026-04-18: Phase 0 plan written. Next: execute plan from Task 1.

## Blockers / parked ideas

_Anything that's waiting on an external decision or that you deferred._

- None yet.
```

- [ ] **Step 5: 验证所有文档是 valid markdown**

Run: `flutter analyze --fatal-infos`
Expected: 仍然 `No issues found!`（analyzer 不检查 .md，但确保没有因为路径笔误破坏任何 dart 引用）

打开 `doc/DESIGN.md`、`doc/MIGRATION.md`、`doc/CONTRIBUTING.md`、`doc/PROGRESS.md` 目测，确认内部链接能跳转。

- [ ] **Step 6: 提交文档骨架**

Run:
```bash
git add doc/
git commit -m "docs: scaffold DESIGN, MIGRATION, CONTRIBUTING, PROGRESS"
```

---

## Task 8: 重写 README.md

**Files:**
- Modify: `README.md` (整文件重写)

- [ ] **Step 1: 完整替换 README.md**

写入以下内容：

```markdown
<p align="center">
  <a href="https://github.com/CalsRanna/ant_design_flutter">
    <img width="200" src="https://gw.alipayobjects.com/zos/rmsportal/KDpgvguMpGfqaHPjicRK.svg">
  </a>
</p>

<h1 align="center">ant_design_flutter 2.0</h1>

<div align="center">

A Flutter component library aligned with **Ant Design v5**, designed for web
and desktop applications. Pure Dart, zero runtime dependencies.

![Status](https://img.shields.io/badge/STATUS-2.0--dev-orange?style=for-the-badge&color=orange)
![Pub Version](https://img.shields.io/pub/v/ant_design_flutter?style=for-the-badge&include_prereleases)
![GitHub](https://img.shields.io/github/license/CalsRanna/ant_design_flutter?style=for-the-badge)

</div>

---

> **⚠️ Development status**
>
> 2.0 is a full rewrite. The `main` branch targets `2.0.0-dev.x` releases —
> no components have landed yet. For a stable (but unmaintained) 1.x release
> see tag `v1-legacy` or version `0.0.1+5`.
>
> Roadmap and design live in
> [`docs/superpowers/specs/2026-04-18-antdf-2.0-design.md`](docs/superpowers/specs/2026-04-18-antdf-2.0-design.md).

## ✨ Features (MVP goals)

- 🎯 Aligned with Ant Design v5 design language
- 🖥 Web + desktop first (Windows / macOS / Linux / Web); mobile out of scope
- 🎨 Token-based theming (Seed → Map → Alias) compatible with `theme.algorithm` extension
- 📦 Zero runtime dependencies — pure Dart on top of `package:flutter/widgets.dart`
- 🌐 Built-in `zh_CN` and `en_US` locales
- 🧩 17 core components in MVP (Button, Input, Select, DatePicker, Form, Table, and more)

## 📦 Installation

**Not yet on pub.dev for 2.0.** While 2.0 is in development, pin to git:

```yaml
dependencies:
  ant_design_flutter:
    git:
      url: https://github.com/CalsRanna/ant_design_flutter
      ref: main
```

Once `2.0.0-dev.2` ships (Phase 3 complete) it will be published to pub.dev.

## 🔨 Usage

Components land in subsequent phases — see
[`doc/PROGRESS.md`](doc/PROGRESS.md) for current status.

## 🖥 Requirements

- Flutter `>= 3.38.0`
- Dart `>= 3.10.0`

## 🗺 Migration from 1.x

2.0 is a breaking rewrite. See
[`doc/MIGRATION.md`](doc/MIGRATION.md). If you are on 1.x and do not plan to
migrate, pin to `ant_design_flutter: 0.0.1+5` (tag `v1-legacy`).

## 🤝 Contributing

See [`doc/CONTRIBUTING.md`](doc/CONTRIBUTING.md).

## 📄 License

[MIT](LICENSE)
```

- [ ] **Step 2: 提交 README 改动**

Run:
```bash
git add README.md
git commit -m "docs(readme): rewrite for 2.0-dev scope and roadmap"
```

---

## Task 9: 更新 CHANGELOG 并最终校验

**Files:**
- Modify: `CHANGELOG.md` (在顶部追加 2.0.0-dev.1 条目)

- [ ] **Step 1: 在 CHANGELOG.md 顶部追加新条目**

编辑 `CHANGELOG.md`，在文件**最上方**追加以下内容（不删除旧条目）：

```markdown
## 2.0.0-dev.1

Phase 0 scaffold. No components yet — this release delivers the rewrite's
engineering ground truth.

### Breaking (vs 1.x)
- Complete API redesign; 1.x users should stay on `0.0.1+5` (tag `v1-legacy`).
- Library no longer re-exports `package:flutter/widgets.dart` — consumers import
  Flutter widgets directly.
- Minimum Flutter raised to 3.38 / Dart to 3.10.

### Added
- 2.0 design document at `docs/superpowers/specs/`.
- `very_good_analysis` strict lint profile.
- GitHub Actions CI (analyze, format, test).
- widgetbook gallery subproject scaffold at `gallery/`.
- Scaffolded docs: `doc/DESIGN.md`, `MIGRATION.md`, `CONTRIBUTING.md`, `PROGRESS.md`.

### Removed
- All 1.x component sources (`lib/src/`).
- Runtime dependencies `dotted_border` and `flutter_spinkit`.
- Legacy `.packages` file.

### Reference
- Design: `docs/superpowers/specs/2026-04-18-antdf-2.0-design.md`
- Phase 0 plan: `docs/superpowers/plans/2026-04-18-phase-0-scaffold.md`

---

## 0.0.1+5
```

注意：保留原有 `## 0.0.1+5` 及往后全部历史条目；仅在最顶部插入 2.0.0-dev.1 块。

- [ ] **Step 2: 最终端到端校验**

按顺序运行以下命令，全部必须通过：

```bash
# 1. 主库
flutter pub get
flutter analyze --fatal-infos
flutter test
dart format --output=none --set-exit-if-changed .

# 2. Gallery
cd gallery
flutter pub get
flutter analyze --fatal-infos
cd ..
```

Expected:
```
Got dependencies!
No issues found!
All tests passed!
(no output from dart format)
Got dependencies!
No issues found!
```

如有任何一步失败，停下来解决再继续。

- [ ] **Step 3: 提交 CHANGELOG**

Run:
```bash
git add CHANGELOG.md
git commit -m "docs(changelog): add 2.0.0-dev.1 entry"
```

- [ ] **Step 4: 查看完整 git log 确认 Phase 0 交付物**

Run: `git log --oneline v1-legacy..HEAD`

Expected (约 8 条 commit)：
```
<hash> docs(changelog): add 2.0.0-dev.1 entry
<hash> docs(readme): rewrite for 2.0-dev scope and roadmap
<hash> docs: scaffold DESIGN, MIGRATION, CONTRIBUTING, PROGRESS
<hash> feat(gallery): scaffold widgetbook subproject
<hash> ci: add GitHub Actions workflow for analyze, format, test
<hash> feat(scaffold): minimal lib entry, smoke test, example stub
<hash> feat(lint): adopt very_good_analysis with strict type modes
<hash> feat(pubspec): bump to 2.0.0-dev.1 with zero runtime deps
<hash> chore: freeze 1.x at v1-legacy and remove legacy sources
```

- [ ] **Step 5: 更新 doc/PROGRESS.md 标记 Phase 0 完成**

Edit `doc/PROGRESS.md`：

把 Phase 0 行的 `in progress` 改为 `complete`：

```markdown
| 0 | Scaffold (pubspec/lint/CI/gallery shell) | [plans/2026-04-18-phase-0-scaffold.md](../docs/superpowers/plans/2026-04-18-phase-0-scaffold.md) | complete |
```

更新 `Last updated` 为今天日期；在 `Current session notes` 追加：

```markdown
- 2026-04-XX: Phase 0 complete. Next: write Phase 1 plan (Foundation + Theme).
```

把当前日期替换进去。

Run:
```bash
git add doc/PROGRESS.md
git commit -m "docs(progress): mark Phase 0 complete"
```

- [ ] **Step 6: 决定是否 push 到 remote**

> **仅用户决定**：Phase 0 整个可以留本地，也可以推到 origin/main 触发 CI 跑一轮验证。
>
> - 留本地：什么都不做
> - 推到 remote：`git push origin main && git push origin v1-legacy`（tag 可选是否 push）

本 plan 不替用户执行 push。

---

## Phase 0 完成定义 (DoD)

全部满足才算 Phase 0 完成：

- [x] `git tag v1-legacy` 已创建
- [x] `lib/src/` 旧源码全部删除（包括 35 个 0 字节占位文件）
- [x] `pubspec.yaml` 更新到 `2.0.0-dev.1`，SDK `>=3.10.0`，Flutter `>=3.38.0`
- [x] 运行时零第三方依赖
- [x] `very_good_analysis ^10.2.0` + 自定义严格 lint 规则生效
- [x] `flutter analyze --fatal-infos` 通过
- [x] `flutter test` 通过（烟雾测试）
- [x] `dart format --set-exit-if-changed .` 通过
- [x] `.github/workflows/ci.yml` 存在且本地能跑绿全部命令
- [x] `gallery/` 独立子项目可 `flutter run -d chrome` 启动
- [x] `doc/DESIGN.md`、`MIGRATION.md`、`CONTRIBUTING.md`、`PROGRESS.md` 存在
- [x] `README.md` 已重写反映 2.0-dev 状态
- [x] `CHANGELOG.md` 新增 `2.0.0-dev.1` 条目
- [x] `doc/PROGRESS.md` Phase 0 行标记 complete

满足后 Phase 0 结束。下一步：回到 brainstorming 做 Phase 1（Foundation + Theme）的设计细化，或直接 writing-plans 基于现有 spec 的 Section 3 展开 Phase 1 的实施计划。
