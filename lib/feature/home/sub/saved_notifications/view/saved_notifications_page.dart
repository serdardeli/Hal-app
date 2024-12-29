import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hal_app/core/utils/dropdown2_style/dropdown2_style.dart';
import 'package:hal_app/feature/home/sub/bildirim_page/sub/komisyoncu_bildirim_page/viewmodel/cubit/komisyoncu_cubit.dart';
import 'package:hal_app/feature/home/sub/bildirim_page/sub/satin_alim_sanayici_page/viewmodel/cubit/sanayici_satin_alim_cubit.dart';
import 'package:hal_app/feature/home/sub/bildirim_page/sub/ureticiden_sevk_alim/viewmodel/cubit/ureticiden_sevk_alim_cubit.dart';

import 'package:turkish/turkish.dart';

import '../../../../../project/utils/widgets/build_text_form_field_with_animation.dart';
import '../../bildirim_page/main_bildirim_page/view/main_bildirim_page.dart';

import '../../bildirim_page/sub/sat%C4%B1n_al%C4%B1m_page/viewmodel/cubit/satin_alim_cubit.dart';
import '../../bildirim_page/sub/tuccar_hal_ici_disi/viewmodel/cubit/tuccar_hal_ici_disi_main_cubit.dart';
import '../viewmodel/cubit/saved_notification_page_general_cubit.dart';
import '../viewmodel/cubit/saved_notifications_cubit.dart';
import '../../../../../project/cache/bildirimci_cache_manager.dart';
import '../../../../../project/model/bildirim/bildirim_model.dart';
import '../../../../../project/model/bildirimci/bildirimci_model.dart';
import '../../../../../project/model/custom_notification_save_model.dart/custom_notification_save_model.dart';
import '../../../../../project/model/referans_kunye/referans_kunye_model.dart';
import '../../../../../project/model/uretici_model/uretici_model.dart';
import '../../../../../project/model/urun/urun.dart';

import '../../../../../core/utils/widget/expandable_card.dart';
import '../../../../../project/cache/bildirim_list_cache_manager_new.dart';
import '../../../../../project/utils/widgets/expanded_card_secondary_content.dart';
import '../../../../helper/active_tc.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:kartal/kartal.dart';
import '../../../viewmodel/cubit/home_cubit.dart';
import '../../resent_notifications/view/resent_notifications_page.dart';

class SavedNotificationsPage extends StatelessWidget {
  static const String name = "SavedNotificationPage";
  static const int index = 0;
  final List<CustomNotificationSaveModel> searchresult = [];

  final String selectedTc = ActiveTc.instance.activeTc;
  final ScrollController scrollController = ScrollController();

  SavedNotificationsPage({super.key});

