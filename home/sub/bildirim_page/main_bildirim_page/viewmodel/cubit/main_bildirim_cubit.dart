import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hal_app/feature/home/sub/bildirim_page/sub/ureticiden_sevk_alim/viewmodel/cubit/ureticiden_sevk_alim_cubit.dart';
import '../../../../../../../core/enum/sifat_names_enum.dart';
import '../../../../../../../core/enum/sifat_types_enum.dart';
import '../../../../../../helper/active_tc.dart';
import '../../../../../../../project/cache/bildirimci_cache_manager.dart';

part 'main_bildirim_state.dart';

enum UserAdjectives { komisyoncu, hal_ici, hal_disi, uretici, sanayici }

class MainBildirimCubit extends Cubit<MainBildirimState> {
  MainBildirimCubit() : super(MainBildirimInitial());
  UserAdjectives? selectedSifatForMain;
  Future<void> assignRightUser(String tc, BuildContext context) async {
    var bildirimci =
        BildirimciCacheManager.instance.getItem(ActiveTc.instance.activeTc);

    if (bildirimci == null) {
      emit(MainBildirimError(message: "TANIMLI BİLDİRİMCİ BULUNAMADI"));
      return;
    }
    //  emit(MainBildirimError(message: "TANIMLI SIFAT BULUNAMADI"));

    bildirimci.kayitliKisiSifatIdList ??= [];
    if (bildirimci.kayitliKisiSifatIdList?.length == 1) {
      if (bildirimci.kayitliKisiSifatIdList!.first == "5") {
        context.read<UreticidenSevkAlimCubit>().customInit();
        selectedSifatForMain = UserAdjectives.komisyoncu;
        emit(MainBildirimSuccess(
            type: SifatTypes.single, activeSifat: SifatNames.komisyoncu));
      } else if (bildirimci.kayitliKisiSifatIdList!.first == "20") {
        selectedSifatForMain = UserAdjectives.hal_disi;

        emit(MainBildirimSuccess(
            type: SifatTypes.single, activeSifat: SifatNames.tuccarHalDisi));
      } else if (bildirimci.kayitliKisiSifatIdList!.first == "6") {
        selectedSifatForMain = UserAdjectives.hal_ici;

        emit(MainBildirimSuccess(
            type: SifatTypes.single, activeSifat: SifatNames.tuccarHalIci));
      } else if (bildirimci.kayitliKisiSifatIdList!.first == "4") {
        selectedSifatForMain = UserAdjectives.uretici;

        emit(MainBildirimSuccess(
            type: SifatTypes.single, activeSifat: SifatNames.tuccarHalIci));
      } else if (bildirimci.kayitliKisiSifatIdList!.first == "1") {
        selectedSifatForMain = UserAdjectives.sanayici;

        emit(MainBildirimSuccess(
            type: SifatTypes.single, activeSifat: SifatNames.sanayici));
      } else {
        emit(MainBildirimError(message: "TANIMLI SIFAT BULUNAMADI"));
      }
    } else if (bildirimci.kayitliKisiSifatIdList!.isEmpty) {
      emit(MainBildirimError(message: "TANIMLI SIFAT BULUNAMADI"));
    } else {
      //burda izlenicek yolu sor hangi sifatlari ele alacağız multiyse kırpılcak ve sadece hal içi tüccar ,hal dışı tüccar , komisyoncu filan mı gözükcek
      //case :2 komisyoncu ve hal içi hal dışı aynı anda oluyor mu
      for (var element in bildirimci.kayitliKisiSifatIdList!) {
        if (element == "5") {
          context.read<UreticidenSevkAlimCubit>().customInit();
          selectedSifatForMain = UserAdjectives.komisyoncu;

          emit(MainBildirimSuccess(
              type: SifatTypes.single, activeSifat: SifatNames.komisyoncu));
          return;
        } else if (element == "20") {
          selectedSifatForMain = UserAdjectives.hal_disi;

          emit(MainBildirimSuccess(
              type: SifatTypes.single, activeSifat: SifatNames.tuccarHalDisi));
          return;
        } else if (element == "6") {
          selectedSifatForMain = UserAdjectives.hal_ici;

          emit(MainBildirimSuccess(
              type: SifatTypes.single, activeSifat: SifatNames.tuccarHalIci));
          return;
        } else if (element == "4") {
          selectedSifatForMain = UserAdjectives.uretici;

          //üretici
          emit(MainBildirimSuccess(
              type: SifatTypes.single, activeSifat: SifatNames.tuccarHalIci));
          return;
        } else if (element == "1") {
          selectedSifatForMain = UserAdjectives.sanayici;

          //üretici
          emit(MainBildirimSuccess(
              type: SifatTypes.single, activeSifat: SifatNames.sanayici));
          return;
        } else {
          emit(MainBildirimError(message: "TANIMLI SIFAT BULUNAMADI 2"));
          //  return;
        }
      }
    }
  }

  /*printUserSifatlari() async {
    var bildirimci = await BildirimciCacheManager.instance
        .getItem(ActiveTc.instance.activeTc);




    if (bildirimci.kayitliKisiSifatNameList?.length == 1) {
      if (bildirimci.kayitliKisiSifatIdList!.first == "5" ||
          bildirimci.kayitliKisiSifatNameList!.first == "Komisyoncu") {
        MainBildirimSuccess(
            type: SifatTypes.single, activeSifat: SifatNames.komisyoncu);
      } else if (bildirimci.kayitliKisiSifatIdList!.first == "20" ||
          bildirimci.kayitliKisiSifatNameList!.first == "Tüccar (Hal Dışı)") {
        MainBildirimSuccess(
            type: SifatTypes.single, activeSifat: SifatNames.tuccarHalDisi);
      } else if (bildirimci.kayitliKisiSifatIdList!.first == "6" ||
          bildirimci.kayitliKisiSifatNameList!.first == "Tüccar (Hal İçi)") {
        MainBildirimSuccess(
            type: SifatTypes.single, activeSifat: SifatNames.tuccarHalIci);
      } else {
        MainBildirimError(message: "TANIMLI SIFAT BULUNAMADI");
      }

     } else {
      //burda izlenicek yolu sor hangi sifatlari ele alacağız multiyse kırpılcak ve sadece hal içi tüccar ,hal dışı tüccar , komisyoncu filan mı gözükcek
      //case :2 komisyoncu ve hal içi hal dışı aynı anda oluyor mu

     }
  }
*/
}
