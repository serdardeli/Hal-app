import 'dart:developer';
import '../../../../../../project/model/hks_bildirim_model/hks_bildirim_model.dart';
import 'package:kartal/kartal.dart';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import '../../../../../helper/active_tc.dart';
import '../../../../../../project/cache/user_cache_manager.dart';
import '../../../../../../project/model/hks_user/hks_user.dart';
import 'package:uuid/uuid.dart';
import '../../../../../../project/cache/bildirim_cache_manager.dart';
import '../../../../../../project/cache/bildirimci_cache_manager.dart';

import '../../../../../../project/model/bildirim/bildirim_model.dart';
import '../../../../../../project/model/bildirimci/bildirimci_model.dart';
import '../../../../../../project/model/user/my_user_model.dart';
import '../../../../../../project/service/hal/bildirim_service.dart';
import '../../../../../../project/service/hal/genel_service.dart';
import '../../../../../../project/service/hal/urun_service.dart';

part 'bildirim_state.dart';

//Tüccar hal içi ile tüccar hal içi bildirim yapamaz
class BildirimCubit extends Cubit<BildirimState> {
  final TextEditingController cityController = TextEditingController();
  final TextEditingController ilceController = TextEditingController();
  final TextEditingController beldeController = TextEditingController();
  final TextEditingController malinAdiController = TextEditingController();
  final TextEditingController malinTuruController = TextEditingController();
  final TextEditingController malinCinsiController = TextEditingController();
  final TextEditingController adetBagKgController = TextEditingController();
  final TextEditingController gramController = TextEditingController();
  final TextEditingController tlController = TextEditingController();
  final TextEditingController kurusController = TextEditingController();
  final TextEditingController bildirimciTcController = TextEditingController();
  final TextEditingController isletmeTuruController = TextEditingController();
  final TextEditingController kimdenKimeTcController = TextEditingController();
  final TextEditingController ikinciKisiAdSoyadController =
      TextEditingController();
  final TextEditingController ikinciKisCepTelController =
      TextEditingController();

  final TextEditingController plakaController = TextEditingController();
  final TextEditingController belgeNoController = TextEditingController();

  BildirimCubit() : super(BildirimInitial()) {
    //  fetchCities();
    // fetchMallar();
    // fetchTurler();
    // fetchSifatListesi();
    // fetchBildirimTurleri();
    // fetchHalIciIsyeri();
    // fetchUrunMiktarBirimleri();
    // fetchIsletmeTurleri();
    // fetchBelgeTipleri();
    // fetchMalinNitelikleri();
    //sifat sorgusunu tc ekledikten sonra burada yapınız
  }

  String _cityId = "";
  String _ilceId = "";
  String _beldeId = "";
  String _malId = "";
  String _turId = "";
  String _cinsId = "";
  String _malMiktarBirimId = "";
  String _belgeTipiId = "";
  String _bildirimTipiId = "";
  String _malinNiteligiId = "1";
  String _bildirimciSifatId = "";
  String _kimdenSifatId = "";
  String ikinciKisiIsyeriAdi = "";
  String _malIsmi = "";
  String ikinciKisiBulunamadiText = "";
  String gidecegiYerIsletmeTuruId = "";

  String? bildirimciSifat; //= "Komisyoncu"
  String? malinCins;
  String? gidecegiYerIsletmeTuru;

  String? ikinciKisiSifat;
  String? belgeTipi;

  String malMiktarBirimAdi = "";

  String bildirimTuru = "";
  bool isToplamaHal = false;
  bool isAnaliz = false;
  bool gidecekYerKayitlimi = false;
  List<String> kayitliKisiSifatAdiList = [];
  List<String> kayitliKisiSifatIdList = [];

  final Map<String, String> _cities = {};
  Map<String, String> _ilceler = {};
  Map<String, String> _beldeler = {};
  Map<String, String> _mallar = {};
  Map<String, String> _turler = {};
  Map<String, String> _sifatlar = {};
  Map<String, String> _bildirimTurleri = {};
  Map<String, String> _isletmeTurleri = {};
  Map<String, String> _belgeTipleri = {};
  Map<String, String> _malinNitelikleri = {};
  Map<String, dynamic> _kayitliKisiSifatMap = {};
  List<String> urunCinsiIsimleriList = [];
  String gidecegiHalIsyeriId = "";
  Map<String, String> halIciIsyeri = {};
  Map<String, Map<String, String>> _urunMiktarBirimleri = {};
  Map<String, Map<String, String>> _cinsler = {};

