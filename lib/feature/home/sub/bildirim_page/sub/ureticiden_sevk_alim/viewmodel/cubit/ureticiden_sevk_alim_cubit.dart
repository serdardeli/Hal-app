import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:meta/meta.dart';
import 'package:turkish/turkish.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp_share2/whatsapp_share2.dart';

import '../../../../../../../../project/cache/bildirim_list_cache_manager_new.dart';
import '../../../../../../../../project/cache/bildirimci_cache_manager.dart';
import '../../../../../../../../project/cache/last_custom_notifications_cache_manager.dart';
import '../../../../../../../../project/cache/mysoft_user_cache_mananger.dart';
import '../../../../../../../../project/cache/uretici_list_cache_manager.dart';
import '../../../../../../../../project/model/MySoft_user_model/mysoft_user_model.dart';
import '../../../../../../../../project/model/bildirim_kayit_response_model.dart/bildirim_kayit_response_model.dart';
import '../../../../../../../../project/model/bildirim_kayit_response_model.dart/sub/bildirim_kayit_cevap_model.dart';
import '../../../../../../../../project/model/bildirimci/bildirimci_model.dart';
import '../../../../../../../../project/model/custom_notification_save_model.dart/custom_notification_save_model.dart';
import '../../../../../../../../project/model/driver_model/driver_model.dart';
import '../../../../../../../../project/model/hks_bildirim_model/hks_bildirim_model.dart';
import '../../../../../../../../project/model/malin_gidecegi_yer/malin_gidecegi_yer_model.dart';
import '../../../../../../../../project/model/uretici_model/uretici_model.dart';
import '../../../../../../../../project/model/urun/urun.dart';
import '../../../../../../../../project/service/hal/bildirim_service.dart';
import '../../../../../../../../project/service/hal/genel_service.dart';
import '../../../../../../../../project/service/hal/urun_service.dart';
import '../../../../../../../../project/service/mysoft/auth/mysoft_auth_service.dart';
import '../../../../../../../../project/service/mysoft/fatura/mysoft_fatura_service.dart';
import '../../../../../../../helper/active_tc.dart';

part 'ureticiden_sevk_alim_state.dart';

class UreticidenSevkAlimCubit extends Cubit<UreticidenSevkAlimState> {
  UreticidenSevkAlimCubit() : super(UreticidenSevkAlimInitial());
  final TextEditingController ilController = TextEditingController();
  final TextEditingController ilceController = TextEditingController();
  final TextEditingController beldeController = TextEditingController();
  final TextEditingController malinAdiController = TextEditingController();
  final TextEditingController adetBagKgController = TextEditingController();
  final TextEditingController tlController = TextEditingController();
  final TextEditingController ureticiAdiController = TextEditingController();
  final TextEditingController plakaController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final plakaFormKey = GlobalKey<FormState>();

  AutovalidateMode isAutoValidateMode = AutovalidateMode.disabled;
  AutovalidateMode isAutoValidateModeForPlaka = AutovalidateMode.disabled;
  bool isToplamaHal = false;

  List<Uretici> _ureticiList = [];
  Uretici? selectedUretici;
  Bildirimci? bildirimci;
  GidecegiYer? gidecegiYer;
  bool isIrsaliye = false;

  customInit() {
    fetchCities();
    fetchIlceler();
    fetchBeldeler();
    fetchMallar();
    fetchUrunMiktarBirimleri();
    getBildirimci();
  }

  Map<String, String> miktarIdleriStatic = {
    "74": "Kg",
    "76": "Bag",
    "73": "Adet"
  };
  Map<String, String> malinNitelikleri = {
    "1": "Yerli",
    "2": "Ithalat",
    "3": "Toplamamal"
  };
  String _malinNiteligiId = "1";

  String? selectedIl;
  String? selectedIlce;
  String? selectedBelde;
  String? selectedMalinAdi;
  bool isIrsaliyeKesSuccess = false;
  //Driver--
  DriverModel? selectedDriver;

  final TextEditingController driverIdController = TextEditingController();
  final TextEditingController driverNameController = TextEditingController();
  final TextEditingController driverAdiControllerForDropDown =
      TextEditingController();
  bool isSurucuManual = false;
  var driverFormKey = GlobalKey<FormState>();
  AutovalidateMode isAutoValidateModeForDriver = AutovalidateMode.disabled;
  final allPricesFormKey = GlobalKey<FormState>();
  void activateAutoValidateModeForDriver() {
    isAutoValidateModeForDriver = AutovalidateMode.always;
    emit(UreticidenSevkAlimInitial());
  }

