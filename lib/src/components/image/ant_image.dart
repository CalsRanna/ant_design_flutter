import 'package:flutter/widgets.dart';

/// 图片（简版）。对齐 AntD v5 `Image`。
/// MVP 仅提供基础图片显示，不实现预览功能。
class AntImage extends StatelessWidget {
  const AntImage({required this.src, super.key, this.width, this.height, this.fit = BoxFit.cover});
  final String src; final double? width; final double? height; final BoxFit fit;

  @override
  Widget build(BuildContext context) => Image.network(src, width: width, height: height, fit: fit);
}
