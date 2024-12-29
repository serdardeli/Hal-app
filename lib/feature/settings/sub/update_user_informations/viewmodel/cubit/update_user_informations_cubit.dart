import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:hal_app/project/cache/depo_cache_manager.dart';
import 'package:hal_app/project/cache/hal_ici_isyeri_cache_manager.dart';
import 'package:hal_app/project/model/depo/depo_model.dart';
import 'package:hal_app/project/model/kayitli_kisi_model/kayitli_kisi_model.dart';
import 'package:hal_app/project/model/sube/sube_model.dart';
import '../../../../../../core/enum/preferences_keys_enum.dart';
import '../../../../../../project/cache/app_cache_manager.dart';
import '../../../../../../project/cache/bildirim_list_cache_manager_new.dart';
import '../../../../../../project/cache/bildirimci_cache_manager.dart';
import '../../../../../../project/cache/sube_cache_manager.dart';
import '../../../../../../project/cache/user_cache_manager.dart';
import '../../../../../../project/model/hal_ici_isyeri/hal_ici_isyeri_model.dart';
import '../../../../../../project/model/hks_user/hks_user.dart';

import '../../../../../../project/model/bildirimci/bildirimci_model.dart';
import '../../../../../../project/model/user/my_user_model.dart';
import '../../../../../../project/service/firebase/firestore/firestore_service.dart';
import '../../../../../../project/service/hal/bildirim_service.dart';
import '../../../../../../project/service/hal/genel_service.dart';

part 'update_user_informations_state.dart';

class UpdateUserInformationsCubit extends Cubit<UpdateUserInformationsState> {
  UpdateUserInformationsCubit() : super(UpdateUserInformationsInitial());
  final TextEditingController hksUserNameController = TextEditingController();
  final TextEditingController hksPasswordController = TextEditingController();
  final TextEditingController hksWebServicePasswordController =
      TextEditingController();
  var formKey = GlobalKey<FormState>();
  AutovalidateMode isAutoValidateMode = AutovalidateMode.disabled;
  KayitliKisi? kayitliKisi;
  List<HalIciIsyeri> halIciIsyerleriNew = [];
  List<Sube> subeler = [];
  List<Depo> depolar = [];
  List<String> sifatNameList = [];

  Map<String, String>? sifatMap;
  List<String> bildirimciKisiSifatNameList = [];
  HalIciIsyeri? isyeri;
  void clearAllFields() {
    hksPasswordController.clear();
    hksUserNameController.clear();
    hksWebServicePasswordController.clear();

    kayitliKisi = null;
    subeler.clear();
    depolar.clear();
    halIciIsyerleriNew.clear();
    sifatNameList.clear();

    bildirimciKisiSifatNameList.clear();
    disableAutoValidateMode;
  }

  Map<String, String> sifatlar = {
    "9": "Depo/Tasnif ve Ambalaj",
    "24": "E-Market",
    "19": "Hastane",
    "2": "İhracat",
    "23": "İmalatçı",
    "3": "İthalat",
    "13": "Lokanta",
    "8": "Manav",
    "7": "Market",
    "12": "Otel",
    "11": "Pazarcı",
    "1": "Sanayici",
    "5": "Komisyoncu",
    "20": "Tüccar (Hal Dışı)",
    "6": "Tüccar (Hal İçi)",
    "4": "Üretici",
    "10": "Üretici Örgütü",
    "15": "Yemek Fabrikası",
    "14": "Yurt",
  };
  Future<void> fetchAllSifatList() async {
    //TODO: GERİ GİDERKEN ASSİGN İŞLENİMİ DÜŞÜN
    BildirimService.instance.assignHksUserInfo(HksUser(
        password: hksPasswordController.text.trim(),
        userName: hksUserNameController.text.trim(),
        webServicePassword: hksWebServicePasswordController.text.trim()));
    sifatMap = await BildirimService.instance.bildirimSifatListesi();
    if (sifatMap == null || sifatMap!.isEmpty) {
      //TODO: SERVİS İN 200-500 DURUMLARINA GÖRE GÜNCELLEME YAP

      emit(UpdateUserInformationsError(message: "Girdiğiniz Bilgiler Hatalı"));
      emit(UpdateUserInformationsInitial());
    } else {
      // emit(UpdateUserInformationsSuccessful(message: "Bilgiler Doğru"));
      // emit(UpdateUserInformationsInitial());
    }
  }

