import 'dart:io';

void main() {
  print('OpenKit-Dart Project Validation');
  print('===============================');
  
  // Check project structure
  print('\n1. Project Structure:');
  _checkDirectory('lib');
  _checkDirectory('lib/src');
  _checkDirectory('lib/src/api');
  _checkDirectory('lib/src/core');
  _checkDirectory('test');
  _checkDirectory('example');
  
  // Check key files
  print('\n2. Key Files:');
  _checkFile('pubspec.yaml');
  _checkFile('lib/openkit_dart.dart');
  _checkFile('lib/src/OpenKitBuilder.dart');
  _checkFile('lib/src/api/index.dart');
  _checkFile('README.md');
  
  // Check API files
  print('\n3. API Files:');
  _checkFile('lib/src/api/OpenKit.dart');
  _checkFile('lib/src/api/Session.dart');
  _checkFile('lib/src/api/Action.dart');
  _checkFile('lib/src/api/DataCollectionLevel.dart');
  _checkFile('lib/src/api/CrashReportingLevel.dart');
  _checkFile('lib/src/api/LogLevel.dart');
  _checkFile('lib/src/api/Orientation.dart');
  
  // Check core files
  print('\n4. Core Files:');
  _checkFile('lib/src/core/config/Configuration.dart');
  _checkFile('lib/src/core/impl/OpenKitImpl.dart');
  _checkFile('lib/src/core/logging/ConsoleLoggerFactory.dart');
  _checkFile('lib/src/core/provider/DefaultRandomNumberProvider.dart');
  
  print('\n5. Example and Test Files:');
  _checkFile('example/lib/main.dart');
  _checkFile('test/openkit_dart_test.dart');
  
  print('\nValidation Complete!');
}

void _checkDirectory(String path) {
  final dir = Directory(path);
  if (dir.existsSync()) {
    print('✓ $path/');
  } else {
    print('✗ $path/ (missing)');
  }
}

void _checkFile(String path) {
  final file = File(path);
  if (file.existsSync()) {
    final size = file.lengthSync();
    print('✓ $path (${size} bytes)');
  } else {
    print('✗ $path (missing)');
  }
}
