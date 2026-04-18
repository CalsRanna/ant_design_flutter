import 'package:ant_design_flutter/src/primitives/overlay/ant_overlay_slot.dart';
import 'package:flutter/widgets.dart';

/// 内部：per-(Overlay × slot) 的 host widget。
/// 由 `AntOverlayManager` 注入到 `OverlayEntry` 中；Manager 通过
/// `GlobalKey<AntOverlayHostState>` 拿到 state 后增删条目。
class AntOverlayHost extends StatefulWidget {
  const AntOverlayHost({required this.slot, super.key});

  final AntOverlaySlot slot;

  @override
  State<AntOverlayHost> createState() => AntOverlayHostState();
}

class _HostedEntry {
  _HostedEntry(this.id, this.builder);

  final int id;
  final WidgetBuilder builder;
}

class AntOverlayHostState extends State<AntOverlayHost> {
  final List<_HostedEntry> _entries = <_HostedEntry>[];

  /// @internal 供 `AntOverlayManager.show` 调用。
  void addEntry(int id, WidgetBuilder builder) {
    setState(() {
      if (widget.slot.isSingleton && _entries.isNotEmpty) {
        _entries.clear();
      }
      _entries.add(_HostedEntry(id, builder));
    });
  }

  /// @internal 供 `AntOverlayManager.dismiss` 调用。
  void removeEntry(int id) {
    final idx = _entries.indexWhere((e) => e.id == id);
    if (idx == -1) return;
    setState(() => _entries.removeAt(idx));
  }

  /// @internal 供 `AntOverlayManager.dismissAll` 调用。
  void clear() {
    if (_entries.isEmpty) return;
    setState(_entries.clear);
  }

  @override
  Widget build(BuildContext context) {
    if (_entries.isEmpty) return const SizedBox.shrink();
    // Task 12 will switch to slot-specific layout (message / notification
    // vertical stack, modal / drawer with barrier). For now, plain Stack
    // is enough to render inserted entries so the lifecycle tests pass.
    return Stack(
      alignment: Alignment.center,
      children: [
        for (final e in _entries)
          KeyedSubtree(
            key: ValueKey('ant-overlay-${widget.slot.name}-${e.id}'),
            child: e.builder(context),
          ),
      ],
    );
  }
}
