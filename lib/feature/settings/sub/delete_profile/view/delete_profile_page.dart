import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:kartal/kartal.dart';

import '../../../../../core/enum/preferences_keys_enum.dart';
import '../../../../../project/cache/app_cache_manager.dart';
import '../../../../../project/utils/widgets/settings_page_card_item.dart';
import '../../../../auth/login/view/login_page.dart';

class DeleteProfile extends StatelessWidget {
  static const String name = "deleteProfilePage";
  const DeleteProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CupertinoNavigationBar(
        middle: Text("Kullanıcı Sil"),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            await AppCacheManager.instance
                .removeItem(PreferencesKeys.phone.name);

            await FirebaseAuth.instance.signOut();
            Navigator.pushNamedAndRemoveUntil(
                context, LoginPage.name, (route) => false);
          },
          label: const Text("Kullanıcı Sil")),
      body: Padding(
        padding: context.padding.horizontalLow,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ValueListenableBuilder(
                valueListenable:
                    Hive.box<String>(AppCacheManager.instance.key).listenable(),
                builder:
                    (BuildContext context, Box<String>? box, Widget? widget) {
                  //AppCacheManager.instance.getItem(key)
                  String? phone = box?.get(PreferencesKeys.phone.name);
                  return SettingsCardItem(
                      text: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          phone != null
                              ? RichText(
                                  textAlign: TextAlign.start,
                                  text: TextSpan(
                                      text: "Kayıtlı Telefon: ",
                                      style:
                                          context.general.textTheme.bodyLarge,
                                      children: [TextSpan(text: phone)]),
                                )
                              : const Text("Telefon numarası bulunamadı"),
                        ],
                      ),
                      ontap: () {});
                }),
          ],
        ),
      ),
    );
  }
}
