import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:hal_app/core/utils/dropdown2_style/dropdown2_style.dart';
import 'package:hal_app/feature/home/sub/add_profile/viewmodel/cubit/add_profile_page_general_cubit.dart';
import 'package:hal_app/feature/home/sub/bildirim_page/sub/satis_page/viewmodel/cubit/satis_cubit.dart';
import 'package:hal_app/feature/home/sub/bildirim_page/sub/sevk_etme_page/viewmodel/cubit/sevk_etme_cubit.dart';
import 'package:hal_app/feature/home/sub/bildirim_page/sub/tuccar_hal_ici_disi/viewmodel/cubit/tuccar_hal_ici_disi_main_cubit.dart';
import 'package:hal_app/project/service/firebase/log/firebase_log.dart';
import 'package:network_logger/network_logger.dart';
import '../sub/bildirim_page/sub/sat%C4%B1n_al%C4%B1m_page/viewmodel/cubit/satin_alim_cubit.dart';
import '../sub/bildirim_page/sub/satin_alim_sanayici_page/viewmodel/cubit/sanayici_satin_alim_cubit.dart';
import '../sub/bildirim_page/sub/sevk_etme_for_komisyoncu_page/viewmodel/cubit/sevk_etme_for_komisyoncu_cubit.dart';
import '../sub/bildirim_page/sub/ureticiden_sevk_alim/viewmodel/cubit/ureticiden_sevk_alim_cubit.dart';
import '../sub/remove_saved_notification/view/remove_saved_notification.dart';
import '../sub/resent_notifications/viewmodel/cubit/recent_notifications_cubit.dart';
import '../sub/saved_notifications/viewmodel/cubit/saved_notification_page_general_cubit.dart';
import '../sub/saved_notifications/viewmodel/cubit/saved_notifications_cubit.dart';
import '../viewmodel/cubit/home_cubit.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:kartal/kartal.dart';
import 'package:line_icons/line_icons.dart';

import '../sub/bildirim_page/main_bildirim_page/view/main_bildirim_page.dart';

import '../../../project/cache/bildirimci_cache_manager.dart';
import '../../../project/model/bildirimci/bildirimci_model.dart';
import '../../../project/model/hks_user/hks_user.dart';
import '../../../project/service/hal/bildirim_service.dart';
import '../../../project/service/hal/genel_service.dart';
import '../../../project/service/hal/urun_service.dart';
import '../../helper/active_tc.dart';
import '../../settings/view/settings_page.dart';
import '../sub/add_profile/view/add_profile_page.dart';

import '../sub/add_profile/viewmodel/cubit/add_profile_cubit.dart';
import '../sub/bildirim_page/main_bildirim_page/viewmodel/cubit/main_bildirim_cubit.dart';
import '../sub/saved_notifications/view/saved_notifications_page.dart';

