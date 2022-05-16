import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

class NestedGestureDetector extends StatelessWidget {
  const NestedGestureDetector({Key? key, required this.child, this.onTap})
      : super(key: key);

  final Widget child;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return RawGestureDetector(
      behavior: HitTestBehavior.opaque,
      gestures: {
        _AllowNestedGestureRecognizer:
            GestureRecognizerFactoryWithHandlers<_AllowNestedGestureRecognizer>(
                () => _AllowNestedGestureRecognizer(),
                (_AllowNestedGestureRecognizer recognizer) {
          recognizer.onTap = onTap;
        })
      },
      child: child,
    );
  }
}

class _AllowNestedGestureRecognizer extends TapGestureRecognizer {
  @override
  void rejectGesture(int pointer) {
    acceptGesture(pointer);
  }
}
