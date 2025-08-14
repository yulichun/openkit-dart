import '../../api/index.dart';
import '../beacon/strategies/SendingStrategy.dart';

/// Configuration for OpenKit
class Configuration {
  final OpenKitConfig openKit;
  final PrivacyConfig privacy;
  final MetaConfig meta;
  final DeviceConfig device;

  const Configuration({
    required this.openKit,
    required this.privacy,
    required this.meta,
    required this.device,
  });

  /// Create configuration from map
  factory Configuration.fromMap(Map<String, dynamic> map) {
    return Configuration(
      openKit: OpenKitConfig.fromMap(map['openKit'] as Map<String, dynamic>),
      privacy: PrivacyConfig.fromMap(map['privacy'] as Map<String, dynamic>),
      meta: MetaConfig.fromMap(map['meta'] as Map<String, dynamic>),
      device: DeviceConfig.fromMap(map['device'] as Map<String, dynamic>),
    );
  }

  /// Convert to map
  Map<String, dynamic> toMap() {
    return {
      'openKit': openKit.toMap(),
      'privacy': privacy.toMap(),
      'meta': meta.toMap(),
      'device': device.toMap(),
    };
  }
}

/// OpenKit specific configuration
class OpenKitConfig {
  final String beaconURL;
  final String deviceId;
  final String applicationId;
  final CommunicationChannel communicationChannel;
  final RandomNumberProvider random;
  final LoggerFactory loggerFactory;
  final List<SendingStrategy> sendingStrategies;

  const OpenKitConfig({
    required this.beaconURL,
    required this.deviceId,
    required this.applicationId,
    required this.communicationChannel,
    required this.random,
    required this.loggerFactory,
    required this.sendingStrategies,
  });

  factory OpenKitConfig.fromMap(Map<String, dynamic> map) {
    return OpenKitConfig(
      beaconURL: map['beaconURL'] as String,
      deviceId: map['deviceId'] as String,
      applicationId: map['applicationId'] as String,
      communicationChannel: map['communicationChannel'] as CommunicationChannel,
      random: map['random'] as RandomNumberProvider,
      loggerFactory: map['loggerFactory'] as LoggerFactory,
      sendingStrategies: List<SendingStrategy>.from(map['sendingStrategies']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'beaconURL': beaconURL,
      'deviceId': deviceId,
      'applicationId': applicationId,
      'communicationChannel': communicationChannel,
      'random': random,
      'loggerFactory': loggerFactory,
      'sendingStrategies': sendingStrategies,
    };
  }
}

/// Privacy configuration
class PrivacyConfig {
  final DataCollectionLevel dataCollectionLevel;
  final CrashReportingLevel crashReportingLevel;

  const PrivacyConfig({
    required this.dataCollectionLevel,
    required this.crashReportingLevel,
  });

  factory PrivacyConfig.fromMap(Map<String, dynamic> map) {
    return PrivacyConfig(
      dataCollectionLevel:
          DataCollectionLevel.fromValue(map['dataCollectionLevel'] as int),
      crashReportingLevel:
          CrashReportingLevel.fromValue(map['crashReportingLevel'] as int),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'dataCollectionLevel': dataCollectionLevel.value,
      'crashReportingLevel': crashReportingLevel.value,
    };
  }
}

/// Meta information configuration
class MetaConfig {
  final String? applicationVersion;
  final String operatingSystem;

  const MetaConfig({
    this.applicationVersion,
    required this.operatingSystem,
  });

  factory MetaConfig.fromMap(Map<String, dynamic> map) {
    return MetaConfig(
      applicationVersion: map['applicationVersion'] as String?,
      operatingSystem: map['operatingSystem'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'applicationVersion': applicationVersion,
      'operatingSystem': operatingSystem,
    };
  }
}

/// Device configuration
class DeviceConfig {
  final String? manufacturer;
  final String? modelId;
  final String? userLanguage;
  final int? screenWidth;
  final int? screenHeight;
  final Orientation? orientation;

  const DeviceConfig({
    this.manufacturer,
    this.modelId,
    this.userLanguage,
    this.screenWidth,
    this.screenHeight,
    this.orientation,
  });

  factory DeviceConfig.fromMap(Map<String, dynamic> map) {
    return DeviceConfig(
      manufacturer: map['manufacturer'] as String?,
      modelId: map['modelId'] as String?,
      userLanguage: map['userLanguage'] as String?,
      screenWidth: map['screenWidth'] as int?,
      screenHeight: map['screenHeight'] as int?,
      orientation: map['orientation'] != null
          ? Orientation.fromValue(map['orientation'] as String)
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'manufacturer': manufacturer,
      'modelId': modelId,
      'userLanguage': userLanguage,
      'screenWidth': screenWidth,
      'screenHeight': screenHeight,
      'orientation': orientation?.value,
    };
  }
}
