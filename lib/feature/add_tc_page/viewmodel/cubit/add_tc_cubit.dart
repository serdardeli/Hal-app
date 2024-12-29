import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hal_app/project/cache/bildirim_list_cache_manager_new.dart';
import '../../../../project/cache/depo_cache_manager.dart';
import '../../../../project/cache/hal_ici_isyeri_cache_manager.dart';
import '../../../../project/cache/sube_cache_manager.dart';
import '../../../../project/model/depo/depo_model.dart';
import '../../../../project/model/hal_ici_isyeri/hal_ici_isyeri_model.dart';
import '../../../../project/model/kayitli_kisi_model/kayitli_kisi_model.dart';
import '../../../../project/model/sube/sube_model.dart';
import '../../../../core/enum/preferences_keys_enum.dart';
import '../../../../project/model/hks_user/hks_user.dart';
import '../../../../project/service/hal/urun_service.dart';
import '../../../../project/cache/app_cache_manager.dart';
import '../../../../project/cache/bildirimci_cache_manager.dart';
import '../../../../project/cache/user_cache_manager.dart';
import '../../../../project/model/bildirimci/bildirimci_model.dart';
import '../../../../project/service/firebase/firestore/firestore_service.dart';
import '../../../../project/service/hal/bildirim_service.dart';
import '../../../../project/service/hal/genel_service.dart';
import 'package:kartal/kartal.dart';

import '../../../../project/model/user/my_user_model.dart';

part 'add_tc_state.dart';
//tc 4550743384 şifre Halil14  TJ1COJ7CGZ
//tc 3830753863 şifre 123654yB  08JBHVZ2S2
//tc 1900643195 şifre 3636Murat  P172G9Z2
//tc 8920308978 şifre 123654yB  018S26G817

class AddTcCubit extends Cubit<AddTcState> {
  final TextEditingController hksUserNameController = TextEditingController();
  final TextEditingController hksPasswordController = TextEditingController();
  final TextEditingController hksWebServicePasswordController =
      TextEditingController();
  List<String> bildirimciKisiSifatNameList = [];
  var formKey = GlobalKey<FormState>();
  AutovalidateMode isAutoValidateMode = AutovalidateMode.disabled;
  List<HalIciIsyeri> halIciIsyerleriNew = [];
  List<Sube> subeler = [];
  List<Depo> depolar = [];
  KayitliKisi? kayitliKisi;
  Map<String, String>? sifatMap;
  AddTcCubit() : super(AddTcInitial()) {
    //  hksUserNameController.text = "8920308978";
    //  hksPasswordController.text = "123654yB";
    //  hksWebServicePasswordController.text = "018S26G817";
  }
  void clearAllFields() {
    hksPasswordController.clear();
    hksUserNameController.clear();
    hksWebServicePasswordController.clear();

    kayitliKisi = null;
    // subeler.clear();
    // depolar.clear();
    // halIciIsyerleriNew.clear();

    bildirimciKisiSifatNameList.clear();
    disableAutoValidateMode;
  }
  // TODO: NEW BURADA HKSUSER LARI EKLEDİKTEN SONRA INIT ETMEK GERMİYOR MU
  Future<void> addTcNew(BuildContext context) async {
    emit(AddTcLoading());
    BildirimService.instance.assignHksUserInfo(HksUser(
        password: hksPasswordController.text.trim(),
        userName: hksUserNameController.text.trim(),
        webServicePassword: hksWebServicePasswordController.text.trim()));
    GeneralService.instance.assignHksUserInfo(HksUser(
        password: hksPasswordController.text.trim(),
        userName: hksUserNameController.text.trim(),
        webServicePassword: hksWebServicePasswordController.text.trim()));
    UrunService.instance.assignHksUserInfo(HksUser(
        password: hksPasswordController.text.trim(),
        userName: hksUserNameController.text.trim(),
        webServicePassword: hksWebServicePasswordController.text.trim()));

    var result = await kayitliKisiSorguNew();
    if (result) {
      fetchAllSifatList().then((value) {
        fetchInfosAndAddToDb();
      });
      //  emit(UpdateUserInformationsUserFound());
    } else {
      emit(AddTcError(message: "Kayıtlı Kişi Bulunamadı."));
      emit(AddTcInitial());
      return;
    }
  }