  void disableAutoValidateModeForDriver() {
    isAutoValidateModeForDriver = AutovalidateMode.disabled;
    emit(UreticidenSevkAlimInitial());
  }

  //Driver--
  //TODO : HATA MESAJI EKLE NULL OLABLİR
  getBildirimci() async {
    bildirimci =
        BildirimciCacheManager.instance.getItem(ActiveTc.instance.activeTc);
  }

  List<Uretici> get ureticiList {
    if (_ureticiList.isEmpty) {
      fillUreticiList();
    }
    return _ureticiList;
  }

  fillUreticiList() {
    _ureticiList.clear();
    var result =
        UreticiListCacheManager.instance.getItem(ActiveTc.instance.activeTc);

    _ureticiList = result
            ?.map((e) => Uretici.fromJson(Map<String, dynamic>.from(e)))
            .toList() ??
        [];
    emit(UreticidenSevkAlimInitial());
  }

  kimiEmitEdeceginiBul() {
    Bildirimci? bildirimci =
        BildirimciCacheManager.instance.getItem(ActiveTc.instance.activeTc);
    if (bildirimci != null) {
      for (var element in bildirimci.kayitliKisiSifatIdList!) {
        if (element == "5") {
          //komisyoncu
        }
        if (element == "6") {
          //hal içi tüccar
        }
        if (element == "20") {
          //hal dışı tüccar
        }
      }
    }
  }

  //NİTELİK YERLİ 1
  Map<String, String> _iller = {};
  Map<String, String> _ilceler = {};
  Map<String, String> _beldeler = {};
  Map<String, String> _mallar = {};
  List<String> urunCinsiIsimleriList = [];
  List<String> urunCinsiIdList = [];

  //eklenen ürün bilgileri
  List<Urun> urunList = [];

  Map<String, Map<String, String>> _urunMiktarBirimleri = {};
  Map<String, Map<String, String>> _cinsler = {};

  String _ilId = "";
  String _ilceId = "";
  String _beldeId = "";
  String _malId = "";
  final String _turId = "28";
  String _cinsId = "";
  String _malMiktarBirimId = "";

  String _malIsmi = "";
  String malMiktarBirimAdi = "";

  String? malinCins;

  Map<String, String> get getCities {
    if (_iller.values.isEmpty) {
      fetchCities();
    }
    return _iller;
  }

  Map<String, String> get getIlceler {
    if (_ilceler.values.isEmpty) {
      fetchIlceler();
    }
    return _ilceler;
  }

  Map<String, String> get getBeldeler {
    if (_beldeler.values.isEmpty) {
      fetchBeldeler();
    }
    return _beldeler;
  }

  Map<String, String> get getMallar {
    if (_mallar.values.isEmpty) {
      fetchMallar();
    }
    return _mallar;
  }

  Map<String, Map<String, String>> get getUrunMiktarBirimleri {
    if (_urunMiktarBirimleri.keys.isEmpty) {
      fetchUrunMiktarBirimleri();
    }
    return _urunMiktarBirimleri;
  }

  Future<void> fetchUrunMiktarBirimleri() async {
    _urunMiktarBirimleri =
        await UrunService.instance.fetchUrunMiktarBirimleri();

    emit(UreticidenSevkAlimInitial());
  }

  Future<void> fetchCities() async {
    var response = await GeneralService.instance.fetchAllCities();

    if (response.error != null) {
      if (response.error?.statusCode == 400 ||
          response.error?.statusCode == 500) {
        //emit(UreticiSevkAlimError(message: "Hks hata"));
        // emit(UreticidenSevkAlimInitial());
      } else {
        // emit(UreticiSevkAlimError(message: "Hata"));
        // emit(UreticidenSevkAlimInitial());
      }
    } else {
      _iller = response.data;
      emit(UreticidenSevkAlimInitial());
    }
  }

  Future<void> fetchIlceler() async {
    if (selectedIl != null) {
      _ilceler = await GeneralService.instance.fetchAllIlceler(_ilId);
      emit(UreticidenSevkAlimInitial());
    }
  }

  Future<void> fetchBeldeler() async {
    if (selectedIlce != null) {
      _beldeler = await GeneralService.instance.fetchAllBeldeler(_ilceId);
      emit(UreticidenSevkAlimInitial());
    }
  }

  Future<void> fetchMallar() async {
    _mallar = await UrunService.instance.fetchUrunler();
    emit(UreticidenSevkAlimInitial());
  }

