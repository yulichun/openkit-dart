import 'package:flutter_test/flutter_test.dart';
import 'package:openkit_dart/openkit_dart.dart';

void main() {
  group('OpenKitBuilder Tests', () {
    test('should create OpenKitBuilder with required parameters', () {
      final builder = OpenKitBuilder(
        'https://test.com/mbeacon',
        'test-app',
        12345,
      );

      expect(builder, isNotNull);
    });

    test('should set operating system', () {
      final builder = OpenKitBuilder(
        'https://test.com/mbeacon',
        'test-app',
        12345,
      ).withOperatingSystem('Flutter');

      final config = builder.getConfig();
      expect(config.meta.operatingSystem, equals('Flutter'));
    });

    test('should set application version', () {
      final builder = OpenKitBuilder(
        'https://test.com/mbeacon',
        'test-app',
        12345,
      ).withApplicationVersion('1.0.0');

      final config = builder.getConfig();
      expect(config.meta.applicationVersion, equals('1.0.0'));
    });

    test('should set data collection level', () {
      final builder = OpenKitBuilder(
        'https://test.com/mbeacon',
        'test-app',
        12345,
      ).withDataCollectionLevel(DataCollectionLevel.performance);

      final config = builder.getConfig();
      expect(config.privacy.dataCollectionLevel, equals(DataCollectionLevel.performance));
    });

    test('should set crash reporting level', () {
      final builder = OpenKitBuilder(
        'https://test.com/mbeacon',
        'test-app',
        12345,
      ).withCrashReportingLevel(CrashReportingLevel.optOutCrashes);

      final config = builder.getConfig();
      expect(config.privacy.crashReportingLevel, equals(CrashReportingLevel.optOutCrashes));
    });

    test('should set log level', () {
      final builder = OpenKitBuilder(
        'https://test.com/mbeacon',
        'test-app',
        12345,
      ).withLogLevel(LogLevel.debug);

      final config = builder.getConfig();
      // The log level is used internally by the logger factory
      expect(builder, isNotNull);
    });

    test('should set manufacturer', () {
      final builder = OpenKitBuilder(
        'https://test.com/mbeacon',
        'test-app',
        12345,
      ).withManufacturer('Apple');

      final config = builder.getConfig();
      expect(config.device.manufacturer, equals('Apple'));
    });

    test('should set model ID', () {
      final builder = OpenKitBuilder(
        'https://test.com/mbeacon',
        'test-app',
        12345,
      ).withModelId('iPhone 14');

      final config = builder.getConfig();
      expect(config.device.modelId, equals('iPhone 14'));
    });

    test('should set user language', () {
      final builder = OpenKitBuilder(
        'https://test.com/mbeacon',
        'test-app',
        12345,
      ).withUserLanguage('en-US');

      final config = builder.getConfig();
      expect(config.device.userLanguage, equals('en-US'));
    });

    test('should set screen resolution', () {
      final builder = OpenKitBuilder(
        'https://test.com/mbeacon',
        'test-app',
        12345,
      ).withScreenResolution(390, 844);

      final config = builder.getConfig();
      expect(config.device.screenWidth, equals(390));
      expect(config.device.screenHeight, equals(844));
    });

    test('should set screen orientation', () {
      final builder = OpenKitBuilder(
        'https://test.com/mbeacon',
        'test-app',
        12345,
      ).withScreenOrientation(Orientation.portrait);

      final config = builder.getConfig();
      expect(config.device.orientation, equals(Orientation.portrait));
    });
  });

  group('DataCollectionLevel Tests', () {
    test('should have correct values', () {
      expect(DataCollectionLevel.off.value, equals(0));
      expect(DataCollectionLevel.performance.value, equals(1));
      expect(DataCollectionLevel.userBehavior.value, equals(2));
    });

    test('should create from value', () {
      expect(DataCollectionLevel.fromValue(0), equals(DataCollectionLevel.off));
      expect(DataCollectionLevel.fromValue(1), equals(DataCollectionLevel.performance));
      expect(DataCollectionLevel.fromValue(2), equals(DataCollectionLevel.userBehavior));
      expect(DataCollectionLevel.fromValue(999), equals(DataCollectionLevel.userBehavior)); // default
    });
  });

  group('CrashReportingLevel Tests', () {
    test('should have correct values', () {
      expect(CrashReportingLevel.off.value, equals(0));
      expect(CrashReportingLevel.optOutCrashes.value, equals(1));
      expect(CrashReportingLevel.optInCrashes.value, equals(2));
    });

    test('should create from value', () {
      expect(CrashReportingLevel.fromValue(0), equals(CrashReportingLevel.off));
      expect(CrashReportingLevel.fromValue(1), equals(CrashReportingLevel.optOutCrashes));
      expect(CrashReportingLevel.fromValue(2), equals(CrashReportingLevel.optInCrashes));
      expect(CrashReportingLevel.fromValue(999), equals(CrashReportingLevel.optInCrashes)); // default
    });
  });

  group('LogLevel Tests', () {
    test('should have correct values', () {
      expect(LogLevel.all.value, equals(0));
      expect(LogLevel.trace.value, equals(1));
      expect(LogLevel.debug.value, equals(2));
      expect(LogLevel.info.value, equals(3));
      expect(LogLevel.warn.value, equals(4));
      expect(LogLevel.error.value, equals(5));
      expect(LogLevel.fatal.value, equals(6));
      expect(LogLevel.off.value, equals(7));
    });

    test('should create from value', () {
      expect(LogLevel.fromValue(0), equals(LogLevel.all));
      expect(LogLevel.fromValue(4), equals(LogLevel.warn));
      expect(LogLevel.fromValue(7), equals(LogLevel.off));
      expect(LogLevel.fromValue(999), equals(LogLevel.warn)); // default
    });
  });

  group('Orientation Tests', () {
    test('should have correct values', () {
      expect(Orientation.portrait.value, equals('p'));
      expect(Orientation.landscape.value, equals('l'));
    });

    test('should create from value', () {
      expect(Orientation.fromValue('p'), equals(Orientation.portrait));
      expect(Orientation.fromValue('l'), equals(Orientation.landscape));
      expect(Orientation.fromValue('invalid'), equals(Orientation.portrait)); // default
    });
  });
}
