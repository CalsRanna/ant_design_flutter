/// `AntOverlayManager` 的 4 个 slot。每个 slot 在一个 Overlay 下最多一个 host。
/// 详见 Phase 2 spec § 5。
enum AntOverlaySlot {
  /// 顶部居中，多条垂直堆叠（FIFO）。
  message,

  /// 右上角，多条垂直堆叠（FIFO）。
  notification,

  /// 屏幕居中，单例（再次 show 先 dismiss 旧的）。
  modal,

  /// 屏幕右侧，单例。
  drawer,
}

extension AntOverlaySlotX on AntOverlaySlot {
  /// 是否单例（同 slot 同时只允许一条）。
  bool get isSingleton =>
      this == AntOverlaySlot.modal || this == AntOverlaySlot.drawer;
}