  void ilSelected(String value) {
    if (selectedIl == null) {
      selectedIl = value;
      for (var element in _iller.entries) {
        if (element.value.toLowerCaseTr() == selectedIl!.toLowerCaseTr()) {
          _ilId = element.key;
        }
      }

      fetchIlceler();
      emit(UreticidenSevkAlimInitial());
    } else {
      selectedIl = value;
      selectedIlce = null;
      selectedBelde = null;
      _beldeId = "";
      _ilceId = "";
      _beldeler.clear();
      _ilceler.clear();
      for (var element in _iller.entries) {
        if (element.value.toLowerCaseTr() == selectedIl!.toLowerCaseTr()) {
          _ilId = element.key;
        }
      }
      fetchIlceler();
      emit(UreticidenSevkAlimInitial());
    }
  }

  void ilceSelected(String value) {
    if (selectedIlce == null) {
      selectedIlce = value;
      for (var element in _ilceler.entries) {
        if (element.value.toLowerCaseTr() == selectedIlce?.toLowerCaseTr()) {
          _ilceId = element.key;
        }
      }
      fetchBeldeler();

      emit(UreticidenSevkAlimInitial());
    } else {
      selectedIlce = value;
      selectedBelde = null;
      _beldeler.clear();
      _beldeId = "";
      for (var element in _ilceler.entries) {
        if (element.value.toLowerCaseTr() == selectedIlce?.toLowerCaseTr()) {
          _ilceId = element.key;
        }
      }
      fetchBeldeler();

      emit(UreticidenSevkAlimInitial());
    }
  }

  void beldeSelected() {
    for (var element in _beldeler.entries) {
      if (element.value.toLowerCaseTr() == selectedBelde?.toLowerCaseTr()) {
        _beldeId = element.key;
      }
    }
    emit(UreticidenSevkAlimInitial());
  }

  void malinAdiSelected(String value) {
    // burada malin cinsleri çekilecek
    if (selectedMalinAdi == null) {
      selectedMalinAdi = value;
      _mallar.entries.forEach((element) async {
        if (element.value.toLowerCaseTr() ==
            selectedMalinAdi?.toLowerCaseTr()) {
          _malId = element.key;
          await fetchCinsler().then((value) => findUrunCinsleriId());
          _malIsmi = element.value;
        }
      });
      setMalMiktari();
      emit(UreticidenSevkAlimInitial());
    } else {
      selectedMalinAdi = value;
      malinCins = null;
      _cinsler.clear();
      _cinsId = "";
      _mallar.entries.forEach((element) async {
        if (element.value.toLowerCaseTr() ==
            selectedMalinAdi?.toLowerCaseTr()) {
          _malId = element.key;
          await fetchCinsler().then((value) => findUrunCinsleriId());
          _malIsmi = element.value;
        }
      });
      setMalMiktari();
      emit(UreticidenSevkAlimInitial());
    }
  }

  findUrunCinsleriId() {
    _cinsler.forEach((key, value) {
      if (malinCins == value["UrunCinsiAdi"]! &&
          _turId == value["UretimSekliId"]) {
        _cinsId = value["Id"].toString();
      }
    });
    emit(UreticidenSevkAlimInitial());
  }

  Future fetchCinsler() async {
    urunCinsiIsimleriList.clear();
    urunCinsiIdList.clear();
    if (_malId != "") {
      _cinsler = await UrunService.instance.fetchUrunCinsleri(_malId);
      String tempName = "";
      _cinsler.forEach(
        (key, value) {
          if (tempName != value["UrunCinsiAdi"] &&
              value["UrunCinsiAdi"].ext.isNotNullOrNoEmpty) {
            tempName = value["UrunCinsiAdi"]!;
            urunCinsiIsimleriList.add(value["UrunCinsiAdi"]!);
            urunCinsiIdList.add(value["Id"]!);
          }
        },
      );
      if (urunCinsiIsimleriList.ext.isNotNullOrEmpty) {
        malinCins = urunCinsiIsimleriList.first;
        _cinsId = urunCinsiIdList.first;

        //malinCins = .first;
      }
      emit(UreticidenSevkAlimInitial());
    }
  }

  setMalMiktari() {
    for (var element in getUrunMiktarBirimleri.keys) {
      if (element == _malId) {
        _malMiktarBirimId = getUrunMiktarBirimleri[element]!["MiktarBirimId"]!;
        malMiktarBirimAdi = getUrunMiktarBirimleri[element]!["MiktarBirimAd"]!;

        //malMiktariAdiController.text = malMiktarBirimAdi;
      }
    }
    emit(UreticidenSevkAlimInitial());
  }

