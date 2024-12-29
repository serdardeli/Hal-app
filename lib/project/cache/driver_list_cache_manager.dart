import 'dart:developer';

import 'package:hal_app/project/model/driver_model/driver_model.dart';

import '../model/bildirimci/bildirimci_model.dart';
import 'package:hive/hive.dart';

import '../model/bildirim/bildirim_model.dart';

class DriverListCacheManager {
  static DriverListCacheManager? _instance;
  static DriverListCacheManager get instance =>
      _instance ??= DriverListCacheManager._();
  DriverListCacheManager._() {
    key = "driver_list_cache_manager";
  }
  late final String key;
  Box<List<dynamic>>? box;

  Future<void> init() async {
    registerAdapters();
    if (!(box?.isOpen ?? false)) {
      box = await Hive.openBox(key);
    }
  }

  Future<void> removeOneUretici(String activeTc, String tcToRemove) async {


    var result = box?.get(activeTc) ?? [];

    if (result.isNotEmpty) {

      for (var i = 0; i < result.length; i++) {
        DriverModel elementFromDb =
            DriverModel.fromJson(Map<String, dynamic>.from(result[i]));





        if (tcToRemove == elementFromDb.tc) {

          if (result.remove(result[i])) {

          }

          await box?.put(activeTc, result);
          return;
        }
      }
    }
  }

  Future<void> addItem(String key, DriverModel item) async {
    var result = box?.get(key) ?? [];
    var isExist = false;
    if (result.isNotEmpty) {
      for (var i = 0; i < result.length; i++) {
        DriverModel elementFromDb =
            DriverModel.fromJson(Map<String, dynamic>.from(result[i]));
        if (item == elementFromDb) {

          isExist = true;
          result[i] = item.toJson();
          await box?.put(key, result);
          return;
        }
      }
    } else {


      result.add(item.toJson());
      await box?.put(key, result);
      return;
    }
    if (!isExist) {


      result.add(item.toJson());
      await box?.put(key, result);
    }
  }

  /* Future<void> addItems(List<Bildirim> items) async {
    await _box?.addAll(items);
  }*/

  List<dynamic>? getItem(String key) {
    return box?.get(key);
  }

  Future<void> putItem(String key, List<Map> item) async {
    await box?.put(key, item);
  }

  Future<void> removeItem(String key) async {
    await box?.delete(key);
  }

  List<List<dynamic>>? getValues() {
    return box?.values.toList();
  }

  List? getkeys() {
    return (box?.keys.toList());
  }

  Future<void> clearAll() async {
    await box?.clear();
  }

  void registerAdapters() {
    if (!Hive.isAdapterRegistered(DriverModelAdapter().typeId)) {
      Hive.registerAdapter(DriverModelAdapter());
    }
  }
}
