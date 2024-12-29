import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:hal_app/project/cache/driver_list_cache_manager.dart';
import 'package:hal_app/project/model/driver_model/driver_model.dart';
import 'package:meta/meta.dart';
import 'package:turkish/turkish.dart';

import '../../../../../../../../helper/active_tc.dart';

part 'add_driver_state.dart';

//TODO: OTOMATİK URETİCİ KONUSUNDA  EMİNMİYİZ
class AddDriverCubit extends Cubit<AddDriverState> {
  AddDriverCubit() : super(AddDriverInitial());
  final TextEditingController tcController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  var formKey = GlobalKey<FormState>();
  AutovalidateMode isAutoValidateMode = AutovalidateMode.disabled;

  bool isUpdateState = false;

  void emitInitialState() => emit(AddDriverInitial());

  void fillDriverData(DriverModel uretici) {
    isUpdateState = true;
    tcController.text = uretici.tc;

    nameController.text = uretici.userName;

    //emit(AddProfileInitial());
  }

  clearAllInfos() {
    nameController.clear();
    tcController.clear();
  }

  bool isNumeric(String? s) {
    if (s == null || s.trim() == "") {
      return false;
    }
    return double.tryParse(s.trim()) != null;
  }

  void addDriver(BuildContext context) {
    addDriverToDb(DriverModel(
        tc: tcController.text.trim(),
        userName: nameController.text.trim().toUpperCaseTr()));
    emit(AddDriverSuccess(message: "Sürücü eklendi."));
    // context.read<MainBildirimCubit>().assignRightUser(ActiveTc.instance.activeTc,context);
  }

  Future<void> addDriverToDb(DriverModel uretici) async {
    await DriverListCacheManager.instance
        .addItem(ActiveTc.instance.activeTc, uretici)
        .then((value) => clearAllFields());
  }

  clearAllFields() {
    nameController.clear();
    tcController.clear();
  }

  void removeUretici() {
    DriverListCacheManager.instance
        .removeOneUretici(ActiveTc.instance.activeTc, tcController.text.trim());
    emit(AddDriverDeleted());
  }

  void setIsUpdate(bool value) {
    isUpdateState = value;
    emit(AddDriverInitial());
  }
}