  Future<void> halIciIsyeriSorguNew() async {
    var result = await GeneralService.instance
        .fetchAllHalIciIsyerleriWithModelNew(hksUserNameController.text.trim());

    for (var element in result) {}

    if (result.isNotEmpty) {
      halIciIsyerleriNew = result;
      List<HalIciIsyeri> listForDb = [];
      for (var element in halIciIsyerleriNew) {
        listForDb.add(HalIciIsyeri.fromJson(element.toJson()));
      }
      await HalIciIsyeriCacheManager.instance
          .putItem(hksUserNameController.text.trim(), listForDb);
    }
  }

  Future<void> subelerSorgu() async {
    var result = await GeneralService.instance
        .fetchSubelerWithModel(hksUserNameController.text.trim());

    for (var element in result) {}

    if (result.isNotEmpty) {
      subeler = result;
      List<Sube> listForDb = [];

      for (var element in subeler) {
        listForDb.add(Sube.fromJson(element.toJson()));
      }
      await SubelerCacheManager.instance
          .putItem(hksUserNameController.text.trim(), listForDb);
    }
  }

  Future<void> depolarSorgu() async {
    var result = await GeneralService.instance
        .fetchDepolarWithModel(hksUserNameController.text.trim());

    for (var element in result) {}
    if (result.isNotEmpty) {
      depolar = result;
      List<Depo> listForDb = [];

      for (var element in depolar) {
        listForDb.add(Depo.fromJson(element.toJson()));
      }
      await DepolarCacheManager.instance
          .putItem(hksUserNameController.text.trim(), listForDb);
    }
  }

  Future<bool> kayitliKisiSorguNew() async {
    var result = await BildirimService.instance
        .bildirimKayitliKisiSorguWithModel(hksUserNameController.text.trim());
    if (result != null) {
      if (result.kayitliKisimi?.toLowerCase() == true.toString()) {
        if (result.sifatlar.isEmpty) {
          emit(UpdateUserInformationsError(
              message: "kayitli kişi Sıfatı Bulunamadı"));
          return false;
        }

        kayitliKisi = result;
        sifatAdlariniIdyeGoreBulma(kayitliKisi!.sifatlar);

        return true;
      }
    }
    return false;
  }

  bool isNumeric(String? s) {
    if (s == null || s.trim() == "") {
      return false;
    }
    return double.tryParse(s.trim()) != null;
  }

  void setSelectedBildirimciTc(Bildirimci bildirimci) {
    clearAllFields();

    hksUserNameController.text = bildirimci.bildirimciTc!;
    hksPasswordController.text = bildirimci.hksSifre!;
    hksWebServicePasswordController.text = bildirimci.webServiceSifre!;

    bildirimci.kayitliKisiSifatIdList?.forEach(
      (element) {
        sifatlar.forEach((key, value) {
          if (key == element) {
            sifatNameList.add(value);
          }
        });
      },
    );

    subeler =
        SubelerCacheManager.instance.getItem(bildirimci.bildirimciTc!.trim());
    depolar =
        DepolarCacheManager.instance.getItem(bildirimci.bildirimciTc!.trim());
    halIciIsyerleriNew = HalIciIsyeriCacheManager.instance
        .getItem(bildirimci.bildirimciTc!.trim());

    emit(UpdateUserInformationsInitial());
  }

  Future<void> updateInfosRequestNew() async {
    emit(UpdateUserInformationsLoading());

    var result = await kayitliKisiSorguNew();
    if (result) {
      await fetchAllSifatList();
      emit(UpdateUserInformationsUserFound());
    } else {
      emit(UpdateUserInformationsError(message: "Kayıtlı Kişi Bulunamadı."));
      emit(UpdateUserInformationsInitial());
      return;
    }
  }

