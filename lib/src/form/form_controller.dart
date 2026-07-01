import 'package:flutter/foundation.dart';

/// 表单控制器。管理字段值、校验状态。
///
/// 使用方式：
/// ```dart
/// final controller = AntFormController();
///
/// controller.setFieldsValue({'username': 'alice'});
/// final errors = await controller.validateFields();
/// controller.submit();
/// ```
class AntFormController extends ChangeNotifier {
  final Map<String, _FieldState> _fields = {};
  final Map<String, String?> _errors = {};
  bool _submitting = false;

  /// 注册字段（由 AntFormItem 自动调用）。
  @visibleForTesting
  void registerField(String name, List<AntValidator> rules) {
    if (!_fields.containsKey(name)) {
      _fields[name] = _FieldState(rules: rules);
      _errors[name] = null;
    }
  }

  /// 注销字段。
  @visibleForTesting
  void unregisterField(String name) {
    _fields.remove(name);
    _errors.remove(name);
  }

  /// 获取指定字段的值。
  T? getFieldValue<T>(String name) {
    return _fields[name]?.value as T?;
  }

  /// 设置多个字段的值。
  void setFieldsValue(Map<String, dynamic> values) {
    for (final entry in values.entries) {
      _fields[entry.key]?.setValue(entry.value);
    }
    notifyListeners();
  }

  /// 设置单个字段的值。
  void setFieldValue(String name, dynamic value) {
    _fields[name]?.setValue(value);
    notifyListeners();
  }

  /// 获取指定字段的校验错误信息。
  String? getFieldError(String name) => _errors[name];

  /// 校验所有字段。返回字段名 → 错误信息的映射。
  Future<Map<String, String?>> validateFields() async {
    final errors = <String, String?>{};
    for (final entry in _fields.entries) {
      errors[entry.key] = await entry.value.validate();
    }
    _errors.addAll(errors);
    notifyListeners();
    return errors;
  }

  /// 校验指定字段。
  Future<String?> validateField(String name) async {
    final field = _fields[name];
    if (field == null) return null;
    final error = await field.validate();
    _errors[name] = error;
    notifyListeners();
    return error;
  }

  /// 重置所有（或指定）字段。
  void resetFields([List<String>? names]) {
    final targets = names ?? _fields.keys.toList();
    for (final name in targets) {
      _fields[name]?.reset();
      _errors[name] = null;
    }
    notifyListeners();
  }

  /// 提交表单。先校验，通过后调用 [onFinish]。
  Future<void> submit({
    required VoidCallback onFinish,
    required void Function(Map<String, String?> errors) onFinishFailed,
  }) async {
    if (_submitting) return;
    _submitting = true;
    try {
      final errors = await validateFields();
      final hasErrors = errors.values.any((e) => e != null);
      if (hasErrors) {
        onFinishFailed(errors);
      } else {
        onFinish();
      }
    } finally {
      _submitting = false;
    }
  }

  /// 获取所有字段的当前值。
  Map<String, dynamic> get values {
    final result = <String, dynamic>{};
    for (final entry in _fields.entries) {
      result[entry.key] = entry.value.value;
    }
    return result;
  }
}

/// 内部字段状态。
class _FieldState {
  _FieldState({required this.rules});

  final List<AntValidator> rules;
  dynamic _value;

  dynamic get value => _value;

  void setValue(dynamic v) => _value = v;

  Future<String?> validate() async {
    for (final rule in rules) {
      final err = await rule.validate(_value);
      if (err != null) return err;
    }
    return null;
  }

  void reset() {
    _value = null;
  }
}

/// 校验器抽象。
abstract class AntValidator {
  const AntValidator();

  /// 校验值。返回 null 表示通过，返回字符串表示错误信息。
  Future<String?> validate(dynamic value);
}

/// 内置校验器工厂。
abstract final class AntValidators {
  /// 必填校验。
  static AntValidator required(String message) =>
      _RequiredValidator(message);

  /// 最小长度校验。
  static AntValidator min(int minLength, String message) =>
      _MinLengthValidator(minLength, message);

  /// 最大长度校验。
  static AntValidator max(int maxLength, String message) =>
      _MaxLengthValidator(maxLength, message);

  /// 邮箱格式校验。
  static AntValidator email([String? message]) =>
      _EmailValidator(message ?? '请输入有效的邮箱地址');

  /// 正则校验。
  static AntValidator pattern(RegExp regex, String message) =>
      _PatternValidator(regex, message);

  /// 自定义校验函数。
  static AntValidator custom(
    Future<String?> Function(dynamic value) fn,
  ) => _CustomValidator(fn);
}

class _RequiredValidator extends AntValidator {
  const _RequiredValidator(this.message);
  final String message;

  @override
  Future<String?> validate(dynamic value) async {
    if (value == null) return message;
    if (value is String && value.trim().isEmpty) return message;
    if (value is Iterable && value.isEmpty) return message;
    return null;
  }
}

class _MinLengthValidator extends AntValidator {
  const _MinLengthValidator(this.minLength, this.message);
  final int minLength;
  final String message;

  @override
  Future<String?> validate(dynamic value) async {
    if (value == null) return null;
    if (value is String && value.length < minLength) return message;
    if (value is Iterable && value.length < minLength) return message;
    return null;
  }
}

class _MaxLengthValidator extends AntValidator {
  const _MaxLengthValidator(this.maxLength, this.message);
  final int maxLength;
  final String message;

  @override
  Future<String?> validate(dynamic value) async {
    if (value == null) return null;
    if (value is String && value.length > maxLength) return message;
    if (value is Iterable && value.length > maxLength) return message;
    return null;
  }
}

class _EmailValidator extends AntValidator {
  const _EmailValidator(this.message);
  final String message;

  static final _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  @override
  Future<String?> validate(dynamic value) async {
    if (value == null) return null;
    if (value is! String) return message;
    if (!_emailRegex.hasMatch(value.trim())) return message;
    return null;
  }
}

class _PatternValidator extends AntValidator {
  const _PatternValidator(this.regex, this.message);
  final RegExp regex;
  final String message;

  @override
  Future<String?> validate(dynamic value) async {
    if (value == null) return null;
    if (value is! String) return message;
    if (!regex.hasMatch(value)) return message;
    return null;
  }
}

class _CustomValidator extends AntValidator {
  const _CustomValidator(this.fn);
  final Future<String?> Function(dynamic value) fn;

  @override
  Future<String?> validate(dynamic value) => fn(value);
}
