import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class AppCacheManagerTrial {
  static AppCacheManagerTrial? _instance;
  static AppCacheManagerTrial get instance => _instance ??= AppCacheManagerTrial._();
  AppCacheManagerTrial._() {
    key = "app_cache_manager_trial";
  }
  late final String key;
  Box<Map>? box;

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

  Future<void> addItems(List<Map> items) async {
    await box?.addAll(items);
  }

  //Future<void> putItems(List<String> items) async {
  //  await _box?.putAll(Map.fromEntries(items.map((e) => MapEntry(e.name, e))));
  //}

  Map? getItem(String key) {
    return box?.get(key);
  }

  Future<void> putItem(String key, Map item) async {
    await box?.put(key, item);
  }

  

  getBoolValue(String key) {
    return (box?.get(key) ?? true).toString();
  }

  Future<void> removeItem(String key) async {
    await box?.delete(key);
  }

  List<Map>? getValues() {
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
