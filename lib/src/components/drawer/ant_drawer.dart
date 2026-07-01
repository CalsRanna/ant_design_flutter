import 'package:ant_design_flutter/src/theme/alias_token.dart';
import 'package:ant_design_flutter/src/app/ant_config_provider.dart';
import 'package:ant_design_flutter/src/primitives/overlay/ant_overlay_manager.dart';
import 'package:ant_design_flutter/src/primitives/overlay/ant_overlay_slot.dart';
import 'package:ant_design_flutter/src/primitives/overlay/overlay_entry_handle.dart';
import 'package:flutter/widgets.dart';

/// 抽屉。对齐 AntD v5 `Drawer`。
abstract final class AntDrawer {
  static OverlayEntryHandle show(
    BuildContext context, {
    required Widget title,
    required Widget child,
    VoidCallback? onClose,
  }) {
    final alias = AntTheme.aliasOf(context);
    final holder = _HandleHolder();
    final handle = AntOverlayManager.show(
      context: context,
      slot: AntOverlaySlot.drawer,
      builder: (_) => _DrawerWidget(
        title: title,
        child: child,
        alias: alias,
        onClose: () {
          holder.dismiss();
          onClose?.call();
        },
      ),
    );
    holder.handle = handle;
    return handle;
  }

  static void dismiss(OverlayEntryHandle handle) {
    AntOverlayManager.dismiss(handle);
  }
}

class _HandleHolder {
  OverlayEntryHandle? _handle;
  set handle(OverlayEntryHandle h) => _handle = h;
  OverlayEntryHandle? get handle => _handle;
  void dismiss() {
    final h = _handle;
    if (h != null && !h.isDismissed) AntOverlayManager.dismiss(h);
  }
}

class _DrawerWidget extends StatelessWidget {
  const _DrawerWidget({
    required this.title,
    required this.child,
    required this.alias,
    required this.onClose,
  });

  final Widget title;
  final Widget child;
  final AntAliasToken alias;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 360,
      child: Container(
        color: alias.colorBackgroundElevated,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: alias.colorSplit)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: DefaultTextStyle(
                      style: TextStyle(
                        fontSize: alias.fontSize,
                        fontWeight: FontWeight.w600,
                        color: alias.colorText,
                      ),
                      child: title,
                    ),
                  ),
                  GestureDetector(
                    onTap: onClose,
                    child: Text(
                      '✕',
                      style: TextStyle(color: alias.colorTextTertiary),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