  void malinCinsiSelected() {
    findUrunCinsleriId();
    emit(UreticidenSevkAlimInitial());
  }

  void setMalinNiteligiId() {
    if (isToplamaHal) {
      for (var element in malinNitelikleri.entries) {
        if (element.value == "Toplamamal") {
          _malinNiteligiId = element.key;
        }
      }
    } else {
      for (var element in malinNitelikleri.entries) {
        if (element.value == "Yerli") {
          _malinNiteligiId = element.key;
        }
      }
    }
  }

  void toplamaMalSelected(bool value) {
    if (urunList.isNotEmpty && isToplamaHal) {
      emit(UreticiSevkAlimError(
          message:
              "Tablo da toplama ürünler varken toplama olmaya ürün eklenemez"));
      emit(UreticidenSevkAlimInitial());
      return;
    } else if (urunList.isNotEmpty && !isToplamaHal) {
      emit(UreticiSevkAlimError(
          message:
              "Tablo da toplama olmayan ürünler varken toplama ürün eklenemez"));
      emit(UreticidenSevkAlimInitial());
      return;
    } else {
      isToplamaHal = value;
      emit(UreticidenSevkAlimInitial());
    }
    setMalinNiteligiId();
    emit(UreticidenSevkAlimInitial());
  }

  void urunEkle() {
    Urun urun = Urun(
        isToplamaMal: isToplamaHal.toString(),
        urunAdi: _malIsmi,
        urunId: _malId,
        urunCinsId: _cinsId,
        urunCinsi: malinCins ?? "null",
        urunMiktarBirimId: _malMiktarBirimId,
        urunMiktari: adetBagKgController.text.trim(),
        urunBirimAdi: malMiktarBirimAdi);
    urunList.add(urun);
    _malIsmi = "";
    _cinsId = "";
    malinCins = null;
    selectedMalinAdi = null;

    _malMiktarBirimId = "";
    adetBagKgController.clear();
    malMiktarBirimAdi = "";
    malinAdiController.clear();
    tlController.clear();

    emit(UreticidenSevkAlimInitial());
  }

  //TODO: SELECTEDURETİCİ BOŞŞSA BİLDİRİM YAPILAMAZ
  void ureticiSelected() {
    ilIlceBeldeSelectedWithUretici(selectedUretici!);
    emit(UreticidenSevkAlimInitial());
  }

  void ilIlceBeldeSelectedWithUretici(Uretici uretici) {
    selectedIl = null;
    selectedIlce = null;
    selectedBelde = null;
    _beldeler.clear();
    _ilceler.clear();
    selectedIl = uretici.ureticiIlAdi;
    selectedIlce = uretici.ureticiIlceAdi;
    selectedBelde = uretici.ureticiBeldeAdi;
    _ilId = uretici.ureticiIlId;
    _beldeId = uretici.ureticiBeldeId;
    _ilceId = uretici.ureticiIlceId;

    emit(UreticidenSevkAlimInitial());
  }

  void removeFromUrunList(Urun urun) {
    urunList.remove(urun);
    emit(UreticidenSevkAlimInitial());
  }

  void disableAutoValidateMode() {
    isAutoValidateMode = AutovalidateMode.disabled;
    emit(UreticidenSevkAlimInitial());
  }

  String dropDownErrorMessage = "";
  bool checkDropDownFieldHasError() {
    dropDownErrorMessage = "";
    bool hasError = false;
    if (!isToplamaHal) {
      if (selectedUretici == null) {
        dropDownErrorMessage += " Üretici,";
        hasError = true;
      }
      if (selectedIl == null) {
        dropDownErrorMessage += " İl,";
        hasError = true;
      }
      if (selectedIlce == null) {
        dropDownErrorMessage += " İlçe,";
        hasError = true;
      }
      if (selectedBelde == null) {
        dropDownErrorMessage += " Belde,";
        hasError = true;
      }
      if (selectedMalinAdi == null) {
        dropDownErrorMessage += " Ürün adı,";
        hasError = true;
      }

      if (malinCins == null) {
        dropDownErrorMessage += " Ürün cinsi,";
        hasError = true;
      }
      if (gidecegiYer == null) {
        dropDownErrorMessage += " Gideceği Yer";
        hasError = true;
      }
      dropDownErrorMessage += " boş olamaz";
    } else {
      if (selectedIl == null) {
        dropDownErrorMessage += " İl,";
        hasError = true;
      }
      if (selectedIlce == null) {
        dropDownErrorMessage += " İlçe,";
        hasError = true;
      }
      if (selectedBelde == null) {
        dropDownErrorMessage += " Belde,";
        hasError = true;
      }
      if (selectedMalinAdi == null) {
        dropDownErrorMessage += " Ürün adı,";
        hasError = true;
      }
      if (malinCins == null) {
        dropDownErrorMessage += " Ürün cinsi,";
        hasError = true;
      }
      if (gidecegiYer == null) {
        dropDownErrorMessage += " Gideceği Yer";
        hasError = true;
      }
      dropDownErrorMessage += " boş olamaz";
    }

    if (hasError == false) {
      dropDownErrorMessage = "";
    }
    emit(UreticidenSevkAlimInitial());
    return hasError;
  }

