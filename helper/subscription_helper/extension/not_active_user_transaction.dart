part of '../subscription_helper.dart';

extension NotActiveUserTransactions on SubscriptionHelper {
  Future<bool> notActiveUserTransactions(CustomerInfo purchaserInfo) async {
    DateTime? currentTime =
        (await TimeService.instance.getTime()) ?? DateTime.now();

    //ACTIVE USER COULD NOT FOUND CHECK BIGGEST EXPIRATION DATE
    if (purchaserInfo.allExpirationDates.values.toList().isEmpty) {
      //EXPIRATION DATE YOK SA HIC UYE OLMAMISTIR ONA DIREK ACCESS DENIED ATA
      return expirationDateCouldNotFoundTransactions();
    } else {
      DateTime? tempExpDate;
      String? selectedIdentifier;
      String? tempLastPurchaseDate;

      selectedIdentifier = findLatestPurchaseDate2(
          purchaserInfo, tempLastPurchaseDate, selectedIdentifier);
      tempExpDate = findLatestExpirationDate(purchaserInfo, tempExpDate);
      double numberOfDaysPasses = double.parse(
          (tempExpDate!.millisecondsSinceEpoch -
                  currentTime.millisecondsSinceEpoch)
              .millisecondToDay
              .toString());
      assignSubscriptionIdToActiveUser(selectedIdentifier);
      String? phone =
          AppCacheManager.instance.getItem(PreferencesKeys.phone.name);
      if (phone != null) {
        MyUser? user = UserCacheManager.instance.getItem(phone);
        if (user != null) {
          //if (user.phoneNumber == "+905448716741") {
          //  user.subscriptionId = "full_access";
          //  return true;
          //}
          //  if (user.phoneNumber == "+905322565218") {
          //    user.subscriptionId = "full_access";
          //    return true;
          //  }
        }
      }

      if (numberOfDaysPasses > -1) {
        AppCacheManager.instance
            .putItem(PreferencesKeys.isAccessDenied.name, false.toString());
         return false; 
      } else if (numberOfDaysPasses <= -1 && numberOfDaysPasses > -2) {
        AppCacheManager.instance
            .putItem(PreferencesKeys.isUserActive.name, false.toString());
        AppCacheManager.instance
            .putItem(PreferencesKeys.isAccessDenied.name, false.toString());
      } else if (numberOfDaysPasses <= -2 && numberOfDaysPasses >= -3) {
        AppCacheManager.instance
            .putItem(PreferencesKeys.isUserActive.name, false.toString());
        AppCacheManager.instance
            .putItem(PreferencesKeys.isAccessDenied.name, false.toString());
      } else {
        // geçen gün 3 günü geçince  kullanıcı girişini komple engelle
        AppCacheManager.instance
            .putItem(PreferencesKeys.isUserActive.name, false.toString());
        AppCacheManager.instance
            .putItem(PreferencesKeys.isAccessDenied.name, true.toString());
      }
    }

    return false;
  }
}

DateTime? findLatestExpirationDate(
    CustomerInfo purchaserInfo, DateTime? tempExpDate) {
  for (var element in purchaserInfo.allExpirationDates.entries) {
    if (element.value != null) {
      var currentElementTime = DateTime.parse(element.value!);
      tempExpDate ??= currentElementTime;
      if (currentElementTime.compareTo(tempExpDate) > 0) {
        tempExpDate = currentElementTime;
      }
    }
  }
  return tempExpDate;
}

bool expirationDateCouldNotFoundTransactions() {
  AppCacheManager.instance
      .putItem(PreferencesKeys.isUserActive.name, false.toString());
  AppCacheManager.instance
      .putItem(PreferencesKeys.isAccessDenied.name, true.toString());
  return false;
}

void addDateToTestSubscriptionExpirationDate(CustomerInfo purchaserInfo) {
  purchaserInfo.allExpirationDates.clear();
  purchaserInfo.allExpirationDates
      .addAll({"two_person_one_month": "2022-07-25T11:03:14.000Z"});
}

String? findLatestPurchaseDate2(CustomerInfo purchaserInfo,
    String? tempLastPurchaseDate, String? selectedIdentifier) {
  purchaserInfo.entitlements.all.values.toList().forEach((element) {
    tempLastPurchaseDate ??= element.latestPurchaseDate;
    selectedIdentifier ??= element.identifier;
    DateTime temp = DateTime.parse(tempLastPurchaseDate!);
    DateTime last = DateTime.parse(element.latestPurchaseDate);
    if (last.compareTo(temp) > 0) {
      tempLastPurchaseDate = element.latestPurchaseDate;
      selectedIdentifier = element.identifier;
    }
  });
  return selectedIdentifier;
}
