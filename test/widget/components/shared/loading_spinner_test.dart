import 'package:ant_design_flutter/src/components/_shared/loading_spinner.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LoadingSpinner', () {
    testWidgets('renders at given size and drives animation', (tester) async {
      await tester.pumpWidget(
        const Directionality(
          textDirection: TextDirection.ltr,
          child: Center(
            child: LoadingSpinner(color: Color(0xFFFFFFFF), size: 16),
          ),
        ),
      );

      // 初始帧渲染 16×16 的方框（SizedBox）。
      final sized = tester.widget<SizedBox>(
        find.byType(SizedBox).first,
      );
      expect(sized.width, 16);
      expect(sized.height, 16);

      // 推进 250ms，AnimationController 应仍在 ticking（widget 还存在）。
      await tester.pump(const Duration(milliseconds: 250));
      expect(find.byType(LoadingSpinner), findsOneWidget);
    });
  });
}
