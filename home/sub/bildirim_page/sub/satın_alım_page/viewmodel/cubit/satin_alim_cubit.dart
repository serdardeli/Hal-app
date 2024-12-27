import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hal_app/feature/home/sub/bildirim_page/sub/sat%C4%B1n_al%C4%B1m_page/view/sat%C4%B1n_al%C4%B1m_page.dart';
import 'package:hal_app/feature/home/sub/bildirim_page/sub/tuccar_hal_ici_disi/viewmodel/cubit/tuccar_hal_ici_disi_main_cubit.dart';
import 'package:hal_app/project/cache/last_custom_notifications_cache_manager.dart';
import 'package:hal_app/project/model/driver_model/driver_model.dart';
import 'package:hal_app/project/service/mysoft/auth/mysoft_auth_service.dart';
import 'package:hal_app/project/service/mysoft/fatura/mysoft_fatura_service.dart';
import 'package:hal_app/project/service/time/time_service.dart';
import 'package:whatsapp_share2/whatsapp_share2.dart';

import '../../../../../../../../project/cache/bildirim_list_cache_manager_new.dart';
import '../../../../../../../../project/cache/bildirimci_cache_manager.dart';
import 'package:kartal/kartal.dart';
import 'package:turkish/turkish.dart';
import 'package:uuid/uuid.dart';

import '../../../../../../../../project/cache/depo_cache_manager.dart';
import '../../../../../../../../project/cache/hal_ici_isyeri_cache_manager.dart';
import '../../../../../../../../project/cache/mysoft_user_cache_mananger.dart';
import '../../../../../../../../project/cache/sube_cache_manager.dart';
import '../../../../../../../../project/cache/uretici_list_cache_manager.dart';
import '../../../../../../../../project/model/MySoft_user_model/mysoft_user_model.dart';
import '../../../../../../../../project/model/bildirim/bildirim_model.dart';
import '../../../../../../../../project/model/bildirim_kayit_response_model.dart/bildirim_kayit_response_model.dart';
import '../../../../../../../../project/model/bildirim_kayit_response_model.dart/sub/bildirim_kayit_cevap_model.dart';
import '../../../../../../../../project/model/bildirimci/bildirimci_model.dart';
import '../../../../../../../../project/model/custom_notification_save_model.dart/custom_notification_save_model.dart';
import '../../../../../../../../project/model/depo/depo_model.dart';
import '../../../../../../../../project/model/hal_ici_isyeri/hal_ici_isyeri_model.dart';
import '../../../../../../../../project/model/hks_bildirim_model/hks_bildirim_model.dart';
import '../../../../../../../../project/model/malin_gidecegi_yer/malin_gidecegi_yer_model.dart';
import '../../../../../../../../project/model/malin_gidecegi_yer_info_model/malin_gidecegi_yer_info_model.dart';
import '../../../../../../../../project/model/sube/sube_model.dart';
import '../../../../../../../../project/model/uretici_model/uretici_model.dart';
import '../../../../../../../../project/model/urun/urun.dart';
import '../../../../../../../../project/service/hal/bildirim_service.dart';
import '../../../../../../../../project/service/hal/genel_service.dart';
import '../../../../../../../../project/service/hal/urun_service.dart';
import '../../../../../../../helper/active_tc.dart';

part 'satin_alim_state.dart';

//nitelik toplama mal 3
//kişi sıfati tüccar hal içi 6
// küsatları . ile göndermenizi istiyor
/* <b:SifatDTO>
     <b:Id>20</b:Id>
     <b:SifatAdi>Tüccar (Hal Dışı)</b:SifatAdi>
 </b:SifatDTO>
 <b:SifatDTO>
     <b:Id>6</b:Id>
     <b:SifatAdi>Tüccar (Hal İçi)</b:SifatAdi>*/

class SatinAlimCubit extends Cubit<SatinAlimState> {
  SatinAlimCubit() : super(SatinAlimInitial());
  final TextEditingController ureticiAdiController = TextEditingController();

