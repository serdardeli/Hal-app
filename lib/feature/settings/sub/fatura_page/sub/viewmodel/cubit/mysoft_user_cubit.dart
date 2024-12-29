import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:hal_app/feature/helper/active_tc.dart';
import 'package:hal_app/project/cache/mysoft_user_cache_mananger.dart';

import 'package:meta/meta.dart';

import '../../../../../../../project/model/MySoft_user_model/mysoft_user_model.dart';
import '../../../../../../../project/service/mysoft/auth/mysoft_auth_service.dart';

part 'mysoft_user_state.dart';

class AddMySoftUserCubit extends Cubit<AddMySoftUserState> {
  AddMySoftUserCubit() : super(AddMySoftUserInitial()) {
    currentMySoftUser =
        MySoftUserCacheManager.instance.getItem(ActiveTc.instance.activeTc);
    if (currentMySoftUser != null) {
      userNameController.text = currentMySoftUser!.userName;
      passwordController.text = currentMySoftUser!.password;
      firmaController.text = currentMySoftUser!.firmaAdi;
    }
  }
  void fillWithOutSideData() {
    currentMySoftUser =
        MySoftUserCacheManager.instance.getItem(ActiveTc.instance.activeTc);
    if (currentMySoftUser != null) {
      userNameController.text = currentMySoftUser!.userName;
      passwordController.text = currentMySoftUser!.password;
      firmaController.text = currentMySoftUser!.firmaAdi;
    }
  }

  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController firmaController = TextEditingController();

  MySoftUserModel? currentMySoftUser;
  var formKey = GlobalKey<FormState>();
  AutovalidateMode isAutoValidateMode = AutovalidateMode.disabled;
  bool isNumeric(String? s) {
    if (s == null || s.trim() == "") {
      return false;
    }
    return double.tryParse(s.trim()) != null;
  }

  void clearAll() {
    userNameController.clear();
    passwordController.clear();
    firmaController.clear();
  }

  Future<void> updateMySoftUser() async {
    try {
      var result = await MySoftAuthService.instance.getToken(
          userNameController.text.trim(), passwordController.text.trim());

      if (result.error != null) {
        emit(AddMySoftUserError(message: result.error!.message));
        emit(AddMySoftUserInitial());
      } else if (result.data != null || result.data?.trim() != "") {


        await addToDb();
        emit(AddMySoftUserUpdateSuccessful());
        emit(AddMySoftUserInitial());
      } else {
        emit(AddMySoftUserError(message: result.error!.message));
        emit(AddMySoftUserInitial());
      }
    } catch (e) {
      emit(AddMySoftUserError(message: e.toString()));
      emit(AddMySoftUserInitial());
    }
  }

  Future<void> addMySoftUser() async {
    try {
      var result = await MySoftAuthService.instance.getToken(
          userNameController.text.trim(), passwordController.text.trim());

      if (result.error != null) {
        emit(AddMySoftUserError(message: result.error!.message));
        emit(AddMySoftUserInitial());
      } else if (result.data != null || result.data?.trim() != "") {


        await addToDb();
        emit(AddMySoftUserAddSuccessful());
        emit(AddMySoftUserInitial());
      } else {
        emit(AddMySoftUserError(message: result.error!.message));
        emit(AddMySoftUserInitial());
      }
    } catch (e) {
      emit(AddMySoftUserError(message: e.toString()));
      emit(AddMySoftUserInitial());
    }
  }

  Future<void> addToDb() async {
    MySoftUserCacheManager.instance.putItem(
        ActiveTc.instance.activeTc,
        MySoftUserModel(
            password: passwordController.text.trim(),
            userName: userNameController.text.trim(),
            firmaAdi: firmaController.text.trim()));
  }
}
