import 'dart:developer';

import 'package:bloc/bloc.dart';
import '../../../../core/api/purchase_api.dart';
import '../../../../project/model/subscription/subscription_model.dart';
import '../../../../project/service/firebase/firestore/firestore_service.dart';
import 'package:meta/meta.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../../../core/enum/preferences_keys_enum.dart';
import '../../../../project/cache/app_cache_manager.dart';
import '../../../../project/cache/user_cache_manager.dart';
import '../../../../project/model/user/my_user_model.dart';
import '../../../../project/service/time/time_service.dart';

part 'subscriptions_state.dart';

class SubscriptionsCubit extends Cubit<SubscriptionsState> {
  SubscriptionsCubit() : super(SubscriptionsInitial()) {
    fetchAvailablePackages();
    dropdownValue = '2';
  }
  List<Package> _availablePackages = [];

  Future<List<Package>> availablePackages() async {
    if (_availablePackages.isEmpty) {
      var value = await fetchAvailablePackages();
      return value;
    } else {
      return _availablePackages;
    }
  }

  List<String> subscriptionsNumbers = [
    '2',
    '3',
    '4',
    '5',
    '6',
  ]; /*
  
  
    '7',
    '8',
    '9',
    '10',
    '11'
  */
  /**
one_person_one_month
one_person_one_month
one_person_one_month
   "7": 'seven_person_one_month',
    "8": 'eight_person_one_month',
    "9": 'nine_person_one_month',
    "10": 'ten_person_one_month',
   */
  Map<String, String> subscriptionsIdentifiers = {
    "1": 'one_person_one_month_new',
    "2": 'two_person_one_month_new',
    "3": 'three_person_one_month_new',
    "4": 'four_person_one_month_new',
    "5": 'five_person_one_month_new',
    "6": 'six_person_one_month',
    "7": 'one_week_new',
  };

  late String dropdownValue;
  Future<List<Package>> fetchAvailablePackages() async {
    try {
      _availablePackages = await PurchaseApi.instance.fetchAvailablePackages();
      print("available packages");

      for (var element in _availablePackages) {
        print(element.identifier);
      }

      emit(SubscriptionsInitial());
      return _availablePackages;
    } catch (e) {
      print(e.toString());
      emit(SubscriptionsError(message: "Hata"));
      return [];
    }
  }

  Future<void> clickBasicSubscription() async {
    emit(SubscriptionsLoading());
    try {
      var packages = await availablePackages();
      Package? selectedPackage;
      for (var element in packages) {
        if (element.identifier == subscriptionsIdentifiers["1"]) {
          selectedPackage = element;
        }
      }
      if (selectedPackage != null) {
        var result =
            await PurchaseApi.instance.purchasePackage(selectedPackage);

        if (result.toLowerCase() == "true") {
          //   await checkIsSubscriber();
          AppCacheManager.instance
              .putItem(PreferencesKeys.isUserActive.name, true.toString());
          AppCacheManager.instance
              .putItem(PreferencesKeys.isAccessDenied.name, false.toString());
          saveSubscription().then((value) async {
            FirestoreService.instance.saveUserInformations(
                UserCacheManager.instance.getItem(AppCacheManager.instance
                        .getItem(PreferencesKeys.phone.name)!) ??
                    MyUser());
          });
//furkanacr911@gmail.com
          emit(SubscriptionsSuccessful());
          emit(SubscriptionsInitial());
        } else {
          emit(SubscriptionsError(message: result.toString()));
          emit(SubscriptionsInitial());
        }
      } else {
        emit(SubscriptionsError(message: "paket seçilemedi"));
        emit(SubscriptionsInitial());
      }
    } catch (e) {
      emit(SubscriptionsError(message: "Hata "));
      emit(SubscriptionsInitial());
    }
  }

