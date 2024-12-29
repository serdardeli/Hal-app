// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hal_app/core/extention/int_extension.dart';
import 'package:hal_app/core/extention/user_extension.dart';
import 'package:hal_app/feature/remove_excess_tc_page/view/remove_excess_tc_page.dart';
import 'package:hal_app/project/cache/hal_ici_isyeri_cache_manager.dart';
import 'package:hal_app/project/cache/mysoft_user_cache_mananger.dart';
import 'package:hal_app/project/cache/last_custom_notifications_cache_manager.dart';
import 'package:hal_app/project/cache/musteri_depo_cache_manager.dart';
import 'package:hal_app/project/cache/musteri_hal_ici_isyeri_cache_manager.dart';
import 'package:hal_app/project/cache/musteri_list_cache_manager.dart';
import 'package:hal_app/project/cache/musteri_sube_cache_manager.dart';
import 'package:hal_app/project/cache/sube_cache_manager.dart';
import 'package:hal_app/project/cache/trial.dart';
import 'package:hal_app/project/service/firebase/auth/password_login_service.dart';
import 'package:hal_app/project/service/firebase/firestore/firestore_service.dart';
import 'package:hal_app/project/service/time/time_service.dart';
import 'package:kartal/kartal.dart';
import 'package:lottie/lottie.dart';
import '../../../core/model/response_model/IResponse_model.dart';
import '../../../project/cache/depo_cache_manager.dart';
import '../../../project/cache/driver_list_cache_manager.dart';
import '../../../project/model/subscription_start_model/subscription_start_model.dart';
import '../../auth/start_free_subscription/start_free_subscription.dart';
import '../../home/view/home_view.dart';
import '../../../project/cache/uretici_list_cache_manager.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../../core/api/purchase_api.dart';
import '../../../project/cache/bildirim_list_cache_manager_new.dart';
import '../../../project/model/bildirimci/bildirimci_model.dart';
import '../../../project/model/hks_user/hks_user.dart';
import '../../../project/service/hal/bildirim_service.dart';
import '../../../project/service/hal/genel_service.dart';
import '../../../project/service/hal/urun_service.dart';
import '../../helper/active_tc.dart';
import '../../home/sub/bildirim_page/main_bildirim_page/viewmodel/cubit/main_bildirim_cubit.dart';
import '../../manage_tc/view/manage_tc_page.dart';
import '../../subscriptions/view/subscriptions_page.dart';
import '../../../project/cache/bildirimci_cache_manager.dart';
import '../../../project/model/user/my_user_model.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import '../../auth/login/view/login_page.dart';
import '../../../project/cache/user_cache_manager.dart';
import 'package:hive_flutter/adapters.dart';

import '../../../core/enum/preferences_keys_enum.dart';
import '../../../project/cache/app_cache_manager.dart';
import '../../../project/cache/bildirim_cache_manager.dart';
import '../../helper/subscription_helper/subscription_helper.dart';

class Init {
  static Init? _instance;
  static Init get instance {
    _instance ??= Init._init();
    return _instance!;
  }

  Init._init();

  Future<void> initialize(BuildContext context) async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    await Hive.initFlutter().then((value) async {
      await AppCacheManager.instance.init();
      await AppCacheManagerTrial.instance.init();
      await DriverListCacheManager.instance.init();

      await MySoftUserCacheManager.instance.init();

      await MusteriListCacheManager.instance.init();
      await MusteriDepolarCacheManager.instance.init();
      await MusteriHalIciIsyeriCacheManager.instance.init();
      await MusteriSubelerCacheManager.instance.init();

      await HalIciIsyeriCacheManager.instance.init();

      await DepolarCacheManager.instance.init();
      await SubelerCacheManager.instance.init();
      await UserCacheManager.instance.init();
      await BildirimciCacheManager.instance.init();
      await BildirimCacheManager.instance.init();
      await UreticiListCacheManager.instance.init();

      await CustomNotificationSaveCacheManager.instance.init();
      await LastCustomNotificationSaveCacheManager.instance.init();
      // await AppCacheManager.instance.clearAll();
      // await UserCacheManager.instance.clearAll();
    });

    String? number =
        AppCacheManager.instance.getItem(PreferencesKeys.phone.name);
    if (number != null) {
      await FirebaseAnalytics.instance.logSelectContent(
        contentType: "location",
        itemId: number,
      );
      await FirebaseAnalytics.instance.logEvent(
        name: "launch",
        parameters: {
          "content_type": "launch",
          "item_id": number,
        },
      );
    }
  }
}