  final TextEditingController ilController = TextEditingController();
  final TextEditingController ilceController = TextEditingController();
  final TextEditingController beldeController = TextEditingController();
  final TextEditingController malinAdiController = TextEditingController();
  final TextEditingController adetBagKgController = TextEditingController();
  final TextEditingController tlController = TextEditingController();
  final TextEditingController plakaController = TextEditingController();
  final TextEditingController driverIdController = TextEditingController();
  final TextEditingController driverNameController = TextEditingController();
  final TextEditingController driverAdiControllerForDropDown =
      TextEditingController();

  var formKey = GlobalKey<FormState>();
  var plakaFormKey = GlobalKey<FormState>();
  var driverFormKey = GlobalKey<FormState>();

  AutovalidateMode isAutoValidateMode = AutovalidateMode.disabled;
  AutovalidateMode isAutoValidateModeForPlaka = AutovalidateMode.disabled;
  AutovalidateMode isAutoValidateModeForDriver = AutovalidateMode.disabled;

  Bildirimci? bildirimci;
  final ScrollController scrollController = ScrollController();
  GlobalKey dropdownButtonKey = GlobalKey();

  Map<String, String> miktarIdleriStatic = {
    "74": "Kg",
    "76": "Bag",
    "73": "Adet"
  };
  //String? selectedGilecekYerAdi;
  GidecegiYer? gidecegiYer;

  List<Urun> urunList = [];
  String? selectedIl;
  String? selectedIlce;
  String? selectedBelde;
  String? selectedMalinAdi;
  List<String> urunCinsiIdList = [];

  bool isToplamaHal = false;
  bool isMustahsil = false;
  bool isIrsaliye = false;

  bool isMustahsilKesSuccess = false;
  bool isIrsaliyeKesSuccess = false;

  bool isSurucuManual = false;

  String _malinNiteligiId = "1";
  List<Uretici> _ureticiList = [];
  final List<DriverModel> _driverList = [];

  Uretici? selectedUretici;
  DriverModel? selectedDriver;

  String? activeBildirimciSifatId;
  void changeIsSurucuManual() {
    isSurucuManual = !isSurucuManual;
    emit(SatinAlimInitial());
  }

  customInit() {
    //clearAllPageInfo();

    fetchCities();
    fetchIlceler();
    fetchBeldeler();
    fetchMallar();
    fetchUrunMiktarBirimleri();
    assignActiveBildirimciSifatId();
    getBildirimci();

    //isAutoValidateMode = AutovalidateMode.disabled;
  }

  clearAllPageInfo() {
    driverIdController.clear();
    driverNameController.clear();
    isSurucuManual = false;
    selectedUretici = null;
    selectedDriver = null;
    isIrsaliye = false;
    isMustahsil = false;
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
    isToplamaHal = false;
    urunList.clear();
    malMiktarBirimAdi = "";
    _malMiktarBirimId = "";
    adetBagKgController.clear();
    tlController.clear();

    emit(SatinAlimInitial());
  }

  fillWithOutSideDataCustom(
      CustomNotificationSaveModel saveModel, BuildContext context) {
    try {
      Uretici? uretici;

      if (saveModel.uretici != null) {
        uretici =
            Uretici.fromJson(Map<String, dynamic>.from(saveModel.uretici!));
      }

      if (uretici != null) {
        context.read<TuccarHalIciDisiMainCubit>().selectedSifatType =
            saveModel.selectedSifatType;
        context.read<TuccarHalIciDisiMainCubit>().selectedSifatId =
            saveModel.selectedSifatId;

        selectedIl = null;
        selectedIlce = null;
        selectedBelde = null;
        malinCins = null;
        selectedMalinAdi = null;
        _beldeler.clear();
        _ilceler.clear();

        _cinsler.clear();
        urunCinsiIsimleriList.clear();
        urunCinsiIdList.clear();
        selectedIl = uretici.ureticiIlAdi;
        selectedIlce = uretici.ureticiIlceAdi;
        selectedBelde = uretici.ureticiBeldeAdi;
        _ilId = uretici.ureticiIlId;
        _ilceId = uretici.ureticiIlceId;
        _beldeId = uretici.ureticiBeldeId;
        selectedUretici = uretici;
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

        _malId = "";

        _cinsId = "";

        urunList = saveModel.urunList
            .map((e) => Urun.fromJson(Map<String, dynamic>.from(e)))
            .toList()
            .cast<Urun>();
      } else {
        //BURASI TOPLAMA MAL İÇİN
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
    } catch (e) {
      emit(SatinAlimError(message: e.toString()));

      emit(SatinAlimInitial());
    }

    emit(SatinAlimInitial());
  }

  getBildirimci() async {
    bildirimci =
        BildirimciCacheManager.instance.getItem(ActiveTc.instance.activeTc);
  }

  List<String> urunCinsiIsimleriList = [];

  Map<String, String> _iller = {};
  Map<String, String> _ilceler = {};
  Map<String, String> _beldeler = {};
  Map<String, String> _mallar = {};
  String _ilId = "";
  String _ilceId = "";
  String _beldeId = "";
  String _malId = "";
  final String _turId = "28";
  String _cinsId = "";
  String _malMiktarBirimId = "";
  Map<String, Map<String, String>> _urunMiktarBirimleri = {};
  Map<String, Map<String, String>> _cinsler = {};

  String malMiktarBirimAdi = "";

  String? malinCins;

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
    emit(SatinAlimInitial());
  }

