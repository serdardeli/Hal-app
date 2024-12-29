import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hal_app/feature/home/sub/bildirim_page/sub/tuccar_hal_ici_disi/viewmodel/cubit/tuccar_hal_ici_disi_main_cubit.dart';
import 'package:whatsapp_share2/whatsapp_share2.dart';
import '../../../../../../../../project/cache/mysoft_user_cache_mananger.dart';
import '../../../../../../../../project/model/MySoft_user_model/mysoft_user_model.dart';
import '../../../../../../../../project/model/driver_model/driver_model.dart';
import '../../../../../../../../project/model/hal_ici_isyeri/hal_ici_isyeri_model.dart';
import '../../../../../../../../project/model/malin_gidecegi_yer/malin_gidecegi_yer_model.dart';
import '../../../../../../../../project/model/musteri_model/musteri_model.dart';
import '../../../../../../../../project/service/hal/genel_service.dart';
import 'package:intl/intl.dart';
import 'package:kartal/kartal.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';
import 'package:xml/xml.dart';

import '../../../../../../../../project/cache/bildirimci_cache_manager.dart';
import '../../../../../../../../project/model/bildirim_kayit_response_model.dart/bildirim_kayit_response_model.dart';
import '../../../../../../../../project/model/bildirim_kayit_response_model.dart/sub/bildirim_kayit_cevap_model.dart';
import '../../../../../../../../project/model/bildirimci/bildirimci_model.dart';
import '../../../../../../../../project/model/hks_bildirim_model/hks_bildirim_model.dart';
import '../../../../../../../../project/model/referans_kunye/referans_kunye_model.dart';
import '../../../../../../../../project/service/hal/bildirim_service.dart';
import '../../../../../../../../project/service/hal/urun_service.dart';
import '../../../../../../../../project/service/mysoft/auth/mysoft_auth_service.dart';
import '../../../../../../../../project/service/mysoft/fatura/mysoft_fatura_service.dart';
import '../../../../../../../helper/active_tc.dart';

part 'sevk_etme_state.dart';

// sevk etme 196
class SevkEtmeCubit extends Cubit<SevkEtmeState> {
  SevkEtmeCubit() : super(SevkEtmeInitial()) {
    maxDate = DateTime.parse(
        dateFormat.format(DateTime.now().add(const Duration(days: 5))));
    startDay = DateTime.parse(
        dateFormat.format(DateTime.now().subtract(const Duration(days: 5))));
    endDay = DateTime.parse(
        dateFormat.format(DateTime.now().add(const Duration(days: 1))));
  }
  final TextEditingController driverIdController = TextEditingController();
  final TextEditingController driverNameController = TextEditingController();
  final TextEditingController driverAdiControllerForDropDown =
      TextEditingController();
  Map<String, String> komisyoncununSevkYapabilecegiSifatlar = {
    "9": "Depo/Tasnif ve Ambalaj",
    "3": "İthalat",
    "5": "Komisyoncu",
    "4": "Üretici",
    "10": "Üretici Örgütü",
  };
  TextEditingController plakaController = TextEditingController();
  final TextEditingController musteriAdiController = TextEditingController();
  final TextEditingController gidecegiYerController = TextEditingController();

  List<ReferansKunye> listReferansKunyeBildirimcininYaptigi = [];
  List<ReferansKunye> listReferansKunyeBildirimciyeYapilan = [];
  List<ReferansKunye> allReferansKunyeler = [];
  List<ReferansKunye> selectedKunyeler = [];
  bool isSurucuManual = false;
  DriverModel? selectedDriver;

  var driverFormKey = GlobalKey<FormState>();
  AutovalidateMode isAutoValidateModeForDriver = AutovalidateMode.disabled;

  String? activeBildirimciSifatId;
  Bildirimci? bildirimci;
  Musteri? selectedMusteri;
  late DateTime maxDate;
  static DateFormat dateFormat = DateFormat("yyyy-MM-dd");
  late DateTime startDay;
  bool isIrsaliyeKesSuccess = false;
  late DateTime endDay;
  bool isIrsaliye = false;
  bool isSevkYourself = false;
  set setIsSevkYourSelf(bool value) {
    isSevkYourself = value;
    emit(SevkEtmeInitial());
  }

  final plakaFormKey = GlobalKey<FormState>();
  final formKey = GlobalKey<FormState>();
  AutovalidateMode isAutoValidateMode = AutovalidateMode.disabled;

  AutovalidateMode isAutoValidateModeForPlaka = AutovalidateMode.disabled;
  String? ikinciKisiSifatId;
  String tcSorgulamaErrorText = "";
  GidecegiYer? gidecegiYer;

  Map<String, String> miktarIdleriStatic = {
    "74": "Kg",
    "76": "Bag",
    "73": "Adet"
  };

