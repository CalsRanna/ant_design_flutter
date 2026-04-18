import 'package:ant_design_flutter/src/primitives/overlay/ant_overlay_host.dart';
import 'package:ant_design_flutter/src/primitives/overlay/ant_overlay_slot.dart';
import 'package:ant_design_flutter/src/primitives/overlay/overlay_entry_handle.dart';
import 'package:flutter/scheduler.dart' show SchedulerBinding;
import 'package:flutter/widgets.dart';

/// 浮层管理器。详见 Phase 2 spec § 5。
abstract final class AntOverlayManager {
  static int _idSeq = 0;

  /// Overlay → (slot → host GlobalKey)。
  static final Expando<Map<AntOverlaySlot, GlobalKey<AntOverlayHostState>>>
      _hostsByOverlay = Expando();

  /// Overlay → (slot → host OverlayEntry)。仅用于生命周期持有。
  static final Expando<Map<AntOverlaySlot, OverlayEntry>> _entriesByOverlay =
      Expando();

  /// 已注册过的 Overlay 列表。`Expando` 无法枚举，用伴随 list 让
  /// `_allHostsForSlot` 能跨 Overlay 查找。Overlay dispose 时本 list 不
  /// 主动清理——MVP 单 WidgetsApp 场景足够；测试用 tearDown 清理。
  static final List<OverlayState> _registeredOverlays = <OverlayState>[];

  /// 在 [context] 所属 Overlay 的 [slot] 中插入一条浮层。
  static OverlayEntryHandle show({
    required BuildContext context,
    required AntOverlaySlot slot,
    required WidgetBuilder builder,
  }) {
    final overlay = Overlay.of(context);
    final id = ++_idSeq;
    final handle = OverlayEntryHandle.internal(slot, id);
    final hostKey = _ensureHost(overlay, slot);
    final state = hostKey.currentState;
    if (state != null) {
      state.addEntry(id, builder);
    } else {
      // Host just got inserted this frame — its state isn't mounted yet.
      // Defer to next frame, then skip if dismissed in the meantime.
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (handle.isDismissed) return;
        hostKey.currentState?.addEntry(id, builder);
      });
    }
    return handle;
  }

  /// 关闭指定 handle 对应的浮层。对已 dismissed 的 handle 幂等无操作。
  static void dismiss(OverlayEntryHandle handle) {
    if (handle.isDismissed) return;
    for (final host in _allHostsForSlot(handle.slot)) {
      host.currentState?.removeEntry(handle.id);
    }
    handle.markDismissed();
  }

  /// 清空 [context] 所属 Overlay 的指定 slot 所有条目。
  static void dismissAll(AntOverlaySlot slot, BuildContext context) {
    final overlay = Overlay.of(context);
    final hostKey = _hostsByOverlay[overlay]?[slot];
    hostKey?.currentState?.clear();
  }

  // ---------- internal ----------

  static GlobalKey<AntOverlayHostState> _ensureHost(
    OverlayState overlay,
    AntOverlaySlot slot,
  ) {
    if (!_registeredOverlays.contains(overlay)) {
      _registeredOverlays.add(overlay);
    }
    final hosts = _hostsByOverlay[overlay] ??= {};
    final entries = _entriesByOverlay[overlay] ??= {};
    final existing = hosts[slot];
    if (existing != null) return existing;

    final key = GlobalKey<AntOverlayHostState>();
    hosts[slot] = key;
    final entry = OverlayEntry(
      builder: (_) => AntOverlayHost(key: key, slot: slot),
    );
    entries[slot] = entry;
    overlay.insert(entry);
    return key;
  }

  static Iterable<GlobalKey<AntOverlayHostState>> _allHostsForSlot(
    AntOverlaySlot slot,
  ) sync* {
    for (final ov in _registeredOverlays) {
      final key = _hostsByOverlay[ov]?[slot];
      if (key != null) yield key;
    }
  }
}
