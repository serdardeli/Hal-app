import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hal_app/feature/settings/view/settings_page.dart';
import '../../helper/test.dart';
import '../../home/sub/bildirim_page/main_bildirim_page/viewmodel/cubit/main_bildirim_cubit.dart';
import '../../../project/cache/bildirimci_cache_manager.dart';
import '../../../project/model/bildirimci/bildirimci_model.dart';
import '../../../core/enum/preferences_keys_enum.dart';
import '../../../core/extention/user_extension.dart';
import '../../../project/model/hks_user/hks_user.dart';
import '../../../project/service/hal/bildirim_service.dart';
import '../../../project/service/hal/genel_service.dart';
import '../../../project/service/hal/urun_service.dart';
import '../../auth/login/view/login_page.dart';
import '../../helper/active_tc.dart';
import '../../helper/scaffold_messager.dart';
import '../../home/view/home_view.dart';
import '../../settings/sub/update_user_informations/view/update_user_informations_page.dart';
import '../../settings/sub/update_user_informations/viewmodel/cubit/update_user_informations_cubit.dart';
import '../viewmodel/cubit/manage_tc_cubit.dart';
import '../../../project/cache/app_cache_manager.dart';
import '../../../project/cache/user_cache_manager.dart';
import '../../../project/model/user/my_user_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kartal/kartal.dart';

import '../../../project/utils/widgets/settings_page_card_item.dart';
import '../../subscriptions/view/subscriptions_page.dart';

class ManageTcPage extends StatelessWidget {
  static const String name = "manageTc";
  const ManageTcPage({Key? key}) : super(key: key);

// AppBar(title: Text("Bildirimci Tc leri")),
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        //     Navigator.pop(context);
        //  context.read<HomeCubit>().pageController.dispose();

