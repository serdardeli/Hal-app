import 'dart:developer';

import 'package:hal_app/project/model/depo/depo_model.dart';

import '../model/bildirimci/bildirimci_model.dart';
import 'package:hive/hive.dart';

import '../model/bildirim/bildirim_model.dart';
import '../model/uretici_model/uretici_model.dart';

class MusteriDepolarCacheManager {
  static MusteriDepolarCacheManager? _instance;
  static MusteriDepolarCacheManager get instance =>
      _instance ??= MusteriDepolarCacheManager._();
  MusteriDepolarCacheManager._() {
    key = "musteri_depo_list_cache_manager";
  }
  late final String key;
  Box<List<dynamic>>? box;

  Future<void> init() async {
    registerAdapters();
    if (!(box?.isOpen ?? false)) {
      box = await Hive.openBox(key);
    }
  }

  List<Depo> getItem(String key) {
    var result = box?.get(key);
    List<Depo> listReal = [];
    if (result != null) {
      if (result.runtimeType.toString() ==
          "List<${Depo.getFakeModel().runtimeType.toString()}>") {
        return (result as List<Depo>);
      }
      for (var element in result) {
        if (element.runtimeType.toString() ==
            Depo.getFakeModel().runtimeType.toString()) {
          listReal.add(element);
        } else {
          listReal.add(Depo.fromJson(Map<String, dynamic>.from(element)));
        }
      }
    }

    return listReal;
  }

  Future<void> putItem(String key, List<Depo> item) async {
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
    if (!Hive.isAdapterRegistered(DepoAdapter().typeId)) {
      Hive.registerAdapter(DepoAdapter());
    }
  }
}
