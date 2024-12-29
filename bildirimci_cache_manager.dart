import 'dart:developer';

import '../model/bildirimci/bildirimci_model.dart';
import 'package:hive/hive.dart';

class BildirimciCacheManager {
  static BildirimciCacheManager? _instance;
  static BildirimciCacheManager get instance =>
      _instance ??= BildirimciCacheManager._();
  BildirimciCacheManager._() {
    key = "bildirimci_cache_manager";
  }
  late final String key;
  Box<Bildirimci>? _box;

  Future<void> init() async {
    registerAdapters();
    if (!(_box?.isOpen ?? false)) {
      _box = await Hive.openBox(key);
    }
    /*if (_box == null) {
      _box = await Hive.openBox(key);
    }*/
  }

  Future<void> addItems(List<Bildirimci> items) async {
    await _box?.addAll(items);
  }

  Bildirimci? getItem(String key) {
    return _box?.get(key);
  }
Future<void> deleteItem(String key ) async {
    await _box?.delete(key);
  }
  Future<void> putItem(String key, Bildirimci item) async {
    await _box?.put(key, item);
  }

  Future<void> removeItem(String key) async {
    await _box?.delete(key);
  }

  List<Bildirimci>? getValues() {
    return _box?.values.toList();
  }

  List<String>? getkeys() {
    if (_box?.keys.toList() != null) {
      return (_box?.keys.toList().cast<String>());
    } else {
      return [];
    }
  }

  Future<void> clearAll() async {
    await _box?.clear();
  }

  void registerAdapters() {
    if (!Hive.isAdapterRegistered(BildirimciAdapter().typeId)) {
      Hive.registerAdapter(BildirimciAdapter());
    }
  }
}
