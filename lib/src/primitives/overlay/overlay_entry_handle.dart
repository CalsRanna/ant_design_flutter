import 'package:ant_design_flutter/src/primitives/overlay/ant_overlay_slot.dart';

/// 不透明句柄。consumer 只用它传给 `AntOverlayManager.dismiss`。
/// 内部字段全部包私有，外部不可读。
class OverlayEntryHandle {
  /// @internal
  OverlayEntryHandle.internal(this.slot, this.id);

  /// @internal 所属的 slot。
  final AntOverlaySlot slot;

  /// @internal 自增 id，Manager 用来在 host 的 list 中定位。
  final int id;

  bool _dismissed = false;

  /// @internal
  bool get isDismissed => _dismissed;

  /// @internal
  void markDismissed() => _dismissed = true;

  @override
  String toString() =>
      'OverlayEntryHandle(${slot.name}#$id${_dismissed ? ' dismissed' : ''})';
}
