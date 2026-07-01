import 'package:ant_design_flutter/src/app/ant_config_provider.dart';
import 'package:ant_design_flutter/src/primitives/overlay/ant_overlay_manager.dart';
import 'package:ant_design_flutter/src/primitives/overlay/ant_overlay_slot.dart';
import 'package:ant_design_flutter/src/primitives/overlay/overlay_entry_handle.dart';
import 'package:flutter/widgets.dart';

/// 漫游式引导步骤定义。
class AntTourStep {
  const AntTourStep({required this.title, required this.description});
  final String title;
  final String description;
}

/// 漫游式引导窗口组件。
class AntTourOverlay extends StatelessWidget {
  const AntTourOverlay({
    required this.step,
    required this.index,
    required this.total,
    required this.onPrev,
    required this.onNext,
    required this.onFinish,
  });

  final AntTourStep step;
  final int index;
  final int total;
  final VoidCallback onPrev;
  final VoidCallback onNext;
  final VoidCallback onFinish;

  @override
  Widget build(BuildContext context) {
    final alias = AntTheme.aliasOf(context);
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: const EdgeInsets.all(24),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: alias.colorBackgroundElevated,
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(
              color: Color(0x26000000),
              blurRadius: 16,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              step.title,
              style: TextStyle(
                fontSize: alias.fontSize + 2,
                fontWeight: FontWeight.w600,
                color: alias.colorText,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              step.description,
              style: TextStyle(color: alias.colorTextSecondary, fontSize: alias.fontSize),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${index + 1} / $total',
                  style: TextStyle(color: alias.colorTextTertiary, fontSize: 12),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (index > 0)
                      GestureDetector(
                        onTap: onPrev,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            '上一步',
                            style: TextStyle(color: alias.colorPrimary),
                          ),
                        ),
                      ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: index < total - 1 ? onNext : onFinish,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          color: alias.colorPrimary,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          index < total - 1 ? '下一步' : '完成',
                          style: const TextStyle(color: Color(0xFFFFFFFF)),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// 漫游式引导（简版）。对齐 AntD v5 `Tour`。
abstract final class AntTour {
  static OverlayEntryHandle? _handle;
  static List<AntTourStep>? _steps;
  static int _current = 0;
  static VoidCallback? _onFinish;

  static void start(
    BuildContext context, {
    required List<AntTourStep> steps,
    required VoidCallback onFinish,
  }) {
    _steps = steps;
    _onFinish = onFinish;
    _current = 0;
    _showStep(context);
  }

  static void _showStep(BuildContext context) {
    _dismiss();

    if (_steps == null || _current >= _steps!.length) {
      _onFinish?.call();
      return;
    }

    _handle = AntOverlayManager.show(
      context: context,
      slot: AntOverlaySlot.message,
      builder: (_) => AntTourOverlay(
        step: _steps![_current],
        index: _current,
        total: _steps!.length,
        onPrev: () {
          _current--;
          _showStep(context);
        },
        onNext: () {
          _current++;
          _showStep(context);
        },
        onFinish: () {
          _dismiss();
          _onFinish?.call();
        },
      ),
    );
  }

  static void _dismiss() {
    if (_handle != null) {
      AntOverlayManager.dismiss(_handle!);
      _handle = null;
    }
  }
}
