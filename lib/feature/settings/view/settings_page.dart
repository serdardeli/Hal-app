import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hal_app/core/enum/preferences_keys_enum.dart';
import 'package:hal_app/feature/settings/sub/last_mobile_notifications/view/last_mobile_notifications.dart';
import 'package:hal_app/feature/settings/sub/user_activity/view/user_activity_page.dart';
import 'package:hal_app/feature/settings/sub/yedekleme_page/view/back_up_page.dart';
import 'package:hal_app/project/cache/app_cache_manager.dart';
import 'package:hal_app/project/cache/bildirimci_cache_manager.dart';
import 'package:hal_app/project/cache/user_cache_manager.dart';
import 'package:hal_app/project/service/firebase/auth/fireabase_auth_service.dart';
import '../../auth/login/view/login_page.dart';
import '../../manage_tc/view/manage_tc_page.dart';
import '../sub/fatura_page/view/fatura_page.dart';
import '../sub/help_page/view/help_page.dart';
import '../sub/user_profile_page/view/user_profile.dart';
import '../viewmodel/cubit/settings_cubit.dart';
import '../../subscriptions/view/subscriptions_page.dart';
import '../../../project/utils/widgets/settings_page_card_item.dart';
import 'package:kartal/kartal.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: context.padding.horizontalNormal,
        child: SingleChildScrollView(
            child: Column(
          children: [
            SettingsCardItem(
                prefix: const Icon(Icons.person_outline_outlined),
                text: const Text("Profil"),
                ontap: () {
                  Navigator.pushNamed(context, UserProfile.name);
                }),
            SettingsCardItem(
                prefix: const Icon(Icons.person_outline_outlined),
                text: const Text("Yardım"),
                ontap: () {
                  Navigator.pushNamed(context, HelpPage.name);
                }),
            SettingsCardItem(
                prefix: const Icon(Icons.person_outline_outlined),
                text: const Text("Bildirimci Ekle / Güncelle"),
                ontap: () {
                  Navigator.pushNamed(context, ManageTcPage.name);
                }),
            SettingsCardItem(
                prefix: const Icon(Icons.person_outline_outlined),
                text: const Text("Üyelik"),
                ontap: () {
                  Navigator.pushNamed(context, SubscriptionsPage.name);
                }),
            SettingsCardItem(
                prefix: const Icon(Icons.person_outline_outlined),
                text: const Text("Yedekleme"),
                ontap: () {
                  Navigator.pushNamed(context, BackupPage.name);
                }),
            SettingsCardItem(
                prefix: const Icon(Icons.person_outline_outlined),
                text: const Text("Son Yapılan Mobil Bildirimler"),
                ontap: () {
                  Navigator.pushNamed(context, LastMobileNotifications.name);
                }),
            SettingsCardItem(
                prefix: const Icon(Icons.person_outline_outlined),
                text: const Text("E-Belge"),
                ontap: () {
                  Navigator.pushNamed(context, FaturaPage.name);
                }),
            buildSignOutButton(context),
            buildViewUsersButton(context)
          ],
        )),
      ),
    );
  }

  Widget buildViewUsersButton(BuildContext context) =>
      AppCacheManager.instance.getItem(PreferencesKeys.phone.name) ==
              "+905448716741"
          ? SettingsCardItem(
              prefix: const Icon(Icons.person_outline_outlined),
              text: const Text("User Activity"),
              ontap: () {
                Navigator.pushNamed(context, UserActivityPage.name);
              })
          : const SizedBox();

  SettingsCardItem buildSignOutButton(BuildContext context) {
    return SettingsCardItem(
        prefix: const Icon(Icons.person_outline_outlined),
        text: const Text("Çıkış Yap"),
        ontap: () async {
          // await AppCacheManager.instance.removeItem(PreferencesKeys.phone.name);

          // await context.read<SettingsCubit>().signOut().then((value) =>
          //     Navigator.pushNamedAndRemoveUntil(
          //         context, LoginPage.name, (route) => false));
          await commonLogOut(context);
        });
  }
}

commonLogOut(BuildContext context) async {
  await AppCacheManager.instance.removeItem(PreferencesKeys.phone.name);
  //FirebaseAuthService.instance.signOut();
  AppCacheManager.instance.clearAll();
  UserCacheManager.instance.clearAll();
  await context.read<SettingsCubit>().signOut().then((value) =>
      Navigator.pushNamedAndRemoveUntil(
          context, LoginPage.name, (route) => false));
}
