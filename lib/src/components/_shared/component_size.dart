/// 组件尺寸档位。
///
/// 对齐 AntD v5 `size` 属性。三档分别对应 controlHeight 24 / 32 / 40。
enum AntComponentSize {
  /// 紧凑场景：控件高度 24、字号 -2。
  small,

  /// 默认档位：控件高度来自 `AntAliasToken.controlHeight`（=32）、默认字号。
  middle,

  /// 宽松场景：控件高度 40、字号 +2。
  large,
}
