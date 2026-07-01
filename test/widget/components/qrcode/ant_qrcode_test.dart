import 'dart:ui' show Color;
import 'package:ant_design_flutter/ant_design_flutter.dart';
import 'package:ant_design_flutter/src/components/qrcode/qr_encoder.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AntQRCode', () {
    testWidgets('renders QR code for short text', (tester) async {
      await tester.pumpWidget(const AntApp(home: AntQRCode(data: 'HELLO')));
    });

    testWidgets('renders with custom color', (tester) async {
      await tester.pumpWidget(const AntApp(home: AntQRCode(data: 'TEST', color: Color(0xFF00FF00))));
    });

    testWidgets('renders with error correction M', (tester) async {
      await tester.pumpWidget(const AntApp(home: AntQRCode(data: 'HELLO', errorCorrection: QrEcc.m)));
    });

    testWidgets('renders URL', (tester) async {
      await tester.pumpWidget(const AntApp(home: AntQRCode(data: 'https://github.com/CalsRanna/ant_design_flutter')));
    });
  });
}
