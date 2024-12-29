import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kartal/kartal.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp_share2/whatsapp_share2.dart';

import '../../../../../../../../project/cache/bildirimci_cache_manager.dart';
import '../../../../../../../../project/cache/mysoft_user_cache_mananger.dart';
import '../../../../../../../../project/model/MySoft_user_model/mysoft_user_model.dart';
import '../../../../../../../../project/model/bildirim_kayit_response_model.dart/bildirim_kayit_response_model.dart';
import '../../../../../../../../project/model/bildirim_kayit_response_model.dart/sub/bildirim_kayit_cevap_model.dart';
import '../../../../../../../../project/model/driver_model/driver_model.dart';
import '../../../../../../../../project/model/hks_bildirim_model/hks_bildirim_model.dart';
import '../../../../../../../../project/model/malin_gidecegi_yer/malin_gidecegi_yer_model.dart';
import '../../../../../../../../project/model/musteri_model/musteri_model.dart';
import '../../../../../../../../project/model/referans_kunye/referans_kunye_model.dart';
import '../../../../../../../../project/service/hal/bildirim_service.dart';
import '../../../../../../../../project/service/hal/urun_service.dart';
import '../../../../../../../../project/service/mysoft/auth/mysoft_auth_service.dart';
import '../../../../../../../../project/service/mysoft/fatura/mysoft_fatura_service.dart';
import '../../../../../../../helper/active_tc.dart';

part 'sevk_etme_for_sanayici_state.dart';

class SevkEtmeForSanayiciCubit extends Cubit<SevkEtmeForSanayiciState> {
  SevkEtmeForSanayiciCubit() : super(SevkEtmeForSanayiciInitial()) {
    maxDate = DateTime.parse(
        dateFormat.format(DateTime.now().add(const Duration(days: 5))));
    startDay = DateTime.parse(
        dateFormat.format(DateTime.now().subtract(const Duration(days: 5))));
    endDay = DateTime.parse(
        dateFormat.format(DateTime.now().add(const Duration(days: 1))));
  }
  final TextEditingController gidecegiYerController = TextEditingController();

  TextEditingController plakaController = TextEditingController();

  final plakaFormKey = GlobalKey<FormState>();
  final formKey = GlobalKey<FormState>();
  AutovalidateMode isAutoValidateMode = AutovalidateMode.disabled;
  AutovalidateMode isAutoValidateModeForPlaka = AutovalidateMode.disabled;

  final TextEditingController musteriAdiController = TextEditingController();
  Musteri? selectedMusteri;
  GidecegiYer? gidecegiYer;
  late DateTime maxDate;
  bool sadeceSelectedUreticiyeAitKunyeleriSorgula = false;
  static DateFormat dateFormat = DateFormat("yyyy-MM-dd");
  late DateTime startDay;

  late DateTime endDay;
  bool isIrsaliye = false;
  bool isIrsaliyeKesSuccess = false;

  Map<String, String> _mallar = {};
  //Driver--
  DriverModel? selectedDriver;

  final TextEditingController driverIdController = TextEditingController();
  final TextEditingController driverNameController = TextEditingController();
  final TextEditingController driverAdiControllerForDropDown =
      TextEditingController();
  bool isSurucuManual = false;
  var driverFormKey = GlobalKey<FormState>();
  void activateAutoValidateModeForDriver() {
    isAutoValidateModeForDriver = AutovalidateMode.always;
    emit(SevkEtmeForSanayiciInitial());
  }

  void disableAutoValidateModeForDriver() {
    isAutoValidateModeForDriver = AutovalidateMode.disabled;
    emit(SevkEtmeForSanayiciInitial());
  }

  AutovalidateMode isAutoValidateModeForDriver = AutovalidateMode.disabled;

