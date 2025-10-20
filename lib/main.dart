import 'package:flutter/material.dart';
import 'package:tealium/common.dart';
import 'package:tealium/tealium.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final config = TealiumConfig(
    "success-ryunosuke-senda",
    "mobile-test",
    TealiumEnvironment.dev, // or TealiumEnvironment.qa, TealiumEnvironment.prod
    [Collectors.AppData, Collectors.Lifecycle],
    [Dispatchers.RemoteCommands, Dispatchers.Collect],
  );

  await Tealium.initialize(config);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _sendEvent() {
    Tealium.track(TealiumEvent("button_click", {
      "button_name": "signup",
      "screen": "home_page",
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tealium Example")),
      body: Center(
        child: ElevatedButton(
          onPressed: _sendEvent,
          child: const Text("Send Event"),
        ),
      ),
    );
  }
}
