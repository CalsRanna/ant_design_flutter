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
    final children = <Widget>[
      for (final e in _entries)
        KeyedSubtree(
          key: ValueKey('ant-overlay-${widget.slot.name}-${e.id}'),
          child: e.builder(context),
        ),
    ];

    switch (widget.slot) {
      case AntOverlaySlot.message:
        return Positioned.fill(
          child: SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 24),
                child: _verticalStack(children),
              ),
            ),
          ),
        );
      case AntOverlaySlot.notification:
        return Positioned.fill(
          child: SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 24, right: 24),
                child: _verticalStack(children),
              ),
            ),
          ),
        );
      case AntOverlaySlot.modal:
      case AntOverlaySlot.drawer:
        // Task 13 replaces with barrier + positioned content.
        return Positioned.fill(
          child: Stack(alignment: Alignment.center, children: children),
        );
    }
  }

  static Widget _verticalStack(List<Widget> children) {
    final interleaved = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      if (i > 0) interleaved.add(const SizedBox(height: 8));
      interleaved.add(children[i]);
    }
    return Column(mainAxisSize: MainAxisSize.min, children: interleaved);
  }
}