  List<DriverModel> get driverList {
    if (_driverList.isEmpty) {
      fillUreticiList();
    }
    return _driverList;
  }

  fillDriverList() {
//  _driverList.clear();
//  var result =
//      UreticiListCacheManager.instance.getItem(ActiveTc.instance.activeTc);
//
//  _driverList = result
//          ?.map((e) => Uretici.fromJson(Map<String, dynamic>.from(e)))
//          .toList() ??
//      [];
//  emit(SatinAlimInitial());
  }

  Map<String, String> malinNitelikleri = {
    "1": "Yerli",
    "2": "Ithalat",
    "3": "Toplamamal"
  };
  Map<String, String> get getCities {
    if (_iller.values.isEmpty) {
      fetchCities();
    }
    //if (_iller.isNotEmpty && selectedIl.isEmpty) {
    // //selectedIl = _iller.values.first;
    // //  _ilId = _iller.keys.first;
    //}
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

  Future<void> assignActiveBildirimciSifatId() async {
    var bildirimci =
        BildirimciCacheManager.instance.getItem(ActiveTc.instance.activeTc);
    if (bildirimci != null) {
      bildirimci.kayitliKisiSifatIdList?.forEach((element) {
        if (element == "20") {
          activeBildirimciSifatId = "20";
        }
        if (element == "6") {
          activeBildirimciSifatId = "6";
        }
      });
    } else {
      // TODO : HATA DURUMUNU ELE AL
    }
  }

  Future<void> fetchUrunMiktarBirimleri() async {
    _urunMiktarBirimleri =
        await UrunService.instance.fetchUrunMiktarBirimleri();

    emit(SatinAlimInitial());
  }

  Future<void> fetchCities() async {
    var response = await GeneralService.instance.fetchAllCities();

    if (response.error != null) {
      if (response.error?.statusCode == 400 ||
          response.error?.statusCode == 500) {
        // emit(SatinAlimError(message: "Hks hata"));

        // emit(SatinAlimInitial());
      } else {
        //  emit(SatinAlimError(message: "Hata"));
        // emit(SatinAlimInitial());
      }
    } else {
      _iller = response.data;
      emit(SatinAlimInitial());
    }
  }

  Future<void> fetchIlceler() async {
    if (selectedIl != null) {
      _ilceler = await GeneralService.instance.fetchAllIlceler(_ilId);
      emit(SatinAlimInitial());
    }
  }

  Future<void> fetchBeldeler() async {
    if (selectedIlce != null) {
      _beldeler = await GeneralService.instance.fetchAllBeldeler(_ilceId);
      emit(SatinAlimInitial());
    }
  }

  Future<void> fetchMallar() async {
    _mallar = await UrunService.instance.fetchUrunler();
    emit(SatinAlimInitial());
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

    emit(SatinAlimInitial());
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
      emit(SatinAlimInitial());
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
      emit(SatinAlimInitial());
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

      emit(SatinAlimInitial());
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

      emit(SatinAlimInitial());
    }
  }