  void activateAutoValidateMode() {
    isAutoValidateMode = AutovalidateMode.always;
    emit(UreticidenSevkAlimInitial());
  }

  void activateAutoValidateModeForPlaka() {
    isAutoValidateModeForPlaka = AutovalidateMode.always;
    emit(UreticidenSevkAlimInitial());
  }

  void disableAutoValidateModeForPlaka() {
    isAutoValidateModeForPlaka = AutovalidateMode.disabled;
    emit(UreticidenSevkAlimInitial());
  }

  Future<void> bildirimYap() async {
    if (selectedUretici == null && isToplamaHal == false) {
      emit(UreticiSevkAlimError(message: "Üretici Seçiniz"));
      emit(UreticidenSevkAlimInitial());
      return;
    }
    if (gidecegiYer == null) {
      emit(UreticiSevkAlimError(
          message:
              "Gideceği Yer Bulunamadı Lütfen Ayarlardan Bildirimci Bilgilerini güncelleyiniz"));
      emit(UreticidenSevkAlimInitial());
      return;
    }
    emit(UreticiSevkAlimLoading());

    try {
      List<HksBildirim> hksBildirimList = [];
      for (var urun in urunList) {
        if (urun.gonderilmekIstenenMiktar != null &&
            urun.gonderilmekIstenenMiktar != "" &&
            double.parse(urun.gonderilmekIstenenMiktar!) > 0) {
          urun.urunMiktari = urun.gonderilmekIstenenMiktar!;
        }
        var hks = HksBildirim(
          malId: urun.urunId,
          malinCinsiId: urun.urunCinsId,
          uretimSekliId: _turId,
          malinMiktarBirimId: urun.urunMiktarBirimId,
          malinNiteligiId: isToplamaHal ? "3" : "1",
          uretimBeldeId: _beldeId,
          uretimIlId: _ilId,
          uretimIlceId: _ilceId,
          malinMiktari: urun.urunMiktari,
          malinSatisFiyat: "0",
          gidecegiYerBeldeId: "0",
          gidecegiYerIlId: "0",
          gidecegiYerIlceId: "0",
          bilidirimTuruId: "206",
          bildirimciKisiSifatId: "5",
          ikinciKisiAdiSoyadi:
              isToplamaHal ? "0" : (selectedUretici!.ureticiAdiSoyadi),
          ceptel: isToplamaHal ? "0" : selectedUretici!.ureticiTel,
          ikinciKisiSifat: isToplamaHal ? "4" : selectedUretici!.ureticiSifatId,
          ikinciKisiTcVergiNo: isToplamaHal ? "0" : selectedUretici!.ureticiTc,
          aracPlakaNo: plakaController.text.trim(),
          gidecegiIsyeriId: gidecegiYer!.isyeriId,
          gidecegiYerIsletmeTuruId: gidecegiYer!.isletmeTuruId,
          uniqueId: uniqueIdGenerator,
          belgeTipi: "207",
        );
        hksBildirimList.add(hks);
      }
      var result2 =
          await BildirimService.instance.cokluBildirimKaydet(hksBildirimList);
      List<BildirimKayitCevapModel> succefullKayitCevaplari = [];
      if (result2.error != null) {
        emit(UreticiSevkAlimError(message: result2.error!.message));
        emit(UreticidenSevkAlimInitial());
      } else {
        bool hasError = false;
        if (result2.data.kayitCevapList != null &&
            result2.data.kayitCevapList!.isNotEmpty) {
          for (var element in result2.data.kayitCevapList!) {
            if (element.kunyeNo == "0" || element.kunyeNo == null) {
              hasError = true;
            } else {
              succefullKayitCevaplari.add(element);
              //kaydedilecek künyeler
            }
          }

          if (hasError) {
            //TODO: BAŞARILILARI SİL BAŞARISIZLAR KALSIN
            if (isIrsaliye) {
              var dbResult = await basariliBildirimleriDbYeYaz(
                  urunList, succefullKayitCevaplari);
              if (dbResult.isNotEmpty) {
                String? token = await getToken();
                if (token != null) {
                  await Future.wait([saveIrsaliye(dbResult, token)]).then(
                      (value) => removeUnsuccessfulNotificationsFromDb(
                          urunList, succefullKayitCevaplari));
                  emit(UreticiSevkAlimSuccessHasSomeError(
                      response: result2.data));
                } else {
                  removeUnsuccessfulNotificationsFromDb(
                      urunList, succefullKayitCevaplari);
                  emit(UreticiSevkAlimSuccessHasSomeError(
                      response: result2.data));
                }
              } else {
                removeUnsuccessfulNotificationsFromDb(
                    urunList, succefullKayitCevaplari);
                emit(
                    UreticiSevkAlimSuccessHasSomeError(response: result2.data));
              }
            } else {
              emit(UreticiSevkAlimSuccessHasSomeError(response: result2.data));

              basariliBildirimleriDbYeYaz(urunList, succefullKayitCevaplari)
                  .then((value) => removeUnsuccessfulNotificationsFromDb(
                      urunList, succefullKayitCevaplari));
            }
          } else {
            if (isIrsaliye) {
              var dbResult = await basariliBildirimleriDbYeYaz(
                  urunList, succefullKayitCevaplari);
              if (dbResult.isNotEmpty) {
                String? token = await getToken();
                if (token != null) {
                  await Future.wait([saveIrsaliye(dbResult, token)])
                      .then((value) => clearAllPageInfo());
                  emit(UreticiSevkAlimCompletelySuccessful(
                      response: result2.data));
                } else {
                  emit(UreticiSevkAlimCompletelySuccessful(
                      response: result2.data));
                  clearAllPageInfo();
                }
              } else {
                emit(UreticiSevkAlimCompletelySuccessful(
                    response: result2.data));
                clearAllPageInfo();
              }
            } else {
              basariliBildirimleriDbYeYaz(urunList, succefullKayitCevaplari)
                  .then((value) => clearAllPageInfo());

              emit(UreticiSevkAlimCompletelySuccessful(response: result2.data));
            }
            logBildirim();
          }
        } else {
          //hata
        }
      }
    } catch (e) {
      emit(UreticiSevkAlimError(message: e.toString()));

      emit(UreticidenSevkAlimInitial());
    }
  }