  Future<void> clickPremiumSubscription() async {
    emit(SubscriptionsLoading());
    try {
      var packages = await availablePackages();
      Package? selectedPackage;

      for (var element in packages) {
        if (element.identifier == subscriptionsIdentifiers[dropdownValue]) {
          selectedPackage = element;
        }
      }
      if (selectedPackage != null) {
        var result =
            await PurchaseApi.instance.purchasePackage(selectedPackage);

        if (result.toLowerCase() == "true") {
          //   await checkIsSubscriber();
          AppCacheManager.instance
              .putItem(PreferencesKeys.isUserActive.name, true.toString());
          AppCacheManager.instance
              .putItem(PreferencesKeys.isAccessDenied.name, false.toString());
          saveSubscription().then((value) async {
            FirestoreService.instance.saveUserInformations(
                UserCacheManager.instance.getItem(AppCacheManager.instance
                        .getItem(PreferencesKeys.phone.name)!) ??
                    MyUser());
          });

          emit(SubscriptionsSuccessful());
          emit(SubscriptionsInitial());
        } else {
          emit(SubscriptionsError(message: result.toString()));
          emit(SubscriptionsInitial());
        }
      } else {
        emit(SubscriptionsError(message: "paket seçilemedi"));
        emit(SubscriptionsInitial());
      }
    } catch (e) {
      emit(SubscriptionsError(message: "Hata "));
      emit(SubscriptionsInitial());
    }
  }

  Future<void> saveSubscription() async {
    //TODO: CURRENT DATE GARANTİYE ALINACAK
    String appId = (await Purchases.appUserID);
    DateTime currentTime =
        (await TimeService.instance.getTime()) ?? DateTime.now();
    await FirestoreService.instance.saveSubscriptionInfo(Subscription(
        user: UserCacheManager.instance.getItem(
            AppCacheManager.instance.getItem(PreferencesKeys.phone.name)!)!
          ..revenueCatSubscriptionId = appId
          ..save(),
        time: currentTime));
  }