  clearAllIds() {
    _kimdenSifatId = "";
    bildirimciSifat = null;
    kayitliKisiSifatAdiList.clear();
    // bildirimciSifat = "null";


    emit(BildirimInitial());
  } //bunu sayfadan çıkarken de yapabilirsin

  fetchDataAsSelectedTc(String tc) {
    Bildirimci? bildirimci = BildirimciCacheManager.instance.getItem(tc);
    if (bildirimci == null) {
      emit(BildirimError(
          message: "kullanıcı bulunamadı lütfen uygulamayı tekrar başlatınız"));
    } else {

      customInit();
      fetchKayitliKisiSorgu();
      //getKayitliKisiSifatlari;
      bildirimciTcController.text = bildirimci.bildirimciTc!;
      //  _bildirimciSifatId = bildirimci.kisiSifatId!;
    }
  }

  Future<void> customInit() async {
    Future.wait([
      fetchCities(),
      fetchMallar(),
      fetchTurler(),
      fetchSifatListesi(),
      fetchBildirimTurleri(),
      fetchHalIciIsyeri(),
      fetchUrunMiktarBirimleri(),
      fetchIsletmeTurleri(),
      fetchBelgeTipleri(),
      fetchMalinNitelikleri()
    ]);
    getKayitliKisiSifatlari;
    var result = await GeneralService.instance
        .fetchAllHalIciIsyeri(ActiveTc.instance.activeTc);
    gidecegiHalIsyeriId = result["Id"].toString();

  }

  List<String> get getKayitliKisiSifatlari {

    if (kayitliKisiSifatAdiList.isEmpty) {


      fillKayitliKisiIsimleri();
    }
    if (kayitliKisiSifatAdiList.ext.isNotNullOrEmpty) {


      bildirimciSifat = kayitliKisiSifatAdiList.first;
      setBildirimciSifatId();
    }
    //emit(BildirimInitial());
    return kayitliKisiSifatAdiList;
  }

  void fillKayitliKisiIsimleri() {
    for (var element in getSifatlar.entries) {
      for (var item in kayitliKisiSifatIdList) {
        if (item == element.key) {
          kayitliKisiSifatAdiList.add(element.value);
        }
      }
    }
    if (kayitliKisiSifatAdiList.ext.isNotNullOrEmpty) {
      bildirimciSifat = kayitliKisiSifatAdiList.first;
      setBildirimciSifatId();
    }
    emit(BildirimInitial());
  }

  get getCities {
    if (_cities.values.isEmpty) {
      fetchCities();
    }
    return _cities;
  }

  get getIlceler {
    if (_ilceler.values.isEmpty) {
      fetchIlceler();
    }
    return _ilceler;
  }

  get getBeldeler {
    if (_beldeler.values.isEmpty) {
      fetchBeldeler();
    }
    return _beldeler;
  }

  get getMallar {
    if (_mallar.values.isEmpty) {
      fetchMallar();
    }
    return _mallar;
  }

  get getTurler {
    if (_turler.values.isEmpty) {
      fetchTurler();
    }
    return _turler;
  }

  Map<String, dynamic> get getKayitliKisiSorgu {
    if (_kayitliKisiSifatMap.values.isEmpty) {
      fetchKayitliKisiSorgu();
    }
    return _kayitliKisiSifatMap;
  }

  Map<String, String> get getBelgeTipleri {
    if (_belgeTipleri.values.isEmpty) {
      fetchBelgeTipleri();
    }
    return _belgeTipleri;
  }

  Map<String, String> get getMalinNitelikleri {
    if (_malinNitelikleri.values.isEmpty) {
      fetchMalinNitelikleri();
    }
    return _malinNitelikleri;
  }

  Map<String, String> get getIsletmeTurleri {
    if (_isletmeTurleri.values.isEmpty) {
      fetchIsletmeTurleri();
    }
    return _isletmeTurleri;
  }

  Map<String, Map<String, String>> get getUrunMiktarBirimleri {
    if (_urunMiktarBirimleri.keys.isEmpty) {
      fetchUrunMiktarBirimleri();
    }
    return _urunMiktarBirimleri;
  }

  Map<String, String> get getBildirimTurleri {
    if (_bildirimTurleri.values.isEmpty) {
      fetchBildirimTurleri();
    }
    return _bildirimTurleri;
  }