        //context.read<HomeCubit>().currentIndex = 0;
        if (!Navigator.canPop(context)) {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text("Çıkmak istiyor musun?"),
                  actions: [
                    TextButton(
                      child: const Text('Hayır'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: const Text('Evet'),
                      onPressed: () {
                        SystemNavigator.pop();
                      },
                    ),
                  ],
                );
              });

          return false;
        }
        return true;
      },
      child: Scaffold(
        //  floatingActionButton: FloatingActionButton(onPressed: () {
        //    FirebaseCrashlytics.instance.crash();
        //   }),
        drawer: !Navigator.canPop(context)
            ? Drawer(
                child: SafeArea(
                    child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        // AppCacheManager.instance
                        //     .removeItem(PreferencesKeys.phone.name);
                        // context.read<ManageTcCubit>().signOut().then((value) =>
                        //     Navigator.pushNamedAndRemoveUntil(
                        //         context, LoginPage.name, (route) => false));
                        commonLogOut(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          title: Text("Çıkış yap",
                              style: context.general.textTheme.titleLarge
                                  ?.copyWith(color: Colors.black)),
                          trailing: const Icon(Icons.exit_to_app),
                        ),
                      ),
                    ),
                  ],
                )),
              )
            : null,
        appBar: AppBar(
          title: const Text("Bildirimci Tc leri"),
        ),
        body: Padding(
          padding: context.padding.horizontalNormal,
          child: SingleChildScrollView(
            child: Stack(
              children: [
                buildBlocConsumer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  BlocConsumer<ManageTcCubit, ManageTcState> buildBlocConsumer() {
    return BlocConsumer<ManageTcCubit, ManageTcState>(
      listener: (context, state) {
        if (state is ManageTcError) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.message)));
          if (state.message == "kullanıcı bulunamadı") {
            Navigator.pushNamed(context, LoginPage.name);
          }
        }
      },
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: context.general.mediaSize.width,
            ),
            ValueListenableBuilder(
                valueListenable:
                    Hive.box<Bildirimci>(BildirimciCacheManager.instance.key)
                        .listenable(),
                builder: (context, Box<Bildirimci>? box, widget) {
                  List<String>? listBildirimciler =
                      box?.keys.toList().cast<String>();
                  return ValueListenableBuilder(
                      valueListenable:
                          Hive.box<MyUser>(UserCacheManager.instance.key)
                              .listenable(),
                      builder: (context, Box<MyUser>? box, widget) {
                        MyUser? user = box?.get(AppCacheManager.instance
                            .getItem(PreferencesKeys.phone.name));
                        return SettingsCardItem(
                          text: user == null
                              ? const Text("null user")
                              : Column(
                                  children: [
                                    Padding(
                                      padding: context.padding.verticalNormal,
                                      child: Text(
                                        buildFirstText(
                                            context, user, listBildirimciler),
                                        style: context
                                            .general.textTheme.titleLarge,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        Text(user.phoneNumber!),
                                        Text(user.subscriptionId ??
                                            "subscriptionId NULL"),
                                      ],
                                    ),
                                  ],
                                ),
                        );
                      });
                }),

            buildTcListBuilder(context),
            //  buildTcCard("10003272724"),
            buildAddTcButton(context),
            ValueListenableBuilder(
                valueListenable:
                    Hive.box<Bildirimci>(BildirimciCacheManager.instance.key)
                        .listenable(),
                builder: (context, Box<Bildirimci>? box, widget) {
                  List<String>? listBildirimciler =
                      box?.keys.toList().cast<String>();
                  return (!Navigator.canPop(context) &&
                          listBildirimciler != null &&
                          listBildirimciler.isNotEmpty)
                      ? Padding(
                          padding: context.padding.verticalNormal,
                          child: FloatingActionButton.extended(
                              backgroundColor: Colors.green,
                              onPressed: () async {
                                String? number = AppCacheManager.instance
                                    .getItem(PreferencesKeys.phone.name);
                                if (number == null) {
                                  Navigator.pushNamed(
                                          context, ManageTcPage.name)
                                      .then((value) {
                                    //   context.loaderOverlay.hide();
                                  });
                                } else {
                                  List<Bildirimci>? bildirimciList =
                                      BildirimciCacheManager.instance
                                          .getValues();
                                  if (bildirimciList != null &&
                                      bildirimciList.isNotEmpty) {
                                    Bildirimci bildirimci =
                                        bildirimciList.first;
                                    //bildirimci found
                                    ActiveTc.instance.activeTc =
                                        bildirimci.bildirimciTc!;

                                    HksUser user = HksUser(
                                        password: bildirimci.hksSifre!,
                                        userName: bildirimci.bildirimciTc!,
                                        webServicePassword:
                                            bildirimci.webServiceSifre!);
                                    GeneralService.instance
                                        .assignHksUserInfo(user);
                                    UrunService.instance
                                        .assignHksUserInfo(user);
                                    BildirimService.instance
                                        .assignHksUserInfo(user);

                                    await context
                                        .read<MainBildirimCubit>()
                                        .assignRightUser(
                                            bildirimci.bildirimciTc!, context);

                                    //context.read<BildirimCubit>().fetchDataAsSelectedTc(tc);
                                    //   context.read<HomeCubit>().refreshAllIndex();
                                    //  Navigator.pushNamed(context, HomePage.name);
                                    Navigator.pushNamedAndRemoveUntil(context,
                                        HomePage.name, (route) => false);
                                  } else {
                                    Navigator.pushNamedAndRemoveUntil(context,
                                        ManageTcPage.name, (route) => false);
                                    //bildirimci empty ise
                                  }
                                }
                              },
                              label: const Text("Ana Sayfa")),
                        )
                      : const SizedBox();
                }),

            //     buildSubButton(context),
            //    !TestApp.instance.isTest
            //        ? const SizedBox()
            //        : ElevatedButton(
            //            onPressed: () async {
            //              UserCacheManager.instance.clearAll();
            //              BildirimciCacheManager.instance.clearAll();
            //            },
            //            child: Text("aa"))
          ],
        );
      },
    );
  }

  String buildFirstText(
      BuildContext context, MyUser user, List<String>? bildirimicilerList) {
    bildirimicilerList ??= [];
    int subscriptionNumber = user.findSubscriptionNumber;

    if (bildirimicilerList.isEmpty) {
      return "Henüz Tc eklemediz.";
    } else if (bildirimicilerList.length == subscriptionNumber) {
      return "TC ekleme hakkınız bitmiştir!";
    } else if (bildirimicilerList.length < subscriptionNumber) {
      return "${subscriptionNumber - bildirimicilerList.length} adet Tc ekleme hakkınız kalmıştır.";
    } else {
      return "Hatalı işlem";
    }
  }

  Widget buildSubButton(BuildContext context) {
    return !TestApp.instance.isTest
        ? const SizedBox()
        : ElevatedButton(
            onPressed: () async {
              Navigator.pushNamed(context, SubscriptionsPage.name);
            },
            child: const Text("sub"));
  }

  Widget buildTcListBuilder(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable:
            Hive.box<Bildirimci>(BildirimciCacheManager.instance.key)
                .listenable(),
        builder: (context, Box<Bildirimci>? box, widget) {
          List<String>? tcs = box?.keys.toList().cast<String>();

          if (tcs != null) {
            return (!tcs.ext.isNotNullOrEmpty)
                ? Padding(
                    padding: context.padding.verticalNormal,
                    child: const Text(" Bildirimci Listesi Boş "),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: tcs.length,
                    itemBuilder: (context, index) {
                      return buildTcCard(context, tc: tcs[index]);
                    },
                  );
          } else {
            return const Text("Kullanıcı bulunamadı ");
          }
        });
  }

  SettingsCardItem buildTcCard(BuildContext context, {required String tc}) {
    return SettingsCardItem(
      ontap: () async {
        Bildirimci? bildirimci = BildirimciCacheManager.instance.getItem(tc);
        if (bildirimci != null) {
          context
              .read<UpdateUserInformationsCubit>()
              .setSelectedBildirimciTc(bildirimci);
          Navigator.pushNamed(context, UpdateUserInformationPage.name);
        } else {
          ScaffoldMessengerHelper.instance
              .showErrorSnackBar(context, "Bildirimci Tc Bulunamadı");
        }
      },
      prefix: const Icon(Icons.person),
      text: Text(
        tc,
        style: context.general.textTheme.titleLarge,
      ),
      suffix: const Icon(Icons.arrow_forward),
    );
  }

  Widget buildAddTcButton(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable:
          Hive.box<MyUser>(UserCacheManager.instance.key).listenable(),
      builder: (context, Box<MyUser>? box, widget) {
        MyUser? user = box
            ?.get(AppCacheManager.instance.getItem(PreferencesKeys.phone.name));
        if (user != null) {
          return InkWell(
            onTap: () {
              //TODO: SUBSCRIPTION NUMBERI DB YE ORDAN ÇEK CONTEXT TEN OLMUYO
              List<String> keys =
                  BildirimciCacheManager.instance.getkeys() ?? [];
              print(keys);
              print(user.findSubscriptionNumber);
              print(user.subscriptionNumber);
              print(user);
              // user.tcList!
              if (((user.findSubscriptionNumber) - (keys.length)) > 0) {
                context.read<ManageTcCubit>().addTc(context);
              } else {
                showUpgradePopupMessage(context);
              }
            },
            borderRadius: BorderRadius.circular(50),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: InkWell(
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Material(
                    elevation: 10,
                    borderRadius: BorderRadius.circular(50),
                    child: Padding(
                      padding: context.padding.horizontalNormal,
                      child: const SizedBox(
                        //  color: Colors.red,
                        width: 75,
                        height: 75,
                        //  color: Colors.red,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Bildirimci Ekle",
                                style: TextStyle(fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center),
                            Icon(Icons.add),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        } else {
          return const Text("null user a tc ekleme yapılamaz");
        }
      },
    );
  }

  showUpgradePopupMessage(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Tc ekleme hakkınız bitmiştir!",
                textAlign: TextAlign.center),
            content: const Text(
                "Tc ekleyebilmek için üyeliğinizi yükselmeniz gerekmetedir.\n\n Üyelik yükseltme sayfasına gitmek ister misiniz?",
                textAlign: TextAlign.center),
            actions: [
              TextButton(
                child: const Text('Hayır'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Evet'),
                onPressed: () {
                  Navigator.pushNamed(context, SubscriptionsPage.name);
                  //SystemNavigator.pop();
                },
              ),
            ],
          );
        });
  }
}
