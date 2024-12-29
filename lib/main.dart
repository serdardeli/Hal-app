import 'dart:io';

import 'package:cupertino_will_pop_scope/cupertino_will_pop_scope.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hal_app/core/api/purchase_api.dart';
import 'package:hal_app/feature/home/sub/bildirim_page/sub/komisyoncu_bildirim_page/viewmodel/cubit/komisyoncu_cubit.dart';
import 'package:hal_app/feature/home/sub/bildirim_page/sub/satis_page/viewmodel/cubit/satis_cubit.dart';
import 'package:hal_app/feature/home/sub/bildirim_page/sub/ureticiden_sevk_alim/viewmodel/cubit/ureticiden_sevk_alim_cubit.dart';
import 'package:hal_app/feature/settings/sub/delete_profile/view/delete_profile_page.dart';
import 'package:hal_app/feature/settings/sub/fatura_page/sub/driver/sub/viewmodel/cubit/add_driver_cubit.dart';
import 'package:hal_app/feature/settings/sub/fatura_page/sub/giden_fatura_page/view/giden_fatura_page.dart';
import 'package:hal_app/feature/settings/sub/fatura_page/sub/giden_fatura_page/viewmodel/cubit/giden_fatura_cubit.dart';
import 'package:hal_app/feature/settings/sub/fatura_page/sub/help/view/help_fatura_page.dart';
import 'package:hal_app/feature/settings/sub/fatura_page/sub/view/mysoft_user_page.dart';
import 'package:hal_app/feature/settings/sub/fatura_page/sub/viewmodel/cubit/mysoft_user_cubit.dart';
import 'package:hal_app/feature/settings/sub/fatura_page/view/fatura_page.dart';
import 'package:hal_app/feature/settings/sub/last_mobile_notifications/view/last_mobile_notifications.dart';
import 'package:hal_app/feature/settings/sub/last_mobile_notifications/viewmodel/cubit/last_mobile_notifications_cubit.dart';
import 'package:hal_app/feature/settings/sub/user_activity/view/user_activity_page.dart';
import 'package:hal_app/feature/settings/sub/yedekleme_page/view/back_up_page.dart';
import 'feature/auth/start_free_subscription/start_free_subscription.dart';
import 'feature/home/sub/add_musteri/sub/view/add_musteri_sub.dart';
import 'feature/home/sub/add_musteri/sub/viewmodel/cubit/add_musteri_sub_cubit.dart';
import 'feature/home/sub/add_profile/viewmodel/cubit/add_profile_cubit.dart';
import 'feature/home/sub/add_profile/viewmodel/cubit/add_profile_page_general_cubit.dart';
import 'feature/home/sub/bildirim_page/sub/sanayici_main_page/viewmodel/cubit/sanayici_main_cubit.dart';
import 'feature/home/sub/bildirim_page/sub/sat%C4%B1n_al%C4%B1m_page/viewmodel/cubit/satin_alim_cubit.dart';
import 'feature/home/sub/bildirim_page/sub/satin_alim_sanayici_page/viewmodel/cubit/sanayici_satin_alim_cubit.dart';
import 'feature/home/sub/bildirim_page/sub/sevk_etme_for_komisyoncu_page/viewmodel/cubit/sevk_etme_for_komisyoncu_cubit.dart';
import 'feature/home/sub/bildirim_page/sub/sevk_etme_for_sanayici/viewmodel/cubit/sevk_etme_for_sanayici_cubit.dart';
import 'feature/home/sub/bildirim_page/sub/sevk_etme_page/viewmodel/cubit/sevk_etme_cubit.dart';
import 'feature/home/sub/bildirim_page/sub/tuccar_hal_ici_disi/viewmodel/cubit/tuccar_hal_ici_disi_main_cubit.dart';
import 'feature/home/sub/remove_saved_notification/view/remove_saved_notification.dart';
import 'feature/home/sub/resent_notifications/viewmodel/cubit/recent_notifications_cubit.dart';
import 'feature/home/sub/saved_notifications/viewmodel/cubit/saved_notification_page_general_cubit.dart';
import 'feature/home/sub/saved_notifications/viewmodel/cubit/saved_notifications_cubit.dart';
import 'feature/remove_excess_tc_page/view/remove_excess_tc_page.dart';
import 'feature/settings/sub/fatura_page/sub/driver/sub/view/add_driver.dart';
import 'feature/settings/sub/fatura_page/sub/driver/view/driver_page.dart';
import 'feature/settings/sub/help_page/view/help_page.dart';
import 'feature/settings/sub/update_user_informations/view/update_user_informations_page.dart';
import 'feature/settings/sub/user_profile_page/view/user_profile.dart';
import 'package:kartal/kartal.dart';
import 'feature/add_tc_page/view/add_tc_page.dart';
import 'feature/add_tc_page/viewmodel/cubit/add_tc_cubit.dart';
import 'feature/auth/login/view/login_page.dart';
import 'feature/auth/login/viewmodel/cubit/login_cubit.dart';
import 'feature/auth/register/view/register_page.dart';
import 'feature/auth/register/viewmodel/cubit/register_cubit.dart';
import 'feature/auth/sms_check_page/sms_check_view.dart';
import 'feature/home/sub/add_profile/sub/add_profile/view/add_uretici_profile.dart';
import 'feature/home/sub/bildirim/view/bildirim_view.dart';
import 'feature/home/sub/bildirim_page/main_bildirim_page/viewmodel/cubit/main_bildirim_cubit.dart';
import 'feature/home/view/home_view.dart';
import 'feature/home/viewmodel/cubit/home_cubit.dart';
import 'feature/launch/view/launch_view.dart';
import 'feature/manage_tc/view/manage_tc_page.dart';
import 'feature/manage_tc/viewmodel/cubit/manage_tc_cubit.dart';
import 'feature/settings/sub/update_user_informations/viewmodel/cubit/update_user_informations_cubit.dart';
import 'feature/settings/viewmodel/cubit/settings_cubit.dart';
import 'feature/subscriptions/view/subscriptions_page.dart';
import 'feature/subscriptions/viewmodel/cubit/subscriptions_cubit.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';