  final TextEditingController searchKunyeTextEditingController =
      TextEditingController();

  Future<void> customInit() async {
    assignActiveBildirimciSifatId();
    fetchKunyeTransActions();
    fetchMallar();
  }

  Map<String, String> _mallar = {};
  Map<String, String> get getMallar {
    if (_mallar.values.isEmpty) {
      fetchMallar();
    }
    return _mallar;
  }

  Future<void> fetchMallar() async {
    _mallar = await UrunService.instance.fetchUrunler();
    emit(SevkEtmeInitial());
  }

  fetchKunyeTransActions() {
    if (allReferansKunyeler.isEmpty) {
      Future.wait([
        fetchReferansKunyelerBildirimcininYaptigiWithObject(null, null),
        fetchReferansKunyelerBildirimciyeYapilanWithObject(null, null)
      ]).then((value) {
        fillAllReferansKunyeler();
      });
    }
  }

  Future<void> fetchKunyeTransActionsWithNewDate(
      DateTime? startDate, DateTime? endDate) async {
    emit(SevkEtmeLoading());

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

  Future<void> assignActiveBildirimciSifatId() async {
    bildirimci =
        BildirimciCacheManager.instance.getItem(ActiveTc.instance.activeTc);

    if (bildirimci != null) {
      bildirimci!.kayitliKisiSifatIdList?.forEach((element) {
        if (element == "6") {
          activeBildirimciSifatId = "6";
        }
        if (element == "20") {
          activeBildirimciSifatId = "20";
        }
      });
    } else {
      // TODO : HATA DURUMUNU ELE AL
    }
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

  bool isNumeric(String? s) {
    if (s == null || s.trim() == "") {
      return false;
    }
    return double.tryParse(s.trim()) != null;
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
      emit(SevkEtmeError(message: result.error!.message));
      emit(SevkEtmeInitial());
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
      emit(SevkEtmeError(message: result.error!.message));
      emit(SevkEtmeInitial());
    } else {
      result.data.forEach((element) {
        if (element.bildirimTuru == "197" || element.bildirimTuru == "196") {
          listReferansKunyeBildirimciyeYapilan.add(element);
        }
      });
    }
  }

  /*
  Future<void> fetchReferansKunyelerBildirimciyeYapilan() async {
    listKunyeBildirimciyeYapilan.clear();
    listReferansKunyeBildirimciyeYapilan.clear();

    DateFormat dateFormat = DateFormat("yyyy-MM-ddTHH:mm:ss");
    String startDay =
        dateFormat.format(DateTime.now().subtract(Duration(days: 3)));
    String endDay = dateFormat.format(DateTime.now().add(Duration(days: 1)));




    var result = await BildirimService.instance
        .bildirimBildirimciyeYapilanBildirimListesi(startDay, endDay);

    final document = XmlDocument.parse(result);
    var result1 = document.findAllElements('b:BildirimSorguDTO');

    listKunyeBildirimciyeYapilan = [];
    result1.forEach(
      (element) {
        listKunyeBildirimciyeYapilan.add(ReferansKunye.fromXmlElement(element));
        ReferansKunye.fromXmlElement(element);

      },
    );
    listKunyeBildirimciyeYapilan.forEach((element) {
      if (element.bildirimTuru == "197") {
        listReferansKunyeBildirimciyeYapilan.add(element);
      }
    });




  }
 Future<void> fetchReferansKunyelerBildirimcininYaptigi() async {
    listKunyeBildirimcininYaptigi.clear();
    listReferansKunyeBildirimcininYaptigi.clear();
    DateFormat dateFormat = DateFormat("yyyy-MM-ddTHH:mm:ss");
    String startDay =
        dateFormat.format(DateTime.now().subtract(Duration(days: 3)));
    String endDay = dateFormat.format(DateTime.now().add(Duration(days: 1)));

    var result = await BildirimService.instance
        .bildirimBildirimcininYaptigiBildirimListi(startDay, endDay);

    final document = XmlDocument.parse(result);
    var result1 = document.findAllElements('b:BildirimSorguDTO');

    listKunyeBildirimcininYaptigi = [];
    result1.forEach(
      (element) {
        listKunyeBildirimcininYaptigi
            .add(ReferansKunye.fromXmlElement(element));
        ReferansKunye.fromXmlElement(element);

      },
    );
    listKunyeBildirimcininYaptigi.forEach((element) {
      if (element.bildirimTuru == "195") {
        listReferansKunyeBildirimcininYaptigi.add(element);
      }
    });




  }
 */
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
    emit(SevkEtmeInitial());
  }

  void activateAutoValidateMode() {
    isAutoValidateMode = AutovalidateMode.always;
    emit(SevkEtmeInitial());
  }

