import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hal_app/feature/settings/sub/delete_profile/view/delete_profile_page.dart';
import '../../../../helper/scaffold_messager.dart';
import '../../update_user_informations/view/update_user_informations_page.dart';
import '../../update_user_informations/viewmodel/cubit/update_user_informations_cubit.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:kartal/kartal.dart';

import '../../../../../core/enum/preferences_keys_enum.dart';
import '../../../../../project/cache/app_cache_manager.dart';
import '../../../../../project/cache/bildirimci_cache_manager.dart';
import '../../../../../project/model/bildirimci/bildirimci_model.dart';
import '../../../../../project/utils/widgets/settings_page_card_item.dart';

class UserProfile extends StatelessWidget {
  static const String name = "userProfile";
  const UserProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CupertinoNavigationBar(middle: Text("Kullanıcı Ayaları")),
      body: Padding(
          padding: context.padding.horizontalLow,
          child: ListView(
            shrinkWrap: true,
            children: [
              ValueListenableBuilder(
                  valueListenable:
                      Hive.box<String>(AppCacheManager.instance.key)
                          .listenable(),
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
                        ontap: () async {
                          await Navigator.pushNamed(
                              context, DeleteProfile.name);
                        });
                  }),

              ValueListenableBuilder(
                  valueListenable:
                      Hive.box<Bildirimci>(BildirimciCacheManager.instance.key)
                          .listenable(),
                  builder: (BuildContext context, Box<Bildirimci>? box,
                      Widget? widget) {
                    //AppCacheManager.instance.getItem(key)

                    List<Bildirimci>? bildirimciler = box?.values.toList();
                    if (bildirimciler != null && bildirimciler.isNotEmpty) {
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: bildirimciler.length + 1,
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return Padding(
                              padding: context.padding.verticalNormal,
                              child: Text(
                                "Sisteme Kayıtlı Bildirimciler",
                                style: context.general.textTheme.titleLarge,
                                textAlign: TextAlign.center,
                              ),
                            );
                          }

                          Bildirimci bildirimci = bildirimciler[index - 1];

                          return SettingsCardItem(
                              text: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(bildirimci.isyeriAdi ?? "Bildirimci",
                                      style: context.general.textTheme.bodyLarge
                                          ?.copyWith(
                                              fontWeight: FontWeight.bold)),
                                  Text(bildirimci.bildirimciTc!),
                                ],
                              ),
                              ontap: () {
                                if (bildirimci.bildirimciTc == null) {
                                  ScaffoldMessengerHelper.instance
                                      .showErrorSnackBar(
                                          context, "Bildirimci Tc Bulunamadı");
                                } else {
                                  context
                                      .read<UpdateUserInformationsCubit>()
                                      .setSelectedBildirimciTc(bildirimci);
                                  Navigator.pushNamed(
                                      context, UpdateUserInformationPage.name);
                                }
                              });
                        },
                      );
                    } else {
                      return SettingsCardItem(
                          text: const Text("Bildirimci bulunamadı"),
                          ontap: () {});
                    }
                  }),
              //kullanıcı adı
              // kullanıcı telefon
              //şifre değiştir
            ],
          )),
    );
  }
}
