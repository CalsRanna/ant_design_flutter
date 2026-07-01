import 'package:ant_design_flutter/src/app/ant_config_provider.dart';
import 'package:ant_design_flutter/src/primitives/interaction/ant_interaction_detector.dart';
import 'package:ant_design_flutter/src/primitives/portal/ant_placement.dart';
import 'package:ant_design_flutter/src/primitives/portal/ant_portal.dart';
import 'package:flutter/widgets.dart';

/// Ant Design 风格的 Tooltip。
///
/// 当用户 hover 子 widget 时，在指定方位弹出提示文字。
///
/// 对齐 AntD v5 `Tooltip` 组件。MVP 实现：
/// - `title`：提示文字（必填）
/// - `placement`：12 方位定位
/// - `color`：自定义背景色（默认 rgba(0,0,0,0.75)）
/// - `mouseEnterDelay` / `mouseLeaveDelay`：延迟显隐（毫秒）
///
/// 推迟到 2.1：`arrow` 箭头、`overlayInnerStyle`、`trigger` 扩展、
/// `getPopupContainer`、`zIndex`。
class AntTooltip extends StatefulWidget {
  const AntTooltip({
    required this.title,
    required this.child,
    super.key,
    this.placement = AntPlacement.top,
    this.color,
    this.mouseEnterDelay = 100,
    this.mouseLeaveDelay = 100,
  });

  /// 提示文字内容。
  final String title;

  /// 触发提示的子 widget。
  final Widget child;

  /// 弹出方位，默认 top。
  final AntPlacement placement;

  /// 自定义背景色。null 时使用默认深色（`Color(0xBF000000)` / rgba(0,0,0,0.75)）。
  final Color? color;

  /// 鼠标进入后显示的延迟（毫秒）。
  final int mouseEnterDelay;

  /// 鼠标离开后隐藏的延迟（毫秒）。
  final int mouseLeaveDelay;

  @override
  State<AntTooltip> createState() => _AntTooltipState();
}

class _AntTooltipState extends State<AntTooltip> {
  bool _visible = false;

  void _show() {
    if (!mounted) return;
    setState(() => _visible = true);
  }

  void _hide() {
    if (!mounted) return;
    setState(() => _visible = false);
  }

  @override
  Widget build(BuildContext context) {
    final alias = AntTheme.aliasOf(context);
    final bgColor = widget.color ?? const Color(0xBF000000);

    return AntPortal(
      placement: widget.placement,
      visible: _visible,
      child: AntInteractionDetector(
        onHover: (hovering) {
          if (hovering) {
            Future.delayed(Duration(milliseconds: widget.mouseEnterDelay), () {
              if (mounted) _show();
            });
          } else {
            Future.delayed(Duration(milliseconds: widget.mouseLeaveDelay), () {
              if (mounted) _hide();
            });
          }
        },
        builder: (context, states) => widget.child,
      ),
      overlayBuilder: (context) => _TooltipOverlay(
        title: widget.title,
        color: bgColor,
        borderRadius: alias.borderRadius,
        fontSize: alias.fontSize,
      ),
    );
  }
}

class _TooltipOverlay extends StatelessWidget {
  const _TooltipOverlay({
    required this.title,
    required this.color,
    required this.borderRadius,
    required this.fontSize,
  });

  final String title;
  final Color color;
  final double borderRadius;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: 32,
        maxWidth: 240,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Text(
          title,
          style: const TextStyle(
            color: Color(0xFFFFFFFF),
            fontSize: 14,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
