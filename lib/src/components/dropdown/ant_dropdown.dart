import 'package:ant_design_flutter/src/theme/alias_token.dart';
import 'package:ant_design_flutter/src/app/ant_config_provider.dart';
import 'package:ant_design_flutter/src/primitives/portal/ant_placement.dart';
import 'package:ant_design_flutter/src/primitives/portal/ant_portal.dart';
import 'package:flutter/widgets.dart';

/// 下拉菜单。对齐 AntD v5 `Dropdown`。
class AntDropdown extends StatefulWidget {
  const AntDropdown({
    required this.overlay,
    required this.child,
    super.key,
    this.placement = AntPlacement.bottomLeft,
    this.trigger = AntDropdownTrigger.hover,
  });

  final List<AntDropdownItem> overlay;
  final Widget child;
  final AntPlacement placement;
  final AntDropdownTrigger trigger;

  @override
  State<AntDropdown> createState() => _AntDropdownState();
}

class _AntDropdownState extends State<AntDropdown> {
  bool _visible = false;

  @override
  Widget build(BuildContext context) {
    final alias = AntTheme.aliasOf(context);

    return AntPortal(
      placement: widget.placement,
      visible: _visible,
      offset: const Offset(0, 4),
      onDismiss: () => setState(() => _visible = false),
      child: MouseRegion(
        onEnter: widget.trigger == AntDropdownTrigger.hover
            ? (_) => setState(() => _visible = true)
            : null,
        onExit: widget.trigger == AntDropdownTrigger.hover
            ? (_) => setState(() => _visible = false)
            : null,
        child: GestureDetector(
          onTap: widget.trigger == AntDropdownTrigger.click
              ? () => setState(() => _visible = !_visible)
              : null,
          child: widget.child,
        ),
      ),
      overlayBuilder: (c) => Container(
        constraints: const BoxConstraints(maxHeight: 256),
        decoration: BoxDecoration(
          color: alias.colorBackgroundElevated,
          borderRadius: BorderRadius.circular(alias.borderRadius),
          boxShadow: const [
            BoxShadow(color: Color(0x1A000000), blurRadius: 8, offset: Offset(0, 2)),
          ],
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          for (final item in widget.overlay)
            GestureDetector(
              onTap: item.disabled ? null : () { item.onClick?.call(); setState(() => _visible = false); },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                width: double.infinity,
                child: Text(
                  item.title,
                  style: TextStyle(
                    color: item.disabled ? alias.colorTextDisabled : alias.colorText,
                    fontSize: alias.fontSize,
                  ),
                ),
              ),
            ),
        ]),
      ),
    );
  }
}

class AntDropdownItem {
  const AntDropdownItem({required this.title, this.onClick, this.disabled = false});
  final String title;
  final VoidCallback? onClick;
  final bool disabled;
}

enum AntDropdownTrigger { hover, click }
