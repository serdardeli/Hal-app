import 'package:flutter/material.dart'; 
import 'package:hal_app/core/enum/preferences_keys_enum.dart';
import 'package:hal_app/feature/helper/scaffold_messager.dart';
import 'package:hal_app/feature/manage_tc/view/manage_tc_page.dart';
import 'package:hal_app/project/cache/app_cache_manager.dart';
import 'package:hal_app/project/service/firebase/firestore/firestore_service.dart';
import 'package:hal_app/project/service/time/time_service.dart';
import 'package:kartal/kartal.dart';

import '../../../project/model/subscription_start_model/subscription_start_model.dart';

class StartFreeSubscriptionPage extends StatelessWidget {
  static const String name = "startFreeSubscriptionPage";
  const StartFreeSubscriptionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("asset/app_logo/logo_min.jpeg"),
            Padding(
              padding: context.padding.verticalLow,
              child: ElevatedButton(
                  onPressed: () async {
                    try {
                      Future.wait([
                        assignUserInfos(),
                        startFreeSubscriptionLocale(),
                        startFreeSubscriptionService()
                      ]).then((value) => {
                            Navigator.pushNamedAndRemoveUntil(
                                context, ManageTcPage.name, (route) => false)
                          });
                    } catch (e) {
                      ScaffoldMessengerHelper.instance
                          .showErrorSnackBar(context, e.toString());
                      ScaffoldMessengerHelper.instance
                          .showErrorSnackBar(context, "Tekrar Deneyiniz");
                    }
                  },
                  child: const Text("2 Haftalık Ücretsiz Denemeyi Başlat")),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> assignUserInfos() async {
    await AppCacheManager.instance
        .putItem(PreferencesKeys.isAccessDenied.name, false.toString());
    await AppCacheManager.instance
        .putItem(PreferencesKeys.isUserActive.name, true.toString());
  }

  Future<void> startFreeSubscriptionService() async {
    await FirestoreService.instance.saveStartSubscriptionInfo(
        SubscriptionStartModel(
            isFreeSubscriptionUsed: "false",
            subscriptionStartDate:
                ((await TimeService.instance.getTime()) ?? DateTime.now())
                    .toString()));
  }

  Future<void> startFreeSubscriptionLocale() async {
    String? phone =
        AppCacheManager.instance.getItem(PreferencesKeys.phone.name);
    if (phone != null) {
      await AppCacheManager.instance.putItem(
          PreferencesKeys.subscriptionStartDate.name,
          ((await TimeService.instance.getTime()) ?? DateTime.now())
              .toString());
      await AppCacheManager.instance.putItem(
          PreferencesKeys.isFreeSubscriptionUsed.name, false.toString());
    }
  }
}
