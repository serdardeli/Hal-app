import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:hal_app/feature/helper/active_tc.dart';
import 'package:hal_app/project/cache/bildirimci_cache_manager.dart';
import 'package:hal_app/project/cache/musteri_list_cache_manager.dart';
import 'package:hal_app/project/model/musteri_model/musteri_model.dart';
import 'package:meta/meta.dart';
import 'package:turkish/turkish.dart';

import '../../../../../../../project/cache/musteri_depo_cache_manager.dart';
import '../../../../../../../project/cache/musteri_hal_ici_isyeri_cache_manager.dart';
import '../../../../../../../project/cache/musteri_sube_cache_manager.dart';
import '../../../../../../../project/model/bildirimci/bildirimci_model.dart';
import '../../../../../../../project/model/depo/depo_model.dart';
import '../../../../../../../project/model/hal_ici_isyeri/hal_ici_isyeri_model.dart';
import '../../../../../../../project/model/hks_user/hks_user.dart';
import '../../../../../../../project/model/kayitli_kisi_model/kayitli_kisi_model.dart';
import '../../../../../../../project/model/sube/sube_model.dart';
import '../../../../../../../project/service/hal/bildirim_service.dart';
import '../../../../../../../project/service/hal/genel_service.dart';

part 'add_musteri_sub_state.dart';
part './extension/add_musteri_sub_extension.dart';

enum CustomerStatus { customerFound, customerNotFound, idle }

class AddMusteriSubCubit extends Cubit<AddMusteriSubState> {
  AddMusteriSubCubit() : super(AddMusteriSubInitial());
  TextEditingController tcController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  String? selectedNotFoundCustomerSifatName;
  String? selectedNotFoundCustomerSifatId;
  String? selectedNotFoundMalinGidecegiYerAdi;
  String? selectedNotFoundMalinGidecegiYerId;
  String? selectedIl;
  String? selectedIlce;
  String? selectedBelde;
  Map<String, String> malinGidecegiYerlerForNonRegisterUser = {
    "1": "Şube",
    "18": "Bireysel Tüketim",
    "19": "Perakende Satiş Yeri"
  };
  final formKey = GlobalKey<FormState>();
  final adSoyadformKey = GlobalKey<FormState>();
  CustomerStatus customerStatus = CustomerStatus.idle;
  AutovalidateMode isAutoValidateMode = AutovalidateMode.disabled;
  bool isNumeric(String? s) {
    if (s == null || s.trim() == "") {
      return false;
    }
    return double.tryParse(s.trim()) != null;
  }

////****----- */
  //İL İLÇE BELDE MODULE
  Map<String, String> _iller = {};
  Map<String, String> _ilceler = {};
  Map<String, String> _beldeler = {};
  String _ilId = "";
  String _ilceId = "";
  String _beldeId = "";
  final TextEditingController ilController = TextEditingController();
  final TextEditingController ilceController = TextEditingController();
  final TextEditingController beldeController = TextEditingController();

  ///***------ */
  Map<String, String> customerNotFoundSifatlar = {
    "9": "Depo/Tasnif ve Ambalaj",
    "24": "E-Market",
    "19": "Hastane",
    "13": "Lokanta",
    "8": "Manav",
    "7": "Market",
    "12": "Otel",
    "11": "Pazarcı",
    "15": "Yemek Fabrikası",
    "14": "Yurt"
  };

  late KayitliKisi kayitliKisi;

  List<HalIciIsyeri> halIciIsyerleriNew = [];
  List<Sube> subeler = [];
  List<Depo> depolar = [];
  Map<String, String>? sifatMap;
  List<String> sifatNameList = [];
  Future<void> fetchAllSifatList() async {
    //TODO: GERİ GİDERKEN ASSİGN İŞLENİMİ DÜŞÜN
    Bildirimci? bildirimci = await BildirimciCacheManager.instance
        .getItem(ActiveTc.instance.activeTc);
    if (bildirimci != null) {
      BildirimService.instance.assignHksUserInfo(HksUser(
          password: bildirimci.hksSifre!.trim(),
          userName: bildirimci.bildirimciTc!.trim(),
          webServicePassword: bildirimci.webServiceSifre!.trim()));

      sifatMap = await BildirimService.instance.bildirimSifatListesi();

      if (sifatMap == null || sifatMap!.isEmpty) {
        //TODO: SERVİS İN 200-500 DURUMLARINA GÖRE GÜNCELLEME YAP

        emit(AddMusteriSubError(message: "Girdiğiniz Bilgiler Hatalı"));
        emit(AddMusteriSubInitial());
      } else {
        // emit(UpdateUserInformationsSuccessful(message: "Bilgiler Doğru"));
        // emit(UpdateUserInformationsInitial());

      }
    }
  }

  clearAllInfos() {
    _ilceler.clear();
    _beldeler.clear();
    subeler = [];
    depolar = [];
    isUpdateState = false;
    halIciIsyerleriNew = [];
    tcController.clear();
    nameController.clear();
    phoneController.clear();
    sifatNameList.clear();
    selectedNotFoundCustomerSifatId = null;
    selectedNotFoundCustomerSifatName = null;
    selectedNotFoundMalinGidecegiYerAdi = null;
    selectedNotFoundMalinGidecegiYerId = null;
    customerStatus = CustomerStatus.idle;
  }

