import '../CommunicationState.dart';
import '../../payload/PayloadBuilder.dart';
import '../../../api/Session.dart';

/// Cache entry for storing session information
class CacheEntry {
  final String prefix;
  final CommunicationState communicationState;
  final Session session;
  final PayloadBuilder builder;
  bool initialized;

  CacheEntry({
    required this.prefix,
    required this.communicationState,
    required this.session,
    required this.builder,
    this.initialized = false,
  });
}

/// Interface for beacon cache
abstract class BeaconCache {
  /// Get a copy of all entries
  List<CacheEntry> getEntriesCopy();

  /// Register a new session
  CacheEntry register(
    Session session,
    String prefix,
    PayloadBuilder payloadBuilder,
    CommunicationState state,
  );

  /// Get all uninitialized sessions
  List<CacheEntry> getAllUninitializedSessions();

  /// Get all closed sessions
  List<CacheEntry> getAllClosedSessions();

  /// Get all initialized sessions
  List<CacheEntry> getAllInitializedSessions();

  /// Unregister an entry
  void unregister(CacheEntry entry);
}

/// Implementation of BeaconCache
class BeaconCacheImpl implements BeaconCache {
  final List<CacheEntry> _entries = [];

  @override
  CacheEntry register(
    Session session,
    String prefix,
    PayloadBuilder payloadBuilder,
    CommunicationState state,
  ) {
    final entry = CacheEntry(
      session: session,
      initialized: false,
      prefix: prefix,
      communicationState: state,
      builder: payloadBuilder,
    );

    _entries.add(entry);
    return entry;
  }

  @override
  List<CacheEntry> getAllUninitializedSessions() {
    return _entries.where((entry) => !entry.initialized).toList();
  }

  @override
  List<CacheEntry> getAllClosedSessions() {
    return _entries
        .where((entry) => entry.initialized && entry.session.isEnded)
        .toList();
  }

  @override
  List<CacheEntry> getAllInitializedSessions() {
    return _entries.where((entry) => entry.initialized).toList();
  }

  @override
  void unregister(CacheEntry entry) {
    _entries.remove(entry);
  }

  @override
  List<CacheEntry> getEntriesCopy() {
    return List.from(_entries);
  }
}
