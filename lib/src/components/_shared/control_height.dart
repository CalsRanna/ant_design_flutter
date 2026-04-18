import 'package:ant_design_flutter/src/components/_shared/component_size.dart';
import 'package:ant_design_flutter/src/theme/alias_token.dart';

/// 根据 [size] 从 [alias] 派生控件高度。
///
/// Alias 目前仅持有 middle 档位（`controlHeight`）。small / large 档位
/// 在 Phase 3 用常量给出（24 / 40），待 2.1 引入 alias 小 / 大字段后改读 alias，
/// 调用方零改动。
double resolveControlHeight(AntAliasToken alias, AntComponentSize size) {
  return switch (size) {
    AntComponentSize.small => 24,
    AntComponentSize.middle => alias.controlHeight,
    AntComponentSize.large => 40,
  };
}