  void disableAutoValidateMode() {
    isAutoValidateMode = AutovalidateMode.disabled;
    emit(SevkEtmeInitial());
  }

  void activateAutoValidateModeForPlaka() {
    isAutoValidateModeForPlaka = AutovalidateMode.always;
    emit(SevkEtmeInitial());
  }

  void disableAutoValidateModeForPlaka() {
    isAutoValidateModeForPlaka = AutovalidateMode.disabled;
    emit(SevkEtmeInitial());
  }

  void activateAutoValidateModeForDriver() {
    isAutoValidateModeForDriver = AutovalidateMode.always;
    emit(SevkEtmeInitial());
  }

  void disableAutoValidateModeForDriver() {
    isAutoValidateModeForDriver = AutovalidateMode.disabled;
    emit(SevkEtmeInitial());
  }

  Future<void> sevkYap(BuildContext context) async {
    emit(SevkEtmeLoading());

    for (var kunye in selectedKunyeler) {
      if (kunye.gonderilmekIstenenMiktar != null &&
          kunye.gonderilmekIstenenMiktar != "" &&
          double.parse(kunye.gonderilmekIstenenMiktar!) > 0) {
        kunye.kalanMiktar = kunye.gonderilmekIstenenMiktar;
      }
    }

    for (var kunye in selectedKunyeler) {}
    String? token = await getToken();
    if (token != null) {
      var result = await saveIrsaliyeForYourSelf(selectedKunyeler, token);
      if (result == true) {
        emit(SevkEtmeSuccessfulForJustIrsaliye());
        clearAllPageInfo();
      }
      // emit(SevkEtmeSuccessfulHasSomeError(response: result2.data));
    } else {
      emit(SevkEtmeError(message: "MySoft fatura error"));
      //emit(SevkEtmeSuccessfulHasSomeError(response: result2.data));
    }
  }