class Launch extends StatefulWidget {
  static const String name = "launch";

  const Launch({Key? key}) : super(key: key);

  @override
  State<Launch> createState() => _LaunchState();
}

class _LaunchState extends State<Launch> {
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return Scaffold(
        body: Center(child: buildFutureBuilder(context)),
      );
    });
  }

  FutureBuilder<void> buildFutureBuilder(BuildContext context) {
    return FutureBuilder(
        future: (Init.instance.initialize(context)),
        builder: ((context, snapshot) {
          // BildirimciCacheManager.instance.clearAll();
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SizedBox(
                width: context.general.mediaSize.width * .5,
                child: Lottie.asset('asset/animations/fruit_animation.json'));
          } else {
            SchedulerBinding.instance.addPostFrameCallback((_) async {
              //  await AppCacheManager.instance.clearAll();
              bool result = await isLogin();
              if (result) {
                MyUser user;
                String phone = AppCacheManager.instance
                    .getItem(PreferencesKeys.phone.name)!;
                user = UserCacheManager.instance.getItem(phone)!;

                //LOCAL DB CHECK
                checkLocalDbAndFillWithFirebaseData(); //TODO: BU SADECE NUMARA KOYUYOR BURAYA FIRESTORE DATALARI GELMELI AYNI LOGIN DE DE OLMALI
                //FIRESTORE CHECK

                AppCacheManager.instance.putItem(
                    PreferencesKeys.isUserActive.name, false.toString());
                //Test
                ifAuthUserSetTestUsers();

                var result =
                    await SubscriptionHelper.instance.checkIsSubscriber2(phone);
                print("result: $result");
                // User is not subscriber
                if (!result) {
                  String? phone = AppCacheManager.instance
                      .getItem(PreferencesKeys.phone.name);
                  if (phone != null) {
                    MyUser? user = UserCacheManager.instance.getItem(phone);
                    if (user != null) {
                      user.subscriptionId = "basic_trial";
                      user.save();
                    }
                  }
                  AppCacheManager.instance.putItem(
                      PreferencesKeys.isUserActive.name, false.toString());
                  //BURDA expreation date bak kullanıcaya aynı internet yok gibi bir mesaj gösterebilirsin(abonelik yenilenemedi gibi exp date varsa eski bir satıl alım vardır
                  //yani doğru) ve ona basınca abonelik sayfasına uçabilir olmazsa zorlama
                  if (context.loaderOverlay.visible) {
                    context.loaderOverlay.hide();
                  }
                  String? isFreeUsed = AppCacheManager.instance
                      .getItem(PreferencesKeys.isFreeSubscriptionUsed.name);
                  print("isFreeUsed: $isFreeUsed");
                  if (isFreeUsed == "true") {
                    //go subscription page
                    Navigator.pushNamedAndRemoveUntil(
                        context, SubscriptionsPage.name, (route) => false);
                  } else {
                    print("object");

                    //check time
                    String? subscriptionStartDate = AppCacheManager.instance
                        .getItem(PreferencesKeys.subscriptionStartDate.name);
                    print("subscriptionStartDate: $subscriptionStartDate");
                    if (subscriptionStartDate != null) {
                      DateTime currentTime =
                          ((await TimeService.instance.getTime()) ??
                              DateTime.now());

                      double dayOfDifference = currentTime
                          .difference(DateTime.parse(subscriptionStartDate))
                          .inMilliseconds
                          .millisecondToDay;
                      //dayOfDifference = dayOfDifference * 100*5;

                      if (dayOfDifference > 14) {
                        await trialPeriodExceed(subscriptionStartDate);
                      } else {
                        String? phone = AppCacheManager.instance
                            .getItem(PreferencesKeys.phone.name);
                        if (phone != null) {
                          MyUser? user =
                              UserCacheManager.instance.getItem(phone);
                          if (user != null) {
                            user.subscriptionId = "basic_trial";
                            user.save();
                          }
                        } else {
                          await directToLoginPage(context);
                        }

                        await AppCacheManager.instance.putItem(
                            PreferencesKeys.isAccessDenied.name,
                            false.toString());
                        await AppCacheManager.instance.putItem(
                            PreferencesKeys.isUserActive.name, true.toString());

                        List<Bildirimci>? bildirimciList =
                            BildirimciCacheManager.instance.getValues();

                        if (bildirimciList.ext.isNotNullOrEmpty) {
                          await bildirimciFoundDirectToHomePage(
                              bildirimciList!);
                        } else {
                          bildirimciNotFoundDirectToManageTcPage();
                        }
                      }
                    } else {
                      // subscription start date null so check firebase
                      var result =
                          await checkFirebaseForSubscriptionStart(); //yerel db yazma işlerinide yapmayı unutma
                      if (!result) {
                        //    AppCacheManager.instance.putItem(
                        // PreferencesKeys.isUserActive.name, true.toString());
                        return;
                      }
                    }
                  }
                }
                // User is subscriber
                else {

                  /// kullanıcı bildirimci sayısı aboneliğin gereksinimlerinden fazlamı onu check et
                  var result = checkUserExcess();
                  if (result) return;
                  AppCacheManager.instance.putItem(
                      PreferencesKeys.isUserActive.name, true.toString());
                  //TODO: NEW burada neden visible kontrolü var
                  if (context.loaderOverlay.visible) {
                    context.loaderOverlay.hide();
                  }

                  String? number = AppCacheManager.instance
                      .getItem(PreferencesKeys.phone.name);
                  //TODO: NEW BURADA NUMBER OLMAMA İHTİMALİ VA RMI

                  if (number == null) {
                    await directToLoginPage(context);
                  } else {
                    List<Bildirimci>? bildirimciList =
                        BildirimciCacheManager.instance.getValues();

                    if (bildirimciList.ext.isNotNullOrEmpty) {
                      print("object1");

                      await bildirimciFoundDirectToHomePage(bildirimciList!);
                    } else {
                      await bildirimciNotFoundDirectToManageTcPage();
                    }
                  }
                }
              } else {
                await directToLoginPage(context);
              }
            });
            return SizedBox(
                width: context.general.mediaSize.width * .5,
                child: Lottie.asset('asset/animations/fruit_animation.json'));
          }
        }));
  }

  Future trialPeriodExceed(String? subscriptionStartDate) async {
    try {
      await AppCacheManager.instance.putItem(
          PreferencesKeys.isFreeSubscriptionUsed.name, true.toString());
      (FirestoreService.instance.saveStartSubscriptionInfo(
              SubscriptionStartModel(
                  isFreeSubscriptionUsed: "true",
                  subscriptionStartDate: subscriptionStartDate)))
          .then((value) {
        Navigator.pushNamedAndRemoveUntil(
            context, SubscriptionsPage.name, (route) => false);
      });
    } catch (e) {
      directToSubscriptionPage();
    }
    directToSubscriptionPage();
  }

  directToSubscriptionPage() {
    Navigator.pushNamedAndRemoveUntil(
        context, SubscriptionsPage.name, (route) => false);
  }

  void ifAuthUserSetTestUsers() {
    String? phone =
        AppCacheManager.instance.getItem(PreferencesKeys.phone.name);
    if (phone != null) {
      MyUser? user = UserCacheManager.instance.getItem(phone);
      if (user != null) {
        // if (user.phoneNumber == "+905448716741") {
        //    user.subscriptionId = "full_access";
        // }
        if (user.phoneNumber == "+905322565218") {
          user.subscriptionId = "full_access";
        }
        if (user.phoneNumber == "+905555555555") {
          user.subscriptionId = "full_access";
        }
      }
    }
  }

  Future bildirimciNotFoundDirectToManageTcPage() async {
    await Navigator.pushNamedAndRemoveUntil(
        context, ManageTcPage.name, (route) => false);
  }

  Future bildirimciFoundDirectToHomePage(
      List<Bildirimci> bildirimciList) async {
    Bildirimci bildirimci = bildirimciList.first;
    //bildirimci found
    ActiveTc.instance.activeTc = bildirimci.bildirimciTc!;

    HksUser user = HksUser(
        password: bildirimci.hksSifre!,
        userName: bildirimci.bildirimciTc!,
        webServicePassword: bildirimci.webServiceSifre!);
    GeneralService.instance.assignHksUserInfo(user);
    UrunService.instance.assignHksUserInfo(user);
    BildirimService.instance.assignHksUserInfo(user);

    await context
        .read<MainBildirimCubit>()
        .assignRightUser(bildirimci.bildirimciTc!, context);

    Navigator.pushNamedAndRemoveUntil(context, HomePage.name, (route) => false);
  }

  Future directToLoginPage(BuildContext context) async {
    if (context.loaderOverlay.visible) {
      context.loaderOverlay.hide();
    }
    Navigator.pushNamedAndRemoveUntil(
      context,
      LoginPage.name,
      (route) => false,
    ).then((value) {
      if (context.loaderOverlay.visible) {
        context.loaderOverlay.hide();
      }
    });
  }

  Future<void> startFreeSubscriptionLocaleCompleted() async {
    String? phone =
        AppCacheManager.instance.getItem(PreferencesKeys.phone.name);
    if (phone != null) {
      await AppCacheManager.instance.putItem(
          PreferencesKeys.subscriptionStartDate.name,
          ((await TimeService.instance.getTime()) ?? DateTime.now())
              .subtract(const Duration(days: 15))
              .toString());
      await AppCacheManager.instance.putItem(
          PreferencesKeys.isFreeSubscriptionUsed.name, true.toString());
    }
  }

  Future<void> startFreeSubscriptionServiceCompleted() async {
    await FirestoreService.instance.saveStartSubscriptionInfo(
        SubscriptionStartModel(
            isFreeSubscriptionUsed: true.toString(),
            subscriptionStartDate:
                ((await TimeService.instance.getTime()) ?? DateTime.now())
                    .subtract(const Duration(days: 15))
                    .toString()));
  }

  Future<bool> checkFirebaseForSubscriptionStart() async {
    // return false ise kır  //bir yere navigation varsa false dönüyorum.
    DateTime currentTime =
        ((await TimeService.instance.getTime()) ?? DateTime.now());
    String? phoneNumber =
        AppCacheManager.instance.getItem(PreferencesKeys.phone.name);
    if (phoneNumber != null) {
      IResponseModel<SubscriptionStartModel?> subscriptionResponse =
          await FirestoreService.instance.readUserSubscriptionInfo();
      if (subscriptionResponse.data != null) {
        String? isFreeUsed = subscriptionResponse.data!.isFreeSubscriptionUsed;
        if (isFreeUsed == "true") {
          //go to subscription page
          await startFreeSubscriptionLocaleCompleted();
          Navigator.pushNamedAndRemoveUntil(
              context, SubscriptionsPage.name, (route) => false);
          return false;
        } else {
          //false
          String? startDateFromFirebase =
              subscriptionResponse.data!.subscriptionStartDate;
          if (startDateFromFirebase != null) {
            double dayOfDifference = currentTime
                .difference(DateTime.parse(startDateFromFirebase))
                .inMilliseconds
                .millisecondToDay;
            if (dayOfDifference > 14) {
              //abonelik sayfasına git
              try {
                await startFreeSubscriptionLocaleCompleted()
                    .then((value) async {
                  await startFreeSubscriptionServiceCompleted();
                  Navigator.pushNamedAndRemoveUntil(
                      context, SubscriptionsPage.name, (route) => false);
                });
              } catch (e) {
                await startFreeSubscriptionLocaleCompleted();

                Navigator.pushNamedAndRemoveUntil(
                    context, SubscriptionsPage.name, (route) => false);
              }

              return false;
            } else {
              String? phone =
                  AppCacheManager.instance.getItem(PreferencesKeys.phone.name);
              if (phone != null) {
                await AppCacheManager.instance.putItem(
                    PreferencesKeys.subscriptionStartDate.name,
                    startDateFromFirebase);
                await AppCacheManager.instance.putItem(
                    PreferencesKeys.isFreeSubscriptionUsed.name,
                    false.toString());
              }

              await AppCacheManager.instance.putItem(
                  PreferencesKeys.isAccessDenied.name, false.toString());
              await AppCacheManager.instance
                  .putItem(PreferencesKeys.isUserActive.name, true.toString());
              List<Bildirimci>? bildirimciList =
                  BildirimciCacheManager.instance.getValues();

              if (phone != null) {
                MyUser? user = UserCacheManager.instance.getItem(phone);
                if (user != null) {
                  user.subscriptionId = "basic_trial";
                  user.save();
                }
              }
              if (bildirimciList.ext.isNotNullOrEmpty) {
                await bildirimciFoundDirectToHomePage(bildirimciList!);
              } else {
                await bildirimciNotFoundDirectToManageTcPage();
              }

              return false;
            }
          } else {
            String? phone =
                AppCacheManager.instance.getItem(PreferencesKeys.phone.name);
            if (phone != null) {
              MyUser? user = UserCacheManager.instance.getItem(phone);
              if (user != null) {
                user.subscriptionId = "basic_trial";
                user.save();
              }
            }
            await AppCacheManager.instance
                .putItem(PreferencesKeys.isAccessDenied.name, false.toString());
            await AppCacheManager.instance
                .putItem(PreferencesKeys.isUserActive.name, true.toString());
            Navigator.pushNamedAndRemoveUntil(
                context, StartFreeSubscriptionPage.name, (route) => false);
            return false;
          }
        }
      } else {
        String? phone =
            AppCacheManager.instance.getItem(PreferencesKeys.phone.name);
        if (phone != null) {
          MyUser? user = UserCacheManager.instance.getItem(phone);
          if (user != null) {
            user.subscriptionId = "basic_trial";
            user.save();
          }
        }
        await AppCacheManager.instance
            .putItem(PreferencesKeys.isAccessDenied.name, false.toString());
        await AppCacheManager.instance
            .putItem(PreferencesKeys.isUserActive.name, true.toString());
        //go to start page
        Navigator.pushNamedAndRemoveUntil(
            context, StartFreeSubscriptionPage.name, (route) => false);
        return false;
      }
    } else {
      return true;
    }
  }

