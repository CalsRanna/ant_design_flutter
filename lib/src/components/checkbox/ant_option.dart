import 'package:flutter/foundation.dart';

/// Group 系列组件（`AntCheckboxGroup` / `AntRadioGroup`）的选项数据类。
///
/// `radio_group.dart` 显式 import 本文件复用（spec §2 例外条款）。
@immutable
class AntOption<T> {
  const AntOption({
    required this.value,
    required this.label,
    this.disabled = false,
  });

  final T value;
  final String label;
  final bool disabled;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AntOption<T> &&
        other.value == value &&
        other.label == label &&
        other.disabled == disabled;
  }

  @override
  int get hashCode => Object.hash(value, label, disabled);
}