  Future<List<String>> sifatAdlariniIdyeGoreBulma(List<String> idList) async {
    if (sifatMap != null) {
      List<String> list = [];
      sifatMap!.entries.forEach((element) {
        idList.forEach((item) {
          if (element.key == item) {
            list.add(element.value);
          }
        });
      });

      return list;
    } else {
      return fetchAllSifatList().then((value) async {
        List<String> list = [];
        sifatMap!.entries.forEach((element) {
          idList.forEach((item) {
            if (element.key == item) {
              list.add(element.value);
            }
          });
        });

        return list;
      });
    }
  }

  Future<void> gidecegiIsyeriSifatSorgula() async {
    emit(AddMusteriSubLoading());
    customerStatus = CustomerStatus.idle;

    subeler = [];
    depolar = [];
    halIciIsyerleriNew = [];
    sifatNameList.clear();
    var result = await BildirimService.instance
        .bildirimKayitliKisiSorguWithModel(tcController.text.trim());
    if (result != null) {
      kayitliKisi = result;
      if (result.kayitliKisimi.toString() == "true") {

        sifatNameList = await sifatAdlariniIdyeGoreBulma(result.sifatlar);
        if (sifatNameList.isNotEmpty) {
          Future.wait([halIciIsyeriSorguNew(), subelerSorgu(), depolarSorgu()])
              .then((value) {
            if (halIciIsyerleriNew.isEmpty &&
                subeler.isEmpty &&
                depolar.isEmpty) {
              customerStatus = CustomerStatus.customerNotFound;

              emit(AddMusteriSubError(
                  message:
                      "Kayitli Kişiye Şube, Depo, Hal içi işyeri bulunamadı"));
              emit(AddMusteriSubInitial());
            } else {
              customerStatus = CustomerStatus.customerFound;

              emit(AddMusteriSubUserInfoFound());
              emit(AddMusteriSubInitial());
            }
          });
          //hal ici
          //sube
          //depo
        } else {
          customerStatus = CustomerStatus.customerNotFound;
          emit(AddMusteriSubInitial());
        }
      } else {
        customerStatus = CustomerStatus.customerNotFound;

        emit(AddMusteriSubError(message: "Kayitli Kişi Bulunamadı"));
        emit(AddMusteriSubInitial());
      }
    } else {
      customerStatus = CustomerStatus.customerNotFound;

      emit(AddMusteriSubError(message: "Kayitli Kişi Bulunamadı 2"));
      emit(AddMusteriSubInitial());
    }
  }

  Future<void> halIciIsyeriSorguNew() async {


    var result = await GeneralService.instance
        .fetchAllHalIciIsyerleriWithModelNew(tcController.text.trim());


    result.forEach((element) {


    });
    if (result.isNotEmpty) {
      halIciIsyerleriNew = result;
    }
  }

  Future<void> subelerSorgu() async {
    var result = await GeneralService.instance
        .fetchSubelerWithModel(tcController.text.trim());


    result.forEach((element) {


    });
    if (result.isNotEmpty) {
      subeler = result;
    }
  }

  Future<void> depolarSorgu() async {
    var result = await GeneralService.instance
        .fetchDepolarWithModel(tcController.text.trim());


    result.forEach((element) {


    });
    if (result.isNotEmpty) {
      depolar = result;
    }
  }

  Future<void> gidecegiIsyeriTcSorgula() async {
    // var sifatResult = await gidecegiIsyeriSifatSorgula();
    // if (sifatResult) {
    //   final result = await GeneralService.instance
    //       .fetchAllHalIciIsyeriWithModel(tcController.text.trim());
    //   if (result == null) {
    //     isyeri = result;

    //     emit(SevkEtmeError(message: "İşyeri bulunamadı"));
    //     emit(AddMusteriSubInitial());
    //     tcSorgulamaErrorText =
    //         "İşyeri bulunamadı \n Kayıtlı olmayan işyerine sevk işlemi yapamazsınız";
    //   } else {
    //     isyeri = result;
    //     tcSorgulamaErrorText = "";

    //     emit(AddMusteriSubInitial());
    //   }

    // } else {
    //   isyeri = null;

    //   tcSorgulamaErrorText =
    //       "İşyeri bulunamadı \n Kayıtlı olmayan işyerine sevk işlemi yapamazsınız";
    // }
  }

  void activateAutoValidateMode() {
    isAutoValidateMode = AutovalidateMode.always;
    emit(AddMusteriSubInitial());
  }

  void disableAutoValidateMode() {
    isAutoValidateMode = AutovalidateMode.disabled;
    emit(AddMusteriSubInitial());
  }

  bool isUpdateState = false;

