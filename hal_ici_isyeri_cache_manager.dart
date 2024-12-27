import 'package:hive/hive.dart';

import '../model/hal_ici_isyeri/hal_ici_isyeri_model.dart';

class HalIciIsyeriCacheManager {
  static HalIciIsyeriCacheManager? _instance;
  static HalIciIsyeriCacheManager get instance =>
      _instance ??= HalIciIsyeriCacheManager._();
  HalIciIsyeriCacheManager._() {
    key = "hal_ici_isyeri_list_cache_manager";
  }
  late final String key;
  Box<List<dynamic>>? box;

  Future<void> putItem(String key, List<HalIciIsyeri> item) async { 
    await box?.put(key, item);
  }
  Future<void> init() async {
    registerAdapters();
    if (!(box?.isOpen ?? false)) {
      box = await Hive.openBox(key);
    }
  }

  List<HalIciIsyeri> getItem(String key) {
    var result = box?.get(key);
    List<HalIciIsyeri> listReal = [];

    if (result != null) {
      if (result.runtimeType.toString() ==
          "List<${HalIciIsyeri.getFakeModel().runtimeType.toString()}>") {
        return (result as List<HalIciIsyeri>);
      }
      for (var element in result) {
        if (element.runtimeType.toString() ==
            HalIciIsyeri.getFakeModel().runtimeType.toString()) {
          listReal.add(element);
        } else {
          listReal
              .add(HalIciIsyeri.fromJson(Map<String, dynamic>.from(element)));
        }
      }
    }

    return listReal;
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
    if (!Hive.isAdapterRegistered(HalIciIsyeriAdapter().typeId)) {
      Hive.registerAdapter(HalIciIsyeriAdapter());
    }
  }
}