// ignore: use_key_in_widget_constructors
class HomePage extends StatefulWidget {
  static const String name = "home";

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String selectedTc = ActiveTc.instance.activeTc;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (kDebugMode) {
      NetworkLoggerOverlay.attachTo(context, right: 200, bottom: 100);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        //     Navigator.pop(context);
        //  context.read<HomeCubit>().pageController.dispose();

        //context.read<HomeCubit>().currentIndex = 0;

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
      },
      child: Scaffold(
          //  resizeToAvoidBottomInset: false,
          // floatingActionButton: FloatingActionButton(
          //   onPressed: () {
          //     FirestoreLogService().logBildirim();
          //   },
          //   child: const Icon(Icons.add),
          // ),
          appBar: CupertinoNavigationBar(
              leading: BlocBuilder<HomeCubit, HomeState>(
                builder: (context, state) {
                  return context.read<HomeCubit>().currentIndex == 0
                      ? IconButton(
                          onPressed: () {
                            Navigator.pushNamed(
                                context, RemoveNotificationPage.name);
                          },
                          icon: const Icon(Icons.delete_outline_outlined))
                      : const SizedBox();
                },
              ),
              backgroundColor: Colors.white,
              trailing: clearBildirimPageIcon(context),
              middle: Material(child: buildChooseTcDropDown(context))),
          body: PageView(
            controller: context.read<HomeCubit>().pageController,
            onPageChanged: (index) {
              context.read<HomeCubit>().currentIndex = index;
            },
            children: <Widget>[
              SavedNotificationsPage(),
              const MainBildirimPage(),
              AddProfilePage(),
              //  ResentNotificationsPage(),
              const SettingsPage()
            ],
          ),
          bottomNavigationBar: buildGNavBar(context)),
    );
  }

  Padding buildBildirLogo(BuildContext context) => Padding(
        padding: context.padding.verticalLow * 0,
        child: Image.asset(
          //
          "asset/app_logo/app_logo_trial5.jpeg",
        ),
      );

  Widget clearBildirimPageIcon(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (context.read<HomeCubit>().currentIndex == 1) {
          return IconButton(
              onPressed: () {
                context.read<SevkEtmeCubit>().clearAllPageInfo();
                context.read<SevkEtmeForKomisyoncuCubit>().clearAllPageInfo();
                context.read<UreticidenSevkAlimCubit>().clearAllPageInfo();

                context.read<SatisCubit>().clearAllPageInfo();

                context.read<SatinAlimCubit>().clearAllPageInfo();
                context.read<SanayiciSatinAlimCubit>().clearAllPageInfo();
              },
              icon: const Icon(Icons.delete_outline_rounded));
        } else if (context.read<HomeCubit>().currentIndex == 0) {
          return buildOpenSearchFieldIconSavedNotificationTab(context);
        } else if (context.read<HomeCubit>().currentIndex == 2) {
          return buildOpenSearchFieldIconAddProfileTab(context);
        } else {
          return const SizedBox();
        }
      },
    );
  }

  IconButton buildOpenSearchFieldIconSavedNotificationTab(
      BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.search),
      onPressed: () async {
        context
            .read<SavedNotificationPageGeneralCubit>()
            .changeIsSearch(context);

        if (context.read<SavedNotificationPageGeneralCubit>().isSearchOpen ==
            false) {
          context
              .read<SavedNotificationPageGeneralCubit>()
              .searchTextEditingController
              .clear();
        }
      },
    );
  }

  IconButton buildOpenSearchFieldIconAddProfileTab(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.search),
      onPressed: () async {
        context.read<AddProfilePageGeneralCubit>().changeIsSearch(context);

        if (context.read<AddProfilePageGeneralCubit>().isSearchOpen == false) {
          context
              .read<AddProfilePageGeneralCubit>()
              .searchTextEditingController
              .clear();
        }
      },
    );
  }

  Widget buildChooseTcDropDown(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable:
            Hive.box<Bildirimci>(BildirimciCacheManager.instance.key)
                .listenable(),
        builder: (context, Box<Bildirimci>? box, children) {
          List<String>? bildirimciTcList = box?.keys.toList().cast<String>();
          if (bildirimciTcList == null || bildirimciTcList.isEmpty) {
            return Text(
              "Bildirimci Ekleyiniz",
              style: context.general.textTheme.titleLarge,
            );
          }
          if (bildirimciTcList.length == 1) {
            return buildBildirLogo(context);
          }
          return BlocBuilder<MainBildirimCubit, MainBildirimState>(
            builder: (context, state) {
              return DropdownButtonHideUnderline(
                child: DropdownButton2(
                  dropdownStyleData: DropDown2Style.dropdownStyleData(context),
                  buttonStyleData: DropDown2Style.buttonStyleData(context,
                      width: 160,
                      height: 35,
                      padding: context.padding.horizontalLow),
                  hint: Text('Tc Seç',
                      style: TextStyle(
                          fontSize: 16, color: Theme.of(context).hintColor)),
                  items: bildirimciTcList
                      .map((item) => DropdownMenuItem<String>(
                            value: item,
                            child: Text(
                              item,
                              style: context.general.textTheme.titleMedium,
                            ),
                          ))
                      .toList(),
                  value: ActiveTc.instance.activeTc,
                  onChanged: (value) async {
                    ActiveTc.instance.activeTc = value as String;
                    var bildirimci =
                        BildirimciCacheManager.instance.getItem(value);
                    HksUser user = HksUser(
                        password: bildirimci!.hksSifre!,
                        userName: bildirimci.bildirimciTc!,
                        webServicePassword: bildirimci.webServiceSifre!);
                    GeneralService.instance.assignHksUserInfo(user);
                    UrunService.instance.assignHksUserInfo(user);
                    BildirimService.instance.assignHksUserInfo(user);
                    await context
                        .read<MainBildirimCubit>()
                        .assignRightUser(value, context);
                    context.read<SevkEtmeCubit>().clearAllPageInfo();
                    context.read<SanayiciSatinAlimCubit>().clearAllPageInfo();

                    context
                        .read<SevkEtmeForKomisyoncuCubit>()
                        .clearAllPageInfo();

                    context.read<UreticidenSevkAlimCubit>().clearAllPageInfo();

                    context.read<SatisCubit>().clearAllPageInfo();

                    context.read<SatinAlimCubit>().clearAllPageInfo();
                    context.read<SatinAlimCubit>().emitInitial();

                    context.read<SavedNotificationsCubit>().emitInitial();
                    context.read<RecentNotificationsCubit>().emitInitial();

                    context.read<AddProfileCubit>().emitInitialState();

                    context.read<TuccarHalIciDisiMainCubit>().customInit();
                  },
                ),
              );
            },
          );
        });
  }

  BlocBuilder buildGNavBar(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                blurRadius: 20,
                color: Colors.black.withOpacity(.1),
              )
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: SafeArea(
              child: GNav(
                rippleColor: Colors.grey[300]!,
                hoverColor: Colors.grey[100]!,
                gap: 8,
                activeColor: Colors.white,
                iconSize: 24,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                duration: const Duration(milliseconds: 400),
                tabBackgroundColor: Colors.grey[100]!,
                color: Colors.green[700],
                tabs: const [
                  GButton(
                    icon: LineIcons.home,
                    backgroundColor: Colors.green,
                    text: 'Home',
                    textStyle: TextStyle(color: Colors.white),
                  ),
                  GButton(
                    icon: Icons.notification_add_outlined,
                    backgroundColor: Colors.green,
                    text: 'Bildir',
                    textStyle: TextStyle(color: Colors.white),
                  ),
                  GButton(
                    icon: LineIcons.userPlus,
                    backgroundColor: Colors.green,
                    text: 'Üretici',
                    textStyle: TextStyle(color: Colors.white),
                  ),
                  //  GButton(
                  //    icon: LineIcons.user,
                  //    text: 'Son',
                  //  ),
                  GButton(
                    icon: Icons.settings_outlined,
                    backgroundColor: Colors.green,
                    text: 'Ayarlar',
                    textStyle: TextStyle(color: Colors.white),
                  ),
                ],
                selectedIndex: context.read<HomeCubit>().currentIndex,
                onTabChange: (index) {
                  //    context.read<HomeCubit>().currentIndex = index;
                  // _pageController.animateToPage(
                  //   index,
                  //   curve: Curves.ease,
                  //   duration: Duration(milliseconds: 400),
                  // );
                  //TODO : BUNA KARAR VER BİR DE SET STATELERDEN KURTULUP DENE BELKİ OZAMAN DÜZELİR

                  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                    context.read<HomeCubit>().pageController.jumpToPage(index);
                  });
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
