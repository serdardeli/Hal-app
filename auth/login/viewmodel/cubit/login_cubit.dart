import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hal_app/project/service/firebase/auth/password_login_service.dart';
import 'package:hal_app/project/service/firebase/firestore/firestore_service.dart';
import 'package:phone_form_field/phone_form_field.dart';
import '../../../../launch/view/launch_view.dart';
import '../../../../../core/api/purchase_api.dart';
import '../../../../../core/enum/preferences_keys_enum.dart';
import '../../../../helper/subscription_helper/subscription_helper.dart';

import '../../../../../project/cache/app_cache_manager.dart';
import '../../../../../project/cache/user_cache_manager.dart';

import '../../../../../project/model/user/my_user_model.dart';
import '../../../../../project/service/user_service_controller/user_service_controller.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial()) {
    // numberController.text = "5448716741";
  }
  TextEditingController passwordController = TextEditingController();

  PhoneController phoneController = PhoneController(
      initialValue: const PhoneNumber(isoCode: IsoCode.TR, nsn: ''));
  MyUser? user;
  late String verificationId;
  final formKey = GlobalKey<FormState>();

  String get phoneNumber =>
      "+${phoneController.value.countryCode}${phoneController.value.nsn}";

  Future<void> logPhone() async {
    try {
      await FirestoreService.instance.savefirstUserInfo(phoneNumber);
    } catch (e) {
      emit(LoginError(message: e.toString()));
      emit(LoginInitial());
    }
  }

  Future<bool> passwordLogin() async {
    try {
      emit(LoginLoading());
      bool result = await PasswordLoginService.instance
          .login(phoneNumber, passwordController.text);
      if (result) {
        await AppCacheManager.instance
            .putItem(PreferencesKeys.phone.name, (phoneNumber));
        await UserCacheManager.instance.putItem(
            phoneNumber,
            MyUser(
                phoneNumber: (phoneNumber),
                password: passwordController.text.trim()));

        emit(LoginSuccess(rootNameToGo: Launch.name));
        emit(LoginInitial());
      } else {
        emit(LoginError(message: "Bir Hata Oluştu"));
        emit(LoginInitial());
      }
    } catch (e) {
      print(e);
      emit(LoginError(message: e.toString()));
      emit(LoginInitial());
    }
    return false;
  }

  Future<bool> passwordLoginAppleDemo() async {
    const String password = '123123';

    try {
      emit(LoginLoading());
      bool result =
          await PasswordLoginService.instance.login(phoneNumber, password);
      if (result) {
        await AppCacheManager.instance
            .putItem(PreferencesKeys.phone.name, (phoneNumber));
        await UserCacheManager.instance.putItem(phoneNumber,
            MyUser(phoneNumber: (phoneNumber), password: password));

        emit(LoginSuccess(rootNameToGo: Launch.name));
        emit(LoginInitial());
      } else {
        emit(LoginError(message: "Bir Hata Oluştu"));
        emit(LoginInitial());
      }
    } catch (e) {
      print(e);
      emit(LoginError(message: e.toString()));
      emit(LoginInitial());
    }
    return false;
  }

  Future<void> signInWithPhoneNumber() async {
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // await FirebaseAuth.instance.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          if (e.code == 'invalid-phone-number') {}
          emit(LoginError(message: "${e}error from verif"));
          emit(LoginInitial());
        },
        codeSent: (String verificationId, int? resendToken) async {
          this.verificationId = verificationId;
          emit(LoginSentCode());
          emit(LoginInitial());
          try {
            await FirestoreService.instance
                .savefirstUserInfoDetail(phoneNumber, {"codesent": "codeSent"});
          } catch (e) {
            emit(LoginError(message: e.toString()));
            emit(LoginInitial());
          }
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          emit(LoginError(message: "sms zaman aşımı"));
          emit(LoginInitial());
        },
      );
    } catch (e) {
      try {
        await FirestoreService.instance
            .savefirstUserInfoDetail(phoneNumber, {"hata": e.toString()});
      } catch (e) {
        emit(LoginError(message: e.toString()));
        emit(LoginInitial());
      }
      emit(LoginError(message: "bir hata oldu lütfen tekrar deneyiniz"));
      emit(LoginInitial());
    }
  }

  Future<void> fakeLogin() async {
    try {
      Future.wait([
        AppCacheManager.instance
            .putItem(PreferencesKeys.phone.name, (phoneNumber)),
        UserCacheManager.instance.putItem(
            AppCacheManager.instance.getItem(PreferencesKeys.phone.name) ??
                (phoneNumber),
            MyUser(phoneNumber: (phoneNumber))),
      ]).then((value) {
        //TODO: BURDA SUB BAŞARISIZ OLSADA launcha gidiyor bunu ele almak lazım
        PurchaseApi.instance.init().then((value) {
          SubscriptionHelper.instance.checkIsSubscriber().then((value) {
            emit(LoginSuccess(rootNameToGo: Launch.name));
            emit(LoginInitial());

            emit(LoginInitial());

            return;
          });
        });
      });
    } catch (e) {
      // emit(LoginSuccess(rootNameToGo: SubscriptionsPage.name));
      // emit(LoginInitial());

      emit(LoginError(message: "bir hata oldu lütfen tekrar deneyiniz"));
      emit(LoginInitial());
    }
  }

  submitCode(String code) async {
    emit(LoginLoading());
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: code);

      var result =
          await _userServiceController.signInWithCredential(credential);
      if (result.error != null) {
        emit(LoginError(
            message:
                "${(result.error?.message) ?? "error Credential"} submit login error"));
        emit(LoginInitial());
      } else {
        try {
          Future.wait([
            AppCacheManager.instance
                .putItem(PreferencesKeys.phone.name, (phoneNumber)),
            UserCacheManager.instance.putItem(
                phoneNumber,
                MyUser(
                    phoneNumber: (phoneNumber),
                    password: passwordController.text.trim())),
          ]).then((value) {
            //TODO: BURDA SUB BAŞARISIZ OLSADA launcha gidiyor bunu ele almak lazım
            PurchaseApi.instance.init().then((value) {
              SubscriptionHelper.instance.checkIsSubscriber().then((value) {
                emit(LoginSuccess(rootNameToGo: Launch.name));
                emit(LoginInitial());

                /*if (value) {

              emit(LoginSuccess(rootNameToGo: ManageTcPage.name));
              emit(LoginInitial());
            } else {

              emit(LoginSuccess(rootNameToGo: SubscriptionsPage.name));
              emit(LoginInitial());
            }*/

                return;
              });
            });
          });
        } catch (e) {
          // emit(LoginSuccess(rootNameToGo: SubscriptionsPage.name));
          // emit(LoginInitial());

          emit(LoginError(message: e.toString()));

          emit(LoginInitial());
        }
      }
      emit(LoginInitial());
    } catch (e) {}
  }

  final UserServiceController _userServiceController =
      UserServiceController.instance;
  /* Future<void> signInWithEmailandPassword() async {
    emit(LoginLoading());

    var result = await _userServiceController.signInWithEmailandPassword(
        numberController.text.trim(), passwordController.text.trim());
    if (result.error != null) {
      user = result.data;
      emit(LoginError(message: result.error!.message));
      emit(LoginInitial());
    } else if (result.data != null) {
      user = result.data;

      emit(LoginSuccess());
    } else {
      user = result.data;

      emit(LoginInitial());
    }
  }*/
}
