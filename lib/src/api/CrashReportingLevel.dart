/// Crash reporting level for OpenKit
enum CrashReportingLevel {
  /// No crashes are reported
  off(0),
  
  /// No crashes are reported (opt-out)
  optOutCrashes(1),
  
  /// Crashes are reported (opt-in)
  optInCrashes(2);

  const CrashReportingLevel(this.value);
  
  final int value;
  
  /// Get CrashReportingLevel from integer value
  static CrashReportingLevel fromValue(int value) {
    return CrashReportingLevel.values.firstWhere(
      (level) => level.value == value,
      orElse: () => CrashReportingLevel.optInCrashes,
    );
  }
}