  //Driver--
  List<ReferansKunye> listReferansKunyeBildirimcininYaptigi = [];
  List<ReferansKunye> listReferansKunyeBildirimciyeYapilan = [];
  List<ReferansKunye> allReferansKunyeler = [];
  List<ReferansKunye> selectedKunyeler = [];
  final TextEditingController searchKunyeTextEditingController =
      TextEditingController();
  Map<String, String> komisyoncununSevkYapabilecegiSifatlar = {
    "9": "Depo/Tasnif ve Ambalaj",
    "3": "İthalat",
    "5": "Komisyoncu",
    "4": "Üretici",
    "10": "Üretici Örgütü",
  };
  Map<String, String> miktarIdleriStatic = {
    "74": "Kg",
    "76": "Bag",
    "73": "Adet"
  };
  Map<String, String> musterideOlanSatisYapilabilecekSifatlar = {};
  String? selectedSatisYapilacakSifatName;
  String? selectedSatisYapilacakSifatId;
  Map<String, String> get getMallar {
    if (_mallar.values.isEmpty) {
      fetchMallar();
    }
    return _mallar;
  }

  void musteriSelected() {
    gidecegiYer = null;
    assignSatisYapilabilecekSifatlar();

    emit(SevkEtmeForSanayiciInitial());
  }

  void clearAllPageInfo() {
    //plakaController.clear();
    selectedKunyeler.clear();
    gidecegiYer = null;
    musterideOlanSatisYapilabilecekSifatlar.clear();
    selectedSatisYapilacakSifatName = null;
    selectedSatisYapilacakSifatId = null;
    selectedMusteri = null;
    plakaController.clear();
    sadeceSelectedUreticiyeAitKunyeleriSorgula = false;

    emit(SevkEtmeForSanayiciInitial());
  }

  bool isNumeric(String? s) {
    if (s == null || s.trim() == "") {
      return false;
    }
    return double.tryParse(s.trim()) != null;
  }

  void removeFromSelectedKunyeList(ReferansKunye e) {
    selectedKunyeler.remove(e);
    emit(SevkEtmeForSanayiciInitial());
  }

  void fillAllReferansKunyeler() {
    allReferansKunyeler.clear();
    allReferansKunyeler.addAll(listReferansKunyeBildirimcininYaptigi);
    allReferansKunyeler.addAll(listReferansKunyeBildirimciyeYapilan);
    sortAsDayTime(allReferansKunyeler);
  }

  sortAsDayTime(List<ReferansKunye> kunyeList) {
    kunyeList.sort((a, b) => b.compareTo(a));
  }

  Future<void> fetchKunyeTransActionsWithNewDate(
      DateTime? startDate, DateTime? endDate) async {
    emit(SevkEtmeForSanayiciLoading());
    listReferansKunyeBildirimcininYaptigi.clear();
    listReferansKunyeBildirimciyeYapilan.clear();
    allReferansKunyeler.clear();
    await Future.wait([
      fetchReferansKunyelerBildirimcininYaptigiWithObject(startDate, endDate),
      fetchReferansKunyelerBildirimciyeYapilanWithObject(startDate, endDate)
    ]).then((value) {
      fillAllReferansKunyeler();
    });
  }

  Future<void> fetchReferansKunyelerBildirimcininYaptigiWithObject(
      DateTime? startDate, DateTime? endDate) async {
    listReferansKunyeBildirimcininYaptigi.clear();
    DateFormat dateFormat = DateFormat("yyyy-MM-ddTHH:mm:ss");
    String startDay =
        dateFormat.format(DateTime.now().subtract(const Duration(days: 3)));
    String endDay =
        dateFormat.format(DateTime.now().add(const Duration(days: 1)));
    if (startDate != null) {
      startDay = dateFormat.format(startDate);
    }
    if (endDate != null) {
      endDay = dateFormat.format(endDate);
    }
    var result = await BildirimService.instance
        .bildirimBildirimcininYaptigiBildirimListesiWithObject(
            startDay, endDay);
    if (result.error != null) {
      emit(SevkEtmeForSanayiciError(message: result.error!.message));
      emit(SevkEtmeForSanayiciInitial());
    } else {
      result.data.forEach((element) {
        if (element.bildirimTuru == "195" || element.bildirimTuru == "206") {
          listReferansKunyeBildirimcininYaptigi.add(element);
        }
      });
    }
  }

