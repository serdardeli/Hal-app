import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';

import '../../../../../../project/model/referans_kunye/referans_kunye_model.dart';
import '../../../../../../project/service/hal/bildirim_service.dart';

part 'recent_notifications_state.dart';

//197ler görünmeyecek
class RecentNotificationsCubit extends Cubit<RecentNotificationsState> {
  RecentNotificationsCubit() : super(RecentNotificationsLoading()) {
    emitInitial();
  }
  Future<void> emitInitial() async {


    await fetchBoth();
  }

  Future<void> fetchBoth() async {
    emit(RecentNotificationsLoading());

    Future.wait([
      fetchRecentNotifications(),
      fetchRecentNotificationsToBildirimci()
    ]).then((value) {
      mergeBothList();
      emit(RecentNotificationsInitial());
    });
    // emit(RecentNotificationsInitial());
  }

  void mergeBothList() {
    bildirimListMerged.clear();
    bildirimListMerged.addAll(bildirimlistFromUser);
    bildirimListMerged.addAll(bildirimlistToUser);
  }

  List<ReferansKunye> bildirimlistFromUser = [];
  List<ReferansKunye> bildirimlistToUser = [];
  List<ReferansKunye> bildirimListMerged = [];

  Future<void> fetchRecentNotifications() async {

    emit(RecentNotificationsLoading());

    try {
      emit(RecentNotificationsLoading());

      DateFormat dateFormat = DateFormat("yyyy-MM-ddTHH:mm:ss");
      String startDay =
          dateFormat.format(DateTime.now().subtract(const Duration(days: 3)));
      String endDay = dateFormat.format(DateTime.now().add(const Duration(days: 1)));

      var result = await BildirimService.instance
          .bildirimBildirimcininYaptigiBildirimListesiWithObject(
              startDay, endDay);
      if (result.error != null) {
        emit(RecentNotificationsError(message: result.error!.message));
        emit(RecentNotificationsInitial());
      } else {

        bildirimlistFromUser = [];

        result.data.forEach((element) {
          //BİLDİRİMCİYE YAPILAN BİLİDİRMDE SATIŞ DEĞİLSE
          if (element.bildirimTuru != "197") {
            bildirimlistFromUser.add(element);
          }
        //  bildirimlistFromUser.add(element);

          //  result.data.forEach((element) {

          //  });
        });
      }
    } catch (e) {

      emit(RecentNotificationsInitial());
    }
  }

  Future<void> fetchRecentNotificationsToBildirimci() async {

    try {
      DateFormat dateFormat = DateFormat("yyyy-MM-ddTHH:mm:ss");
      String startDay =
          dateFormat.format(DateTime.now().subtract(const Duration(days: 3)));
      String endDay = dateFormat.format(DateTime.now().add(const Duration(days: 1)));

      var result = await BildirimService.instance
          .bildirimBildirimciyeYapilanBildirimListesiWithObject(
              startDay, endDay);
      if (result.error != null) {
        emit(RecentNotificationsError(message: result.error!.message));
        emit(RecentNotificationsInitial());
      } else {


        bildirimlistToUser = [];
        result.data.forEach((element) {
          //BİLDİRİMCİYE YAPILAN BİLİDİRMDE SATIŞ DEĞİLSE
          bildirimlistToUser.add(element);
        });
        //  result.data.forEach((element) {

        //  });
      }
    } catch (e) {

      emit(RecentNotificationsInitial());
    }
  }
}
