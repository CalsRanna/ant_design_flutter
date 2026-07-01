import 'package:ant_design_flutter/src/app/ant_config_provider.dart';
import 'package:ant_design_flutter/src/primitives/overlay/ant_overlay_manager.dart';
import 'package:ant_design_flutter/src/primitives/overlay/ant_overlay_slot.dart';
import 'package:ant_design_flutter/src/primitives/overlay/overlay_entry_handle.dart';
import 'package:flutter/widgets.dart';

/// 漫游式引导（简版）。对齐 AntD v5 `Tour`。
class AntTourStep {
  const AntTourStep({required this.title, required this.description});
  final String title; final String description;
}

class AntTourOverlay extends StatelessWidget {
  const AntTourOverlay({
    required this.step, required this.index, required this.total,
    required this.onPrev, required this.onNext, required this.onFinish,
  });
  final AntTourStep step; final int index; final int total;
  final VoidCallback onPrev; final VoidCallback onNext; final VoidCallback onFinish;

  @override
  Widget build(BuildContext context) {
    final alias = AntTheme.aliasOf(context);
    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: alias.colorBackgroundElevated, borderRadius: BorderRadius.circular(8),
        boxShadow: const [BoxShadow(color: Color(0x26000000), blurRadius: 16, offset: Offset(0, 8))]),
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(step.title, style: TextStyle(fontSize: alias.fontSize + 2, fontWeight: FontWeight.w600, color: alias.colorText)),
        const SizedBox(height: 8),
        Text(step.description, style: TextStyle(color: alias.colorTextSecondary, fontSize: alias.fontSize)),
        const SizedBox(height: 16),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('${index + 1} / $total', style: TextStyle(color: alias.colorTextTertiary, fontSize: 12)),
          Row(mainAxisSize: MainAxisSize.min, children: [
            if (index > 0) GestureDetector(onTap: onPrev, child: Container(padding: const EdgeInsets.all(8), child: Text('上一步', style: TextStyle(color: alias.colorPrimary)))),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: index < total - 1 ? onNext : onFinish,
              child: Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(color: alias.colorPrimary, borderRadius: BorderRadius.circular(4)),
                child: Text(index < total - 1 ? '下一步' : '完成', style: const TextStyle(color: Color(0xFFFFFFFF)))),
            ),
          ]),
        ]),
      ]),
    );
  }
}