  Map<String, String> get getSifatlar {
    if (_sifatlar.values.isEmpty) {
      fetchSifatListesi();
    }
    return _sifatlar;
  }

  Map<String, Map<String, String>> get getCinsler {
    if (_cinsler.values.isEmpty) {
      fetchCinsler();
    }
    return _cinsler;
  }

  printAllIds() {















  }

  Future<void> fetchCities() async {
   //_cities = await GeneralService.instance.fetchAllCities();
  }

  Future<void> fetchIlceler() async {
    if (cityController.text.trim() != "") {
      _ilceler = await GeneralService.instance.fetchAllIlceler(_cityId);
    }
  }

  Future<void> fetchBeldeler() async {
    if (ilceController.text.trim() != "") {
      _beldeler = await GeneralService.instance.fetchAllBeldeler(_ilceId);
    }
  }

  Future<void> fetchMallar() async {
    _mallar = await UrunService.instance.fetchUrunler();
  }

  Future<void> fetchTurler() async {
    _turler = await UrunService.instance.fetchUretimSekiller();
  }

  Future<void> fetchHalIciIsyeri() async {
    halIciIsyeri =
        await GeneralService.instance.fetchAllHalIciIsyeri("8920308978");
  }

  Future fetchCinsler() async {
    urunCinsiIsimleriList.clear();
    if (_malId != "") {
      _cinsler = await UrunService.instance.fetchUrunCinsleri(_malId);
      String tempName = "";
      _cinsler.forEach(
        (key, value) {
          if (tempName != value["UrunCinsiAdi"] &&
              value["UrunCinsiAdi"].ext.isNotNullOrNoEmpty) {
            tempName = value["UrunCinsiAdi"]!;

            urunCinsiIsimleriList.add(value["UrunCinsiAdi"]!);
          }

          // tempName = value["UrunCinsiAdi"];
          var res = value["UrunCinsiAdi"];


        },
      );
      if (urunCinsiIsimleriList.ext.isNotNullOrEmpty) {
        malinCins = urunCinsiIsimleriList.first;
      }
      emit(BildirimInitial());




    }
  }

  Future<void> fetchSifatListesi() async {
    _sifatlar = await BildirimService.instance.bildirimSifatListesi();
    if (ikinciKisiSifat == null) {
      var result = _sifatlar.entries.first;
      ikinciKisiSifat = result.value;
      _kimdenSifatId = result.key;
    }
  }

  Future<void> fetchBildirimTurleri() async {
    _bildirimTurleri = await BildirimService.instance.bildirimTurleri();

    if (bildirimTuru == "") {
      MapEntry<String, String> result = getBildirimTurleri.entries.first;
      bildirimTuru = result.value;
      _bildirimTipiId = result.key;
    }
    for (var element in getBildirimTurleri.entries) {
      if (element.value == bildirimTuru) {
        _bildirimTipiId = element.key;
      }
    }
  }

  Future<void> fetchUrunMiktarBirimleri() async {
    _urunMiktarBirimleri =
        await UrunService.instance.fetchUrunMiktarBirimleri();
  }

  Future<void> fetchIsletmeTurleri() async {
    _isletmeTurleri = await GeneralService.instance.fetchAllHalIsletmeTurleri();

    if (gidecegiYerIsletmeTuru == null) {
      var result = _isletmeTurleri.entries.first;
      gidecegiYerIsletmeTuru = result.value;
      gidecegiYerIsletmeTuruId = result.key;
    }
  }

  Future<void> fetchBelgeTipleri() async {
    _belgeTipleri = await BildirimService.instance.belgeTipleriListesi();


    if (belgeTipi == null) {

      var result = _belgeTipleri.entries.first;

      belgeTipi = result.value;
      _belgeTipiId = result.key;
    }
  }

  Future<void> fetchMalinNitelikleri() async {
    _malinNitelikleri = await UrunService.instance.fetchMalinNiteligi();

  }

  Future<void> fetchKayitliKisiSorgu() async {
    _kayitliKisiSifatMap = await BildirimService.instance
        .bildirimKayitliKisiSorgu(ActiveTc.instance.activeTc);
    if (_kayitliKisiSifatMap["Sifatlari"] != null) {
      kayitliKisiSifatIdList = _kayitliKisiSifatMap["Sifatlari"];
      fillKayitliKisiIsimleriForInit();
    }
    if (bildirimciSifat == null) {}


    emit(BildirimInitial());
  }

