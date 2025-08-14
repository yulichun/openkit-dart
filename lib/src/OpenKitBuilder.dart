import 'api/index.dart';
import 'core/beacon/strategies/ImmediateSendingStrategy.dart';
import 'core/beacon/strategies/IntervalSendingStrategy.dart';
import 'core/beacon/strategies/SendingStrategy.dart';
import 'core/communication/http/FetchHttpClient.dart';
import 'core/communication/http/state/HttpCommunicationChannel.dart';
import 'core/config/Configuration.dart';
import 'core/impl/OpenKitImpl.dart';
import 'core/logging/ConsoleLoggerFactory.dart';
import 'core/provider/DefaultRandomNumberProvider.dart';
import 'core/utils/HashUtils.dart';
import 'core/utils/Utils.dart';

const DataCollectionLevel _defaultDataCollectionLevel =
    DataCollectionLevel.userBehavior;
const CrashReportingLevel _defaultCrashReportingLevel =
    CrashReportingLevel.optInCrashes;
const String _defaultOperatingSystem = 'OpenKit';

/// Builder for an OpenKit instance.
class OpenKitBuilder {
  final String _beaconUrl;
  final String _applicationId;
  final int _deviceId;

  String _operatingSystem = _defaultOperatingSystem;
  String? _applicationVersion;

  CrashReportingLevel _crashReportingLevel = CrashReportingLevel.optInCrashes;
  DataCollectionLevel _dataCollectionLevel = DataCollectionLevel.userBehavior;

  CommunicationChannel? _communicationChannel;
  RandomNumberProvider? _randomNumberProvider;

  LogLevel _logLevel = LogLevel.warn;
  LoggerFactory? _loggerFactory;

  String? _manufacturer;
  String? _modelId;
  String? _userLanguage;
  int? _screenWidth;
  int? _screenHeight;
  Orientation? _orientation;

  /// Creates a new OpenKitBuilder
  ///
  /// [beaconURL] The url to the beacon endpoint
  /// [applicationId] The id of the custom application
  /// [deviceId] The id of the current device, which must be a decimal number
  /// in the range of int.min to int.max. If the number is outside of this range,
  /// not decimal or invalid it will be hashed.
  OpenKitBuilder(this._beaconUrl, this._applicationId, this._deviceId);

  /// Sets the operating system information. Defaults to 'OpenKit'.
  ///
  /// [operatingSystem] The operating system
  /// Returns The current OpenKitBuilder
  OpenKitBuilder withOperatingSystem(String operatingSystem) {
    _operatingSystem = operatingSystem;
    return this;
  }

  /// Defines the version of the application.
  ///
  /// [appVersion] The application version
  /// Returns The current OpenKitBuilder
  OpenKitBuilder withApplicationVersion(String appVersion) {
    _applicationVersion = appVersion;
    return this;
  }

  /// Sets the data collection level.
  ///
  /// Depending on the chosen level the amount and granularity of data sent is controlled.
  /// Off (0) - no data collected
  /// Performance (1) - only performance related data is collected
  /// UserBehavior (2) - all available RUM data including performance related data is collected.
  ///
  /// If an invalid value is passed, it is ignored.
  ///
  /// Default value is UserBehavior (2)
  ///
  /// [dataCollectionLevel] The data collection level
  /// Returns The current OpenKitBuilder
  OpenKitBuilder withDataCollectionLevel(
      DataCollectionLevel dataCollectionLevel) {
    if (dataCollectionLevel.value >= 0 && dataCollectionLevel.value <= 2) {
      _dataCollectionLevel = dataCollectionLevel;
    }
    return this;
  }

  /// Sets the flag if crash reporting is enabled
  ///
  /// Off (0) - No crashes are reported
  /// OptOutCrashes = (1) - No crashes are reported
  /// OptInCrashes = (2) - Crashes are reported
  ///
  /// If an invalid value is passed, it is ignored.
  ///
  /// [crashReportingLevel] The crash reporting level
  /// Returns The current OpenKitBuilder
  OpenKitBuilder withCrashReportingLevel(
      CrashReportingLevel crashReportingLevel) {
    if (crashReportingLevel.value >= 0 && crashReportingLevel.value <= 2) {
      _crashReportingLevel = crashReportingLevel;
    }
    return this;
  }

  /// Sets the communication channel. If the object is null or undefined, it is ignored.
  ///
  /// [communicationChannel] The communication channel
  /// Returns The current OpenKitBuilder
  OpenKitBuilder withCommunicationChannel(
      CommunicationChannel communicationChannel) {
    if (communicationChannel != null) {
      _communicationChannel = communicationChannel;
    }
    return this;
  }

  /// Sets the random number provider. If the object is null or undefined, it is ignored.
  ///
  /// [random] The random number provider.
  /// Returns The current OpenKitBuilder
  OpenKitBuilder withRandomNumberProvider(RandomNumberProvider random) {
    if (random != null) {
      _randomNumberProvider = random;
    }
    return this;
  }

