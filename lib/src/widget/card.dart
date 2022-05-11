import 'package:ant_design_flutter/src/enum/size.dart';
import 'package:ant_design_flutter/src/style/color.dart';
import 'package:flutter/widgets.dart';

class Card extends StatefulWidget {
  const Card({
    Key? key,
    required this.child,
    this.extra,
    this.hoverable = false,
    this.size = AntSize.medium,
    this.title,
  }) : super(key: key);

  final Widget child;
  final Widget? extra;
  final bool hoverable;
  final AntSize size;
  final Widget? title;

  @override
  State<Card> createState() => _CardState();
}

class _CardState extends State<Card> {
  bool hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      child: Container(
        child: Column(
          children: [
            widget.title != null || widget.extra != null
                ? Container(
                    child: Row(
                      children: [
                        Expanded(
                          child: DefaultTextStyle.merge(
                            child: Container(child: widget.title),
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        DefaultTextStyle.merge(
                          child: Container(child: widget.extra),
                          style: const TextStyle(
                            color: Colors.blue_6,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    ),
                    decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.gray_4)),
                    ),
                    padding:
                        EdgeInsets.all(AntSize.medium == widget.size ? 24 : 12),
                  )
                : const SizedBox(),
            Padding(
              child: widget.child,
              padding: EdgeInsets.all(AntSize.medium == widget.size ? 24 : 12),
            )
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.gray_4),
          borderRadius: BorderRadius.circular(2),
          boxShadow: hovered
              ? const [
                  BoxShadow(
                    blurRadius: 4,
                    color: Colors.gray_3,
                    offset: Offset(4, 4),
                    spreadRadius: 0.1,
                  ),
                  BoxShadow(
                    blurRadius: 4,
                    color: Colors.gray_3,
                    offset: Offset(-4, 0),
                    spreadRadius: 0.1,
                  ),
                ]
              : null,
          color: Colors.white,
        ),
      ),
      cursor: widget.hoverable
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      onEnter: (_) {
        setState(() {
          hovered = true;
        });
      },
      onExit: (_) {
        setState(() {
          hovered = false;
        });
      },
    );
  }
}