  void fillKayitliKisiIsimleriForInit() {
    if (kayitliKisiSifatAdiList.isNotEmpty) {
      kayitliKisiSifatAdiList.clear();
    }
    for (var element in getSifatlar.entries) {
      for (var item in kayitliKisiSifatIdList) {
        if (item == element.key) {
          kayitliKisiSifatAdiList.add(element.value);
        }
      }
    }
    if (kayitliKisiSifatAdiList.ext.isNotNullOrEmpty) {
      bildirimciSifat = kayitliKisiSifatAdiList.first;
      setBildirimciSifatId();
    }
    emit(BildirimInitial());
  }

  void setBildirimciSifatId() {
    for (var element in getSifatlar.entries) {
      if (bildirimciSifat == "Komisyoncu") {
        bildirimTuru = "Üreticiden Sevk Alım";
        gidecegiYerIsletmeTuru = "Hal İçi İşyeri";
        setBildirimTuruId();
        setHalIciIsyeriId();
      }
      if (element.value == bildirimciSifat) {
        _bildirimciSifatId = element.key;
      }
    }
    emit(BildirimInitial());
  }

  findUrunCinsleriId() {

    _cinsler.forEach((key, value) {


      if (malinCins == value["UrunCinsiAdi"]! &&
          _turId == value["UretimSekliId"]) {
        _cinsId = value["Id"].toString();



      }
    });

  }

  malinAdiAndMalinTuruSelected() {
    if (malinAdiController.text.trim() != "" &&
        malinTuruController.text.trim() != "") {

      findUrunCinsleriId();

      //fetchCinsler().then((value) {
      //  setMalinCinsi();
      //});
      emit(BildirimInitial());
    }
  }

  citySelected() {
    for (var element in _cities.entries) {
      if (element.value == cityController.text.trim()) {
        _cityId = element.key;
      }
    }
    fetchIlceler();
    emit(BildirimInitial());
  }

  ilceSelected() {
    for (var element in _ilceler.entries) {
      if (element.value == ilceController.text.trim()) {
        _ilceId = element.key;
      }
    }
    fetchBeldeler();
    emit(BildirimInitial());
  }

