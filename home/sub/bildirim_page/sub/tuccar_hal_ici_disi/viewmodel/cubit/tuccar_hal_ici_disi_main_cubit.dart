import 'package:bloc/bloc.dart';
import '../../../../../../../../core/enum/bildirim_types.enum.dart';
import 'package:meta/meta.dart';

import '../../../../../../../../project/cache/bildirimci_cache_manager.dart';
import '../../../../../../../../project/model/bildirimci/bildirimci_model.dart';
import '../../../../../../../helper/active_tc.dart';

part 'tuccar_hal_ici_disi_main_state.dart';

class TuccarHalIciDisiMainCubit extends Cubit<TuccarHalIciDisiMainState> {
  TuccarHalIciDisiMainCubit() : super(TuccarHalIciDisiMainSatinAlim()) {
    customInit();

  }
  String? selectedSifatType;
  String? selectedSifatId;
  String bildirimType = "Satın Alım";

  String bildirimId = "195";

  Map<String, String> tuccarBildirimTypes = {
    "195": "Satın Alım",
    "196": "Sevk Etme",
    "197": "Satış",
  };
  Map<String, String> desteklenenSifatlarSatinAlim = {
    "6": "Tüccar (Hal İçi)",
    "20": "Tüccar (Hal Dışı)"
  };
  Map<String, String> desteklenenSifatlarSevkEtme = {
    "6": "Tüccar (Hal İçi)",
    "20": "Tüccar (Hal Dışı)",
    "4": "Üretici"
  };
  Map<String, String> desteklenenSifatlarSatis = {
    "6": "Tüccar (Hal İçi)",
    "20": "Tüccar (Hal Dışı)"
  };
  void customInit() {
    selectedSifatType = null;


    sifatTypeSelected();
  }

  void assignDesteklenenSifatlarForSatinAlim() {


    kullanicininDesteklenenSifatlari = {};
    // selectedSifatType = null;
    Bildirimci? bildirimci =
        BildirimciCacheManager.instance.getItem(ActiveTc.instance.activeTc);
    if (bildirimci != null) {
      for (var element in (bildirimci.kayitliKisiSifatIdList ?? [])) {
        for (var item in desteklenenSifatlarSatinAlim.entries) {
          if (element == item.key) {
            kullanicininDesteklenenSifatlari.addAll({item.key: item.value});
          }
        }
      }
      if (kullanicininDesteklenenSifatlari.isNotEmpty &&
          selectedSifatType == null) {
        selectedSifatType = kullanicininDesteklenenSifatlari.values.first;
      }
      kullanicininDesteklenenSifatlari.forEach(
        (key, value) {
          if (value == selectedSifatType) {
            selectedSifatId = key;
          }
        },
      );




    } else {}
    //  return SizedBox();
  }

//desteklenenSifatlarSatis
  void assignDesteklenenSifatlarForSatis() {


    kullanicininDesteklenenSifatlari = {};
    // selectedSifatType = null;
    Bildirimci? bildirimci =
        BildirimciCacheManager.instance.getItem(ActiveTc.instance.activeTc);
    if (bildirimci != null) {
      for (var element in (bildirimci.kayitliKisiSifatIdList ?? [])) {
        for (var item in desteklenenSifatlarSatis.entries) {
          if (element == item.key) {
            kullanicininDesteklenenSifatlari.addAll({item.key: item.value});
          }
        }
      }
      if (kullanicininDesteklenenSifatlari.isNotEmpty &&
          selectedSifatType == null) {
        selectedSifatType = kullanicininDesteklenenSifatlari.values.first;
      }
      kullanicininDesteklenenSifatlari.forEach(
        (key, value) {
          if (value == selectedSifatType) {
            selectedSifatId = key;
          }
        },
      );




    } else {}
    //  return SizedBox();
  }

  void assignDesteklenenSifatlarForSevkEtme() {


    kullanicininDesteklenenSifatlari = {};
    // selectedSifatType = null;
    Bildirimci? bildirimci =
        BildirimciCacheManager.instance.getItem(ActiveTc.instance.activeTc);
    if (bildirimci != null) {
      bildirimci.kayitliKisiSifatIdList?.forEach((element) {



      });
      for (var element in (bildirimci.kayitliKisiSifatIdList ?? [])) {
        for (var item in desteklenenSifatlarSevkEtme.entries) {
          if (element == item.key) {
            kullanicininDesteklenenSifatlari.addAll({item.key: item.value});
          }
        }
      }
      if (kullanicininDesteklenenSifatlari.isNotEmpty &&
          selectedSifatType == null) {
        selectedSifatType = kullanicininDesteklenenSifatlari.values.first;
      }
      kullanicininDesteklenenSifatlari.forEach(
        (key, value) {
          if (value == selectedSifatType) {
            selectedSifatId = key;
          }
        },
      );



    } else {}
    //  return SizedBox();
  }

  Map<String, String> kullanicininDesteklenenSifatlari = {};
  void bildirimTypeSelected() {


    if (bildirimType == "Satın Alım") {
      bildirimId = "195";
      customInit();

      emit(TuccarHalIciDisiMainSatinAlim());
    } else if (bildirimType == "Sevk Etme") {
      customInit();

      emit(TuccarHalIciDisiMainSevkEtme());
      bildirimId = "196";
    } else {
      bildirimId = "197";
      emit(TuccarHalIciDisiMainSatis());
    }
    //  emit(TuccarHalIciDisiMainInitial());
  }

  void sifatTypeSelected() {

    if (bildirimType == "Satın Alım") {
      assignDesteklenenSifatlarForSatinAlim();

      bildirimId = "195";
      emit(TuccarHalIciDisiMainSatinAlim());
    } else if (bildirimType == "Sevk Etme") {
      assignDesteklenenSifatlarForSevkEtme();
      emit(TuccarHalIciDisiMainSevkEtme());
      bildirimId = "196";
    } else if (bildirimType == "Satış") {
      assignDesteklenenSifatlarForSatis();
      bildirimId = "197";

      emit(TuccarHalIciDisiMainSatis());
    }
  }

  void changeBildirimTypeFromOutSide() {


    bildirimType = "Satın Alım";
    if (bildirimType == "Satın Alım") {
      bildirimId = "195";
      
      emit(TuccarHalIciDisiMainSatinAlim());
    } else if (bildirimType == "Sevk Etme") {
      emit(TuccarHalIciDisiMainSevkEtme());
      bildirimId = "196";
    } else if (bildirimType == "Satış") {
      bildirimId = "197";

      emit(TuccarHalIciDisiMainSatis());
    }
    //  emit(TuccarHalIciDisiMainInitial());
  }
}