  //TODO: ACELESI YOG BUNU KUCULTEBILIRSIN LAUNCH TA GEREKLI OLAN BIR COK ISI BURADA TEKRAR YAPIYORUM
  Future<bool> checkIsSubscriber() async {
    //TODO: KISI NIN ACTIVE ABONELIGI YOKSA EXP DATE EN SON SUB ID YI KISIYE ATA 3 GUN GECTIYSE SUB YI SIL SUB ID ATA
    //TODO:ABONELIK ALDIKTAN SONRADA SUB ID ATA

    CustomerInfo purchaserInfo = await Purchases.getCustomerInfo();
    DateTime? currentTime =
        (await TimeService.instance.getTime()) ?? DateTime.now();

    //FIND LATEST ACTIVE USER
    if (purchaserInfo.entitlements.active.isNotEmpty) {
      AppCacheManager.instance
          .putItem(PreferencesKeys.isUserActive.name, true.toString());
      AppCacheManager.instance
          .putItem(PreferencesKeys.isAccessDenied.name, false.toString());
      //ACTIVE USER FOUND

      String? tempLastPurchaseDate;
      String? selectedIdentifier;
      //find latest purchae data
      purchaserInfo.entitlements.active.values.toList().forEach((element) {
        tempLastPurchaseDate ??= element.latestPurchaseDate;
        selectedIdentifier ??= element.identifier;
        DateTime temp = DateTime.parse(tempLastPurchaseDate!);
        DateTime last = DateTime.parse(element.latestPurchaseDate);
        temp.compareTo(last);
        if (last.compareTo(temp) > 0) {
          tempLastPurchaseDate = element.latestPurchaseDate;

          selectedIdentifier = element.identifier;
        }
      });
      //find latest purchae data

      String? number =
          AppCacheManager.instance.getItem(PreferencesKeys.phone.name);
      if (number != null) {
        MyUser? user = UserCacheManager.instance.getItem(number);

        if (user != null) {
          user.subscriptionId = selectedIdentifier;
          user.save();
        } else {
          UserCacheManager.instance.putItem(number,
              MyUser(phoneNumber: number, subscriptionId: selectedIdentifier));
        }
      }

      DateTime subExTime = DateTime.parse(purchaserInfo
              .entitlements.active[selectedIdentifier]!.expirationDate!)
          .toLocal();
      DateTime currentTime =
          await TimeService.instance.getTime() ?? DateTime.now();

      //!!!!!!! for trial !!!!!!

      return true;
    } else {
      //ACTIVE USER COULD NOT FOUND CHECK BIGGEST EXPIRATION DATE

      //UYELIK SISTEMINI TEST ETMEK ICIN FAKE DATA EKLEME
      purchaserInfo.allExpirationDates.clear();
      purchaserInfo.allExpirationDates
          .addAll({"two_person_one_month": "2022-07-25T11:03:14.000Z"});
      //UYELIK SISTEMINI TEST ETMEK ICIN FAKE DATA EKLEME

      // FIND THE BIGGEST EXPIRATION DATE
      if (purchaserInfo.allExpirationDates.values.toList().isEmpty) {
        //EXPIRATION DATE YOK SA HIC UYE OLMAMISTIR ONA DIREK ACCESS DENIED ATA

        AppCacheManager.instance
            .putItem(PreferencesKeys.isUserActive.name, false.toString());
        AppCacheManager.instance
            .putItem(PreferencesKeys.isAccessDenied.name, true.toString());
      } else {
        DateTime? tempExpDate;

        for (var element in purchaserInfo.allExpirationDates.entries) {
          if (element.value != null) {
            var currentElementTime = DateTime.parse(element.value!);
            tempExpDate ??= currentElementTime;
            if (currentElementTime.compareTo(tempExpDate) > 0) {
              tempExpDate = currentElementTime;
            }
          }
        }

        double numberOfDaysPasses = double.parse(millisecondToDay(
            (tempExpDate?.millisecondsSinceEpoch ??
                0 - currentTime.millisecondsSinceEpoch)));

        if (numberOfDaysPasses > -1) {
          log("bir günlük ödeme gecikmesi veya normal expration data daha çok var buraya girmesi mantıksız ama düşünücem");
          AppCacheManager.instance
              .putItem(PreferencesKeys.isAccessDenied.name, false.toString());
          // passed one day do nothing
          return true;
        } else if (numberOfDaysPasses <= -1 && numberOfDaysPasses > -2) {
          //geçen gün 1  3 gün arasındaysa  isnotactive i active et

          log("ödeme alınamıştır eğer üyeliğinizi yenilemezsiniz 2 gün içinde sisteminizi kapatacağız");
          AppCacheManager.instance
              .putItem(PreferencesKeys.isUserActive.name, false.toString());
          AppCacheManager.instance
              .putItem(PreferencesKeys.isAccessDenied.name, false.toString());
        } else if (numberOfDaysPasses <= -2 && numberOfDaysPasses >= -3) {
          log("ödeme alınamıştır eğer üyeliğinizi yenilemezsiniz 1 gün içinde sisteminizi kapatacağız");
          AppCacheManager.instance
              .putItem(PreferencesKeys.isUserActive.name, false.toString());
          AppCacheManager.instance
              .putItem(PreferencesKeys.isAccessDenied.name, false.toString());
        } else {
          log("ERİŞİM ENGELLENMİŞTİR");

          // geçen gün 3 günü geçince  kullanıcı girişini komple engelle
          AppCacheManager.instance
              .putItem(PreferencesKeys.isUserActive.name, false.toString());
          AppCacheManager.instance
              .putItem(PreferencesKeys.isAccessDenied.name, true.toString());
        }
      }
    }

    return false;
  }

  void emitState() {
    emit(SubscriptionsInitial());
  }

  String millisecondToDay(int timeInMillSec) {
    // const MINUTE = 60 * SECOND;
    // const HOUR = 60 * MINUTE;
    // const DAY = 24 * HOUR;
    int toMinute = (1000 * 60);
    int toHour = (1000 * 60) * 60;
    int toDay = (1000 * 60) * 60 * 24;

    return (timeInMillSec / toDay).toString();
  }

  void dropdownSelected() {
    emit(SubscriptionsInitial());
  }
}
