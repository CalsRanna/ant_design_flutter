import 'package:flutter/widgets.dart';

/// 回到顶部。对齐 AntD v5 `BackTop`。
class AntBackTop extends StatelessWidget {
  const AntBackTop({super.key, this.onClick});
  final VoidCallback? onClick;

  @override
  Widget build(BuildContext context) => Positioned(
    right: 24, bottom: 48,
    child: GestureDetector(
      onTap: onClick,
      child: Container(
        width: 40, height: 40,
        decoration: BoxDecoration(color: const Color(0xFFFFFFFF), borderRadius: BorderRadius.circular(20),
          boxShadow: const [BoxShadow(color: Color(0x1A000000), blurRadius: 4, offset: Offset(0, 2))]),
        child: const Center(child: Text('↑', style: TextStyle(fontSize: 18))),
      ),
    ),
  );
}
