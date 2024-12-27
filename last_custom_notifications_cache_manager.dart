import 'dart:developer';

import '../model/uretici_model/uretici_model.dart';
import '../model/urun/urun.dart';

import '../model/bildirimci/bildirimci_model.dart';
import 'package:hive/hive.dart';

import '../model/bildirim/bildirim_model.dart';
import '../model/custom_notification_save_model.dart/custom_notification_save_model.dart';

class LastCustomNotificationSaveCacheManager {
  static LastCustomNotificationSaveCacheManager? _instance;
  static LastCustomNotificationSaveCacheManager get instance =>
      _instance ??= LastCustomNotificationSaveCacheManager._();

  LastCustomNotificationSaveCacheManager._() {
    key = "last_bildirim_cache_manager_new";
  }
  late final String key;
  Box<List<dynamic>>? box;

  Future<void> init() async {
    registerAdapters();
    if (!(box?.isOpen ?? false)) {
      box = await Hive.openBox(key);
    }
    /*if (_box == null) {
      _box = await Hive.openBox(key);
    }*/
  }

  sortList(List<dynamic> list) {
    int lengthOfArray = list.length;
    for (int i = 0; i < lengthOfArray - 1; i++) {
      for (int j = 0; j < lengthOfArray - i - 1; j++) {
        if (list[j]["addedCount"] == null) {
          list[j]["addedCount"] = 0;
        }
        if (list[j + 1]["addedCount"] == null) {
          list[j + 1]["addedCount"] = 0;
        }
        if (list[j]["addedCount"] < list[j + 1]["addedCount"]) {
          // Swapping using temporary variable
          var temp = list[j];
          list[j] = list[j + 1];
          list[j + 1] = temp;
        }
      }
    }
    return (list);
  }

  List<dynamic> sortListCustomTotalAddedCount(List<dynamic> list) {
    List<CustomNotificationSaveModel> listForSort = [];
    for (var element in list) {
      if (element.runtimeType ==
          CustomNotificationSaveModel.getFakeModel().runtimeType) {
        listForSort.add(element);
      } else {
        var newItem = CustomNotificationSaveModel.fromJson(
            Map<String, dynamic>.from(element));
        listForSort.add(newItem);
      }
    }
    int lengthOfArray = listForSort.length;
    for (int i = 0; i < lengthOfArray - 1; i++) {
      for (int j = 0; j < lengthOfArray - i - 1; j++) {
        if (listForSort[j].totalAddedCount == null) {
          listForSort[j].totalAddedCount = 0;
        }
        if (listForSort[j + 1].totalAddedCount == null) {
          listForSort[j + 1].totalAddedCount = 0;
        }
        if (listForSort[j].totalAddedCount! <
            listForSort[j + 1].totalAddedCount!) {
          // Swapping using temporary variable
          var temp = listForSort[j];
          listForSort[j] = listForSort[j + 1];
          listForSort[j + 1] = temp;
        }
      }
    }
    return (listForSort);
  }

  Future<void> addItems(String key, List<Bildirim> items) async {}

  bool checkTwoListIsDifferent(
      List<Bildirim> firstList, List<Bildirim> secondList) {
    bool hasEqualtItem = false;
    for (var first in firstList) {
      for (var second in secondList) {
        if (first == second) {
          hasEqualtItem = true;
        }
      }
      if (hasEqualtItem) {
        continue;
      } else {
        return false;
      }
    }
    return true;
  }

  Future<void> addItem(
      String key, CustomNotificationSaveModel saveModel) async {
    var result = box?.get(key) ?? [];
    result.add(saveModel);

    await box?.put(key, result);
  }

  Future<void> addItemCopy3(
      String key, CustomNotificationSaveModel saveModel) async {

    var result = box?.get(key) ?? [];
    var isExist = false;


    if (result.isNotEmpty) {


      for (var i = 0; i < result.length; i++) {
        //  if(){}

        CustomNotificationSaveModel elementFromDb;
        if (result[i].runtimeType ==
            CustomNotificationSaveModel.getFakeModel().runtimeType) {

          elementFromDb = result[i];
        } else {
          elementFromDb = CustomNotificationSaveModel.fromJson(
              Map<String, dynamic>.from(result[i]));
        }

        //CustomNotificationSaveModel.fromJson(
        //    Map<String, dynamic>.from(result[i]));
        if (saveModel == elementFromDb) {


          var totalAddedCount = elementFromDb.incrementTotalAddedCount();
          var weeklyAddedCount = elementFromDb.incrementWeeklyAddedCount();



          saveModel.totalAddedCount = totalAddedCount;
          saveModel.weeklyAddedCount = weeklyAddedCount;

          if (result[i].runtimeType ==
              CustomNotificationSaveModel.getFakeModel().runtimeType) {
            result[i] = saveModel;
          } else {
            result[i] = saveModel.toJson();
          }
          //  result = sortList(result);
          var list = sortListCustomTotalAddedCount(result);
          box?.put(key, list);
          isExist = true;
          return;
        }
      }
    } else {



      saveModel.totalAddedCount = 1;
      saveModel.weeklyAddedCount = 1;


      //saveModel.save();


      result.add(saveModel);


      await box?.put(key, result);
      return;
    }
    if (!isExist) {



      saveModel.totalAddedCount = 1;
      saveModel.weeklyAddedCount = 1;
      // saveModel.save();

      result.add(saveModel);
      var list = sortListCustomTotalAddedCount(result);
      await box?.put(key, list);
    }
  }

  List<CustomNotificationSaveModel> getItem(String key) {
    var result = box?.get(key);
    List<CustomNotificationSaveModel> listReal = [];

    if (result != null) {
      if (result.runtimeType.toString() ==
          "List<CustomNotificationSaveModel>") {
        return (result as List<CustomNotificationSaveModel>);
      }
      for (var element in result) {
        if (element.runtimeType.toString() == "CustomNotificationSaveModel") {
          listReal.add(element);
        } else {
          listReal.add(CustomNotificationSaveModel.fromJson(
              Map<String, dynamic>.from(element)));
        }
      }
    }


    return listReal;
  }

  Future<void> putItem(
      String key, List<CustomNotificationSaveModel> item) async {
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
    if (!Hive.isAdapterRegistered(
        CustomNotificationSaveModelAdapter().typeId)) {
      Hive.registerAdapter(CustomNotificationSaveModelAdapter());
    }
    //  if (!Hive.isAdapterRegistered(UrunAdapter().typeId)) {
    //    Hive.registerAdapter(UrunAdapter());
    //  }
    //  if (!Hive.isAdapterRegistered(UreticiAdapter().typeId)) {
    //    Hive.registerAdapter(UreticiAdapter());
    //  }
  }
}
