import 'package:ant_design_flutter/ant_design_flutter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AntFormController', () {
    test('registerField and getFieldValue', () {
      final ctrl = AntFormController();
      ctrl.registerField('name', []);
      ctrl.setFieldValue('name', 'Alice');
      expect(ctrl.getFieldValue<String>('name'), 'Alice');
    });

    test('setFieldsValue sets multiple fields', () {
      final ctrl = AntFormController();
      ctrl.registerField('a', []);
      ctrl.registerField('b', []);
      ctrl.setFieldsValue({'a': 1, 'b': 2});
      expect(ctrl.getFieldValue<int>('a'), 1);
      expect(ctrl.getFieldValue<int>('b'), 2);
    });

    test('validateFields returns no errors for valid fields', () async {
      final ctrl = AntFormController();
      ctrl.registerField('email', [AntValidators.email()]);
      ctrl.setFieldValue('email', 'test@example.com');
      final errors = await ctrl.validateFields();
      expect(errors['email'], isNull);
    });

    test('validateFields returns error for invalid email', () async {
      final ctrl = AntFormController();
      ctrl.registerField('email', [AntValidators.email('bad email')]);
      ctrl.setFieldValue('email', 'not-an-email');
      final errors = await ctrl.validateFields();
      expect(errors['email'], 'bad email');
    });

    test('required validator catches null', () async {
      final v = AntValidators.required('required');
      expect(await v.validate(null), 'required');
      expect(await v.validate('hello'), isNull);
      expect(await v.validate(''), 'required');
    });

    test('min validator checks length', () async {
      final v = AntValidators.min(3, 'too short');
      expect(await v.validate('ab'), 'too short');
      expect(await v.validate('abc'), isNull);
    });

    test('max validator checks length', () async {
      final v = AntValidators.max(5, 'too long');
      expect(await v.validate('abcdef'), 'too long');
      expect(await v.validate('abcde'), isNull);
    });

    test('pattern validator', () async {
      final v = AntValidators.pattern(RegExp(r'^\d+$'), 'digits only');
      expect(await v.validate('123'), isNull);
      expect(await v.validate('abc'), 'digits only');
    });

    test('resetFields clears values and errors', () async {
      final ctrl = AntFormController();
      ctrl.registerField('name', [AntValidators.required('req')]);
      ctrl.setFieldValue('name', '');
      await ctrl.validateFields();
      expect(ctrl.getFieldError('name'), isNotNull);

      ctrl.resetFields();
      expect(ctrl.getFieldValue<String>('name'), isNull);
      expect(ctrl.getFieldError('name'), isNull);
    });

    test('submit calls onFinish on valid', () async {
      final ctrl = AntFormController();
      ctrl.registerField('name', []);
      ctrl.setFieldValue('name', 'Alice');

      var finished = false;
      var failed = false;
      await ctrl.submit(
        onFinish: () => finished = true,
        onFinishFailed: (_) => failed = true,
      );

      expect(finished, isTrue);
      expect(failed, isFalse);
    });

    test('submit calls onFinishFailed on invalid', () async {
      final ctrl = AntFormController();
      ctrl.registerField('name', [AntValidators.required('req')]);

      Map<String, String?>? capturedErrors;
      var finished = false;
      await ctrl.submit(
        onFinish: () => finished = true,
        onFinishFailed: (errors) => capturedErrors = errors,
      );

      expect(finished, isFalse);
      expect(capturedErrors, isNotNull);
      expect(capturedErrors!['name'], 'req');
    });

    test('values returns all field values', () {
      final ctrl = AntFormController();
      ctrl.registerField('a', []);
      ctrl.registerField('b', []);
      ctrl.setFieldsValue({'a': 'x', 'b': 42});
      expect(ctrl.values, {'a': 'x', 'b': 42});
    });
  });
}
