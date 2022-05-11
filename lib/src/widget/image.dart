import 'package:flutter/widgets.dart' as material;

class Image extends material.StatefulWidget {
  const Image({
    material.Key? key,
    this.alt,
    this.fallback,
    this.height,
    this.onError,
    this.placeholder,
    this.preview = false,
    required this.src,
    this.width,
  }) : super(key: key);

  final String? alt;
  final String? fallback;
  final double? height;
  final void Function()? onError;
  final material.Widget? placeholder;
  final bool preview;
  final String src;
  final double? width;

  @override
  material.State<Image> createState() => _ImageState();
}

class _ImageState extends material.State<Image> {
  @override
  material.Widget build(material.BuildContext context) {
    return material.Image(
      height: widget.height,
      image: widget.src.contains('http')
          ? material.NetworkImage(widget.src)
          : material.AssetImage(widget.src) as material.ImageProvider,
      semanticLabel: widget.alt,
      width: widget.width,
    );
  }
}
