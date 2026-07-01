import 'package:ant_design_flutter/src/app/ant_config_provider.dart';
import 'package:flutter/widgets.dart';

/// 漫游式引导（简版）。对齐 AntD v5 `Tour`。
abstract final class AntTour {
  static OverlayEntryHandle? _handle;

  static void start(
    BuildContext context, {
    required List<AntTourStep> steps,
    required VoidCallback onFinish,
  }) {
    _showStep(context, 0, steps, onFinish);
  }

  static void _showStep(BuildContext context, int index, List<AntTourStep> steps, VoidCallback onFinish) {
    if (index >= steps.length) { onFinish(); return; }
    _dismiss();
    final alias = AntTheme.aliasOf(context);
    final step = steps[index];

    // Simple overlay-based tour step display.
    // MVP does not implement target highlighting.
    _handle = OverlayEntryHandle.internal(AntOverlaySlot.message, -index - 1);
    // Use message slot as simple overlay for tour popups
  }
}
