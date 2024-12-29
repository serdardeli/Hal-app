import 'dart:developer';

import '../model/bildirimci/bildirimci_model.dart';
import 'package:hive/hive.dart';

import '../model/bildirim/bildirim_model.dart';
import '../model/sube/sube_model.dart';
import '../model/uretici_model/uretici_model.dart';

class SubelerCacheManager {
  static SubelerCacheManager? _instance;
  static SubelerCacheManager get instance =>
      _instance ??= SubelerCacheManager._();
  SubelerCacheManager._() {
    key = "sube_list_cache_manager";
  }
  late final String key;
  Box<List<dynamic>>? box;

  Future<void> init() async {
    registerAdapters();
    if (!(box?.isOpen ?? false)) {
      box = await Hive.openBox(key);
    }
  }

  List<Sube> getItem(String key) {
    var result = box?.get(key);
    List<Sube> listReal = [];

    if (result != null) {
      if (result.runtimeType.toString() ==
          "List<${Sube.getFakeModel().runtimeType.toString()}>") {
        return (result as List<Sube>);
      }
      for (var element in result) {
        if (element.runtimeType.toString() ==
            Sube.getFakeModel().runtimeType.toString()) {
          listReal.add(element);
        } else {
          listReal.add(Sube.fromJson(Map<String, dynamic>.from(element)));
        }
      }
    }

    return listReal;
  }

  Future<void> putItem(String key, List<Sube> item) async {
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
    if (!Hive.isAdapterRegistered(SubeAdapter().typeId)) {
      Hive.registerAdapter(SubeAdapter());
    }
  }
}
