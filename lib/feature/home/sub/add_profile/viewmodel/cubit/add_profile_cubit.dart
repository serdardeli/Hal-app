import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../helper/active_tc.dart';
import '../../../../../../project/cache/uretici_list_cache_manager.dart';
import '../../../../../../project/model/uretici_model/uretici_model.dart';
import 'package:meta/meta.dart';
import 'package:turkish/turkish.dart';

import '../../../../../../project/service/hal/bildirim_service.dart';
import '../../../../../../project/service/hal/genel_service.dart';
import '../../../bildirim_page/main_bildirim_page/viewmodel/cubit/main_bildirim_cubit.dart';

part 'add_profile_state.dart';

//TODO: OTOMATİK URETİCİ KONUSUNDA  EMİNMİYİZ
class AddProfileCubit extends Cubit<AddProfileState> {
  AddProfileCubit() : super(AddProfileInitial());
  final TextEditingController tcController = TextEditingController();
  final TextEditingController telController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ilController = TextEditingController();
  final TextEditingController ilceController = TextEditingController();
  final TextEditingController beldeController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  AutovalidateMode isAutoValidateMode = AutovalidateMode.disabled;

  bool isUpdateState = false;
  Map<String, String> _iller = {};
  Map<String, String> _ilceler = {};
  Map<String, String> _beldeler = {};
  String _ilId = "";
  String _ilceId = "";
  String _beldeId = "";

  String ureticiSifat = "4";

  String? selectedIl;
  String? selectedIlce;
  String? selectedBelde;
  void emitInitialState() => emit(AddProfileInitial());

  void fillUreticiData(Uretici uretici) {
    _ilceler.clear();
    _beldeler.clear();
    isUpdateState = true;
    tcController.text = uretici.ureticiTc;

    telController.text = uretici.ureticiTel;
    nameController.text = uretici.ureticiAdiSoyadi;
    _ilId = uretici.ureticiIlId;
    _ilceId = uretici.ureticiIlceId;
    _beldeId = uretici.ureticiBeldeId;

    selectedIl = uretici.ureticiIlAdi;
    selectedIlce = uretici.ureticiIlceAdi;
    selectedBelde = uretici.ureticiBeldeAdi;
    //emit(AddProfileInitial());
  }

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

  Future<void> fetchCities() async {
    var response = await GeneralService.instance.fetchAllCities();
    if (response.error != null) {
      if (response.error?.statusCode == 400 ||
          response.error?.statusCode == 500) {
        emit(AddProfileError(message: "Hks hata"));
        emit(AddProfileInitial());
      } else {
        emit(AddProfileError(message: "Hata"));
        emit(AddProfileInitial());
      }
    } else {
      _iller = response.data;
      emit(AddProfileInitial());
    }
  }

  Future<void> fetchIlceler() async {
    if (selectedIl != null) {
      _ilceler = await GeneralService.instance.fetchAllIlceler(_ilId);
      emit(AddProfileInitial());
    }
  }

  Future<void> fetchBeldeler() async {
    if (selectedIlce != null) {
      _beldeler = await GeneralService.instance.fetchAllBeldeler(_ilceId);
      emit(AddProfileInitial());
    }
  }

  bool isNumeric(String? s) {
    if (s == null || s.trim() == "") {
      return false;
    }
    return double.tryParse(s.trim()) != null;
  }

  void addProfile(BuildContext context) {
    isAutoValidateMode = AutovalidateMode.always;
    if (!checkDropDownFieldHasError()) {
      isAutoValidateMode = AutovalidateMode.disabled;

      kayitliKisiSorgu().then((value) {
        addUreticiToDb(Uretici(
            ureticiAdiSoyadi: nameController.text.toUpperCaseTr().trim(),
            ureticiSifatId: ureticiSifat,
            ureticiTc: tcController.text.trim(),
            ureticiTel: telController.text.trim(),
            ureticiBeldeAdi: selectedBelde!,
            ureticiBeldeId: _beldeId,
            ureticiIlAdi: selectedIl!,
            ureticiIlId: _ilId,
            ureticiIlceAdi: selectedIlce!,
            ureticiIlceId: _ilceId));
        // context.read<MainBildirimCubit>().assignRightUser(ActiveTc.instance.activeTc,context);
      });
    }
  }

