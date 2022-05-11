import 'package:ant_design_flutter/antdf.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return AntApp(
      home: AntScaffold(
        body: Center(
          child: Column(
            children: [
              Text('You have clicked the button $count times'),
              const SizedBox(height: 8),
              Button(
                child: const Text('Click'),
                type: ButtonType.primary,
                onClick: () => setState(() => count++),
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
        ),
      ),
    );
  }
}