  /// Sets the manufacturer of the device. If the argument is not a string or empty string, it is ignored.
  ///
  /// [manufacturer] The manufacturer of the device
  /// Returns The current OpenKitBuilder
  OpenKitBuilder withManufacturer(String manufacturer) {
    if (manufacturer.isNotEmpty) {
      _manufacturer = Utils.truncate(manufacturer);
    }
    return this;
  }

  /// Sets the modelId of the device. If the argument is not a string or empty string, it is ignored.
  ///
  /// [modelId] The model id of the device
  /// Returns The current OpenKitBuilder
  OpenKitBuilder withModelId(String modelId) {
    if (modelId.isNotEmpty) {
      _modelId = Utils.truncate(modelId);
    }
    return this;
  }

  /// Sets the user language. If the language is not a string or empty string, it is ignored.
  /// Currently, there are no restrictions on RFC/ISO codes.
  ///
  /// [language] The user language
  /// Returns The current OpenKitBuilder
  OpenKitBuilder withUserLanguage(String language) {
    if (language.isNotEmpty) {
      _userLanguage = language;
    }
    return this;
  }

  /// Sets the screen resolution. If the width or height are not positive finite numbers, both are ignored.
  ///
  /// [width] The width of the screen
  /// [height] The height of the screen
  /// Returns The current OpenKitBuilder
  OpenKitBuilder withScreenResolution(int width, int height) {
    // Check input for valid numbers
    if (width > 0 && height > 0) {
      _screenWidth = width;
      _screenHeight = height;
    }
    return this;
  }

  /// Sets the screen orientation. Allowed values are Orientation.Portrait ('p') and Orientation.Landscape ('l').
  /// All other values are ignored.
  ///
  /// [orientation] The orientation. 'p' || 'l'.
  /// Returns The current OpenKitBuilder
  OpenKitBuilder withScreenOrientation(Orientation orientation) {
    if (orientation == Orientation.landscape ||
        orientation == Orientation.portrait) {
      _orientation = orientation;
    }
    return this;
  }

  /// Sets the logger factory.
  /// If the argument is null or undefined, it is ignored.
  ///
  /// [loggerFactory] The logger factory
  /// Returns The current OpenKitBuilder
  OpenKitBuilder withLoggerFactory(LoggerFactory loggerFactory) {
    if (loggerFactory != null) {
      _loggerFactory = loggerFactory;
    }
    return this;
  }

  /// Sets the default log level if the default logger factory is used.
  ///
  /// [logLevel] The loglevel for the default logger factory.
  /// Returns The current OpenKitBuilder
  OpenKitBuilder withLogLevel(LogLevel logLevel) {
    _logLevel = logLevel;
    return this;
  }

  /// Builds and gets the current configuration.
  ///
  /// Returns the current configuration
  Configuration getConfig() {
    return _buildConfig();
  }

  /// Build and initialize an OpenKit instance.
  ///
  /// Returns The OpenKit instance.
  OpenKit build() {
    final config = _buildConfig();
    final openKit = OpenKitImpl(config);
    openKit.initialize();
    return openKit;
  }

  Configuration _buildConfig() {
    final loggerFactory = _loggerFactory ?? ConsoleLoggerFactory(_logLevel);

    final communicationChannel = _communicationChannel ??
        HttpCommunicationChannel(
          FetchHttpClient(loggerFactory),
          loggerFactory,
        );

    final random = _randomNumberProvider ?? DefaultRandomNumberProvider();

    // user does not allow data tracking
    final deviceIdStr = _normalizeDeviceId(
      _deviceId,
      _dataCollectionLevel,
      random,
    );
    final sendingStrategies = _getContextBasedSendingStrategies();

    return Configuration(
      openKit: OpenKitConfig(
        beaconURL: _beaconUrl,
        deviceId: deviceIdStr,
        applicationId: _applicationId,
        communicationChannel: communicationChannel,
        random: random,
        loggerFactory: loggerFactory,
        sendingStrategies: sendingStrategies,
      ),
      privacy: PrivacyConfig(
        dataCollectionLevel: _dataCollectionLevel,
        crashReportingLevel: _crashReportingLevel,
      ),
      meta: MetaConfig(
        applicationVersion: _applicationVersion,
        operatingSystem: _operatingSystem,
      ),
      device: DeviceConfig(
        manufacturer: _manufacturer,
        modelId: _modelId,
        userLanguage: _userLanguage,
        screenWidth: _screenWidth,
        screenHeight: _screenHeight,
        orientation: _orientation,
      ),
    );
  }

  String _normalizeDeviceId(
    int deviceId,
    DataCollectionLevel dcl,
    RandomNumberProvider random,
  ) {
    if (dcl != DataCollectionLevel.userBehavior) {
      return random.nextPositiveInteger().toString();
    }

    final deviceIdStr = deviceId.toString();

    if (!Utils.isInteger(deviceId)) {
      return HashUtils.to53BitHash(deviceIdStr).toString();
    }

    return deviceIdStr;
  }

  List<SendingStrategy> _getContextBasedSendingStrategies() {
    if (Utils.isNode) {
      return [IntervalSendingStrategy()];
    } else {
      return [ImmediateSendingStrategy()];
    }
  }
}
