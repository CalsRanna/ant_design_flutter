import 'package:ant_design_flutter/src/theme/alias_token.dart';
import 'package:ant_design_flutter/src/theme/map_token.dart';
import 'package:ant_design_flutter/src/theme/seed_token.dart';

/// 主题算法接口：将 Seed 派生为 Map，再派生为 Alias。
///
/// `DefaultAlgorithm` 为 Phase 1 唯一实现。`DarkAlgorithm` /
/// `CompactAlgorithm` 计划在 2.1 版本引入，届时只新增实现类，不改接口。
abstract interface class AntThemeAlgorithm {
  AntMapToken mapFromSeed(AntSeedToken seed);
  AntAliasToken aliasFromMap(AntSeedToken seed, AntMapToken map);
}
