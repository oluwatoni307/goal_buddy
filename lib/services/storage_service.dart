import 'package:get_storage/get_storage.dart';

/// Thin, test-friendly wrapper around GetStorage.
/// All access to GetStorage goes through this class.
class StorageService {
  static final StorageService _instance = StorageService._internal();
  late final GetStorage _box;

  factory StorageService() => _instance;

  StorageService._internal();

  Future<void> init() async {
    await GetStorage.init();
    _box = GetStorage();
  }

  Future<void> write(String key, dynamic value) async =>
      await _box.write(key, value);

  T? read<T>(String key) => _box.read<T>(key);

  Future<void> remove(String key) async => await _box.remove(key);

  Future<void> clear() async => await _box.erase();
}