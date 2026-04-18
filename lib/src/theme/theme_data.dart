import 'package:ant_design_flutter/src/theme/algorithm/default_algorithm.dart';
import 'package:ant_design_flutter/src/theme/algorithm/theme_algorithm.dart';
import 'package:ant_design_flutter/src/theme/alias_token.dart';
import 'package:ant_design_flutter/src/theme/map_token.dart';
import 'package:ant_design_flutter/src/theme/seed_token.dart';
import 'package:flutter/foundation.dart';

/// 主题数据聚合：构造时立即算出 [map] 和 [alias]，三份 token 都是 `final`。
///
/// 相同 `seed + algorithm` 必出相同 `map + alias`（算法纯函数）。
///
/// 注意：无法标为 `const` — 构造体调了 `algorithm.mapFromSeed`，
/// 这是方法调用。需要默认 theme 时写 `AntThemeData()` 而非 `const AntThemeData()`。
@immutable
class AntThemeData {
  factory AntThemeData({
    AntSeedToken seed = const AntSeedToken(),
    AntThemeAlgorithm algorithm = const DefaultAlgorithm(),
  }) {
    final map = algorithm.mapFromSeed(seed);
    final alias = algorithm.aliasFromMap(seed, map);
    return AntThemeData._(
      seed: seed,
      algorithm: algorithm,
      map: map,
      alias: alias,
    );
  }

  const AntThemeData._({
    required this.seed,
    required this.algorithm,
    required this.map,
    required this.alias,
  });

  final AntSeedToken seed;
  final AntThemeAlgorithm algorithm;
  final AntMapToken map;
  final AntAliasToken alias;

  AntThemeData copyWith({
    AntSeedToken? seed,
    AntThemeAlgorithm? algorithm,
  }) {
    return AntThemeData(
      seed: seed ?? this.seed,
      algorithm: algorithm ?? this.algorithm,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AntThemeData &&
        other.seed == seed &&
        other.algorithm.runtimeType == algorithm.runtimeType &&
        other.map == map &&
        other.alias == alias;
  }

  @override
  int get hashCode => Object.hash(seed, algorithm.runtimeType, map, alias);
}