  Padding buildBildirLogo(BuildContext context) {
    return Padding(
      padding: context.padding.verticalLow * .5,
      child: Image.asset(
        "asset/app_logo/logo_three.jpeg",
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Map<String, Map<String, String>> newMap = {};

    List<ReferansKunye> listKunye = [];
//TabController tabController=TabController(length: null, vsync: null);
    return SafeArea(
      child: DefaultTabController(
        initialIndex: 0,
        length: 2,
        child: BlocBuilder<SavedNotificationsCubit, SavedNotificationsState>(
          builder: (context, state) {
            return Container(
              child: Scaffold(
                backgroundColor: Colors.transparent,
                appBar: AppBar(
                  backgroundColor: Colors.white,
                  leading: const SizedBox(),
                  flexibleSpace: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TabBar(
                        labelColor: Colors.black,
                        indicatorColor: Colors.black,
                        tabs: [
                          Tab(
                              child: Text("SIK YAPILAN",
                                  style: context.general.textTheme.bodyLarge
                                      ?.copyWith(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold))),
                          Tab(
                              child: Text("SON YAPILAN",
                                  style: context.general.textTheme.bodyLarge
                                      ?.copyWith(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold))),
                        ],
                      ),
                    ],
                  ),
                ),
                body: TabBarView(
                  children: <Widget>[
                    buildSikKullanilanlarTabbar(context),
                    const ResentNotificationsPage(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  BlocBuilder buildMalinAdiField2(BuildContext context) {
    return BlocBuilder<SatinAlimCubit, SatinAlimState>(
      builder: (context, state) {
        return DropdownButtonHideUnderline(
          child: DropdownButton2<String>(
            isExpanded: true,
            dropdownStyleData: DropDown2Style.dropdownStyleData(context),
            buttonStyleData: DropDown2Style.buttonStyleData(context),

            dropdownSearchData: DropdownSearchData(
              searchController:
                  context.read<SatinAlimCubit>().malinAdiController,
              searchMatchFn: (item, searchValue) {
                return (item.value
                    .toString()
                    .toLowerCaseTr()
                    .contains(searchValue.toLowerCaseTr()));
              },
            ),
            hint: Text('Ürün Seç',
                style: TextStyle(
                    fontSize: 14, color: Theme.of(context).hintColor)),
            items: context
                .read<SavedNotificationsCubit>()
                .a
                .keys
                .map((item) => DropdownMenuItem<String>(
                      value: item,
                      child: Text(
                        item,
                        style: const TextStyle(
                            fontSize: 14, overflow: TextOverflow.ellipsis),
                      ),
                    ))
                .toList(),
            value: context.read<SatinAlimCubit>().selectedMalinAdi,
            onChanged: (value) {
              context.read<SatinAlimCubit>().malinAdiSelected(value as String);
            },

            underline: Padding(
              padding: const EdgeInsets.only(
                top: 8,
                bottom: 4,
                right: 8,
                left: 8,
              ),
              child: TextFormField(
                controller: context.read<SatinAlimCubit>().malinAdiController,
                autofocus: true,
                decoration: InputDecoration(
                  // isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  hintText: 'Ürün Ara',
                  hintStyle: const TextStyle(fontSize: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),

            //This to clear the search value when you close the menu
            onMenuStateChange: (isOpen) {
              if (!isOpen) {
                context.read<SatinAlimCubit>().malinAdiController.clear();
              }
            },
          ),
        );
      },
    );
  }

  Padding buildSikKullanilanlarTabbar(BuildContext context) {
    return Padding(
      padding: context.padding.horizontalLow,
      child: SafeArea(
        child: Column(
          children: [
            SizedBox(
              width: context.general.mediaSize.width,
            ),
            Padding(
              padding: context.padding.verticalLow,
              child: Text(
                "Bildirimler",
                style: context.general.textTheme.titleLarge!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            //   buildMalinAdiField2(context),
            BlocBuilder<SavedNotificationPageGeneralCubit,
                SavedNotificationPageGeneralState>(builder: (context, state) {
              return buildTextFormFieldWithAnimation(
                context,
                controller: context
                    .read<SavedNotificationPageGeneralCubit>()
                    .searchTextEditingController,
                focusNode: context
                    .watch<SavedNotificationPageGeneralCubit>()
                    .myFocusNode,
                isSearchOpen: context
                    .watch<SavedNotificationPageGeneralCubit>()
                    .isSearchOpen,
                onChanged: () {
                  context.read<SavedNotificationsCubit>().emitInitial();
                },
              );
            }),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: Hive.box<List<dynamic>>(
                        CustomNotificationSaveCacheManager.instance.key)
                    .listenable(),
                builder: (BuildContext context, value, Widget? child) {
                  List<CustomNotificationSaveModel> list =
                      CustomNotificationSaveCacheManager.instance
                          .getItem(ActiveTc.instance.activeTc);
                  if (list.ext.isNotNullOrEmpty) {
                    list = listToShowTransactions(list, context);

                    return ListView.builder(
                        controller: scrollController,
                        physics: const BouncingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics()),
                        shrinkWrap: true,
                        itemCount: list.length,
                        itemBuilder: ((context, index) {
                          Uretici? uretici2;
                          if (list[index].isToplama) {
                          } else {
                            uretici2 = Uretici.fromJson(
                                Map<String, dynamic>.from(
                                    list[index].uretici!));
                          }

                          List<Urun> urunList = [];
                          for (var element in list[index].urunList) {
                            urunList.add(Urun.fromJson(
                                Map<String, dynamic>.from(element)));
                          }

                          return buildExpandedCard(
                              context, urunList, uretici2, list[index]);
                        }));
                  } else {
                    return const Text("Henuz bildirim yapmadınız ");
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  List<CustomNotificationSaveModel> listToShowTransactions(
      List<CustomNotificationSaveModel> coinListToShow, BuildContext context) {
    coinListToShow = searchTransaction(context, coinListToShow);

    return coinListToShow;
  }

  List<CustomNotificationSaveModel> searchTransaction(
      BuildContext context, List<CustomNotificationSaveModel> coinListToShow) {
    if (context.read<SavedNotificationPageGeneralCubit>().isSearchOpen &&
        context
                .read<SavedNotificationPageGeneralCubit>()
                .searchTextEditingController
                .text !=
            "") {
      coinListToShow = searchResult(coinListToShow, context);
    }
    return coinListToShow;
  }

  List<CustomNotificationSaveModel> searchResult(
      List<CustomNotificationSaveModel> list, BuildContext context) {
    searchresult.clear();

    for (int i = 0; i < list.length; i++) {
      String data =
          (list[i].uretici != null ? list[i].uretici!["ureticiAdiSoyadi"] : "");
      if (data.toLowerCaseTr().contains(context
          .read<SavedNotificationPageGeneralCubit>()
          .searchTextEditingController
          .text
          .toLowerCase())) {
        searchresult.add(list[i]);
      }
    }
    return searchresult;
  }

  ExpansionCard buildExpandedCard(BuildContext context, List<Urun> urunList,
      Uretici? uretici, CustomNotificationSaveModel model) {
    return ExpansionCard(
      secondOnTap: () {
        context
            .read<HomeCubit>()
            .pageController
            .jumpToPage(MainBildirimPage.index);

        //  context.read<HomeCubit>().currentIndex =
        //      MainBildirimPage.index; //TODO:

        Bildirimci? bildirimci =
            BildirimciCacheManager.instance.getItem(ActiveTc.instance.activeTc);
        //TODO : BUNU SOR BİR KİŞİ KOMİSYONCU VE HAL İÇİ TÜCCAR OLABİLİR Mİ
        // BİRLİKTE OLANBİLEN SİFATLAR NEDİR
        // BAŞKA BİR TC KAYIT OLMAK İSTERSE BİZ NE CEVAP VERECEĞİZ

        if (model.selectedSifatId != null) {
          if (model.selectedSifatId == "5") {
            context
                .read<UreticidenSevkAlimCubit>()
                .fillWithOutSideDataCustom(model);

            context.read<KomisyoncuCubit>().bildirimRepeat();
          } else if (model.selectedSifatId == "1") {
            context
                .read<SanayiciSatinAlimCubit>()
                .fillWithOutSideDataCustom(model);

            context.read<KomisyoncuCubit>().bildirimRepeat();
          } else if (model.selectedSifatId == "20" ||
              model.selectedSifatId == "6") {
            context
                .read<TuccarHalIciDisiMainCubit>()
                .changeBildirimTypeFromOutSide();
            context.read<TuccarHalIciDisiMainCubit>().selectedSifatType =
                model.selectedSifatType;

            context.read<TuccarHalIciDisiMainCubit>().sifatTypeSelected();

            context
                .read<SatinAlimCubit>()
                .fillWithOutSideDataCustom(model, context);
          } else {
            context
                .read<SatinAlimCubit>()
                .fillWithOutSideDataCustom(model, context);
          }
        } else {
          if (bildirimci != null) {
            if (bildirimci.kayitliKisiSifatIdList!.contains("5")) {
              context.read<KomisyoncuCubit>().bildirimRepeat();

              context
                  .read<UreticidenSevkAlimCubit>()
                  .fillWithOutSideDataCustom(model);
            } else if (bildirimci.kayitliKisiSifatIdList!.contains("6") ||
                bildirimci.kayitliKisiSifatIdList!.contains("20")) {
              context
                  .read<TuccarHalIciDisiMainCubit>()
                  .changeBildirimTypeFromOutSide();
              context.read<TuccarHalIciDisiMainCubit>().selectedSifatType =
                  model.selectedSifatType;

              context.read<TuccarHalIciDisiMainCubit>().sifatTypeSelected();

              context
                  .read<SatinAlimCubit>()
                  .fillWithOutSideDataCustom(model, context);
            } else {
              context
                  .read<SatinAlimCubit>()
                  .fillWithOutSideDataCustom(model, context);
            }
          } else {}
        }
      },
      title: buildExpandedCardMainContent(urunList, context, uretici, model),
      children: buildExpandedCardSecondaryContent(urunList, context),
    );
  }

  generateCardChildText(Urun urun, BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              overflow: TextOverflow.clip,
              textAlign: TextAlign.start,
              softWrap: true,
              maxLines: 1,
              text: TextSpan(
                style: context.general.textTheme.bodyLarge,
                children: <TextSpan>[
                  const TextSpan(
                      text: 'Urun: ',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: urun.urunAdi),
                ],
              ),
              textScaler: const TextScaler.linear(1),
            ),
            RichText(
              overflow: TextOverflow.clip,
              textAlign: TextAlign.start,
              softWrap: true,
              maxLines: 1,
              text: TextSpan(
                style: context.general.textTheme.bodyLarge,
                children: <TextSpan>[
                  const TextSpan(
                      text: 'Cinsi: ',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: urun.urunCinsi),
                ],
              ),
              textScaler: const TextScaler.linear(1),
            ),
          ],
        ),
        Padding(
          padding: context.padding.horizontalLow,
          child: RichText(
            overflow: TextOverflow.clip,
            textAlign: TextAlign.start,
            softWrap: true,
            maxLines: 1,
            text: TextSpan(
              style: context.general.textTheme.bodyLarge,
              children: <TextSpan>[
                const TextSpan(
                    text: 'Miktar: ',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: "${urun.urunMiktari} ${urun.urunBirimAdi}"),
              ],
            ),
            textScaler: const TextScaler.linear(1),
          ),
        ),
      ],
    );
  }

  List<Widget> buildExpandedCardSecondaryContent(
          List<Urun> urunList, BuildContext context) =>
      [
        ExpandedCardContentSecondaryItem(
            text: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...urunList
                .map((e) => Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${urunList.indexOf(e) + 1}. ",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        generateCardChildText(e, context)
                      ],
                    ))
                .toList()
            // Text(urunList.first.urunAdi),
          ],
        )),
      ];

  Widget buildExpandedCardMainContent(List<Urun> urunList, BuildContext context,
      Uretici? uretici, CustomNotificationSaveModel model) {
    return Flexible(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            uretici == null ? "Toplama Mal" : (uretici.ureticiAdiSoyadi),
            style:
                context.general.textTheme.bodyLarge?.apply(color: Colors.green),
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            urunList.first.urunAdi,
            style: context.general.textTheme.bodySmall,
          ),
          /* Text(
            (model.totalAddedCount ?? 0).toString(),
            style: context.general.textTheme.bodySmall,
          ),
          Text(
            (model.kunyeNo ?? "boş").toString(),
            style: context.general.textTheme.bodySmall,
          ),*/
        ],
      ),
    );
  }

  Padding elementsWithListTile(
      BuildContext context, Bildirim bildirim, Uretici? uretici) {
    return Padding(
      padding: context.padding.verticalLow,
      child: Material(
        elevation: 10,
        borderRadius: BorderRadius.circular(10),
        child: ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text((bildirim.malAdi ?? "null")),
                Text((bildirim.bildirimAdi ?? "null")),
              ],
            ),
            subtitle: Text(
              uretici == null
                  ? "Toplama mal"
                  : uretici == null
                      ? "Toplama Mal"
                      : (uretici.ureticiAdiSoyadi),
              style: context.general.textTheme.bodySmall,
            ),
            trailing: const Icon(Icons.arrow_forward_ios_rounded)),
      ),
    );
  }
}
