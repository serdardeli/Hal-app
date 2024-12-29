part of '../subscription_helper.dart';

extension ActiveUserExtension on SubscriptionHelper {
  Future<void> activeUserTransactions(CustomerInfo purchaserInfo) async {
    AppCacheManager.instance
        .putItem(PreferencesKeys.isUserActive.name, true.toString());
    AppCacheManager.instance
        .putItem(PreferencesKeys.isAccessDenied.name, false.toString());
    //ACTIVE USER FOUND

    String? tempLastPurchaseDate;
    String? selectedIdentifier;
    selectedIdentifier = findLatestPurchaseDate(
        purchaserInfo, tempLastPurchaseDate, selectedIdentifier);

    assignSubscriptionIdToActiveUser(selectedIdentifier);
  }
}


String? findLatestPurchaseDate(CustomerInfo purchaserInfo,
    String? tempLastPurchaseDate, String? selectedIdentifier) {
  purchaserInfo.entitlements.active.values.toList().forEach((element) {
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

Future<void> assignSubscriptionIdToActiveUser(
    String? selectedIdentifier) async {
  String? number = AppCacheManager.instance.getItem(PreferencesKeys.phone.name);
  if (number != null) {
    MyUser? user = UserCacheManager.instance.getItem(number);

    if (user != null) {
      user.subscriptionId = selectedIdentifier;
      user.subscriptionNumber = user.findSubscriptionNumber;
      user.revenueCatSubscriptionId = (await Purchases.appUserID);
      String? phone =
          AppCacheManager.instance.getItem(PreferencesKeys.phone.name);
      if (phone != null) {
        MyUser? user = UserCacheManager.instance.getItem(phone);
        if (user != null) {
          // if (user.phoneNumber == "+905448716741") {
          //   user.subscriptionId = "full_access";
          // }
          // if (user.phoneNumber == "+905322565218") {
          //   user.subscriptionId = "full_access";
          // }
        }
      }
      user.save();
    } else {
      UserCacheManager.instance.putItem(number,
          MyUser(phoneNumber: number, subscriptionId: selectedIdentifier));
    }
  }
}