  Future<String?> getToken() async {
    MySoftUserModel? usermodel =
        MySoftUserCacheManager.instance.getItem(ActiveTc.instance.activeTc);
    if (usermodel != null) {
      var result = await MySoftAuthService.instance
          .getToken(usermodel.userName, usermodel.password);

      if (result.error != null) {
        emit(UreticiSevkAlimError(message: result.error!.message));
        emit(UreticidenSevkAlimInitial());
      } else if (result.data != null) {
        return result.data;
      } else {
        emit(UreticiSevkAlimError(message: "MySoft hata 1"));
        emit(UreticidenSevkAlimInitial());
      }
    } else {
      emit(UreticiSevkAlimError(message: "MySoft Bilgilerini Güncelleyiniz"));
      emit(UreticidenSevkAlimInitial());
    }
    return null;
  }

  void clearFaturaInfo() {
    isIrsaliyeKesSuccess = false;
    isIrsaliye = false;
    emit(UreticidenSevkAlimInitial());
  }

  Future<void> saveIrsaliye(List<Urun> urunler, String token) async {
    try {
      var bildirimci =
          BildirimciCacheManager.instance.getItem(ActiveTc.instance.activeTc);
      var result = await MySoftFaturaService.instance.sendIrsaliye(
          token: token,
          urunler: urunler,
          gidecegiYer: gidecegiYer!,
          driver: selectedDriver!,
          plaka: plakaController.text.trim(),
          bildirimci: bildirimci!);
      if (result.error != null) {
        isIrsaliyeKesSuccess = false;

        emit(UreticiSevkAlimError(
            message: result.error?.message ?? "MySoft irsaliye hata"));
        emit(UreticidenSevkAlimInitial());
      } else {
        isIrsaliyeKesSuccess = true;
        logIrsaliye();
      }
     } catch (e) {
      emit(UreticiSevkAlimError(message: e.toString()));
      emit(UreticidenSevkAlimInitial());
    }
  }