  Future<List<String>> sifatAdlariniIdyeGoreBulma(List<String> idList) async {
    bildirimciKisiSifatNameList.clear();

    if (sifatMap != null) {
      List<String> list = [];
      for (var element in sifatMap!.entries) {
        for (var item in idList) {
          if (element.key == item) {
            bildirimciKisiSifatNameList.add(element.value);
            list.add(element.value);
          }
        }
      }

      return list;
    } else {
      return fetchAllSifatList().then((value) async {
        List<String> list = [];
        for (var element in sifatMap!.entries) {
          for (var item in idList) {
            if (element.key == item) {
              bildirimciKisiSifatNameList.add(element.value);
              list.add(element.value);
            }
          }
        }

        return list;
      });
    }
  }

  Future<bool> fetchAllDepoSubeHalIciIsyerleri() async {
    try {
      return await Future.wait(
              [halIciIsyeriSorguNew(), depolarSorgu(), subelerSorgu()])
          .then((value) {
        if (halIciIsyerleriNew.isEmpty && depolar.isEmpty && subeler.isEmpty) {
          emit(UpdateUserInformationsError(
              message: "Kişiye ait işyeri,şube,depo bulunamadı"));
          emit(UpdateUserInformationsInitial());
          return false;
        }
        return true;
      });
    } catch (e) {
      emit(UpdateUserInformationsError(message: "${e}bütünyerli çek hata"));
      emit(UpdateUserInformationsInitial());
      return false;
    }
  }

  void fetchInfosAndAddToDb() {
    emit(UpdateUserInformationsLoading());

    fetchAllDepoSubeHalIciIsyerleri().then((value) {
      if (value) {
        try {
          List<Map> listOfBildirim = [];
          CustomNotificationSaveCacheManager.instance
              .getItem(hksUserNameController.text.trim())
              .forEach((element) {
            listOfBildirim.add(element.toJson());
          });
          Bildirimci bildirimci = Bildirimci(
              phoneNumber:
                  AppCacheManager.instance.getItem(PreferencesKeys.phone.name),
              hasDepo: depolar.isNotEmpty,
              hasSube: subeler.isNotEmpty,
              hasHalIciIsyeri: halIciIsyerleriNew.isNotEmpty,
              kayitliKisiSifatIdList: kayitliKisi?.sifatlar,
              kayitliKisiSifatNameList: bildirimciKisiSifatNameList,
              hksSifre: hksPasswordController.text.trim(),
              webServiceSifre: hksWebServicePasswordController.text.trim(),
              bildirimciTc: hksUserNameController.text.trim(),
              bildirimList: listOfBildirim,
              gidecegiYerUpdated: true);

          BildirimciCacheManager.instance
              .putItem(hksUserNameController.text.trim(), bildirimci)
              .then((value) {
            addBildirimciToService(bildirimci);
          });
          emit(UpdateUserInformationsSuccessful());
          emit(UpdateUserInformationsInitial());
        } catch (e) {
          emit(UpdateUserInformationsError(message: "hata hata"));
          emit(UpdateUserInformationsInitial());
        }
      } else {
        return;
      }
    });
  }

  Future<void> addBildirimciToService(Bildirimci bildirimci) async {
    var response = await FirestoreService.instance.saveBildirimciTc(bildirimci);
    await addUserToService();
  }

  Future<void> addUserToService() async {
    String? number =
        AppCacheManager.instance.getItem(PreferencesKeys.phone.name);
    if (number != null) {
      MyUser? user = UserCacheManager.instance.getItem(number);
      if (user != null) {
        MyUser userForService = MyUser.fromJson(user.toJson());
        userForService.tcList ??= [];
        userForService.tcList!.add(hksUserNameController.text.trim());

        var response =
            await FirestoreService.instance.saveUserInformations(user);
      }
    }
  }

  void get activateAutoValidateMode {
    isAutoValidateMode = AutovalidateMode.always;
    emit(UpdateUserInformationsInitial());
  }

  void get disableAutoValidateMode {
    isAutoValidateMode = AutovalidateMode.disabled;
    emit(UpdateUserInformationsInitial());
  }
}
