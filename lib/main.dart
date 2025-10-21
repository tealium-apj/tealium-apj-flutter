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
    // Enable consent logging and set the consent policy (GDPR/CCPA)
    consentLoggingEnabled: true,
    consentPolicy: ConsentPolicy.GDPR,
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

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _traceController = TextEditingController();

  @override
  void dispose() {
    _traceController.dispose();
    super.dispose();
  }

  void _sendEvent() {
    Tealium.track(TealiumEvent("button_click", {
      "button_name": "signup",
      "screen": "home_page",
    }));
  }

  void _setConsentConsented() {
    Tealium.setConsentStatus(ConsentStatus.consented);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Consent set to: consented')),
    );
  }

  void _setConsentNotConsented() {
    Tealium.setConsentStatus(ConsentStatus.notConsented);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Consent set to: notConsented')),
    );
  }

  void _joinTrace() {
    final id = _traceController.text.trim();
    if (id.isNotEmpty) {
      Tealium.joinTrace(id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Joined trace: $id')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a trace id')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tealium Example")),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: _sendEvent,
              child: const Text("Send Event"),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _setConsentConsented,
              child: const Text("Set Consent: Consented"),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _setConsentNotConsented,
              child: const Text("Set Consent: Not Consented"),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: TextField(
                controller: _traceController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Trace ID',
                  hintText: 'Enter server-side trace id',
                ),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _joinTrace,
              child: const Text('Join Trace'),
            ),
          ],
        ),
      ),
    );
  }
}