import 'core/init/main_build.dart';
import 'feature/home/sub/bildirim/viewmodel/cubit/bildirim_cubit.dart';
import 'firebase_options.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid) {
    HttpOverrides.global = MyHttpOverrides();
  }
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  /* FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
//Please register custom URL scheme 'app-1-657096510394-ios-34efc89c64eae8df3deb83' in the app's Info.plist file.
 */
  await PurchaseApi.instance.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          BlocProvider<BildirimCubit>(
              create: (BuildContext context) => BildirimCubit()),
          // ChangeNotifierProvider(
          //     create: (BuildContext context) => RevenueCatProvider()),
          BlocProvider<LoginCubit>(
              create: (BuildContext context) => LoginCubit()),
          BlocProvider<RegisterCubit>(
              create: (BuildContext context) => RegisterCubit()),
          BlocProvider<SubscriptionsCubit>(
              create: (BuildContext context) => SubscriptionsCubit()),
          BlocProvider<ManageTcCubit>(
              create: (BuildContext context) => ManageTcCubit()),
          BlocProvider<AddTcCubit>(
              create: (BuildContext context) => AddTcCubit()),
          BlocProvider<HomeCubit>(
              create: (BuildContext context) => HomeCubit()),
          BlocProvider<UreticidenSevkAlimCubit>(
              create: (BuildContext context) => UreticidenSevkAlimCubit()),
          BlocProvider<AddProfileCubit>(
              create: (BuildContext context) => AddProfileCubit()),
          BlocProvider<MainBildirimCubit>(
              create: (BuildContext context) => MainBildirimCubit()),
          BlocProvider<TuccarHalIciDisiMainCubit>(
              create: (BuildContext context) => TuccarHalIciDisiMainCubit()),
          BlocProvider<SatinAlimCubit>(
              create: (BuildContext context) => SatinAlimCubit()),
          BlocProvider<SevkEtmeCubit>(
              create: (BuildContext context) => SevkEtmeCubit()),
          BlocProvider<RecentNotificationsCubit>(
              create: (BuildContext context) => RecentNotificationsCubit()),
          BlocProvider<UpdateUserInformationsCubit>(
              create: (BuildContext context) => UpdateUserInformationsCubit()),
          BlocProvider<SettingsCubit>(
              create: (BuildContext context) => SettingsCubit()),
          BlocProvider<SavedNotificationsCubit>(
              create: (BuildContext context) => SavedNotificationsCubit()),
          BlocProvider<SavedNotificationPageGeneralCubit>(
              create: (BuildContext context) =>
                  SavedNotificationPageGeneralCubit()),
          BlocProvider<AddProfilePageGeneralCubit>(
              create: (BuildContext context) => AddProfilePageGeneralCubit()),
          BlocProvider<LastMobileNotificationsCubit>(
              create: (BuildContext context) => LastMobileNotificationsCubit()),
          BlocProvider<AddMusteriSubCubit>(
              create: (BuildContext context) => AddMusteriSubCubit()),
          BlocProvider<SatisCubit>(
              create: (BuildContext context) => SatisCubit()),
          BlocProvider<KomisyoncuCubit>(
              create: (BuildContext context) => KomisyoncuCubit()),
          BlocProvider<AddMySoftUserCubit>(
              create: (BuildContext context) => AddMySoftUserCubit()),
          BlocProvider<SevkEtmeForKomisyoncuCubit>(
              create: (BuildContext context) => SevkEtmeForKomisyoncuCubit()),
          BlocProvider<AddDriverCubit>(
              create: (BuildContext context) => AddDriverCubit()),
          BlocProvider<GidenFaturaCubit>(
              create: (BuildContext context) => GidenFaturaCubit()),
          BlocProvider<SanayiciMainCubit>(
              create: (BuildContext context) => SanayiciMainCubit()),
          BlocProvider<SanayiciSatinAlimCubit>(
              create: (BuildContext context) => SanayiciSatinAlimCubit()),
          BlocProvider<SevkEtmeForSanayiciCubit>(
              create: (BuildContext context) => SevkEtmeForSanayiciCubit()),
        ],
        child: GlobalLoaderOverlay(
          //  overlayColor: Colors.green,
          overlayWidget: const Center(
              child: SpinKitCubeGrid(
            color: Colors.red,
            size: 50.0,
          )),
          child: MaterialApp(
            localizationsDelegates: GlobalMaterialLocalizations.delegates,
            supportedLocales: const [
              //  const Locale('tr', 'TR'), // English
              Locale('tr', 'TR'), // German
              // ... other locales the app supports
            ],
            debugShowCheckedModeBanner: false,
            theme: ThemeData.light().copyWith(
              colorScheme:
                  context.general.colorScheme.copyWith(primary: Colors.green),
              textTheme: GoogleFonts.latoTextTheme(
                Theme.of(context).textTheme,
              ),
              //    colorScheme: context.colorScheme.copyWith(primary: Colors.red),
              textButtonTheme: TextButtonThemeData(
                  style: TextButton.styleFrom(
                      textStyle: context.general.textTheme.bodyLarge!.apply(
                color: Colors.black,
              ))),
              //  scaffoldBackgroundColor: Color(0xFFDBE9F6),
              inputDecorationTheme: InputDecorationTheme(
                focusColor: Colors.grey,
                labelStyle: const TextStyle(color: Colors.grey),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: Colors.grey[850]!),
                ),
              ),
              snackBarTheme: const SnackBarThemeData(
                actionTextColor: Colors.white,
              ),
              bottomNavigationBarTheme: const BottomNavigationBarThemeData(
                  backgroundColor: Colors.red),

              cupertinoOverrideTheme:
                  NoDefaultCupertinoThemeData(primaryColor: Colors.grey[850]),
              elevatedButtonTheme: ElevatedButtonThemeData(
                  style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.green),
                      foregroundColor:
                          WidgetStateProperty.all(Colors.white))),
              floatingActionButtonTheme: const FloatingActionButtonThemeData(
                  backgroundColor: Colors.green),
              appBarTheme: AppBarTheme(
                  color: Colors.white,
                  elevation: 1,
                  titleTextStyle: context.general.textTheme.titleLarge,
                  iconTheme: IconThemeData(color: Colors.grey[850])),

              pageTransitionsTheme: const PageTransitionsTheme(
                builders: {
                  TargetPlatform.android: ZoomPageTransitionsBuilder(),
                  TargetPlatform.iOS:
                      CupertinoWillPopScopePageTransionsBuilder(),
                },
              ),
            ),
            builder: EasyLoading.init(builder: MainBuild.build),
            routes: {
              HomePage.name: (BuildContext ctx) => HomePage(),
              Launch.name: (BuildContext ctx) => const Launch(),
              Bildirim.name: (BuildContext ctx) => const Bildirim(),
              LoginPage.name: (BuildContext ctx) => LoginPage(),
              RegisterPage.name: (BuildContext ctx) => const RegisterPage(),
              SubscriptionsPage.name: (BuildContext ctx) =>
                  const SubscriptionsPage(),
              SmsCheckPage.name: (BuildContext ctx) => SmsCheckPage(),
              ManageTcPage.name: (BuildContext ctx) => const ManageTcPage(),
              AddTcPage.name: (BuildContext ctx) => const AddTcPage(),
              HelpPage.name: (BuildContext ctx) => const HelpPage(),
              UserProfile.name: (BuildContext ctx) => const UserProfile(),
              UpdateUserInformationPage.name: (BuildContext ctx) =>
                  const UpdateUserInformationPage(),
              AddUreticiProfilePage.name: (BuildContext ctx) =>
                  const AddUreticiProfilePage(),
              RemoveExcessTcPage.name: (BuildContext ctx) =>
                  const RemoveExcessTcPage(),
              BackupPage.name: (BuildContext ctx) => const BackupPage(),
              LastMobileNotifications.name: (BuildContext ctx) =>
                  const LastMobileNotifications(),
              AddMusteriSub.name: (BuildContext ctx) => const AddMusteriSub(),
              FaturaPage.name: (BuildContext ctx) => const FaturaPage(),
              MySoftUserPage.name: (BuildContext ctx) => const MySoftUserPage(),
              DriverGeneral.name: (BuildContext ctx) => const DriverGeneral(),
              AddDriverPage.name: (BuildContext ctx) => const AddDriverPage(),
              GidenFaturaPage.name: (BuildContext ctx) => GidenFaturaPage(),
              HelpFaturaPage.name: (BuildContext ctx) => const HelpFaturaPage(),
              StartFreeSubscriptionPage.name: (BuildContext ctx) =>
                  const StartFreeSubscriptionPage(),
              RemoveNotificationPage.name: (BuildContext ctx) =>
                  RemoveNotificationPage(),
              DeleteProfile.name: (BuildContext ctx) => const DeleteProfile(),
              UserActivityPage.name: (BuildContext ctx) =>
                  const UserActivityPage(),
            },
            home: const Launch(),
          ),
        ));
  }
}