  shareWithWhatsapp(BildirimKayitResponseModel response) async {
    //adı künye plaka kunye
    response.kayitCevapList?.forEach((element) {
      getMallar.forEach((key, value) {
        if (element.malinId == key) {
          element.malinAdi = value;
        }
      });
      miktarIdleriStatic.forEach((key, value) {
        if (element.malinMiktarBirimId == key) {
          element.malinMiktarBirimAdi = value;
        }
      });
    });
    String messages = "";
    response.kayitCevapList?.forEach((element) {
      var message =
          "Ürün:${element.malinAdi ?? "boş"}\nMiktar:${element.malinMiktari ?? "boş"} ${element.malinMiktarBirimAdi ?? "boş"}\nPlaka:${element.aracPlakaNo ?? "boş"}\nKunye No:${element.kunyeNo ?? "boş"}\n";
      messages = messages + message;
      messages = "$messages\n";
    });
    messages +=
        "HKS BİLDİR Tarafından Gönderilmiştir.\nhttps://www.hksbildir.net";
    await WhatsappShare.share(
      text: messages,
      //  linkUrl: 'https://flutter.dev/',
      phone: '900',
    );
  }

  clearAllPageInfo() {
    selectedDriver = null;
    driverIdController.clear();
    driverNameController.clear();
    isSurucuManual = false;
    gidecegiYer = null;
    selectedIl = null;
    _ilceler.clear();
    selectedIlce = null;
    _beldeler.clear();
    selectedBelde = null;
    selectedMalinAdi = null;
    malinCins = null;
    _cinsler.clear();
    plakaController.clear();
    urunList.clear();
    selectedUretici = null;
    malMiktarBirimAdi = "";
    _malMiktarBirimId = "";
    adetBagKgController.clear();
    tlController.clear();
    isToplamaHal = false;

    emit(UreticidenSevkAlimInitial());
  }

  void removeUnsuccessfulNotificationsFromDb(
      List<Urun> urunlistesi, List<BildirimKayitCevapModel> basariliKunyeler) {
    List<Urun> silinecekKunyeler = [];

    for (var element in urunlistesi) {
      for (var item in basariliKunyeler) {
        if (element.urunId == item.malinId &&
            element.urunCinsId == item.malinCinsiId) {
          silinecekKunyeler.add(element);
        }
      }
    }
    for (var element in silinecekKunyeler) {
      var result = urunList.remove(element);
    }
  }

  Future<List<Urun>> basariliBildirimleriDbYeYaz(List<Urun> urunlistesi,
      List<BildirimKayitCevapModel> basariliKunyeler) async {
    List<Urun> kesinKaydedilecekKunyeler = [];

    bool urunAdded = false;
    for (var urun in urunlistesi) {
      urunAdded = false;

      for (var item in basariliKunyeler) {
        if (urun.urunId == item.malinId &&
            urun.urunCinsId == item.malinCinsiId) {
          if (urunAdded == true) {
            break;
          }

          bool isContain = false;
          for (var element2 in kesinKaydedilecekKunyeler) {
            if (element2.kunyeNo == item.kunyeNo) {
              isContain = true;
              break;
            }
          }
          if (!isContain) {
            urunAdded = true;
            urun.kunyeNo = item.kunyeNo;

            kesinKaydedilecekKunyeler.add(urun);
          }
        }
      }
    }

    await writeNotificationsToDb(kesinKaydedilecekKunyeler);
    return kesinKaydedilecekKunyeler;
  }

  Future<void> writeNotificationsToDb(List<Urun> list) async {
    if (list.isNotEmpty) {
      var result = CustomNotificationSaveModel(
          gidecegiIsyeriId: gidecegiYer?.isyeriId,
          gidecegiYerAdi: gidecegiYer?.name,
          adres: gidecegiYer!.adres,
          gidecegiYerType: gidecegiYer!.type,
          gidecegiYerIsletmeTuruAdi: gidecegiYer?.type,
          gidecegiYerIsletmeTuruId: gidecegiYer?.isletmeTuruId,
          ilAdi: selectedIl,
          ilId: _ilId,
          ilceAdi: selectedIlce,
          ilceId: _ilceId,
          beldeAdi: selectedBelde,
          beldeId: _beldeId,
          bildirimAdi: "Sevk Alım",
          isToplama: isToplamaHal,
          selectedSifatId: "5",
          urunList: list.map((e) => e.toJson()).toList().cast<Map>(),
          uretici: isToplamaHal
              ? null
              : (selectedUretici?.toJson()),
          plaka: plakaController.text.trim());
      result.date = DateTime.now().toString();
      Future.wait([
        CustomNotificationSaveCacheManager.instance
            .addItemCopy3(ActiveTc.instance.activeTc, result),
        LastCustomNotificationSaveCacheManager.instance
            .addItem(ActiveTc.instance.activeTc, result)
      ]);
    } else {}
  }