  beldeSelected() {
    for (var element in _beldeler.entries) {
      if (element.value == beldeController.text.trim()) {
        _beldeId = element.key;
      }
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
  }

  malinAdiSelected() {
    // burada malin cinsleri çekilecek

    for (var element in _mallar.entries) {
      if (element.value == malinAdiController.text.trim()) {
        _malId = element.key;
        fetchCinsler();
        _malIsmi = element.value;
        malinCinsiController.text = malinAdiController.text.trim();
      }
    }

    setMalMiktari();
    emit(BildirimInitial());
  }

  malinTuruSelected() {
    for (var element in _turler.entries) {
      if (element.value == malinTuruController.text.trim()) {
        _turId = element.key;
      }
    }
  }

  //
  malinCinsiSelected() {
    findUrunCinsleriId();
    emit(BildirimInitial());
  }

  void bildirimciSifatSelected() {
    setBildirimciSifatId();
    // emit(BildirimInitial());
  }

  void setKimdenSifat() {
    for (var element in getSifatlar.entries) {
      if (element.value == ikinciKisiSifat) {
        _kimdenSifatId = element.key;
      }
    }
  }

  void ikinciKisiSifatSelected() {
    setKimdenSifat();
    emit(BildirimInitial());
  }

  void bildirimTuruSelected() {
    setBildirimTuruId();

    emit(BildirimInitial());
  }

  void setBildirimTuruId() {
    for (var element in getBildirimTurleri.entries) {
      if (element.value == bildirimTuru) {
        _bildirimTipiId = element.key;
      }
    }
  }

  void toplamaMalSelected() {
    setMalinNiteligiId();
    emit(BildirimInitial());
  }

  void analizSelected() {
    emit(BildirimInitial());
  }

  setHalIciIsyeriId() {
    for (var element in getIsletmeTurleri.entries) {
        if (element.value == gidecegiYerIsletmeTuru) {
          gidecegiYerIsletmeTuruId = element.key;
        }
      }
  }

  void isletmeTuruSelected() {
    //set isletme turuid
    setHalIciIsyeriId();

    emit(BildirimInitial());
  }

  void gidecekYerKayitlimiSelected() {
    emit(BildirimInitial());
  }

  void belgeTipiSelected() {
    for (var element in getBelgeTipleri.entries) {
      if (element.value == belgeTipi) {
        _belgeTipiId = element.key;
      }
    }
    emit(BildirimInitial());
  }

  void setMalinNiteligiId() {
    if (isToplamaHal) {
      for (var element in getMalinNitelikleri.entries) {
        _malinNiteligiId = element.key;
        if (element.value == "Toplamamal") {
          _malinNiteligiId = element.key;

        }
      }
    } else {
      for (var element in getMalinNitelikleri.entries) {
        if (element.value == "Yerli") {
          _malinNiteligiId = element.key;

        }
      }
    }
  }

  Future<void> saveButton() async {
    setMalinNiteligiId();
    Bildirim bildirim = Bildirim(
      uretimIlId: _cityId,
      uretimIlceId: _ilceId,
      uretimBeldeId: _beldeId,
      malId: _malId,
      malinCinsiId: _cinsId,
      malinNiteligiId: _malinNiteligiId,
      malinMiktarBirimId: _malMiktarBirimId,
      uretimSekliId: _turId,
      malAdi: _malIsmi,

      ikiniciKisiSirketAdi: ikinciKisiIsyeriAdi,

    );

    var hks = HksBildirim(
      malId: _malId,
      malinCinsiId: _cinsId,
      uretimSekliId: _turId,
      malinMiktarBirimId: _malMiktarBirimId,
      malinNiteligiId: _malinNiteligiId,
      uretimBeldeId: _beldeId,
      uretimIlId: _cityId,
      uretimIlceId: _ilceId,
      malinMiktari: urunMiktariniBul,
      malinSatisFiyat:
          "${tlController.text.trim()}.${kurusController.text.trim()}",
      bilidirimTuruId: _bildirimTipiId,
      bildirimciKisiSifatId: _bildirimciSifatId,
      ikinciKisiAdiSoyadi: ikinciKisiAdSoyadController.text.trim(),
      ceptel: ikinciKisCepTelController.text.trim(),
      ikinciKisiSifat: _kimdenSifatId,
      ikinciKisiTcVergiNo: kimdenKimeTcController.text.trim(),
      aracPlakaNo: plakaController.text.trim(),
      gidecegiIsyeriId: gidecegiHalIsyeriId,
      gidecegiYerIsletmeTuruId: gidecegiYerIsletmeTuruId,
      uniqueId: uniqueIdGenerator,
      belgeTipi: _belgeTipiId,
    );
    // BildirimService.instance.bildirimKaydet(hks);



   //BildirimListCacheManager.instance
   //    .addItem(ActiveTc.instance.activeTc, bildirim);
    //await BildirimCacheManager.instance.addItem(bildirim);

    //BildirimCacheManager.instance.getValues()!.forEach((element) {

    //});


  }

  String get uniqueIdGenerator {
    var uuid = const Uuid();
    return uuid.v1();
  }

  String get urunMiktariniBul => malMiktarBirimAdi.toLowerCase() == "kg"
      ? "${adetBagKgController.text.trim()}.${gramController.text.trim()}"
      : adetBagKgController.text.trim();

  String kayitliKisiBulunamadiText = "";
  Future<void> kimdenKimeTcSorgula() async {
    var isSaved = await BildirimService.instance
        .bildirimKayitliKisiSorgu(kimdenKimeTcController.text.trim());

    if (isSaved["KayitliKisiMi"] == "true") {
      kayitliKisiBulunamadiText = "";
    } else {
      ikinciKisiSifat = "Üretici";
      for (var element in getSifatlar.entries) {
        _kimdenSifatId = element.key;
      }

      kayitliKisiBulunamadiText =
          "kayitli Kisi Bulunamadı gsm ve ad soyad bilgisini doldurunuz";
    }
  }

  Future<void> malinGidecegiKisiSorgula() async {
    var result = await GeneralService.instance
        .fetchAllHalIciIsyeri(bildirimciTcController.text.trim());
    if (result.isNotEmpty) {
      if (result["IsyeriAdi"] != null) {
        ikinciKisiIsyeriAdi = result["IsyeriAdi"]!;
        ikinciKisiBulunamadiText = "";

        emit(BildirimInitial());
        return;
      }
    }
    ikinciKisiIsyeriAdi = "";
    ikinciKisiBulunamadiText = "bildirimci bulunamadı";

    emit(BildirimInitial());
  }
}