  Future<bool> kayitliKisiSorgu() async {
    var result = await BildirimService.instance
        .bildirimKayitliKisiSorgu(tcController.text.trim());
    if (result["KayitliKisiMi"] == "false") {
      ureticiSifat = "4";
      emit(AddProfileSuccess(
          message: "kayitli kişi değil üretici olarak eklendi"));
      emit(AddProfileInitial());
    }
    if (result["KayitliKisiMi"] == "true") {
      ureticiSifat = (result["Sifatlari"] as List).first;
      emit(AddProfileSuccess(message: "kayitli kişi eklendi"));
      emit(AddProfileInitial());
    } else {
      // bildirimciKisiSifatIdList = result["Sifatlari"];
      // sifatAdlariniIdyeGoreBulma(bildirimciKisiSifatIdList);
    }

    if (ureticiSifat != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> addUreticiToDb(Uretici uretici) async {
    await UreticiListCacheManager.instance
        .addItem(ActiveTc.instance.activeTc, uretici)
        .then((value) => clearAllFields());
  }

  clearAllFields() {
    selectedIl = null;
    selectedIlce = null;
    selectedBelde = null;
    nameController.clear();
    tcController.clear();
    telController.clear();
    _beldeId = "";
    _ilceId = "";
    _ilId = "";
    _beldeler.clear();
    _ilceler.clear();
  }

  void ilSelected(String value) {
    if (selectedIl == null) {
      selectedIl = value;
      getCities.entries.forEach((element) {
        if (element.value.toLowerCaseTr() == selectedIl!.toLowerCaseTr()) {
          _ilId = element.key;
        }
      });

      fetchIlceler();
      emit(AddProfileInitial());
    } else {
      selectedIl = value;
      selectedIlce = null;
      selectedBelde = null;
      _beldeId = "";
      _ilceId = "";
      _beldeler.clear();
      _ilceler.clear();
      getCities.entries.forEach((element) {
        if (element.value.toLowerCaseTr() == selectedIl!.toLowerCaseTr()) {
          _ilId = element.key;
        }
      });
      fetchIlceler();
      emit(AddProfileInitial());
    }
  }

  void ilceSelected(String value) {
    if (selectedIlce == null) {
      selectedIlce = value;
      selectedBelde = null;
      _beldeler.clear();
      _beldeId = "";
      _ilceId = "";
      getIlceler.entries.forEach((element) {
        if (element.value.toLowerCaseTr() == selectedIlce?.toLowerCaseTr()) {
          _ilceId = element.key;
        }
      });
      fetchBeldeler();

      emit(AddProfileInitial());
    } else {
      selectedIlce = value;
      selectedBelde = null;
      _beldeler.clear();
      _beldeId = "";
      _ilceId = "";
      getIlceler.entries.forEach((element) {
        if (element.value.toLowerCaseTr() == selectedIlce?.toLowerCaseTr()) {
          _ilceId = element.key;
        }
      });
      fetchBeldeler();

      emit(AddProfileInitial());
    }
  }

  void beldeSelected() {





    getBeldeler.entries.forEach((element) {
      if (element.value == selectedBelde) {
        _beldeId = element.key;
      }
    });
    emit(AddProfileInitial());
  }

  void removeUretici() {
    UreticiListCacheManager.instance
        .removeOneUretici(ActiveTc.instance.activeTc, nameController.text.trim());
    emit(AddProfileDeleted());
  }

  void setIsUpdate(bool value) {
    isUpdateState = value;
    emit(AddProfileInitial());
  }

  String dropDownErrorMessage = "";
  bool checkDropDownFieldHasError() {
    dropDownErrorMessage = "";
    bool hasError = false;

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

    dropDownErrorMessage += " boş olamaz";

    if (hasError == false) {
      dropDownErrorMessage = "";
    }
    emit(AddProfileInitial());
    return hasError;
  }
}
