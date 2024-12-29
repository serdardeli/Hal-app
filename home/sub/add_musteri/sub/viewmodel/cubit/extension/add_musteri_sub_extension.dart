part of '../add_musteri_sub_cubit.dart';

extension AddMusteriSubExtension on AddMusteriSubCubit {
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
        emit(AddMusteriSubError(message: "Hks hata"));
        emit(AddMusteriSubInitial());
      } else {
        emit(AddMusteriSubError(message: "Hata"));
        emit(AddMusteriSubInitial());
      }
    } else {
      _iller = response.data;
      emit(AddMusteriSubInitial());
    }
  }

  Future<void> fetchIlceler() async {
    if (selectedIl != null) {
      _ilceler = await GeneralService.instance.fetchAllIlceler(_ilId);
      emit(AddMusteriSubInitial());
    }
  }

  Future<void> fetchBeldeler() async {
    if (selectedIlce != null) {
      _beldeler = await GeneralService.instance.fetchAllBeldeler(_ilceId);
      emit(AddMusteriSubInitial());
    }
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
      emit(AddMusteriSubInitial());
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
      emit(AddMusteriSubInitial());
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

      emit(AddMusteriSubInitial());
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

      emit(AddMusteriSubInitial());
    }
  }

  void beldeSelected() {





    getBeldeler.entries.forEach((element) {
      if (element.value == selectedBelde) {
        _beldeId = element.key;
      }
    });
    emit(AddMusteriSubInitial());
  }
}
