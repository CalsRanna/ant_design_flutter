import 'package:ant_design_flutter/src/components/qrcode/qr_encoder.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('QrEncoder', () {
    test('encodes a short string', () {
      final matrix = QrEncoder.encode('HELLO');
      expect(matrix.length, 21); // Version 1 = 21x21
      expect(matrix.every((row) => row.length == 21), isTrue);
    });

    test('encodes longer string', () {
      final matrix = QrEncoder.encode('Hello, QR Code!');
      expect(matrix.length, 21);
    });

    test('version 2+ for larger data', () {
      final data = 'A' * 20;
      final matrix = QrEncoder.encode(data);
      expect(matrix.length, 25); // Version 2 (25x25) for 20 bytes
    });

    test('encodes with error correction level M', () {
      final matrix = QrEncoder.encode('TEST', ecc: QrEcc.m);
      expect(matrix.length, 21);
    });

    test('matrix has finder patterns (3 corners with 7x7 blocks)', () {
      final matrix = QrEncoder.encode('HELLO');
      final size = matrix.length;
      // Top-left finder pattern: 7x7 black bordered
      expect(matrix[0][0], isTrue);
      expect(matrix[0][6], isTrue);
      expect(matrix[6][0], isTrue);
      expect(matrix[6][6], isTrue);
      // Center of finder should be black
      expect(matrix[2][2], isTrue);
      expect(matrix[3][3], isTrue);
      expect(matrix[4][4], isTrue);
    });

    test('has timing patterns', () {
      final matrix = QrEncoder.encode('HELLO');
      // Row 6 should have alternating pattern
      var foundTiming = false;
      for (var c = 8; c < matrix.length - 8; c++) {
        if (matrix[6][c] != matrix[6][c - 1]) {
          foundTiming = true;
          break;
        }
      }
      expect(foundTiming, isTrue);
    });

    test('throws on too much data', () {
      final longData = 'X' * 200;
      expect(
        () => QrEncoder.encode(longData),
        throwsArgumentError,
      );
    });

    test('renders valid QR code with non-alphanumeric data', () {
      final matrix = QrEncoder.encode('https://example.com/path?q=1');
      expect(matrix.length, 25); // Version 2 for longer data
    });
  });
}
