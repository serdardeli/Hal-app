import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../../../../project/model/user/my_user_model.dart';
import '../../../../../project/service/user_service_controller/user_service_controller.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitial());
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  MyUser? user;

  final UserServiceController _userServiceController =
      UserServiceController.instance;

  Future<void> createUserWithEmailandPassword() async {
    emit(RegisterLoading());
    var result = await _userServiceController.createUserWithEmailandPassword(
        emailController.text.trim(), passwordController.text.trim(), "furki");
    if (result.error != null) {
      user = result.data;

      emit(RegisterError(message: result.error!.message));
      emit(RegisterInitial());
    } else if (result.data != null) {
      user = result.data;
      emit(RegisterSuccess());
    } else if (result.data == null) {
      user = result.data;

      emit(RegisterInitial());
    } else {
      user = result.data;

      emit(RegisterInitial());
    }
  }
}
