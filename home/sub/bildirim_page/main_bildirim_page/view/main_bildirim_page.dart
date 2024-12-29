import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hal_app/feature/home/sub/bildirim_page/sub/satin_alim_sanayici_page/viewmodel/cubit/sanayici_satin_alim_cubit.dart';
import 'package:hal_app/feature/home/sub/bildirim_page/sub/ureticiden_sevk_alim/viewmodel/cubit/ureticiden_sevk_alim_cubit.dart';
import '../../../../../../core/enum/sifat_names_enum.dart';
import '../../../../../../core/enum/sifat_types_enum.dart';
import '../../sub/komisyoncu_bildirim_page/view/komsiyoncu_bildirim_page.dart';
import '../../sub/sanayici_main_page/view/sanayici_main_page.dart';
import '../viewmodel/cubit/main_bildirim_cubit.dart';
import 'package:kartal/kartal.dart';

import '../../../../../../project/cache/bildirimci_cache_manager.dart';
import '../../../../../../project/model/bildirimci/bildirimci_model.dart';
import '../../../../../helper/active_tc.dart';
import '../../sub/satın_alım_page/viewmodel/cubit/satin_alim_cubit.dart';
import '../../sub/tuccar_hal_ici_disi/view/tuccar_hal_ici_disi_main.dart';

class MainBildirimPage extends StatelessWidget {
  const MainBildirimPage({Key? key}) : super(key: key);
  static const int index = 1;
  IconButton clearBildirimPageIcon(BuildContext context) => IconButton(
      onPressed: () {
        Bildirimci? bildirimci =
            BildirimciCacheManager.instance.getItem(ActiveTc.instance.activeTc);
        //TODO : BUNU SOR BİR KİŞİ KOMİSYONCU VE HAL İÇİ TÜCCAR OLABİLİR Mİ
        // BİRLİKTE OLANBİLEN SİFATLAR NEDİR
        // BAŞKA BİR TC KAYIT OLMAK İSTERSE BİZ NE CEVAP VERECEĞİZ

        if (bildirimci != null) {
          if (bildirimci.kayitliKisiSifatIdList!.contains("5")) {
            context.read<UreticidenSevkAlimCubit>().clearAllPageInfo();
          } else if (bildirimci.kayitliKisiSifatIdList!.contains("6") ||
              bildirimci.kayitliKisiSifatIdList!.contains("20")) {
            context.read<SatinAlimCubit>().clearAllPageInfo();
          } else if (bildirimci.kayitliKisiSifatIdList!.contains("1")) {
            context.read<SanayiciSatinAlimCubit>().clearAllPageInfo();
          } else {
            context.read<SanayiciSatinAlimCubit>().clearAllPageInfo();

            context.read<SatinAlimCubit>().clearAllPageInfo();
          }
        } else {}
        context.read<SatinAlimCubit>().clearAllPageInfo();
      },
      icon: const Icon(Icons.delete_outline_rounded));
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: BlocConsumer<MainBildirimCubit, MainBildirimState>(
          listener: (context, state) {
            // TODO: implement listener
          },
          builder: (context, state) {
            if (state is MainBildirimSuccess) {
              if ((state).type == SifatTypes.single &&
                  (state).activeSifat == SifatNames.komisyoncu) {
                return const KomisyoncuPage();
              } else if ((state).type == SifatTypes.single &&
                  ((state).activeSifat == SifatNames.tuccarHalDisi ||
                      (state).activeSifat == SifatNames.tuccarHalIci)) {
                return const TuccarHalIciDisiMain();
              } else if ((state).type == SifatTypes.single &&
                  ((state).activeSifat == SifatNames.sanayici)) {
                return const SanayiciMainPage();
              }
            } else if (state is MainBildirimError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("error ${state.message}"),
                    ElevatedButton(
                        onPressed: () {
                          print(context
                              .read<MainBildirimCubit>()
                              .selectedSifatForMain);
                        },
                        child: const Text("sıfatları al"))
                  ],
                ),
              );
            } else {
              return Scaffold(
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("henüz istediğiniz sifat tanımlanamadı"),
                      ElevatedButton(
                          onPressed: () {
                            //TODO: NEW BURASI NE DÜZELT
                            //   context
                            //       .read<MainBildirimCubit>()
                            //       .printUserSifatlari();
                          },
                          child: const Text("sifatyları al"))
                    ],
                  ),
                ),
              );
            }
            return const Scaffold(
              body: Center(
                child: Text("Kullanıcı Sıfat hatası"),
              ),
            );
          },
        ),
      ),
    );
  }

  Padding buildBildirLogo(BuildContext context) {
    return Padding(
      padding: context.padding.verticalLow * .5,
      child: Image.asset(
        "asset/app_logo/logo_three.jpeg",
      ),
    );
  }
}
