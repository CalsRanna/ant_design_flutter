import 'dart:ui';

import 'package:ant_design_flutter/src/foundation/color/generate.dart';
import 'package:flutter_test/flutter_test.dart';

/// 断言色板每阶 RGB 与 expected 的 24-bit RGB 值差 ≤ 1。
void _expectPaletteMatches(List<Color> actual, List<int> expected) {
  expect(actual, hasLength(10));
  for (var i = 0; i < 10; i++) {
    final actualRgb = actual[i].toARGB32() & 0xFFFFFF;
    final expectedRgb = expected[i] & 0xFFFFFF;
    final actualR = (actualRgb >> 16) & 0xFF;
    final actualG = (actualRgb >> 8) & 0xFF;
    final actualB = actualRgb & 0xFF;
    final expectedR = (expectedRgb >> 16) & 0xFF;
    final expectedG = (expectedRgb >> 8) & 0xFF;
    final expectedB = expectedRgb & 0xFF;
    expect(
      (actualR - expectedR).abs(),
      lessThanOrEqualTo(1),
      reason: 'index $i red',
    );
    expect(
      (actualG - expectedG).abs(),
      lessThanOrEqualTo(1),
      reason: 'index $i green',
    );
    expect(
      (actualB - expectedB).abs(),
      lessThanOrEqualTo(1),
      reason: 'index $i blue',
    );
  }
}

void main() {
  group('generatePalette', () {
    test('seed #1677FF (blue) matches @ant-design/colors', () {
      const golden = <int>[
        0xE6F4FF,
        0xBAE0FF,
        0x91CAFF,
        0x69B1FF,
        0x4096FF,
        0x1677FF,
        0x0958D9,
        0x003EB3,
        0x002C8C,
        0x001D66,
      ];
      _expectPaletteMatches(
        generatePalette(const Color(0xFF1677FF)),
        golden,
      );
    });

    test('seed #52C41A (green) matches @ant-design/colors', () {
      const golden = <int>[
        0xF6FFED,
        0xD9F7BE,
        0xB7EB8F,
        0x95DE64,
        0x73D13D,
        0x52C41A,
        0x389E0D,
        0x237804,
        0x135200,
        0x092B00,
      ];
      _expectPaletteMatches(
        generatePalette(const Color(0xFF52C41A)),
        golden,
      );
    });

    test('seed #FAAD14 (gold) matches @ant-design/colors', () {
      const golden = <int>[
        0xFFFBE6,
        0xFFF1B8,
        0xFFE58F,
        0xFFD666,
        0xFFC53D,
        0xFAAD14,
        0xD48806,
        0xAD6800,
        0x874D00,
        0x613400,
      ];
      _expectPaletteMatches(
        generatePalette(const Color(0xFFFAAD14)),
        golden,
      );
    });

    test('index 5 always equals seed', () {
      const seeds = <int>[0xFF1677FF, 0xFF52C41A, 0xFFFAAD14];
      for (final seedInt in seeds) {
        final seed = Color(seedInt);
        final palette = generatePalette(seed);
        expect(
          palette[5].toARGB32(),
          seed.toARGB32(),
          reason: 'seed ${seedInt.toRadixString(16)}',
        );
      }
    });
  });
}