  Future<bool> fetchAllDepoSubeHalIciIsyerleri() async {
    try {
      return Future.wait(
              [halIciIsyeriSorguNew(), depolarSorgu(), subelerSorgu()])
          .then((value) {
        if (halIciIsyerleriNew.isEmpty && depolar.isEmpty && subeler.isEmpty) {
          emit(AddTcError(message: "Kişiye ait işyeri,şube,depo bulunamadı"));
          emit(AddTcInitial());
          return false;
        }
        return true;
      });
    } catch (e) {
      emit(AddTcError(message: "${e}bütünyerli çek hata"));
      emit(AddTcInitial());
      return false;
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
        listForDb.add(HalIciIsyeri(
            halAdi: element.halAdi,
            halId: element.halId,
            isYeriSahibiTc: element.isYeriSahibiTc,
            isyeriAdi: element.isyeriAdi,
            isyeriId: element.isyeriId));
      }

      await HalIciIsyeriCacheManager.instance
          .putItem(hksUserNameController.text.trim(), listForDb);
    }
  }

  Future<void> subelerSorgu() async {
    var result = await GeneralService.instance
        .fetchSubelerWithModel(hksUserNameController.text.trim());

    for (var element in result) {


    }
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


    for (var element in result) {


    }
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

  void fetchInfosAndAddToDb() {
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
          emit(AddTcSuccessful());
          emit(AddTcInitial());
        } catch (e) {

          emit(AddTcError(message: "hata hata"));
          emit(AddTcInitial());
        }
      } else {
        return;
      }
    });
  }

  bool isNumeric(String? s) {
    if (s == null || s.trim() == "") {
      return false;
    }
    return double.tryParse(s.trim()) != null;
  }

  Future<void> fetchAllSifatList() async {


    sifatMap = await BildirimService.instance.bildirimSifatListesi();


    if (sifatMap == null || sifatMap!.isEmpty) {
      //TODO: SERVİS İN 200-500 DURUMLARINA GÖRE GÜNCELLEME YAP

      emit(AddTcError(message: "Kullanıcı bilgileri hata"));
      emit(AddTcInitial());
    }
  }

  Future<bool> kayitliKisiSorguNew() async {


    var result = await BildirimService.instance
        .bildirimKayitliKisiSorguWithModel(hksUserNameController.text.trim());


    if (result != null) {


      if (result.kayitliKisimi?.toLowerCase() == true.toString()) {
        if (result.sifatlar.isEmpty) {
          emit(AddTcError(message: "kayitli kişi Sıfatı Bulunamadı"));
          return false;
        }
        kayitliKisi = result;
        sifatAdlariniIdyeGoreBulma(kayitliKisi!.sifatlar);
        return true;
      }
    }


    return false;
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
        if (response.error != null) {
          emit(AddTcError(message: "firestore ${response.error!.message}"));
          emit(AddTcInitial());
        } else {

        }

        emit(AddTcInitial());
      } else {
        emit(AddTcError(message: "kayıtlı kullanıcı bulunamadı"));
        emit(AddTcInitial());
      }
    } else {
      emit(AddTcError(message: "kayıtlı telefon bulunamadı"));
      emit(AddTcInitial());
    }
  }

  Future<void> addBildirimciToService(Bildirimci bildirimciout) async {
    if (kayitliKisi!.sifatlar.ext.isNotNullOrEmpty) {
      var response =
          await FirestoreService.instance.saveBildirimciTc(bildirimciout);
      await addUserToService();

      if (response.error != null) {
        emit(AddTcError(message: "firestore ${response.error!.message}"));
        emit(AddTcInitial());
      } else {


        emit(AddTcInitial());
      }
    } else {
      emit(AddTcError(
          message: "kayitli kişi değil yada bilgileri yanlış girdiniz"));
      emit(AddTcInitial());
    }
  }

  void get activateAutoValidateMode {
    isAutoValidateMode = AutovalidateMode.always;
    emit(AddTcInitial());
  }

  void get disableAutoValidateMode {
    isAutoValidateMode = AutovalidateMode.disabled;
    emit(AddTcInitial());
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

      //sifat listesini yeniden çek
    }
  }
}