  Future<void> fetchReferansKunyelerBildirimciyeYapilanWithObject(
      DateTime? startDate, DateTime? endDate) async {
    listReferansKunyeBildirimciyeYapilan.clear();

    DateFormat dateFormat = DateFormat("yyyy-MM-ddTHH:mm:ss");
    String startDay =
        dateFormat.format(DateTime.now().subtract(const Duration(days: 3)));
    String endDay =
        dateFormat.format(DateTime.now().add(const Duration(days: 1)));
    if (startDate != null) {
      startDay = dateFormat.format(startDate);
    }
    if (endDate != null) {
      endDay = dateFormat.format(endDate);
    }

    var result = await BildirimService.instance
        .bildirimBildirimciyeYapilanBildirimListesiWithObject(startDay, endDay);
    if (result.error != null) {
      emit(SevkEtmeForSanayiciError(message: result.error!.message));
      emit(SevkEtmeForSanayiciInitial());
    } else {
      result.data.forEach((element) {
        if (element.bildirimTuru == "197" || element.bildirimTuru == "196") {
          listReferansKunyeBildirimciyeYapilan.add(element);
        }
      });
    }
  }

  bool kunyeSelectedOrNot(ReferansKunye kunye) {
    if (selectedKunyeler.ext.isNotNullOrEmpty) {
      for (var element in selectedKunyeler) {
        if (element == kunye) {
          return true;
        }
      }
      return false;
    } else {
      return false;
    }
  }

  void kunyelerSelected() {
    emit(SevkEtmeForSanayiciInitial());
  }

  void emitInitialState() {
    emit(SevkEtmeForSanayiciInitial());
  }

  void activateAutoValidateModeForPlaka() {
    isAutoValidateModeForPlaka = AutovalidateMode.always;
    emit(SevkEtmeForSanayiciInitial());
  }

  void disableAutoValidateModeForPlaka() {
    isAutoValidateModeForPlaka = AutovalidateMode.disabled;
    emit(SevkEtmeForSanayiciInitial());
  }

