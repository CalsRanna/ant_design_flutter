import 'package:ant_design_flutter/src/app/ant_config_provider.dart';
import 'package:ant_design_flutter/src/components/tag/tag_style.dart';
import 'package:ant_design_flutter/src/primitives/interaction/ant_interaction_detector.dart';
import 'package:flutter/widgets.dart';

/// 展示性 Tag：支持自定义底色（对比色自动）、可选关闭按钮。
///
/// 可选中语义见 [AntCheckableTag]（故意拆分以避免互斥属性）。
class AntTag extends StatelessWidget {
  const AntTag({
    required this.child,
    super.key,
    this.color,
    this.bordered = true,
    this.closable = false,
    this.onClose,
  });

  final Widget child;
  final Color? color;
  final bool bordered;
  final bool closable;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    final alias = AntTheme.aliasOf(context);
    final style = TagStyle.resolveDefault(alias: alias, color: color);
    return _TagShell(
      background: style.background,
      borderColor: bordered ? style.borderColor : null,
      child: DefaultTextStyle.merge(
        style: TextStyle(color: style.foreground, fontSize: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            child,
            if (closable) ...[
              const SizedBox(width: 4),
              GestureDetector(
                onTap: onClose,
                behavior: HitTestBehavior.opaque,
                child: SizedBox.square(
                  dimension: 10,
                  child: CustomPaint(
                    painter: _CloseIconPainter(color: style.foreground),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// 可选中 Tag：`checked` 状态 + `onChanged(bool)`。
class AntCheckableTag extends StatelessWidget {
  const AntCheckableTag({
    required this.child,
    required this.checked,
    required this.onChanged,
    super.key,
  });

  final Widget child;
  final bool checked;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    final alias = AntTheme.aliasOf(context);
    return AntInteractionDetector(
      onTap: () => onChanged?.call(!checked),
      builder: (context, _) {
        final style = TagStyle.resolveCheckable(alias: alias, checked: checked);
        return _TagShell(
          background: style.background,
          borderColor: style.borderColor,
          child: DefaultTextStyle.merge(
            style: TextStyle(color: style.foreground, fontSize: 12),
            child: child,
          ),
        );
      },
    );
  }
}

class _TagShell extends StatelessWidget {
  const _TagShell({
    required this.background,
    required this.child,
    this.borderColor,
  });

  final Color background;
  final Color? borderColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 22,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(4),
        border: borderColor == null ? null : Border.all(color: borderColor!),
      ),
      alignment: Alignment.center,
      child: child,
    );
  }
}

class _CloseIconPainter extends CustomPainter {
  _CloseIconPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    canvas
      ..drawLine(Offset.zero, Offset(size.width, size.height), paint)
      ..drawLine(Offset(0, size.height), Offset(size.width, 0), paint);
  }

  @override
  bool shouldRepaint(covariant _CloseIconPainter old) => old.color != color;
}
