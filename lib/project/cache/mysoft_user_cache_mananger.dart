import '../model/MySoft_user_model/mysoft_user_model.dart';
import '../model/user/my_user_model.dart';
import 'package:hive/hive.dart';

class MySoftUserCacheManager {
  static MySoftUserCacheManager? _instance;
  static MySoftUserCacheManager get instance =>
      _instance ??= MySoftUserCacheManager._();
  MySoftUserCacheManager._() {
    key = "mysoft_user_cache_manager";
  }
  late final String key;
  Box<MySoftUserModel>? _box;

  Future<void> init() async {
    registerAdapters();
    if (!(_box?.isOpen ?? false)) {
       _box = await Hive.openBox(key);
    }
  }

  //Future<void> addItems(List<IzibizUserModel> items) async {
  //  await _box?.addAll(items);
  //}

  MySoftUserModel? getItem(String key) {
    return _box?.get(key);
  }

  Future<void> putItem(String key, MySoftUserModel item) async {
    await _box?.put(key, item);
  }

  Future<void> removeItem(String key) async {
    await _box?.delete(key);
  }

  List<MySoftUserModel>? getValues() {
    return _box?.values.toList();
  }

  List? getkeys() {
    return _box?.keys.toList();
  }

  Future<void> clearAll() async {
    await _box?.clear();
  }

  void registerAdapters() {
    if (!Hive.isAdapterRegistered(MySoftUserModelAdapter().typeId)) {
      Hive.registerAdapter(MySoftUserModelAdapter());
    }
  }
}



