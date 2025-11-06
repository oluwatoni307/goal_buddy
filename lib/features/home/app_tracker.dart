import 'package:get_storage/get_storage.dart';

class AppOpenTracker {
  static final _storage = GetStorage();
  static const String _lastOpenDateKey = 'last_open_date';

  /// Check if app was opened today and update the timestamp
  static bool hasOpenedToday() {
    final lastOpenDate = _storage.read<String>(_lastOpenDateKey);
    final today = DateTime.now().toIso8601String().split('T')[0]; // YYYY-MM-DD

    if (lastOpenDate == today) {
      return true; // Already opened today
    }

    // Save today's date
    _storage.write(_lastOpenDateKey, today);
    return false; // First open today
  }

  /// Get the last open date
  static String? getLastOpenDate() {
    return _storage.read<String>(_lastOpenDateKey);
  }
}
