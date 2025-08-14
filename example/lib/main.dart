import 'package:flutter/material.dart';
import 'package:openkit_dart/openkit_dart.dart' as openkit;

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OpenKit-Dart Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'OpenKit-Dart Example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  openkit.OpenKit? _openKit;
  openkit.Session? _session;
  openkit.Action? _currentAction;
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    _initializeOpenKit();
  }

  Future<void> _initializeOpenKit() async {
    try {
      _openKit = openkit.OpenKitBuilder(
        'https://your-dynatrace-environment.com/mbeacon',
        'example-app',
        12345,
      )
          .withOperatingSystem('Flutter')
          .withApplicationVersion('1.0.0')
          .withLogLevel(openkit.LogLevel.info)
          .withDataCollectionLevel(openkit.DataCollectionLevel.userBehavior)
          .withCrashReportingLevel(openkit.CrashReportingLevel.optInCrashes)
          .build();

      _session = _openKit!.createSession('127.0.0.1');

      // Start main action
      _currentAction = _session!.enterAction('App Session');
      _currentAction!.reportEvent('App Started');

      setState(() {});
    } catch (e) {
      debugPrint('Failed to initialize OpenKit: $e');
    }
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });

    // Report the counter increment
    _currentAction?.reportValueInt('counter', _counter);
    _currentAction?.reportEvent('Counter Incremented');
  }

  void _startNewAction() {
    _currentAction?.end();
    _currentAction = _session?.enterAction('User Interaction');
    _currentAction?.reportEvent('New Action Started');
  }

  void _reportError() {
    _currentAction?.reportError('Test Error', 500, 'This is a test error');
  }

  @override
  void dispose() {
    _currentAction?.end();
    _session?.end();
    _openKit?.shutdown();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'OpenKit-Dart Example',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              'OpenKit Status: ${_openKit != null ? "Initialized" : "Not Initialized"}',
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              'Session Status: ${_session != null ? "Active" : "Not Active"}',
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              'Current Action: ${_currentAction?.actionId ?? "None"}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _startNewAction,
                  child: const Text('Start New Action'),
                ),
                ElevatedButton(
                  onPressed: _reportError,
                  child: const Text('Report Error'),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
