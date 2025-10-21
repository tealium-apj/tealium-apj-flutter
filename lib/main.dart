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
    [Dispatchers.RemoteCommands, Dispatchers.TagManagement],
    // enable QR trace handling so the SDK will honor trace ids from server-side
    // interfaces. Set to `false` if you don't want QR/deep-link trace joining.
    qrTraceEnabled: true,
  );

  await Tealium.initialize(config);

  // If you have a server-side trace id for debugging, join it here so that
  // subsequent events include the traceId in the data layer. Replace the
  // placeholder below with the real trace id from your server.
  const serverTraceId = 'mqWLYfmz';
  if (serverTraceId.isNotEmpty && serverTraceId != '') {
    Tealium.joinTrace(serverTraceId);
  }

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