  Future<void> bildirimYap(BuildContext context) async {
    try {
      if (selectedMusteri == null) {
        emit(SevkEtmeError(message: "Müşteri Seçiniz"));

        emit(SevkEtmeInitial());
        return;
      }
      if (gidecegiYer == null) {
        emit(SevkEtmeError(
            message:
                "Gideceği yer seçiniz. Eğer gideceği yeri göremiyorsanız müşteri bilgilerini güncelleyiniz."));

        emit(SevkEtmeInitial());
        return;
      }
      emit(SevkEtmeLoading());
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
          bildirimciKisiSifatId:
              context.read<TuccarHalIciDisiMainCubit>().selectedSifatId ??
                  "null",
          //      activeBildirimciSifatId!, //?? assignActiveBildirimciSifatId()
          ikinciKisiAdiSoyadi: gidecegiYer!.name,
          // ceptel:  isyeri!.,
          ikinciKisiSifat:
              "5", //selected müşterinin durumuna göre bir şey yap satın alımda yapmışsındır
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
        emit(SevkEtmeError(message: result2.error!.message));
        emit(SevkEtmeInitial());
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

            // basariliBildirimleriDbYeYaz(urunList, succefullKayitCevaplari);
            if (isIrsaliye) {
              var dbResult = removeUnsuccessfulNotifications(
                  selectedKunyeler, succefullKayitCevaplari);

              if (dbResult.isNotEmpty) {
                String? token = await getToken();
                if (token != null) {
                  await Future.wait([saveIrsaliye(dbResult, token)]);
                  emit(SevkEtmeSuccessfulHasSomeError(response: result2.data));
                } else {
                  emit(SevkEtmeSuccessfulHasSomeError(response: result2.data));
                }
              } else {
                emit(SevkEtmeSuccessfulHasSomeError(response: result2.data));
              }
            } else {
              removeUnsuccessfulNotifications(
                  selectedKunyeler, succefullKayitCevaplari);
              emit(SevkEtmeSuccessfulHasSomeError(response: result2.data));
            }
          } else {
            // basariliBildirimleriDbYeYaz(urunList, succefullKayitCevaplari);
            if (isIrsaliye) {
              var dbResult = removeUnsuccessfulNotifications(
                  selectedKunyeler, succefullKayitCevaplari);

              if (dbResult.isNotEmpty) {
                String? token = await getToken();
                if (token != null) {
                  await Future.wait([saveIrsaliye(dbResult, token)]);
                  emit(SevkEtmeCompletelySuccessful(response: result2.data));
                } else {
                  emit(SevkEtmeCompletelySuccessful(response: result2.data));
                }
              } else {
                emit(SevkEtmeCompletelySuccessful(response: result2.data));
              }
            } else {
              clearAllPageInfo();

              emit(SevkEtmeCompletelySuccessful(response: result2.data));
            }
            logBildirim();
          }
        } else {
          emit(SevkEtmeError(message: "hata"));

          emit(SevkEtmeInitial());

          //hata
        }
      }

      //emit(SatinAlimSuccess(response: value));

      // emit(SevkEtmeInitial());
    } catch (e) {
      emit(SevkEtmeError(message: e.toString()));

      emit(SevkEtmeInitial());
    }
  }

  Future<String?> getToken() async {
    MySoftUserModel? usermodel =
        MySoftUserCacheManager.instance.getItem(ActiveTc.instance.activeTc);
    if (usermodel != null) {
      var result = await MySoftAuthService.instance
          .getToken(usermodel.userName, usermodel.password);

      if (result.error != null) {
        emit(SevkEtmeError(message: result.error!.message));
        emit(SevkEtmeInitial());
      } else if (result.data != null) {
        return result.data;
      } else {
        emit(SevkEtmeError(message: "MySoft hata 1"));
        emit(SevkEtmeInitial());
      }
    } else {
      emit(SevkEtmeError(message: "MySoft Bilgilerini Güncelleyiniz"));
      emit(SevkEtmeInitial());
    }
    return null;
  }

  void clearFaturaInfo() {
    isIrsaliyeKesSuccess = false;
    isIrsaliye = false;
    emit(SevkEtmeInitial());
  }

  Future<bool> saveIrsaliyeForYourSelf(
      List<ReferansKunye> urunler, String token) async {
    try {
      if (gidecegiYer == null) {
        emit(SevkEtmeError(message: "Gideceği yer hata save irsaliye"));
        return false;
      }
      var bildirimci =
          BildirimciCacheManager.instance.getItem(ActiveTc.instance.activeTc);
      var musteri =
          MySoftUserCacheManager.instance.getItem(ActiveTc.instance.activeTc)!;
      var result = await MySoftFaturaService.instance.sendIrsaliyeForSevkJUSTSEVK(
          token: token,
          urunler: urunler,
          musteri: Musteri(
              musteriAdiSoyadi: musteri.firmaAdi,
              musteriSifatIdList: [],
              musteriSifatNameList: [],
              musteriTc: bildirimci!.bildirimciTc!,
              isregisteredToHks: true),
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
          bildirimci: bildirimci);
      if (result.error != null) {
        isIrsaliyeKesSuccess = false;

        emit(SevkEtmeError(
            message: result.error?.message ?? "MySoft irsaliye hata"));
        emit(SevkEtmeInitial());
        return false;
      } else {
        isIrsaliyeKesSuccess = true;

        return true;
      }
    } catch (e) {
      emit(SevkEtmeError(message: e.toString()));
      emit(SevkEtmeInitial());

      return false;
    }
  }

  Future<bool> saveIrsaliye(List<ReferansKunye> urunler, String token) async {
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

        emit(SevkEtmeError(
            message: result.error?.message ?? "MySoft irsaliye hata"));
        emit(SevkEtmeInitial());
        return false;
      } else {
        isIrsaliyeKesSuccess = true;
        logIrsaliye();
        return true;
      }
    } catch (e) {
      emit(SevkEtmeError(message: e.toString()));
      emit(SevkEtmeInitial());

      return false;
    }
  }

  String get uniqueIdGenerator {
    var uuid = const Uuid();
    return uuid.v1();
  }

  List<ReferansKunye> removeUnsuccessfulNotifications(
      List<ReferansKunye> urunlistesi,
      List<BildirimKayitCevapModel> basariliKunyeler) {
    List<ReferansKunye> silinecekKunyeler = []; //ASLINDA BAŞARILI OLAN KÜNYELER

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

  void removeFromSelectedKunyeList(ReferansKunye e) {
    selectedKunyeler.remove(e);
    emit(SevkEtmeInitial());
  }

  void clearAllPageInfo() {
    plakaController.clear();
    selectedKunyeler.clear();
    gidecegiYer = null;
    selectedMusteri = null;
    selectedDriver = null;
    driverIdController.clear();
    driverNameController.clear();
    isSurucuManual = false;
    isSevkYourself = false;
    emit(SevkEtmeInitial());
  }

  void musteriSelected() {
    gidecegiYer = null;

    emit(SevkEtmeInitial());
  }

  void gidecegiYerSelected() {
    emit(SevkEtmeInitial());
  }

  void gidecegiYerSelectedSingle() {
    if (gidecegiYer == null) {
      emit(SevkEtmeInitial());
    }
  }

  void emitInitialState() {
    emit(SevkEtmeInitial());
  }

  void emitError(String message) {
    emit(SevkEtmeError(message: message));

    emit(SevkEtmeInitial());
  }

  void logIrsaliye() {}

  void logBildirim() {}
}
