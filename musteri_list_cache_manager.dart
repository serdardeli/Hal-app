import 'package:hal_app/project/model/musteri_model/musteri_model.dart';

import 'package:hive/hive.dart';

class MusteriListCacheManager {
  static MusteriListCacheManager? _instance;
  static MusteriListCacheManager get instance =>
      _instance ??= MusteriListCacheManager._();
  MusteriListCacheManager._() {
    key = "musteri_list_cache_manager";
  }
  late final String key;
  Box<List<dynamic>>? box;

  Future<void> init() async {
    registerAdapters();
    if (!(box?.isOpen ?? false)) {
      box = await Hive.openBox(key);
    }
  }

  Future<void> removeOneUretici(String activeTc, String nameToRemove) async {
    var result = box?.get(activeTc) ?? [];

    if (result.isNotEmpty) {
      for (var i = 0; i < result.length; i++) {
        Musteri elementFromDb =
            Musteri.fromJson(Map<String, dynamic>.from(result[i]));

        if (nameToRemove == elementFromDb.musteriAdiSoyadi) {
          if (result.remove(result[i])) {}

          await box?.put(activeTc, result);
          return;
        }
      }
    }
  }

  Future<void> addItem(String key, Musteri item) async {
    var result = box?.get(key) ?? [];
    var isExist = false;
    if (result.isNotEmpty) {
      for (var i = 0; i < result.length; i++) {
        Musteri elementFromDb =
            Musteri.fromJson(Map<String, dynamic>.from(result[i]));
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

    if (box?.keys.toList() != null) {
      return (box?.keys.toList().cast<String>());
    } else {
      return [];
    }
  }

  Future<void> clearAll() async {
    await box?.clear();
  }

  void registerAdapters() {
    // if (!Hive.isAdapterRegistered(BildirimListAdapter().typeId)) {
    //   Hive.registerAdapter(BildirimListAdapter());
    // }
  }
}
