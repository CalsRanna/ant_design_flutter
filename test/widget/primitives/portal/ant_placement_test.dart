import 'package:ant_design_flutter/ant_design_flutter.dart';
import 'package:ant_design_flutter/src/primitives/portal/ant_placement.dart'
    show AntPlacementAnchors, antPlacementAnchors, flipAntPlacement;
import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AntPlacement anchor table', () {
    // 语义对齐 Phase 2 spec § 4.3
    const expected = <AntPlacement, AntPlacementAnchors>{
      AntPlacement.top: AntPlacementAnchors(
        Alignment.topCenter,
        Alignment.bottomCenter,
      ),
      AntPlacement.topLeft: AntPlacementAnchors(
        Alignment.topLeft,
        Alignment.bottomLeft,
      ),
      AntPlacement.topRight: AntPlacementAnchors(
        Alignment.topRight,
        Alignment.bottomRight,
      ),
      AntPlacement.bottom: AntPlacementAnchors(
        Alignment.bottomCenter,
        Alignment.topCenter,
      ),
      AntPlacement.bottomLeft: AntPlacementAnchors(
        Alignment.bottomLeft,
        Alignment.topLeft,
      ),
      AntPlacement.bottomRight: AntPlacementAnchors(
        Alignment.bottomRight,
        Alignment.topRight,
      ),
      AntPlacement.left: AntPlacementAnchors(
        Alignment.centerLeft,
        Alignment.centerRight,
      ),
      AntPlacement.leftTop: AntPlacementAnchors(
        Alignment.topLeft,
        Alignment.topRight,
      ),
      AntPlacement.leftBottom: AntPlacementAnchors(
        Alignment.bottomLeft,
        Alignment.bottomRight,
      ),
      AntPlacement.right: AntPlacementAnchors(
        Alignment.centerRight,
        Alignment.centerLeft,
      ),
      AntPlacement.rightTop: AntPlacementAnchors(
        Alignment.topRight,
        Alignment.topLeft,
      ),
      AntPlacement.rightBottom: AntPlacementAnchors(
        Alignment.bottomRight,
        Alignment.bottomLeft,
      ),
    };

    for (final entry in expected.entries) {
      test('${entry.key} maps to ${entry.value}', () {
        expect(antPlacementAnchors[entry.key], entry.value);
      });
    }

    test('anchor table covers all 12 placements', () {
      expect(antPlacementAnchors.length, 12);
      for (final p in AntPlacement.values) {
        expect(
          antPlacementAnchors.containsKey(p),
          isTrue,
          reason: '$p missing',
        );
      }
    });
  });

  group('flipAntPlacement', () {
    const topAxis = <AntPlacement, AntPlacement>{
      AntPlacement.top: AntPlacement.bottom,
      AntPlacement.topLeft: AntPlacement.bottomLeft,
      AntPlacement.topRight: AntPlacement.bottomRight,
      AntPlacement.bottom: AntPlacement.top,
      AntPlacement.bottomLeft: AntPlacement.topLeft,
      AntPlacement.bottomRight: AntPlacement.topRight,
    };
    const horizontalAxis = <AntPlacement, AntPlacement>{
      AntPlacement.left: AntPlacement.right,
      AntPlacement.leftTop: AntPlacement.rightTop,
      AntPlacement.leftBottom: AntPlacement.rightBottom,
      AntPlacement.right: AntPlacement.left,
      AntPlacement.rightTop: AntPlacement.leftTop,
      AntPlacement.rightBottom: AntPlacement.leftBottom,
    };

    for (final entry in topAxis.entries) {
      test('${entry.key} flips vertically to ${entry.value}', () {
        expect(flipAntPlacement(entry.key, vertical: true), entry.value);
      });
    }
    for (final entry in horizontalAxis.entries) {
      test('${entry.key} flips horizontally to ${entry.value}', () {
        expect(flipAntPlacement(entry.key, vertical: false), entry.value);
      });
    }
  });
}
