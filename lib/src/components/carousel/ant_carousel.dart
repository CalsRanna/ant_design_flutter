import 'package:flutter/widgets.dart';

/// 走马灯/轮播。对齐 AntD v5 `Carousel`。
class AntCarousel extends StatefulWidget {
  const AntCarousel({required this.children, super.key, this.autoplay = false, this.interval = 3});
  final List<Widget> children; final bool autoplay; final int interval;
  @override
  State<AntCarousel> createState() => _AntCarouselState();
}

class _AntCarouselState extends State<AntCarousel> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      SizedBox(height: 200, child: widget.children[_current % widget.children.length]),
      const SizedBox(height: 8),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        for (var i = 0; i < widget.children.length; i++)
          GestureDetector(
            onTap: () => setState(() => _current = i),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              width: i == _current ? 16 : 8, height: 8,
              decoration: BoxDecoration(
                color: i == _current ? const Color(0xFF1677FF) : const Color(0xFFD9D9D9),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
      ]),
    ]);
  }
}
