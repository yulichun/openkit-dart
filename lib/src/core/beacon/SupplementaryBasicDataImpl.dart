import '../config/Configuration.dart';
import 'SupplementaryBasicData.dart';

/// Implementation of SupplementaryBasicData
class SupplementaryBasicDataImpl implements SupplementaryBasicData {
  final Configuration _config;

  SupplementaryBasicDataImpl(this._config);

  @override
  String get deviceId => _config.openKit.deviceId;

  @override
  String get applicationId => _config.openKit.applicationId;

  @override
  String get operatingSystem => _config.meta.operatingSystem;

  @override
  String? get applicationVersion => _config.meta.applicationVersion;

  @override
  String? get manufacturer => _config.device.manufacturer;

  @override
  String? get modelId => _config.device.modelId;

  @override
  String? get userLanguage => _config.device.userLanguage;

  @override
  int? get screenWidth => _config.device.screenWidth;

  @override
  int? get screenHeight => _config.device.screenHeight;

  @override
  String? get orientation => _config.device.orientation?.value;
}
