/// 组件状态（主要被 `AntInput` / 未来 `AntSelect` 等表单控件消费）。
///
/// 值对应 AntD v5 `status` 属性。`default` 是 Dart 关键字，故重命名为
/// `defaultStatus`。
enum AntStatus {
  /// 默认中立状态。
  defaultStatus,

  /// 校验失败，视觉上 border / icon 用 colorError。
  error,

  /// 警告，视觉上 border / icon 用 colorWarning。
  warning,
}
