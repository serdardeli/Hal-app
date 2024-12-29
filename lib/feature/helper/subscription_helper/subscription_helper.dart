import 'dart:convert';

import 'package:hal_app/project/generate_authorization_string.dart';

import '../../../core/extention/int_extension.dart';
import '../../../core/extention/user_extension.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../../core/enum/preferences_keys_enum.dart';
import '../../../project/cache/app_cache_manager.dart';
import '../../../project/cache/user_cache_manager.dart';
import '../../../project/model/user/my_user_model.dart';
import '../../../project/service/time/time_service.dart';
import 'package:http/http.dart' as http;

part 'extension/active_user_subscription.dart';
part 'extension/not_active_user_transaction.dart';

class SubscriptionHelper {
  static SubscriptionHelper? _instance;

  static SubscriptionHelper get instance =>
      _instance ??= SubscriptionHelper._();

  SubscriptionHelper._();
  Future<bool> checkIsSubscriber2(String phone) async {
    // bool revenueCatSubscription = await checkIsSubscriber();

    // if (revenueCatSubscription) {
    //   return true;
    // }
    String? subscriptionId = await fetchSubscriptionInfo(phone);
    print(subscriptionId);
    if (subscriptionId != null) {
      await activeSub(subscriptionId);
      //  return false;
      return true;
    } else {
      await deactivateUser();
      return false;
    }
  }

  String testBaseUrl = "https://sandbox-api.iyzipay.com/v2";
  String liveBaseUrl = "https://api.iyzipay.com/v2";
  String testApiKey = "sandbox-8Y9btvyTEXOQCvqkjqoLsBe85zAyyjPo";
  String testSecretKey = "sandbox-dcKUauPGIiBjsSih34z4OyeFlBRtowzx";
  String testRandomKey = "123456789";

  String apiKey = 'HiUnASjUZ8oo6lOrrW9ZRSdEIiNAd6cN';
  String secretKey = '9KyO5F2eZS2qWDhOM8Fcz4UJ5LOLiG9O';

  Future<bool> checkIsSubscriber() async {
    //TODO: KISI NIN ACTIVE ABONELIGI YOKSA EXP DATE EN SON SUB ID YI KISIYE ATA 3 GUN GECTIYSE SUB YI SIL SUB ID ATA
    //TODO:ABONELIK ALDIKTAN SONRADA SUB ID ATA

    CustomerInfo purchaserInfo = await Purchases.getCustomerInfo();

    //FIND LATEST ACTIVE USER

    if (purchaserInfo.entitlements.active.isNotEmpty) {
      activeUserTransactions(purchaserInfo);

      return true;
    } else {
      return await notActiveUserTransactions(purchaserInfo);
    }
  }

  Future<String?> fetchSubscriptionInfo(String phone) async {
    try {
      var authorization = generateAuthorizationString(
          '$liveBaseUrl/subscription/subscriptions?subscriptionStatus=ACTIVE&page=1&count=100&locale=tr',
          "",
          apiKey,
          secretKey,
          testRandomKey);
      var response = await http.get(
        Uri.parse(
            '$liveBaseUrl/subscription/subscriptions?subscriptionStatus=ACTIVE&page=1&count=100&locale=tr'),
        headers: {
          "Access-Control-Allow-Origin": "*",
          'Content-Type': 'application/json',
          'Accept': '*/*',
          'Authorization': authorization,
        },
      );

      List items = jsonDecode(response.body)["data"]["items"];

      for (var item in items) {
        if (item["customerGsmNumber"] == phone) {
          if (item["subscriptionStatus"] == "ACTIVE") {
            print('-----------------');
            print(item["pricingPlanName"]);
            return item["pricingPlanName"];
          }
        }
      }
      return null;
    } catch (e) {
      print(e);
    }
    return null;
  }

  //TODO: NEW USER PLANI UPGRADE EDERSE NE YAPACAĞIZ
  Future activeSub(String subscriptionId) async {
    await AppCacheManager.instance
        .putItem(PreferencesKeys.isUserActive.name, true.toString());
    await AppCacheManager.instance
        .putItem(PreferencesKeys.isAccessDenied.name, false.toString());
    String? number =
        AppCacheManager.instance.getItem(PreferencesKeys.phone.name);
    if (number != null) {
      MyUser? user = UserCacheManager.instance.getItem(number);

      if (user != null) {
        user.subscriptionId = subscriptionId;
        // if (number.contains("5448716741")) {
        //   user.subscriptionId = "full_access";
        // }
        user.subscriptionNumber = user.findSubscriptionNumber;
        user.save();
      } else {
        UserCacheManager.instance.putItem(number,
            MyUser(phoneNumber: number, subscriptionId: subscriptionId));
      }
    }
  }

  Future deactivateUser() async {
    await AppCacheManager.instance
        .putItem(PreferencesKeys.isUserActive.name, false.toString());
    await AppCacheManager.instance
        .putItem(PreferencesKeys.isAccessDenied.name, true.toString());
  }
}
