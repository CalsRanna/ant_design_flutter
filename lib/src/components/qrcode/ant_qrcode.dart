import 'package:ant_design_flutter/src/components/qrcode/qr_encoder.dart';
import 'package:flutter/widgets.dart';

/// QR Code 组件。纯 Dart 实现，零第三方依赖。
///
/// 支持 Byte 模式编码、Version 1-4、纠错级别 L/M。
class AntQRCode extends StatelessWidget {
  const AntQRCode({
    required this.data,
    super.key,
    this.size = 128,
    this.color = const Color(0xFF000000),
    this.backgroundColor = const Color(0xFFFFFFFF),
    this.errorCorrection = QrEcc.l,
  });

  /// 要编码的数据。
  final String data;

  /// 二维码尺寸（像素）。
  final double size;

  /// 前景色（深色模块）。
  final Color color;

  /// 背景色。
  final Color backgroundColor;

  /// 纠错级别。
  final QrEcc errorCorrection;

  @override
  Widget build(BuildContext context) {
    try {
      final matrix = QrEncoder.encode(data, ecc: errorCorrection);
      final moduleCount = matrix.length;
      final moduleSize = size / moduleCount;

      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: backgroundColor),
        child: ClipRRect(
          child: CustomPaint(
            size: Size(size, size),
            painter: _QRPainter(
              matrix: matrix,
              moduleSize: moduleSize,
              color: color,
            ),
          ),
        ),
      );
    } catch (e) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(color: const Color(0xFFFF0000)),
        ),
        child: Center(
          child: Text(
            'QR Error: $e',
            style: const TextStyle(color: Color(0xFFFF0000), fontSize: 10),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
  }
}

class _QRPainter extends CustomPainter {
  _QRPainter({
    required this.matrix,
    required this.moduleSize,
    required this.color,
  });

  final List<List<bool>> matrix;
  final double moduleSize;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    for (var r = 0; r < matrix.length; r++) {
      for (var c = 0; c < matrix[r].length; c++) {
        if (matrix[r][c]) {
          canvas.drawRect(
            Rect.fromLTWH(c * moduleSize, r * moduleSize, moduleSize, moduleSize),
            paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _QRPainter old) {
    return old.matrix != matrix || old.moduleSize != moduleSize || old.color != color;
  }
}
