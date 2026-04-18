// Importing the library is itself the smoke test — verifies it compiles.
// ignore: unused_import
import 'package:ant_design_flutter/ant_design_flutter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('library loads without error', () {
    // 2.0 scaffold smoke test - 只要 import 成功且文件编译过即视为通过。
    // Phase 1 起每个组件自带 widget test，届时替换此烟雾测试。
    expect(true, isTrue);
  });
}
