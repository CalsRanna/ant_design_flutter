import 'package:ant_design_flutter/antdf.dart';

class AntImage extends StatefulWidget {
  const AntImage({
    Key? key,
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
  final Widget? placeholder;
  final bool preview;
  final String src;
  final double? width;

  @override
  State<AntImage> createState() => _AntImageState();
}

class _AntImageState extends State<AntImage> {
  @override
  Widget build(BuildContext context) {
    return Image(
      height: widget.height,
      image: widget.src.contains('http')
          ? NetworkImage(widget.src)
          : AssetImage(widget.src) as ImageProvider,
      semanticLabel: widget.alt,
      width: widget.width,
    );
  }
}
