import 'package:ant_design_flutter/ant_design_flutter.dart';
import 'package:flutter/widgets.dart';

void main() => runApp(const _Demo());

class _Demo extends StatelessWidget {
  const _Demo();

  @override
  Widget build(BuildContext context) {
    return const AntApp(home: _RegisterForm());
  }
}

class _RegisterForm extends StatefulWidget {
  const _RegisterForm();

  @override
  State<_RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<_RegisterForm> {
  String _username = '';
  String _password = '';
  List<String> _interests = [];
  String? _gender;
  bool _subscribe = false;
  bool _submitted = false;

  @override
  Widget build(BuildContext context) {
    final alias = AntTheme.aliasOf(context);
    return ColoredBox(
      color: alias.colorBackgroundLayout,
      child: Center(
        child: SizedBox(
          width: 420,
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const AntTitle('Create account', level: AntTitleLevel.h3),
                const SizedBox(height: 16),
                AntInput(
                  placeholder: 'Username',
                  value: _username,
                  onChanged: (v) => setState(() => _username = v),
                ),
                const SizedBox(height: 12),
                AntInput(
                  placeholder: 'Password',
                  value: _password,
                  onChanged: (v) => setState(() => _password = v),
                ),
                const SizedBox(height: 16),
                const AntText('Interests', type: AntTextType.secondary),
                const SizedBox(height: 8),
                AntCheckboxGroup<String>(
                  options: const [
                    AntOption(value: 'read', label: 'Reading'),
                    AntOption(value: 'write', label: 'Writing'),
                    AntOption(value: 'gym', label: 'Gym'),
                  ],
                  value: _interests,
                  onChanged: (v) => setState(() => _interests = v),
                ),
                const SizedBox(height: 16),
                const AntText('Gender', type: AntTextType.secondary),
                const SizedBox(height: 8),
                AntRadioGroup<String>(
                  options: const [
                    AntOption(value: 'm', label: 'Male'),
                    AntOption(value: 'f', label: 'Female'),
                    AntOption(value: 'o', label: 'Other'),
                  ],
                  value: _gender,
                  onChanged: (v) => setState(() => _gender = v),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    AntSwitch(
                      checked: _subscribe,
                      onChanged: (v) => setState(() => _subscribe = v),
                    ),
                    const SizedBox(width: 8),
                    const AntText('Subscribe to newsletter'),
                  ],
                ),
                const SizedBox(height: 16),
                if (_submitted)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: AntTag(
                      color: alias.colorSuccess,
                      child: const Text('Submitted'),
                    ),
                  ),
                AntButton(
                  type: AntButtonType.primary,
                  block: true,
                  onPressed: () => setState(() => _submitted = true),
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