  Future<void> musteriEkle() async {

    emit(AddMusteriSubLoading());
    if (customerStatus == CustomerStatus.customerFound) {
      await MusteriListCacheManager.instance.addItem(
          ActiveTc.instance.activeTc,
          Musteri(
              musteriAdiSoyadi: nameController.text.trim(),
              musteriSifatIdList: kayitliKisi.sifatlar,
              musteriSifatNameList: sifatNameList,
              musteriTc: tcController.text.trim(),
              isregisteredToHks: true));
      await MusteriHalIciIsyeriCacheManager.instance
          .putItem(tcController.text.trim(), halIciIsyerleriNew);
      await MusteriSubelerCacheManager.instance
          .putItem(tcController.text.trim(), subeler);
      await MusteriDepolarCacheManager.instance
          .putItem(tcController.text.trim(), depolar);
      emit(AddMusteriSubSuccessful());
      emit(AddMusteriSubInitial());
    } else {
      Musteri musteri = Musteri(
          musteriAdiSoyadi: nameController.text.trim(),
          musteriSifatIdList: [selectedNotFoundCustomerSifatId!],
          musteriSifatNameList: [selectedNotFoundCustomerSifatName!],
          musteriTc: tcController.text.trim(),
          musteriTel: phoneController.text.trim(),
          isregisteredToHks: false,
          musteriBeldeAdi: selectedBelde,
          musteriBeldeId: _beldeId,
          musteriIlAdi: selectedIl,
          musteriIlId: _ilId,
          musteriIlceAdi: selectedIlce,
          musteriIlceId: _ilceId,
          selectedNotFoundMalinGidecegiYerAdi:
              selectedNotFoundMalinGidecegiYerAdi,
          selectedNotFoundMalinGidecegiYerId:
              selectedNotFoundMalinGidecegiYerId);

      await MusteriListCacheManager.instance
          .addItem(ActiveTc.instance.activeTc, musteri);

      emit(AddMusteriSubSuccessful());
      emit(AddMusteriSubInitial());
    }
  }

  void setIsUpdate(bool value) {
    isUpdateState = value;
    emit(AddMusteriSubInitial());
  }

  void fillMusteriData(Musteri musteri) {
    clearAllInfos();
    isUpdateState = true;

    // _ilceler.clear();
    // _beldeler.clear();



    tcController.text = musteri.musteriTc;

    if (musteri.isregisteredToHks) {
      nameController.text = musteri.musteriAdiSoyadi;
      kayitliKisi = KayitliKisi(
          kayitliKisimi: "true", sifatlar: musteri.musteriSifatIdList);
      customerStatus = CustomerStatus.customerFound;
      musteri.musteriSifatNameList.forEach((element) {
        sifatNameList.add(element);
      });

      subeler =
          MusteriSubelerCacheManager.instance.getItem(tcController.text.trim());
      depolar =
          MusteriDepolarCacheManager.instance.getItem(tcController.text.trim());
      halIciIsyerleriNew = MusteriHalIciIsyeriCacheManager.instance
          .getItem(tcController.text.trim());
    } else {
      kayitliKisi = KayitliKisi(
          kayitliKisimi: "false", sifatlar: musteri.musteriSifatIdList);
      phoneController.text = musteri.musteriTel ?? "hata";
      nameController.text = musteri.musteriAdiSoyadi;

      customerStatus = CustomerStatus.customerNotFound;
      musteri.musteriSifatNameList.forEach((element) {
        sifatNameList.add(element);
      });
      if (sifatNameList.isNotEmpty) {
        selectedNotFoundCustomerSifatName = sifatNameList.first;
        findSifatIdFromName();
      }
      _ilId = musteri.musteriIlId ?? "";
      _ilceId = musteri.musteriIlceId ?? "";
      _beldeId = musteri.musteriBeldeId ?? "";

      selectedIl = musteri.musteriIlAdi;
      selectedIlce = musteri.musteriIlceAdi;
      selectedBelde = musteri.musteriBeldeAdi;
      selectedNotFoundMalinGidecegiYerAdi =
          musteri.selectedNotFoundMalinGidecegiYerAdi;
      selectedNotFoundMalinGidecegiYerId =
          musteri.selectedNotFoundMalinGidecegiYerId;
    }

    emit(AddMusteriSubInitial());
  }

  void removeMusteri() {
    MusteriListCacheManager.instance
        .removeOneUretici(ActiveTc.instance.activeTc, nameController.text.trim());
    emit(AddMusteriSubDeleted());
  }

  void findSifatIdFromName() {
    customerNotFoundSifatlar.forEach((key, value) {
      if (value == selectedNotFoundCustomerSifatName) {
        selectedNotFoundCustomerSifatId = key;
      }
    });
  }

  void findGidecegiYerIdFromName() {
    malinGidecegiYerlerForNonRegisterUser.forEach((key, value) {
      if (value == selectedNotFoundMalinGidecegiYerAdi) {
        selectedNotFoundMalinGidecegiYerId = key;
      }
    });
  }

  void notFoundCustomerSifatSelected() {
    findSifatIdFromName();

    emit(AddMusteriSubInitial());
  }

  void notFoundCustomerMalinGidecegiYerSelected() {
    findGidecegiYerIdFromName();

    emit(AddMusteriSubInitial());
  }

  Future<void> musteriGuncelle() async {
    emit(AddMusteriSubLoading());
  }
}
