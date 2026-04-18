import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter/painting.dart' show Alignment;

/// Portal 12 方位。语义对齐 AntD v5 `Tooltip.placement`。详见 Phase 2 spec § 4.3。
enum AntPlacement {
  topLeft, top, topRight,
  rightTop, right, rightBottom,
  bottomRight, bottom, bottomLeft,
  leftBottom, left, leftTop,
}

/// (targetAnchor, followerAnchor) 对。用于 `CompositedTransformFollower`。
@immutable
class AntPlacementAnchors {
  const AntPlacementAnchors(this.target, this.follower);
  final Alignment target;
  final Alignment follower;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AntPlacementAnchors &&
          other.target == target &&
          other.follower == follower;

  @override
  int get hashCode => Object.hash(target, follower);

  @override
  String toString() => 'AntPlacementAnchors($target → $follower)';
}

/// spec § 4.3 映射表。
const Map<AntPlacement, AntPlacementAnchors> antPlacementAnchors =
    <AntPlacement, AntPlacementAnchors>{
  AntPlacement.top:
      AntPlacementAnchors(Alignment.topCenter, Alignment.bottomCenter),
  AntPlacement.topLeft:
      AntPlacementAnchors(Alignment.topLeft, Alignment.bottomLeft),
  AntPlacement.topRight:
      AntPlacementAnchors(Alignment.topRight, Alignment.bottomRight),
  AntPlacement.bottom:
      AntPlacementAnchors(Alignment.bottomCenter, Alignment.topCenter),
  AntPlacement.bottomLeft:
      AntPlacementAnchors(Alignment.bottomLeft, Alignment.topLeft),
  AntPlacement.bottomRight:
      AntPlacementAnchors(Alignment.bottomRight, Alignment.topRight),
  AntPlacement.left:
      AntPlacementAnchors(Alignment.centerLeft, Alignment.centerRight),
  AntPlacement.leftTop:
      AntPlacementAnchors(Alignment.topLeft, Alignment.topRight),
  AntPlacement.leftBottom:
      AntPlacementAnchors(Alignment.bottomLeft, Alignment.bottomRight),
  AntPlacement.right:
      AntPlacementAnchors(Alignment.centerRight, Alignment.centerLeft),
  AntPlacement.rightTop:
      AntPlacementAnchors(Alignment.topRight, Alignment.topLeft),
  AntPlacement.rightBottom:
      AntPlacementAnchors(Alignment.bottomRight, Alignment.bottomLeft),
};

/// 按主轴翻转 placement。`vertical: true` 翻 top↔bottom；否则翻 left↔right。
/// 副轴保持不变。详见 Phase 2 spec § 4.3 flip 映射。
AntPlacement flipAntPlacement(AntPlacement p, {required bool vertical}) {
  if (vertical) {
    switch (p) {
      case AntPlacement.top: return AntPlacement.bottom;
      case AntPlacement.topLeft: return AntPlacement.bottomLeft;
      case AntPlacement.topRight: return AntPlacement.bottomRight;
      case AntPlacement.bottom: return AntPlacement.top;
      case AntPlacement.bottomLeft: return AntPlacement.topLeft;
      case AntPlacement.bottomRight: return AntPlacement.topRight;
      case AntPlacement.left:
      case AntPlacement.leftTop:
      case AntPlacement.leftBottom:
      case AntPlacement.right:
      case AntPlacement.rightTop:
      case AntPlacement.rightBottom:
        return p;
    }
  }
  switch (p) {
    case AntPlacement.left: return AntPlacement.right;
    case AntPlacement.leftTop: return AntPlacement.rightTop;
    case AntPlacement.leftBottom: return AntPlacement.rightBottom;
    case AntPlacement.right: return AntPlacement.left;
    case AntPlacement.rightTop: return AntPlacement.leftTop;
    case AntPlacement.rightBottom: return AntPlacement.leftBottom;
    case AntPlacement.top:
    case AntPlacement.topLeft:
    case AntPlacement.topRight:
    case AntPlacement.bottom:
    case AntPlacement.bottomLeft:
    case AntPlacement.bottomRight:
      return p;
  }
}
