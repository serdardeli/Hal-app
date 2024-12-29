import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class AppCacheManager {
  static AppCacheManager? _instance;
  static AppCacheManager get instance => _instance ??= AppCacheManager._();
  AppCacheManager._() {
    key = "app_cache_manager";
  }
  late final String key;
  Box<String>? box;

  Future<void> init() async {
    registerAdapters();
    if (!(box?.isOpen ?? false)) {
      Hive.init((await getApplicationDocumentsDirectory()).path);

      box = await Hive.openBox(key);
    }
    /*if (_box == null) {
      _box = await Hive.openBox(key);
    }*/
  }

  Future<void> addItems(List<String> items) async {
    await box?.addAll(items);
  }

  //Future<void> putItems(List<String> items) async {
  //  await _box?.putAll(Map.fromEntries(items.map((e) => MapEntry(e.name, e))));
  //}

  String? getItem(String key) {
    return box?.get(key);
  }

  Future<void> putItem(String key, String item) async {
    await box?.put(key, item);
  }

  Future<void> putBoolItem(String key, bool item) async {
    await box?.put(key, item.toString());
  }

  getBoolValue(String key) {
    return (box?.get(key) ?? true).toString();
  }

  Future<void> removeItem(String key) async {
    await box?.delete(key);
  }

  List<String>? getValues() {
    return box?.values.toList();
  }

  List? getkeys() {
    return box?.keys.toList();
  }

  Future<void> clearAll() async {
    await box?.clear();
  }

  void registerAdapters() {}
}
