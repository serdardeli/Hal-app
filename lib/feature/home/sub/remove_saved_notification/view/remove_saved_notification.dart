import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kartal/kartal.dart';

import '../../../../../core/utils/widget/expandable_card.dart';
import '../../../../../core/utils/widget/expandable_remove_card.dart';
import '../../../../../project/cache/bildirim_list_cache_manager_new.dart';
import '../../../../../project/cache/bildirimci_cache_manager.dart';
import '../../../../../project/model/bildirimci/bildirimci_model.dart';
import '../../../../../project/model/custom_notification_save_model.dart/custom_notification_save_model.dart';
import '../../../../../project/model/uretici_model/uretici_model.dart';
import '../../../../../project/model/urun/urun.dart';
import '../../../../../project/utils/widgets/expanded_card_secondary_content.dart';
import '../../../../helper/active_tc.dart';
import '../../../viewmodel/cubit/home_cubit.dart';
import '../../bildirim_page/main_bildirim_page/view/main_bildirim_page.dart';
import '../../bildirim_page/sub/komisyoncu_bildirim_page/viewmodel/cubit/komisyoncu_cubit.dart';
import '../../bildirim_page/sub/satin_alim_sanayici_page/viewmodel/cubit/sanayici_satin_alim_cubit.dart';
import '../../bildirim_page/sub/satın_alım_page/viewmodel/cubit/satin_alim_cubit.dart';
import '../../bildirim_page/sub/tuccar_hal_ici_disi/viewmodel/cubit/tuccar_hal_ici_disi_main_cubit.dart';
import '../../bildirim_page/sub/ureticiden_sevk_alim/viewmodel/cubit/ureticiden_sevk_alim_cubit.dart';

class RemoveNotificationPage extends StatelessWidget {
  static const String name = "removeSavedNotificationPage";
  RemoveNotificationPage({super.key});
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CupertinoNavigationBar(
        middle: Text("Bildirimleri Sil"),
      ),
      body: Padding(
        padding: context.padding.horizontalLow,
        child: Column(
          children: [
            Padding(
              padding: context.padding.verticalLow,
              child: ElevatedButton(
                  onPressed: () async {
                    await CustomNotificationSaveCacheManager.instance
                        .removeAllList(ActiveTc.instance.activeTc);
                    Navigator.pop(context);
                  },
                  child: const Text("Tümünü Sil")),
            ),
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

                    // list = listToShowTransactions(list, context);

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
                              context, urunList, uretici2, list[index], index);
                        }));
                  } else {
                    return const Center(
                        child: Text(
                      "Henuz bildirim yapmadınız ",
                    ));
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  ExpansionRemoveCard buildExpandedCard(
      BuildContext context,
      List<Urun> urunList,
      Uretici? uretici,
      CustomNotificationSaveModel model,
      int index) {
    return ExpansionRemoveCard(
      removeFunc: () async {
        await CustomNotificationSaveCacheManager.instance
            .removeItem(ActiveTc.instance.activeTc, index);
      },
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
          } else {



          }

        }


      },
      title: buildExpandedCardMainContent(urunList, context, uretici, model),
      children: buildExpandedCardSecondaryContent(urunList, context),
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
            style: context.general.textTheme.bodyLarge?.apply(color: Colors.green),
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
              textScaleFactor: 1,
              text: TextSpan(
                style: context.general.textTheme.bodyLarge,
                children: <TextSpan>[
                  const TextSpan(
                      text: 'Urun: ',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: urun.urunAdi),
                ],
              ),
            ),
            RichText(
              overflow: TextOverflow.clip,
              textAlign: TextAlign.start,
              softWrap: true,
              maxLines: 1,
              textScaleFactor: 1,
              text: TextSpan(
                style: context.general.textTheme.bodyLarge,
                children: <TextSpan>[
                  const TextSpan(
                      text: 'Cinsi: ',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: urun.urunCinsi),
                ],
              ),
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
            textScaleFactor: 1,
            text: TextSpan(
              style: context.general.textTheme.bodyLarge,
              children: <TextSpan>[
                const TextSpan(
                    text: 'Miktar: ',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: "${urun.urunMiktari} ${urun.urunBirimAdi}"),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
