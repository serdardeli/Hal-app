import '../model/user/my_user_model.dart';
import 'package:hive/hive.dart';

class UserCacheManager {
  static UserCacheManager? _instance;
  static UserCacheManager get instance => _instance ??= UserCacheManager._();
  UserCacheManager._() {
    key = "user_cache_manager";
  }
  late final String key;
  Box<MyUser>? _box;

  Future<void> init() async {
    registerAdapters();
    if (!(_box?.isOpen ?? false)) {
      _box = await Hive.openBox(key);
    }
  }

  Future<void> addItems(List<MyUser> items) async {
    await _box?.addAll(items);
  }

  MyUser? deleteBildirimciTc(String key, String tcToDelete) {
    MyUser? user = _box?.get(key);
    if (user != null) {
      var result = user.tcList?.remove(tcToDelete);

      user.save();
    }
    return _box?.get(key);
  }

  MyUser? getItem(String key) {
    return _box?.get(key);
  }

  Future<void> putItem(String key, MyUser item) async {
    await _box?.put(key, item);
  }

  Future<void> removeItem(String key) async {
    await _box?.delete(key);
  }

  List<MyUser>? getValues() {
    return _box?.values.toList();
  }

  List? getkeys() {
    return _box?.keys.toList();
  }

  Future<void> clearAll() async {
    await _box?.clear();
  }

  void registerAdapters() {
    if (!Hive.isAdapterRegistered(MyUserAdapter().typeId)) {
      Hive.registerAdapter(MyUserAdapter());
    }
  }
}