//kullanıcı üyeliğini düşürmüşmü
  bool checkUserExcess() {
    String? phone =
        AppCacheManager.instance.getItem(PreferencesKeys.phone.name);
    if (phone != null) {
      MyUser? user = UserCacheManager.instance.getItem(phone);
      if (user != null) {
        user.subscriptionNumber ??= user.findSubscriptionNumber;
        List<String> listKeys = BildirimciCacheManager.instance.getkeys() ?? [];

        if ((user.subscriptionNumber ?? 0) < (listKeys.length)) {
          //kullanıcı üyelik silmeli
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content:
                Text("Kullanıcı Üyelik Sayısı: ${user.subscriptionNumber}"),
          ));
          Navigator.pushNamedAndRemoveUntil(
              context, RemoveExcessTcPage.name, (route) => false);
          return true;
        }
      }
    }
    return false;
  }

  // TODO : BURADA FIREBASE CURRENT DAN CEKILIYOR KULLANICI BURDADA FIRESTORE U KONTROL ET
  // TODO : KULLANICI TEL NO İLE VARSA FIRESTORE DATALARI CEKMEYI YAPMALISIN VE ONLARI LOCALE YAZ

  //LOCAL DATALARI KONTROL EDER EĞER EKSIK VAR SA VE FIREBASE IN CURRENT DAN TAMAMLANIR
  Future<void> checkLocalDbAndFillWithFirebaseData() async {
    String? number =
        AppCacheManager.instance.getItem(PreferencesKeys.phone.name);
    if (number == null) {
      if (FirebaseAuth.instance.currentUser!.phoneNumber == null) {
        if (FirebaseAuth.instance.currentUser?.email?.split("@")[0] != null) {
          await AppCacheManager.instance.putItem(PreferencesKeys.phone.name,
              FirebaseAuth.instance.currentUser?.email?.split("@")[0] ?? "");
        }
      } else {
        await AppCacheManager.instance.putItem(PreferencesKeys.phone.name,
            FirebaseAuth.instance.currentUser!.phoneNumber!);
      }

      MyUser? user = UserCacheManager.instance.getItem(
          AppCacheManager.instance.getItem(PreferencesKeys.phone.name)!);
      if (user == null) {
        UserCacheManager.instance.putItem(
            AppCacheManager.instance.getItem(PreferencesKeys.phone.name)!,
            MyUser(
                phoneNumber: FirebaseAuth.instance.currentUser?.phoneNumber));
      }
    } else {
      MyUser? user = UserCacheManager.instance.getItem(
          AppCacheManager.instance.getItem(PreferencesKeys.phone.name)!);
      if (user == null) {
        UserCacheManager.instance.putItem(
            AppCacheManager.instance.getItem(PreferencesKeys.phone.name)!,
            MyUser(
                phoneNumber: FirebaseAuth.instance.currentUser?.phoneNumber));
      }
    }
  }

  bool get checkFirebaseUser =>
      FirebaseAuth.instance.currentUser == null ? false : true;

  Future<bool> isLogin() async {
    MyUser? user;
    String? phone =
        AppCacheManager.instance.getItem(PreferencesKeys.phone.name);
    if (phone != null) {
      user = UserCacheManager.instance.getItem(phone);
      print(user);
    } else {
      return false;
    }
    if (user?.password == null || user?.phoneNumber == null) {
      return false;
    }

    try {
      bool result = await PasswordLoginService.instance
          .login(user!.phoneNumber!, user.password!);
      return result;
    } catch (e) {
      return false;
    }
  }
}