  Future<void> bildirimYap(BuildContext context) async {
    try {
      if (selectedMusteri == null) {
        emit(SevkEtmeForSanayiciError(message: "Müşteri Seçiniz"));
        emit(SevkEtmeForSanayiciInitial());
        return;
      }
      if (gidecegiYer == null) {
        emit(SevkEtmeForSanayiciError(
            message:
                "Gideceği yer seçiniz. Eğer gideceği yeri göremiyorsanız müşteri bilgilerini güncelleyiniz."));
        emit(SevkEtmeForSanayiciInitial());
        return;
      }
      emit(SevkEtmeForSanayiciLoading());
      List<HksBildirim> hksBildirimList = [];
      for (var kunye in selectedKunyeler) {
        if (kunye.gonderilmekIstenenMiktar != null &&
            kunye.gonderilmekIstenenMiktar != "" &&
            double.parse(kunye.gonderilmekIstenenMiktar!) > 0) {
          kunye.kalanMiktar = kunye.gonderilmekIstenenMiktar;
        }

        var hks = HksBildirim(
          malId: "0",
          malinCinsiId: "0",
          uretimSekliId: "0",
          malinMiktarBirimId: "0",
          malinNiteligiId: "0",
          uretimBeldeId: "0",
          uretimIlId: "0",
          uretimIlceId: "0",
          malinMiktari: kunye.kalanMiktar!,
          //malinSatisFiyat: kunye.malinSatisFiyati,

          gidecegiYerBeldeId: "0",
          gidecegiYerIlId: "0",
          gidecegiYerIlceId: "0",
          bilidirimTuruId: "196",
          bildirimciKisiSifatId: "5",
          //      activeBildirimciSifatId!, //?? assignActiveBildirimciSifatId()
          ikinciKisiAdiSoyadi: gidecegiYer!.name,
          // ceptel:  isyeri!.,
          ikinciKisiSifat: selectedSatisYapilacakSifatId ??
              "null", //selected müşterinin durumuna göre bir şey yap satın alımda yapmışsındır
          ikinciKisiTcVergiNo: selectedMusteri!.musteriTc,
          aracPlakaNo: plakaController.text.trim(),
          gidecegiIsyeriId: gidecegiYer!.isyeriId,
          gidecegiYerIsletmeTuruId: gidecegiYer!.isletmeTuruId, //??
          uniqueId: uniqueIdGenerator,
          belgeTipi: "207",
          referansBildirimKunyeNo: kunye.kunyeNo!,
        );
        hksBildirimList.add(hks);
      }

      var result2 =
          await BildirimService.instance.cokluBildirimKaydet(hksBildirimList);
      List<BildirimKayitCevapModel> succefullKayitCevaplari = [];

      if (result2.error != null) {
        emit(SevkEtmeForSanayiciError(
            message: result2.error!.statusCode.toString()));
        emit(SevkEtmeForSanayiciInitial());
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
              var dbResult = removeUnsuccessfulNotifications(
                  selectedKunyeler, succefullKayitCevaplari);
              if (dbResult.isNotEmpty) {
                String? token = await getToken();
                if (token != null) {
                  await Future.wait([saveIrsaliye(dbResult, token)]);
                  emit(SevkEtmeForSanayiciSuccessHasSomeError(
                      response: result2.data));
                } else {
                  emit(SevkEtmeForSanayiciSuccessHasSomeError(
                      response: result2.data));
                }
              } else {
                emit(SevkEtmeForSanayiciSuccessHasSomeError(
                    response: result2.data));
              }
            } else {
              removeUnsuccessfulNotifications(
                  selectedKunyeler, succefullKayitCevaplari);
              emit(SevkEtmeForSanayiciSuccessHasSomeError(
                  response: result2.data));
            }
          } else {
            if (isIrsaliye) {
              var dbResult = removeUnsuccessfulNotifications(
                  selectedKunyeler, succefullKayitCevaplari);
              if (dbResult.isNotEmpty) {
                String? token = await getToken();
                if (token != null) {
                  await Future.wait([saveIrsaliye(dbResult, token)]);
                  emit(SevkEtmeForSanayiciCompletelySuccess(
                      response: result2.data));
                } else {
                  emit(SevkEtmeForSanayiciCompletelySuccess(
                      response: result2.data));
                }
              } else {
                emit(SevkEtmeForSanayiciCompletelySuccess(
                    response: result2.data));
              }
            } else {
              clearAllPageInfo();
              emit(
                  SevkEtmeForSanayiciCompletelySuccess(response: result2.data));
            }
            logBildirim();
          }
        } else {
          //hata
          emit(SevkEtmeForSanayiciError(message: "hata"));

          emit(SevkEtmeForSanayiciInitial());
        }
      }
    } catch (e) {
      emit(SevkEtmeForSanayiciError(message: e.toString()));
      emit(SevkEtmeForSanayiciInitial());
    }
  }

  Future<String?> getToken() async {
    MySoftUserModel? usermodel =
        MySoftUserCacheManager.instance.getItem(ActiveTc.instance.activeTc);
    if (usermodel != null) {
      var result = await MySoftAuthService.instance
          .getToken(usermodel.userName, usermodel.password);

      if (result.error != null) {
        emit(SevkEtmeForSanayiciError(message: result.error!.message));
        emit(SevkEtmeForSanayiciInitial());
      } else if (result.data != null) {
        return result.data;
      } else {
        emit(SevkEtmeForSanayiciError(message: "MySoft hata 1"));
        emit(SevkEtmeForSanayiciInitial());
      }
    } else {
      emit(SevkEtmeForSanayiciError(
          message: "MySoft Bilgilerini Güncelleyiniz"));
      emit(SevkEtmeForSanayiciInitial());
    }
    return null;
  }

  void clearFaturaInfo() {
    isIrsaliyeKesSuccess = false;
    isIrsaliye = false;
    emit(SevkEtmeForSanayiciInitial());
  }

  Future<void> saveIrsaliye(List<ReferansKunye> urunler, String token) async {
    try {
      var bildirimci =
          BildirimciCacheManager.instance.getItem(ActiveTc.instance.activeTc);
      var result = await MySoftFaturaService.instance.sendIrsaliyeForSevkJUSTSEVK(
          token: token,
          urunler: urunler,
          musteri: selectedMusteri!,
          gidecegiYer: gidecegiYer ??
              GidecegiYer(
                  adres:
                      ("${selectedMusteri!.musteriIlAdi ?? ""}  ${selectedMusteri!.musteriIlceAdi ?? ""}  ${selectedMusteri!.musteriBeldeAdi ?? ""}"),
                  isletmeTuru: "0",
                  isletmeTuruId: "0",
                  isyeriId: "0",
                  name: "",
                  type: ""),
          driver: selectedDriver!,
          plaka: plakaController.text.trim(),
          bildirimci: bildirimci!);
      if (result.error != null) {
        isIrsaliyeKesSuccess = false;

        emit(SevkEtmeForSanayiciError(
            message: result.error?.message ?? "mysoft irsaliye cubit error"));
        emit(SevkEtmeForSanayiciInitial());
      } else {
        isIrsaliyeKesSuccess = true;
        logIrsaliye();
      }
    } catch (e) {
      emit(SevkEtmeForSanayiciError(message: e.toString()));
      emit(SevkEtmeForSanayiciInitial());
    }
  }

  List<ReferansKunye> removeUnsuccessfulNotifications(
      List<ReferansKunye> urunlistesi,
      List<BildirimKayitCevapModel> basariliKunyeler) {
    List<ReferansKunye> silinecekKunyeler = [];

    bool urunAdded = false;

    for (var urun in urunlistesi) {
      urunAdded = false;

      for (var item in basariliKunyeler) {
        if (urun.malinKodNo == item.malinId &&
            urun.malinCinsiKodNo == item.malinCinsiId) {
          if (urunAdded == true) {
            break;
          }
          bool isContain = false;
          for (var element2 in silinecekKunyeler) {
            if (element2.kunyeNo == item.kunyeNo) {
              isContain = true;

              break;
            }
          }
          if (!isContain) {
            urunAdded = true;
            urun.kunyeNo = item.kunyeNo;
            silinecekKunyeler.add(urun);
          }
        }
      }
    }
    for (var element in silinecekKunyeler) {
      var result = selectedKunyeler.remove(element);
    }
    return silinecekKunyeler;
  }

  String get uniqueIdGenerator {
    var uuid = const Uuid();
    return uuid.v1();
  }

  void gidecegiYerSelectedSingle(GidecegiYer value) {
    if (gidecegiYer == null) {
      gidecegiYer = value;

      emit(SevkEtmeForSanayiciInitial());
      return;
    }
    gidecegiYer = value;
  }

  void gidecegiYerSelected() {
    emit(SevkEtmeForSanayiciInitial());
  }

  void assignSatisYapilabilecekSifatlar() {
    musterideOlanSatisYapilabilecekSifatlar.clear();

    selectedMusteri?.musteriSifatNameList.forEach((element) {
      komisyoncununSevkYapabilecegiSifatlar.forEach((key, value) {
        if (element == value) {
          musterideOlanSatisYapilabilecekSifatlar.addAll({key: value});
        }
      });
    });
    if (musterideOlanSatisYapilabilecekSifatlar.isNotEmpty) {
      selectedSatisYapilacakSifatName =
          musterideOlanSatisYapilabilecekSifatlar.entries.first.value;
      selectedSatisYapilacakSifatId =
          musterideOlanSatisYapilabilecekSifatlar.entries.first.key;
    }
  }

  void satisYapilacakSifatSelected() {
    musterideOlanSatisYapilabilecekSifatlar.forEach(
      (key, value) {
        if (value == selectedSatisYapilacakSifatName) {
          selectedSatisYapilacakSifatId = key;
        }
      },
    );
    emit(SevkEtmeForSanayiciInitial());
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

  Future<void> fetchMallar() async {
    _mallar = await UrunService.instance.fetchUrunler();
    emit(SevkEtmeForSanayiciInitial());
  }

  void emitError(String message) {
    emit(SevkEtmeForSanayiciError(message: message));

    emit(SevkEtmeForSanayiciInitial());
  }

  void logBildirim() {}
  
  void logIrsaliye() {}
}
