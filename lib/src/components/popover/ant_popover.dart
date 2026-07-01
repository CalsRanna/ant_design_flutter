import 'package:ant_design_flutter/src/app/ant_config_provider.dart';
import 'package:ant_design_flutter/src/primitives/interaction/ant_interaction_detector.dart';
import 'package:ant_design_flutter/src/primitives/portal/ant_placement.dart';
import 'package:ant_design_flutter/src/primitives/portal/ant_portal.dart';
import 'package:flutter/widgets.dart';

/// 气泡卡片。对齐 AntD v5 `Popover`。
class AntPopover extends StatefulWidget {
  const AntPopover({required this.title, required this.content, required this.child, super.key, this.placement = AntPlacement.top});
  final String title; final String content; final Widget child; final AntPlacement placement;
  @override
  State<AntPopover> createState() => _AntPopoverState();
}

class _AntPopoverState extends State<AntPopover> {
  bool _visible = false;
  @override
  Widget build(BuildContext context) {
    final alias = AntTheme.aliasOf(context);
    return AntPortal(
      placement: widget.placement, visible: _visible,
      child: AntInteractionDetector(
        onHover: (h) => setState(() => _visible = h),
        builder: (c, s) => widget.child,
      ),
      overlayBuilder: (c) => Container(
        constraints: const BoxConstraints(maxWidth: 240),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: alias.colorBackgroundElevated, borderRadius: BorderRadius.circular(alias.borderRadius),
          boxShadow: const [BoxShadow(color: Color(0x1A000000), blurRadius: 8, offset: Offset(0, 2))]),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(widget.title, style: TextStyle(color: alias.colorText, fontSize: alias.fontSize, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text(widget.content, style: TextStyle(color: alias.colorTextSecondary, fontSize: alias.fontSize)),
        ]),
      ),
    );
  }
}
