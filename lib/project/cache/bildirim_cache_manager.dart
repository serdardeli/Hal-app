import 'dart:developer';

import '../model/bildirimci/bildirimci_model.dart';
import 'package:hive/hive.dart';

import '../model/bildirim/bildirim_model.dart';

class BildirimCacheManager {
  static BildirimCacheManager? _instance;
  static BildirimCacheManager get instance =>
      _instance ??= BildirimCacheManager._();
  BildirimCacheManager._() {
    key = "bildirim_cache_manager";
  }
  late final String key;
  Box<Bildirim>? _box;

  Future<void> init() async {
    registerAdapters();
    if (!(_box?.isOpen ?? false)) {
      _box = await Hive.openBox(key);
    }
    /*if (_box == null) {
      _box = await Hive.openBox(key);
    }*/
  }

  Future<void> addItem(Bildirim item) async {
    var values = _box?.values.toList() ?? [];
    if (values.isNotEmpty) {
      var isExist = false;
      for (var bildirim in values) {
        if (bildirim == item) {

          isExist = true;
        }
      }
      if (!isExist) {


        await _box?.add(item);
      }
    } else {


      await _box?.add(item);
    }
  }

  Future<void> addItems(List<Bildirim> items) async {
    await _box?.addAll(items);
  }

  Bildirim? getItem(String key) {
    return _box?.get(key);
  }

  Future<void> putItem(String key, Bildirim item) async {
    await _box?.put(key, item);
  }

  Future<void> removeItem(String key) async {
    await _box?.delete(key);
  }

  List<Bildirim>? getValues() {
    return _box?.values.toList();
  }

  List? getkeys() {
    return (_box?.keys.toList());


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
    if (!Hive.isAdapterRegistered(BildirimAdapter().typeId)) {
      Hive.registerAdapter(BildirimAdapter());
    }
  }
}
