import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hal_app/feature/home/sub/bildirim_page/main_bildirim_page/viewmodel/cubit/main_bildirim_cubit.dart';
import 'package:hal_app/feature/home/sub/bildirim_page/sub/sevk_etme_page/viewmodel/cubit/sevk_etme_cubit.dart';
import 'package:intl/intl.dart';
import 'package:kartal/kartal.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp_share2/whatsapp_share2.dart';

import '../../../../../../../../core/model/response_model/IResponse_model.dart';
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
import '../../../tuccar_hal_ici_disi/viewmodel/cubit/tuccar_hal_ici_disi_main_cubit.dart';

part 'satis_state.dart';

class SatisCubit extends Cubit<SatisState> {
  SatisCubit() : super(SatisInitial()) {
    maxDate = DateTime.parse(
        dateFormat.format(DateTime.now().add(const Duration(days: 5))));
    startDay = DateTime.parse(
        dateFormat.format(DateTime.now().subtract(const Duration(days: 5))));
    endDay = DateTime.parse(
        dateFormat.format(DateTime.now().add(const Duration(days: 1))));
  }
  TextEditingController plakaController = TextEditingController();
  final TextEditingController musteriAdiController = TextEditingController();
  final TextEditingController searchKunyeTextEditingController =
      TextEditingController();

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
    emit(SatisInitial());
  }

  void disableAutoValidateModeForDriver() {
    isAutoValidateModeForDriver = AutovalidateMode.disabled;
    emit(SatisInitial());
  }

  AutovalidateMode isAutoValidateModeForDriver = AutovalidateMode.disabled;

  //Driver--
  final plakaFormKey = GlobalKey<FormState>();
  final allPricesFormKey = GlobalKey<FormState>();
  AutovalidateMode isAutoValidateModeForPlaka = AutovalidateMode.disabled;

  List<ReferansKunye> listKunyeBildirimcininYaptigi = [];
  List<ReferansKunye> listReferansKunyeBildirimcininYaptigi = [];
  List<ReferansKunye> listKunyeBildirimciyeYapilan = [];
  List<ReferansKunye> listReferansKunyeBildirimciyeYapilan = [];
  List<ReferansKunye> allReferansKunyeler = [];
  List<ReferansKunye> selectedKunyeler = [];
  GidecegiYer? gidecegiYer;
  bool fiyatTumunuSec = false;

  Musteri? selectedMusteri;
  late DateTime maxDate;
  static DateFormat dateFormat = DateFormat("yyyy-MM-dd");
  late DateTime startDay;

  late DateTime endDay;
  Map<String, String> malinGidecegiYerlerForNonRegisterUser = {
    "1": "Şube",
    "18": "Bireysel Tüketim",
    "19": "Perakende Satiş Yeri"
  };
  Map<String, String> _mallar = {};
  bool isSatisFatura = false;
  bool isIrsaliye = false;
  bool isFaturaKesSuccess = false;
  bool isIrsaliyeKesSuccess = false;
  Map<String, String> musterideOlanSatisYapilabilecekSifatlar = {};
  String? selectedSatisYapilacakSifatName;
  String? selectedSatisYapilacakSifatId;

  Map<String, String> satisYapilabilecekSifatlar = {
    "19": "Hastane",
    "2": "İhracat",
    "23": "İmalatçı",
    "13": "Lokanta",
    "8": "Manav",
    "7": "Market",
    "12": "Otel",
    "11": "Pazarcı",
    "1": "Sanayici",
    "20": "Tüccar (Hal Dışı)",
    "6": "Tüccar (Hal İçi)",
    "15": "Yemek Fabrikası",
    "14": "Yurt",
  };
  Map<String, String> miktarIdleriStatic = {
    "74": "Kg",
    "76": "Bag",
    "73": "Adet"
  };
  Map<String, String> get getMallar {
    if (_mallar.values.isEmpty) {
      fetchMallar();
    }
    return _mallar;
  }

  clearMusteriSifatInfos() {
    musterideOlanSatisYapilabilecekSifatlar.clear();
    selectedSatisYapilacakSifatName = null;
    selectedSatisYapilacakSifatId = null;
  }

  void assignSatisYapilabilecekSifatlar() {
    musterideOlanSatisYapilabilecekSifatlar.clear();

    selectedMusteri?.musteriSifatIdList.forEach((element) {
      satisYapilabilecekSifatlar.forEach((key, value) {
        if (element == key) {
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

  //kayıtlı kullanıcının sifatlarını tara komisyonucuyu çıkardıktan sonra
/**
 * 
 * 
 *     DateFormat dateFormat = DateFormat("yyyy-MM-ddTHH:mm:ss");
    String startDay =
        dateFormat.format(DateTime.now().subtract(Duration(days: 3)));
    String endDay = dateFormat.format(DateTime.now().add(Duration(days: 1)));
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

  bool isNumeric(String? s) {
    if (s == null || s.trim() == "") {
      return false;
    }
    return double.tryParse(s.trim()) != null;
  }

  Future<void> customInit() async {
    // assignActiveBildirimciSifatId();
    fetchKunyeTransActions();
    fetchMallar();
  }

  void fetchKunyeTransActions() {
    if (allReferansKunyeler.isEmpty) {
      Future.wait([
        fetchReferansKunyelerBildirimcininYaptigiWithObject(null, null),
        fetchReferansKunyelerBildirimciyeYapilanWithObject(null, null)
      ]).then((value) {
        fillAllReferansKunyeler();
      });
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
      emit(SatisError(message: result.error!.message));
      emit(SatisInitial());
    } else {
      for (var element in (result.data as List<ReferansKunye>)) {
        if (element.bildirimTuru == "195" || element.bildirimTuru == "206") {
          listReferansKunyeBildirimcininYaptigi.add(element);
        }
      }
    }
  }

  Future<void> fetchKunyeTransActionsWithNewDate(
      DateTime? startDate, DateTime? endDate) async {
    emit(SatisLoading());

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
      emit(SatisError(message: result.error!.message));
      emit(SatisInitial());
    } else {
      for (var element in (result.data as List<ReferansKunye>)) {
        if (element.bildirimTuru == "197" || element.bildirimTuru == "196") {
          listReferansKunyeBildirimciyeYapilan.add(element);
        }
      }
    }
  }

  void removeFromSelectedKunyeList(ReferansKunye e) {
    selectedKunyeler.remove(e);
    emit(SatisInitial());
  }

  void activateAutoValidateModeForPlaka() {
    isAutoValidateModeForPlaka = AutovalidateMode.always;
    emit(SatisInitial());
  }

  void disableAutoValidateModeForPlaka() {
    isAutoValidateModeForPlaka = AutovalidateMode.disabled;
    emit(SatisInitial());
  }

  void kunyelerSelected() => emit(SatisInitial());
  void emitInitialState() => emit(SatisInitial());

  Future<void> registeredUserBildirimYapTransactions(
      BuildContext context) async {
    try {
      String selectedBildirimciSifatId = "";
      if (context.read<MainBildirimCubit>().selectedSifatForMain ==
          UserAdjectives.komisyoncu) {
        selectedBildirimciSifatId = "5";
      } else if (context.read<MainBildirimCubit>().selectedSifatForMain ==
          UserAdjectives.sanayici) {
        selectedBildirimciSifatId = "1";
      } else {
        selectedBildirimciSifatId =
            context.read<TuccarHalIciDisiMainCubit>().selectedSifatId == null
                ? "null"
                : context.read<TuccarHalIciDisiMainCubit>().selectedSifatId!;
      }
      List<HksBildirim> hksBildirimList = [];
      for (var kunye in selectedKunyeler) {
        if (kunye.gonderilmekIstenenMiktar != null &&
            kunye.gonderilmekIstenenMiktar != "" &&
            double.parse(kunye.gonderilmekIstenenMiktar!) > 0) {
          kunye.kalanMiktar = kunye.gonderilmekIstenenMiktar;
        }
        if (kunye.gonderilmekIstenenFiyat != null &&
            kunye.gonderilmekIstenenFiyat != "" &&
            double.parse(kunye.gonderilmekIstenenFiyat!) > 0) {
          kunye.malinSatisFiyati = kunye.gonderilmekIstenenFiyat;
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
          malinSatisFiyat: kunye.malinSatisFiyati,
          gidecegiYerBeldeId: "0",
          gidecegiYerIlId: "0",
          gidecegiYerIlceId: "0",
          bilidirimTuruId: "197",
          bildirimciKisiSifatId: selectedBildirimciSifatId,
          ikinciKisiSifat: selectedSatisYapilacakSifatId ?? "null", //HATALII
          ikinciKisiTcVergiNo: selectedMusteri!.musteriTc,
          aracPlakaNo: plakaController.text.trim(),
          gidecegiIsyeriId: gidecegiYer!.isyeriId, //HATA
          gidecegiYerIsletmeTuruId: gidecegiYer!.isletmeTuruId, //HATALI
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
        emit(SatisError(message: result2.error!.message));
        emit(SatisInitial());
      } else {
        bool hasError = false;
        if ((result2.data).kayitCevapList != null &&
            (result2.data as BildirimKayitResponseModel)
                .kayitCevapList!
                .isNotEmpty) {
          for (var element
              in (result2.data as BildirimKayitResponseModel).kayitCevapList!) {
            if (element.kunyeNo == "0" || element.kunyeNo == null) {
              hasError = true;
            } else {
              succefullKayitCevaplari.add(element);
              //kaydedilecek künyeler
            }
          }
          if (hasError) {
            //TODO: BAŞARILILARI SİL BAŞARISIZLAR KALSIN
            if (isIrsaliye && isSatisFatura) {
              var dbResult = removeUnsuccessfulNotifications(
                  selectedKunyeler, succefullKayitCevaplari);
              if (dbResult.isNotEmpty) {
                String? token = await getToken();
                if (token != null) {
                  await Future.wait([
                    saveIrsaliye(dbResult, token),
                    saveFatura(dbResult, token, context)
                  ]);
                  emit(SatisSuccessHasSomeError(response: result2.data));
                } else {
                  emit(SatisSuccessHasSomeError(response: result2.data));
                }
              } else {
                emit(SatisSuccessHasSomeError(response: result2.data));
              }
            } else if (isIrsaliye == false && isSatisFatura) {
              var dbResult = removeUnsuccessfulNotifications(
                  selectedKunyeler, succefullKayitCevaplari);
              if (dbResult.isNotEmpty) {
                String? token = await getToken();
                if (token != null) {
                  await Future.wait([saveFatura(dbResult, token, context)]);
                  emit(SatisSuccessHasSomeError(response: result2.data));
                } else {
                  emit(SatisSuccessHasSomeError(response: result2.data));
                }
              } else {
                emit(SatisSuccessHasSomeError(response: result2.data));
              }
            } else if (isIrsaliye && isSatisFatura == false) {
              var dbResult = removeUnsuccessfulNotifications(
                  selectedKunyeler, succefullKayitCevaplari);
              if (dbResult.isNotEmpty) {
                String? token = await getToken();
                if (token != null) {
                  await Future.wait([saveIrsaliye(dbResult, token)]);
                  emit(SatisSuccessHasSomeError(response: result2.data));
                } else {
                  emit(SatisSuccessHasSomeError(response: result2.data));
                }
              } else {
                emit(SatisSuccessHasSomeError(response: result2.data));
              }
            } else {
              removeUnsuccessfulNotifications(
                  selectedKunyeler, succefullKayitCevaplari);
              emit(SatisSuccessHasSomeError(response: result2.data));
            }

            //   basariliBildirimleriDbYeYaz(urunList, succefullKayitCevaplari);
          } else {
            //  basariliBildirimleriDbYeYaz(urunList, succefullKayitCevaplari);
            if (isIrsaliye && isSatisFatura) {
              var dbResult = removeUnsuccessfulNotifications(
                  selectedKunyeler, succefullKayitCevaplari);
              if (dbResult.isNotEmpty) {
                String? token = await getToken();
                if (token != null) {
                  await Future.wait([
                    saveIrsaliye(dbResult, token),
                    saveFatura(dbResult, token, context)
                  ]);
                  emit(SatisCompletelySuccess(response: result2.data));
                } else {
                  emit(SatisCompletelySuccess(response: result2.data));
                }
              } else {
                emit(SatisCompletelySuccess(response: result2.data));
              }
            } else if (isIrsaliye == false && isSatisFatura) {
              var dbResult = removeUnsuccessfulNotifications(
                  selectedKunyeler, succefullKayitCevaplari);
              if (dbResult.isNotEmpty) {
                String? token = await getToken();
                if (token != null) {
                  await Future.wait([saveFatura(dbResult, token, context)]);
                  emit(SatisCompletelySuccess(response: result2.data));
                } else {
                  emit(SatisCompletelySuccess(response: result2.data));
                }
              } else {
                emit(SatisCompletelySuccess(response: result2.data));
              }
            } else if (isIrsaliye && isSatisFatura == false) {
              var dbResult = removeUnsuccessfulNotifications(
                  selectedKunyeler, succefullKayitCevaplari);
              if (dbResult.isNotEmpty) {
                String? token = await getToken();
                if (token != null) {
                  await Future.wait([saveIrsaliye(dbResult, token)]);
                  emit(SatisCompletelySuccess(response: result2.data));
                } else {
                  emit(SatisCompletelySuccess(response: result2.data));
                }
              } else {
                emit(SatisCompletelySuccess(response: result2.data));
              }
            } else {
              removeUnsuccessfulNotifications(
                  selectedKunyeler, succefullKayitCevaplari);
              emit(SatisCompletelySuccess(response: result2.data));
            }
            clearAllPageInfo();
            logBildirim();
          }
        } else {
          emit(SatisError(message: "hata<"));
          emit(SatisInitial());
          //hata
        }
      }
    } catch (e) {
      emit(SatisError(message: e.toString()));
      emit(SatisInitial());
    }
  }

  Future<String?> getToken() async {
    MySoftUserModel? usermodel =
        MySoftUserCacheManager.instance.getItem(ActiveTc.instance.activeTc);
    if (usermodel != null) {
      var result = await MySoftAuthService.instance
          .getToken(usermodel.userName, usermodel.password);

      if (result.error != null) {
        emit(SatisError(message: result.error!.message));
        emit(SatisInitial());
      } else if (result.data != null) {
        return result.data;
      } else {
        emit(SatisError(message: "MySoft hata 1"));
        emit(SatisInitial());
      }
    } else {
      emit(SatisError(message: "MySoft Bilgilerini Güncelleyiniz"));
      emit(SatisInitial());
    }
    return null;
  }

  void clearFaturaInfo() {
    isFaturaKesSuccess = false;
    isIrsaliyeKesSuccess = false;
    isIrsaliye = false;
    isSatisFatura = false;
    emit(SatisInitial());
  }

  Future<void> saveIrsaliye(List<ReferansKunye> urunler, String token) async {
    try {
      var bildirimci =
          BildirimciCacheManager.instance.getItem(ActiveTc.instance.activeTc);
      var result = await MySoftFaturaService.instance.sendIrsaliyeForSevk(
          token: token,
          urunler: urunler,
          musteri: selectedMusteri!,
          gidecegiYer: gidecegiYer ??
              GidecegiYer(
                  adres:
                      ("${selectedMusteri!.musteriIlAdi ?? ""} ${selectedMusteri!.musteriIlceAdi ?? ""} ${selectedMusteri!.musteriBeldeAdi ?? ""}"),
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

        emit(SatisError(
            message: result.error?.message ?? "mysoft irsaliye cubit error"));

        emit(SatisInitial());
      } else {
        isIrsaliyeKesSuccess = true;
        logIrsaliye();
      }
     } catch (e) {
      emit(SatisError(message: e.toString()));
      emit(SatisInitial());
    }
  }

  Future<void> saveFatura(
      List<ReferansKunye> urunler, String token, BuildContext context) async {
    try {
      String selectedBildirimciSifatId = "";
      if (context.read<MainBildirimCubit>().selectedSifatForMain ==
          UserAdjectives.komisyoncu) {
        selectedBildirimciSifatId = "5";
      } else {
        selectedBildirimciSifatId =
            context.read<TuccarHalIciDisiMainCubit>().selectedSifatId == null
                ? "null"
                : context.read<TuccarHalIciDisiMainCubit>().selectedSifatId!;
      }
      var bildirimci =
          BildirimciCacheManager.instance.getItem(ActiveTc.instance.activeTc);
      IResponseModel<String?> result;
      if (selectedBildirimciSifatId == "5") {
        result = await MySoftFaturaService.instance.sendFaturaForKomisyoncu(
            token: token,
            urunler: urunler,
            musteri: selectedMusteri!,
            gidecegiYer: gidecegiYer ??
                gidecegiYer ??
                GidecegiYer(
                    adres:
                        ("${selectedMusteri!.musteriIlAdi ?? ""}  ${selectedMusteri!.musteriIlceAdi ?? ""}  ${selectedMusteri!.musteriBeldeAdi ?? ""}"),
                    isletmeTuru: "0",
                    isletmeTuruId: "0",
                    isyeriId: "0",
                    name: "",
                    type: ""),
            bildirimci: bildirimci!);
      } else {
        result = await MySoftFaturaService.instance.sendFatura(
            token: token,
            urunler: urunler,
            musteri: selectedMusteri!,
            gidecegiYer: gidecegiYer ??
                gidecegiYer ??
                GidecegiYer(
                    adres:
                        ("${selectedMusteri!.musteriIlAdi ?? ""}   ${selectedMusteri!.musteriIlceAdi ?? ""}   ${selectedMusteri!.musteriBeldeAdi ?? ""}"),
                    isletmeTuru: "0",
                    isletmeTuruId: "0",
                    isyeriId: "0",
                    name: "",
                    type: ""),
            bildirimci: bildirimci!);
      }

      if (result.error != null) {
        isFaturaKesSuccess = false;

        emit(SatisError(
            message: result.error?.message ?? "mysoft fatura cubit error"));

        emit(SatisInitial());
      } else {
        isFaturaKesSuccess = true;
        logFatura();
      }
     } catch (e) {}
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

  Future<void> nonRegisteredUserBildirimYapTransactions(
      BuildContext context) async {
    try {
      String selectedBildirimciSifatId = "";
      if (context.read<MainBildirimCubit>().selectedSifatForMain ==
          UserAdjectives.komisyoncu) {
        selectedBildirimciSifatId = "5";
      } else if (context.read<MainBildirimCubit>().selectedSifatForMain ==
          UserAdjectives.sanayici) {
        selectedBildirimciSifatId = "1";
      } else {
        selectedBildirimciSifatId =
            context.read<TuccarHalIciDisiMainCubit>().selectedSifatId == null
                ? "null"
                : context.read<TuccarHalIciDisiMainCubit>().selectedSifatId!;
      }
      List<HksBildirim> hksBildirimList = [];
      for (var kunye in selectedKunyeler) {
        if (kunye.gonderilmekIstenenMiktar != null &&
            kunye.gonderilmekIstenenMiktar != "" &&
            double.parse(kunye.gonderilmekIstenenMiktar!) > 0) {
          kunye.kalanMiktar = kunye.gonderilmekIstenenMiktar;
        }
        if (kunye.gonderilmekIstenenFiyat != null &&
            kunye.gonderilmekIstenenFiyat != "" &&
            double.parse(kunye.gonderilmekIstenenFiyat!) > 0) {
          kunye.malinSatisFiyati = kunye.gonderilmekIstenenFiyat;
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
          malinSatisFiyat: kunye.malinSatisFiyati,
          gidecegiYerBeldeId: selectedMusteri!.musteriBeldeId!,
          gidecegiYerIlId: selectedMusteri!.musteriIlId!,
          gidecegiYerIlceId: selectedMusteri!.musteriIlceId!,
          bilidirimTuruId: "197",
          bildirimciKisiSifatId: selectedBildirimciSifatId,
          //      activeBildirimciSifatId!, //?? assignActiveBildirimciSifatId()
          ikinciKisiAdiSoyadi: selectedMusteri!.musteriAdiSoyadi,
          ceptel: selectedMusteri!.musteriTel!,
          ikinciKisiSifat: selectedMusteri!.musteriSifatIdList
              .first, //?? ENİŞTENE SOR //DEFAULT KOMİSYONCU MU OLSUN
          ikinciKisiTcVergiNo: selectedMusteri!.musteriTc,
          aracPlakaNo: plakaController.text.trim(),
          gidecegiIsyeriId: "0",
          gidecegiYerIsletmeTuruId:
              selectedMusteri!.selectedNotFoundMalinGidecegiYerId!, //??
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
        emit(SatisError(message: result2.error!.message));
        emit(SatisInitial());
      } else {
        bool hasError = false;
        if ((result2.data).kayitCevapList != null &&
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
            if (isIrsaliye && isSatisFatura) {
              var dbResult = removeUnsuccessfulNotifications(
                  selectedKunyeler, succefullKayitCevaplari);
              if (dbResult.isNotEmpty) {
                String? token = await getToken();
                if (token != null) {
                  await Future.wait([
                    saveIrsaliye(dbResult, token),
                    saveFatura(dbResult, token, context)
                  ]);
                  emit(SatisSuccessHasSomeError(response: result2.data));
                } else {
                  emit(SatisSuccessHasSomeError(response: result2.data));
                }
              } else {
                emit(SatisSuccessHasSomeError(response: result2.data));
              }
            } else if (isIrsaliye == false && isSatisFatura) {
              var dbResult = removeUnsuccessfulNotifications(
                  selectedKunyeler, succefullKayitCevaplari);
              if (dbResult.isNotEmpty) {
                String? token = await getToken();
                if (token != null) {
                  await Future.wait([saveFatura(dbResult, token, context)]);
                  emit(SatisSuccessHasSomeError(response: result2.data));
                } else {
                  emit(SatisSuccessHasSomeError(response: result2.data));
                }
              } else {
                emit(SatisSuccessHasSomeError(response: result2.data));
              }
            } else if (isIrsaliye && isSatisFatura == false) {
              var dbResult = removeUnsuccessfulNotifications(
                  selectedKunyeler, succefullKayitCevaplari);
              if (dbResult.isNotEmpty) {
                String? token = await getToken();
                if (token != null) {
                  await Future.wait([saveIrsaliye(dbResult, token)]);
                  emit(SatisSuccessHasSomeError(response: result2.data));
                } else {
                  emit(SatisSuccessHasSomeError(response: result2.data));
                }
              } else {
                emit(SatisSuccessHasSomeError(response: result2.data));
              }
            } else {
              removeUnsuccessfulNotifications(
                  selectedKunyeler, succefullKayitCevaplari);
              emit(SatisSuccessHasSomeError(response: result2.data));
            }

            //   basariliBildirimleriDbYeYaz(urunList, succefullKayitCevaplari);
          } else {
            //  basariliBildirimleriDbYeYaz(urunList, succefullKayitCevaplari);
            if (isIrsaliye && isSatisFatura) {
              var dbResult = removeUnsuccessfulNotifications(
                  selectedKunyeler, succefullKayitCevaplari);
              if (dbResult.isNotEmpty) {
                String? token = await getToken();
                if (token != null) {
                  await Future.wait([
                    saveIrsaliye(dbResult, token),
                    saveFatura(dbResult, token, context)
                  ]);
                  emit(SatisCompletelySuccess(response: result2.data));
                } else {
                  emit(SatisCompletelySuccess(response: result2.data));
                }
              } else {
                emit(SatisCompletelySuccess(response: result2.data));
              }
            } else if (isIrsaliye == false && isSatisFatura) {
              var dbResult = removeUnsuccessfulNotifications(
                  selectedKunyeler, succefullKayitCevaplari);
              if (dbResult.isNotEmpty) {
                String? token = await getToken();
                if (token != null) {
                  await Future.wait([saveFatura(dbResult, token, context)]);
                  emit(SatisCompletelySuccess(response: result2.data));
                } else {
                  emit(SatisCompletelySuccess(response: result2.data));
                }
              } else {
                emit(SatisCompletelySuccess(response: result2.data));
              }
            } else if (isIrsaliye && isSatisFatura == false) {
              var dbResult = removeUnsuccessfulNotifications(
                  selectedKunyeler, succefullKayitCevaplari);
              if (dbResult.isNotEmpty) {
                String? token = await getToken();
                if (token != null) {
                  await Future.wait([saveIrsaliye(dbResult, token)]);
                  emit(SatisCompletelySuccess(response: result2.data));
                } else {
                  emit(SatisCompletelySuccess(response: result2.data));
                }
              } else {
                emit(SatisCompletelySuccess(response: result2.data));
              }
            } else {
              removeUnsuccessfulNotifications(
                  selectedKunyeler, succefullKayitCevaplari);
              emit(SatisCompletelySuccess(response: result2.data));
            }
            clearAllPageInfo();
            logBildirim();
          }
        } else {
          emit(SatisError(message: "hata"));

          emit(SatisInitial());

          //hata
        }
      }
    } catch (e) {
      emit(SatisError(message: e.toString()));
      emit(SatisInitial());
    }
  }

  void musteriSelected() {
    assignSatisYapilabilecekSifatlar();
    emit(SatisInitial());
  }

  Future<void> bildirimYap(BuildContext context) async {
    if (selectedMusteri == null) {
      emit(SatisError(message: "Müşteri Seçiniz"));
      emit(SatisInitial());
      return;
    }
    if (gidecegiYer == null && selectedMusteri!.isregisteredToHks) {
      emit(SatisError(
          message:
              "Gideceği yer seçiniz. Eğer gideceği yeri göremiyorsanız müşteri bilgilerini güncelleyiniz."));
      emit(SatisInitial());
      return;
    }
    emit(SatisLoading());
    if (selectedMusteri!.isregisteredToHks) {
      await registeredUserBildirimYapTransactions(context);
    } else {
      await nonRegisteredUserBildirimYapTransactions(context);
    }
  }

  String get uniqueIdGenerator {
    var uuid = const Uuid();
    return uuid.v1();
  }

  void satisYapilacakSifatSelected() {
    musterideOlanSatisYapilabilecekSifatlar.forEach(
      (key, value) {
        if (value == selectedSatisYapilacakSifatName) {
          selectedSatisYapilacakSifatId = key;
        }
      },
    );
    emit(SatisInitial());
  }

  void gidecegiYerSelected() {
    emit(SatisInitial());
  }

  void clearAllPageInfo() {
    selectedKunyeler.clear();
    clearMusteriSifatInfos();
    gidecegiYer = null;
    selectedMusteri = null;
    selectedDriver = null;
    driverIdController.clear();
    driverNameController.clear();
    isSurucuManual = false;
    plakaController.clear();
    fiyatTumunuSec = false;

    emit(SatisInitial());
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
    emit(SatisInitial());
  }

  void emitError(String message) {
    emit(SatisError(message: message));

    emit(SatisInitial());
  }

  void logBildirim() {}
  
  void logFatura() {}
  
  void logIrsaliye() {}
}