  String get uniqueIdGenerator {
    var uuid = const Uuid();
    return uuid.v1();
  }

  bool isNumeric(String? s) {
    if (s == null || s.trim() == "") {
      return false;
    }
    return double.tryParse(s.trim()) != null;
  }

  void fillWithOutSideDataCustom(CustomNotificationSaveModel saveModel) {
    Uretici? uretici;

    if (saveModel.uretici != null) {
      uretici = Uretici.fromJson(Map<String, dynamic>.from(saveModel.uretici!));
    }
    if (uretici != null) {
      selectedIl = null;
      selectedIlce = null;
      selectedBelde = null;
      _beldeler.clear();
      _ilceler.clear();
      malinCins = null;
      _cinsler.clear();
      urunCinsiIsimleriList.clear();
      urunCinsiIdList.clear();
      selectedIl = uretici.ureticiIlAdi;
      selectedIlce = uretici.ureticiIlceAdi;
      selectedBelde = uretici.ureticiBeldeAdi;
      _ilId = uretici.ureticiIlId;
      _ilceId = uretici.ureticiIlceId;
      _beldeId = uretici.ureticiBeldeId;
      isToplamaHal = saveModel.isToplama;

      selectedUretici = uretici;
      _malId = "";

      // _ilId = uretici.ureticiIlId;
      // _ilceId = uretici.ureticiIlceId;

      selectedMalinAdi = null;
      //urunCinsiIsimleriList.add(bildirim.malCinsAdi!);
      malinCins = null;
      //   malinCins = bildirim.malCinsAdi!;

      _cinsId = "";
      //_cinsId = bildirim.malinCinsiId!;
      urunList = saveModel.urunList
          .map((e) => Urun.fromJson(Map<String, dynamic>.from(e)))
          .toList()
          .cast<Urun>();
    } else {
      isToplamaHal = saveModel.isToplama;
      if (saveModel.gidecegiYerAdi != null &&
          saveModel.gidecegiYerType != null) {
        gidecegiYer = GidecegiYer(
            type: saveModel.gidecegiYerType!,
            name: saveModel.gidecegiYerAdi!,
            isletmeTuru: saveModel.gidecegiYerIsletmeTuruAdi!,
            isletmeTuruId: saveModel.gidecegiYerIsletmeTuruId!,
            isyeriId: saveModel.gidecegiIsyeriId!,
            adres: saveModel.adres ?? "adres boş");
      }
      selectedIl = (saveModel.ilAdi != "" && saveModel.ilAdi != null)
          ? saveModel.ilAdi
          : null;
      _ilId = (saveModel.ilId != "" && saveModel.ilId != null)
          ? saveModel.ilId!
          : "";
      selectedIlce = (saveModel.ilceAdi != "" && saveModel.ilceAdi != null)
          ? saveModel.ilceAdi
          : null;
      _ilceId = (saveModel.ilceId != "" && saveModel.ilceId != null)
          ? saveModel.ilceId!
          : "";
      selectedBelde = (saveModel.beldeAdi != "" && saveModel.beldeAdi != null)
          ? saveModel.beldeAdi
          : null;
      _beldeId = (saveModel.beldeId != "" && saveModel.beldeId != null)
          ? saveModel.beldeId!
          : "";
      _beldeler.clear();
      _ilceler.clear();
      selectedMalinAdi = null;
      malinCins = null;
      _cinsler.clear();
      urunCinsiIsimleriList.clear();
      urunCinsiIdList.clear();
      isToplamaHal = saveModel.isToplama;
      _malId = "";
      malinCins = null;
      _cinsId = "";
      urunList = saveModel.urunList
          .map((e) => Urun.fromJson(Map<String, dynamic>.from(e)))
          .toList()
          .cast<Urun>();
    }

    emit(UreticidenSevkAlimInitial());
  }

  void emitInitial() {
    emit(UreticidenSevkAlimInitial());
  }

  void emitError(String message) {
    emit(UreticiSevkAlimError(message: message));

    emit(UreticidenSevkAlimInitial());
  }
  
  void logIrsaliye() {}
  
  void logBildirim() {}
}