  void beldeSelected() {
    for (var element in _beldeler.entries) {
      if (element.value.toLowerCaseTr() == selectedBelde?.toLowerCaseTr()) {
        _beldeId = element.key;
      }
    }
    emit(SatinAlimInitial());
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
          selectedMalinAdi = element.value;
        }
      });
      setMalMiktari();
      emit(SatinAlimInitial());
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
          selectedMalinAdi = element.value;
        }
      });
      setMalMiktari();
      emit(SatinAlimInitial());
    }
  }

  findUrunCinsleriId() {
    _cinsler.forEach((key, value) {
      if (malinCins == value["UrunCinsiAdi"]! &&
          _turId == value["UretimSekliId"]) {
        _cinsId = value["Id"].toString();
        // malinCins = value["UrunCinsiAdi"];
      }
    });
    emit(SatinAlimInitial());
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
      }
      emit(SatinAlimInitial());
    }
  }

// malinAdiAndMalinTuruSelected() {
//   if (malinAdiController.text.trim() != "") {
//     findUrunCinsleriId();
//
//     emit(BildirimPageInitial());
//   }
// }

  setMalMiktari() {
    for (var element in getUrunMiktarBirimleri.keys) {
      if (element == _malId) {
        _malMiktarBirimId = getUrunMiktarBirimleri[element]!["MiktarBirimId"]!;
        malMiktarBirimAdi = getUrunMiktarBirimleri[element]!["MiktarBirimAd"]!;

        //malMiktariAdiController.text = malMiktarBirimAdi;
      }
    }
    emit(SatinAlimInitial());
  }

  void malinCinsiSelected() {
    findUrunCinsleriId();
    emit(SatinAlimInitial());
  }

  String convertKg(String kg) => kg.replaceFirst(",", ".");

  String convertTl(String tl) => tl.replaceFirst(",", ".");

  void urunEkle() {
    Urun urun = Urun(
        isToplamaMal: isToplamaHal.toString(),
        urunAdi: selectedMalinAdi ?? "null",
        urunId: _malId,
        urunCinsId: _cinsId,
        urunCinsi: malinCins ?? "null",
        urunMiktarBirimId: _malMiktarBirimId,
        urunMiktari: convertKg(adetBagKgController.text.trim()),
        urunBirimAdi: malMiktarBirimAdi,
        urunFiyati: convertTl(tlController.text.trim()));
    urunList.add(urun);
    selectedMalinAdi = "";
    selectedMalinAdi = null;
    _malId = "";
    _cinsId = "";
    malinCins = null;
    _malMiktarBirimId = "";
    adetBagKgController.clear();
    malMiktarBirimAdi = "";
    malinAdiController.clear();
    tlController.clear();
    emit(SatinAlimInitial());
  }

  //TODO: SELECTEDURETİCİ BOŞŞSA BİLDİRİM YAPILAMAZ
  void ureticiSelected() {
    ilIlceBeldeSelectedWithUretici(selectedUretici!);
    emit(SatinAlimInitial());
  }

  void driverSelected() {
    emit(SatinAlimInitial());
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
      emit(SatinAlimError(
          message:
              "Tablo da toplama ürünler varken toplama olmaya ürün eklenemez"));
      emit(SatinAlimInitial());
      return;
    } else if (urunList.isNotEmpty && !isToplamaHal) {
      emit(SatinAlimError(
          message:
              "Tablo da toplama olmayan ürünler varken toplama ürün eklenemez"));
      emit(SatinAlimInitial());
      return;
    } else {
      isToplamaHal = value;
      emit(SatinAlimInitial());
    }
    setMalinNiteligiId();
    emit(SatinAlimInitial());
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

  String checkTotalNumber(String s) {
    if (s.contains(".0")) {
      return s.split(".").first;
    } else {
      var result = double.parse(s).toStringAsFixed(1);
      return result;
    }
  }

  Future<void> bildirimYap(BuildContext context) async {
    emit(SatinAlimLoading());

    try {
      if (selectedUretici == null && isToplamaHal == false) {
        emit(SatinAlimError(message: "Üretici Seçiniz"));
        emit(SatinAlimInitial());
        return;
      }
      if (gidecegiYer == null) {
        emit(SatinAlimError(
            message:
                "Gideceği yer seçiniz. Eğer gideceği yeri göremiyorsanız müşteri bilgilerini güncelleyiniz."));
        emit(SatinAlimInitial());
        return;
      }
      emit(SatinAlimLoading());

      List<HksBildirim> hksBildirimList = [];
      // List<Bildirim> customBildirimList = [];
      for (var urun in urunList) {
        if (urun.gonderilmekIstenenMiktar != null &&
            urun.gonderilmekIstenenMiktar != "" &&
            double.parse(urun.gonderilmekIstenenMiktar!) > 0) {
          urun.urunMiktari = urun.gonderilmekIstenenMiktar!;
        }
        if (urun.gonderilmekIstenenFiyat != null &&
            urun.gonderilmekIstenenFiyat != "" &&
            double.parse(urun.gonderilmekIstenenFiyat!) > 0) {
          urun.urunFiyati = urun.gonderilmekIstenenFiyat!;
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
          malinSatisFiyat: urun.urunFiyati,
          gidecegiYerBeldeId: "0",
          gidecegiYerIlId: "0",

          gidecegiYerIlceId: "0",
          bilidirimTuruId: "195",
          bildirimciKisiSifatId:
              context.read<TuccarHalIciDisiMainCubit>().selectedSifatId ??
                  "null", //?? assignActiveBildirimciSifatId()
          ikinciKisiAdiSoyadi:
              isToplamaHal ? "0" : (selectedUretici!.ureticiAdiSoyadi),
          ceptel: isToplamaHal ? "0" : selectedUretici!.ureticiTel,
          ikinciKisiSifat: isToplamaHal ? "4" : selectedUretici!.ureticiSifatId,
          ikinciKisiTcVergiNo: isToplamaHal ? "0" : selectedUretici!.ureticiTc,
          aracPlakaNo: plakaController.text.trim(),
          gidecegiIsyeriId: gidecegiYer!.isyeriId, //??????????Bundan eminmiyiz
          gidecegiYerIsletmeTuruId: gidecegiYer!.isletmeTuruId, //7
          uniqueId: uniqueIdGenerator,
          belgeTipi: "207",
        );
        hksBildirimList.add(hks);
      }

      var result2 =
          await BildirimService.instance.cokluBildirimKaydet(hksBildirimList);
      List<BildirimKayitCevapModel> succefullKayitCevaplari = [];

      if (result2.error != null) {
        emit(SatinAlimError(message: result2.error!.statusCode.toString()));
        emit(SatinAlimInitial());
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
            if (isMustahsil == false && isIrsaliye == false) {
              await basariliBildirimleriDbYeYaz(
                      urunList, succefullKayitCevaplari, context)
                  .then((value) => removeUnsuccessfulNotificationsFromDb(
                      urunList, succefullKayitCevaplari));
              emit(SatinAlimSuccessHasSomeError(response: result2.data));
            } else if (isMustahsil == true && isIrsaliye == false) {
              var dbResult = await basariliBildirimleriDbYeYaz(
                  urunList, succefullKayitCevaplari, context);

              if (dbResult.isNotEmpty) {
                String? token = await getToken();
                if (token != null) {
                  await Future.wait([saveMustahsil(dbResult, token)]).then(
                      (value) => removeUnsuccessfulNotificationsFromDb(
                          urunList, succefullKayitCevaplari));
                } else {
                  removeUnsuccessfulNotificationsFromDb(
                      urunList, succefullKayitCevaplari);
                }
              } else {
                removeUnsuccessfulNotificationsFromDb(
                    urunList, succefullKayitCevaplari);
              }
              emit(SatinAlimSuccessHasSomeError(response: result2.data));
            } else if (isMustahsil == false && isIrsaliye == true) {
              var dbResult = await basariliBildirimleriDbYeYaz(
                  urunList, succefullKayitCevaplari, context);

              if (dbResult.isNotEmpty) {
                String? token = await getToken();
                if (token != null) {
                  await Future.wait([
                    saveIrsaliye(dbResult, token),
                  ]).then((value) => removeUnsuccessfulNotificationsFromDb(
                      urunList, succefullKayitCevaplari));
                } else {
                  removeUnsuccessfulNotificationsFromDb(
                      urunList, succefullKayitCevaplari);
                }
              } else {
                removeUnsuccessfulNotificationsFromDb(
                    urunList, succefullKayitCevaplari);
              }
              emit(SatinAlimSuccessHasSomeError(response: result2.data));
            } else {
              var dbResult = await basariliBildirimleriDbYeYaz(
                  urunList, succefullKayitCevaplari, context);

              if (dbResult.isNotEmpty) {
                String? token = await getToken();
                if (token != null) {
                  await Future.wait([
                    saveIrsaliye(dbResult, token),
                    saveMustahsil(dbResult, token)
                  ]).then((value) => removeUnsuccessfulNotificationsFromDb(
                      urunList, succefullKayitCevaplari));
                } else {
                  removeUnsuccessfulNotificationsFromDb(
                      urunList, succefullKayitCevaplari);
                }
              } else {
                removeUnsuccessfulNotificationsFromDb(
                    urunList, succefullKayitCevaplari);
              }
              emit(SatinAlimSuccessHasSomeError(response: result2.data));
            }
          } else {
            if (isMustahsil == false && isIrsaliye == false) {
              await basariliBildirimleriDbYeYaz(
                      urunList, succefullKayitCevaplari, context)
                  .then((value) => clearAllPageInfo());
              emit(SatinAlimCompletelySuccess(response: result2.data));
            } else if (isMustahsil == true && isIrsaliye == false) {
              var dbResult = await basariliBildirimleriDbYeYaz(
                  urunList, succefullKayitCevaplari, context);

              if (dbResult.isNotEmpty) {
                String? token = await getToken();
                if (token != null) {
                  await Future.wait([saveMustahsil(dbResult, token)])
                      .then((value) => clearAllPageInfo());
                } else {}
              } else {
                clearAllPageInfo();
              }
              emit(SatinAlimCompletelySuccess(response: result2.data));
            } else if (isMustahsil == false && isIrsaliye == true) {
              var dbResult = await basariliBildirimleriDbYeYaz(
                  urunList, succefullKayitCevaplari, context);
              if (dbResult.isNotEmpty) {
                String? token = await getToken();
                if (token != null) {
                  await Future.wait([
                    saveIrsaliye(dbResult, token),
                  ]).then((value) => clearAllPageInfo());
                } else {}
              } else {
                clearAllPageInfo();
              }
              emit(SatinAlimCompletelySuccess(response: result2.data));
            } else {
              var dbResult = await basariliBildirimleriDbYeYaz(
                  urunList, succefullKayitCevaplari, context);
              if (dbResult.isNotEmpty) {
                String? token = await getToken();
                if (token != null) {
                  await Future.wait([
                    saveIrsaliye(dbResult, token),
                    saveMustahsil(dbResult, token)
                  ]).then((value) => clearAllPageInfo());
                } else {}
              } else {
                clearAllPageInfo();
              }
              emit(SatinAlimCompletelySuccess(response: result2.data));
            }
            logBildirim();
          }
        } else {
          //hata
          emit(SatinAlimError(message: "hata"));

          emit(SatinAlimInitial());
        }
      }
    } catch (e) {
      emit(SatinAlimError(message: e.toString()));

      emit(SatinAlimInitial());
    }
  }

  Future<String?> getToken() async {
    MySoftUserModel? usermodel =
        MySoftUserCacheManager.instance.getItem(ActiveTc.instance.activeTc);
    if (usermodel != null) {
      var result = await MySoftAuthService.instance
          .getToken(usermodel.userName, usermodel.password);

      if (result.error != null) {
        emit(SatinAlimError(message: result.error!.message));
        emit(SatinAlimInitial());
      } else if (result.data != null) {
        return result.data;
      } else {
        emit(SatinAlimError(message: "MySoft hata 1"));
        emit(SatinAlimInitial());
      }
    } else {
      emit(SatinAlimError(message: "MySoft Bilgilerini Güncelleyiniz"));
      emit(SatinAlimInitial());
    }
    return null;
  }

  void clearFaturaInfo() {
    isMustahsilKesSuccess = false;
    isIrsaliyeKesSuccess = false;
    isIrsaliye = false;
    isMustahsil = false;
    emit(SatinAlimInitial());
  }

  Future<void> saveMustahsil(List<Urun> urunler, String token) async {
    var result = await MySoftFaturaService.instance
        .sendMustahsil(token, urunler, selectedUretici!);
    if (result.error != null) {
      isMustahsilKesSuccess = false;
      emit(SatinAlimError(
          message: result.error?.message ?? "mysoft Müstahsil hata"));

      emit(SatinAlimInitial());
    } else {
      isMustahsilKesSuccess = true;
      logMustahsil();
    }
  }

  Future<void> saveIrsaliye(List<Urun> urunler, String token) async {
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

      emit(SatinAlimError(
          message: result.error?.message ?? "mysoft irsaliye hata"));

      emit(SatinAlimInitial());
    } else {
      isIrsaliyeKesSuccess = true;
      logIrsaliye();
    }
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

  Future<List<Urun>> basariliBildirimleriDbYeYaz(
      List<Urun> urunlistesi,
      List<BildirimKayitCevapModel> basariliKunyeler,
      BuildContext context) async {
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

    await writeNotificationsToDb(kesinKaydedilecekKunyeler, context);
    return kesinKaydedilecekKunyeler;
    //await saveMustahsil(kesinKaydedilecekKunyeler);
    //await saveIrsaliye(kesinKaydedilecekKunyeler);
  }

  Future<void> writeNotificationsToDb(
      List<Urun> list, BuildContext context) async {
    if (list.isNotEmpty) {
      var result = CustomNotificationSaveModel(
          bildirimAdi: "Satın Alım",
          adres: gidecegiYer!.adres,
          isToplama: isToplamaHal,
          ilAdi: selectedIl,
          ilId: _ilId,
          ilceAdi: selectedIlce,
          ilceId: _ilceId,
          beldeAdi: selectedBelde,
          beldeId: _beldeId,
          gidecegiYerAdi: gidecegiYer!.name,
          gidecegiYerType: gidecegiYer!.type,
          gidecegiIsyeriId: gidecegiYer!.isyeriId,
          gidecegiYerIsletmeTuruAdi: gidecegiYer!.isletmeTuru,
          gidecegiYerIsletmeTuruId: gidecegiYer!.isletmeTuruId,
          selectedSifatType:
              context.read<TuccarHalIciDisiMainCubit>().selectedSifatType,
          selectedSifatId:
              context.read<TuccarHalIciDisiMainCubit>().selectedSifatId,
          date: DateTime.now().toString(),
          urunList: list.map((e) => e.toJson()).toList().cast<Map>(),
          uretici: isToplamaHal ? null : (selectedUretici?.toJson()),
          plaka: plakaController.text.trim());
      // result.date = DateTime.now().toString();
      Future.wait([
        CustomNotificationSaveCacheManager.instance
            .addItemCopy3(ActiveTc.instance.activeTc, result),
        LastCustomNotificationSaveCacheManager.instance
            .addItem(ActiveTc.instance.activeTc, result)
      ]);
    } else {}
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
        "Hks Bildir mobil uygulamasından gönderilmiştir.\nhttps://www.hksbildir.net";
    await WhatsappShare.share(
      text: messages,
      //  linkUrl: 'https://flutter.dev/',
      phone: '900',
    );
  }

  void activateAutoValidateMode() {
    isAutoValidateMode = AutovalidateMode.always;
    emit(SatinAlimInitial());
  }

  void disableAutoValidateMode() {
    isAutoValidateMode = AutovalidateMode.disabled;
    emit(SatinAlimInitial());
  }

  void activateAutoValidateModeForPlaka() {
    isAutoValidateModeForPlaka = AutovalidateMode.always;
    emit(SatinAlimInitial());
  }

  void disableAutoValidateModeForPlaka() {
    isAutoValidateModeForPlaka = AutovalidateMode.disabled;
    emit(SatinAlimInitial());
  }

  void activateAutoValidateModeForDriver() {
    isAutoValidateModeForDriver = AutovalidateMode.always;
    emit(SatinAlimInitial());
  }

  void disableAutoValidateModeForDriver() {
    isAutoValidateModeForDriver = AutovalidateMode.disabled;
    emit(SatinAlimInitial());
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
    emit(SatinAlimInitial());
    return hasError;
  }

  void removeFromUrunList(Urun urun) {
    urunList.remove(urun);
    emit(SatinAlimInitial());
  }

  void gidecegiYerSelected() {
    emit(SatinAlimInitial());
  }

  void emitInitial() {
    emit(SatinAlimInitial());
  }

  void emitError(String message) {
    emit(SatinAlimError(message: message));

    emit(SatinAlimInitial());
  }

  void logBildirim() {}

  void logIrsaliye() {}

  void logMustahsil() {}
}
