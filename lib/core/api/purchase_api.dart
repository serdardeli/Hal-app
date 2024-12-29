import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../project/cache/app_cache_manager.dart';
import '../enum/preferences_keys_enum.dart';

class PurchaseApi {
  static PurchaseApi? _instance;

  static PurchaseApi get instance => _instance ??= PurchaseApi._();
  PurchaseApi._();

  static const _apiKeyAndroid = 'goog_URMRSNxHDFjKTNTCNFMYGVYCsMH';
  static const _apiKeyIos = 'appl_ozBRDKpNoVeCRUQueyrYUgOeFFp';
  Future init() async {
    if (Platform.isAndroid) {
      String? phone =
          AppCacheManager.instance.getItem(PreferencesKeys.phone.name);

      DeviceInfoPlugin deviceInfo2 = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo2.androidInfo;

      if (phone != null) {
        String generatedId = ("$phone--${androidInfo.model}");

        return await Purchases.configure(
                PurchasesConfiguration(_apiKeyAndroid)..appUserID = generatedId)
            .then((value) async {
          await Purchases.setPhoneNumber(phone);
        });
      } else {
        return await Purchases.configure(
            PurchasesConfiguration(_apiKeyAndroid));
      }
    } else {
      String? phone =
          AppCacheManager.instance.getItem(PreferencesKeys.phone.name);

      if (phone != null) {
        DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;

        String generatedId = ("$phone--${iosInfo.utsname.machine}");
        PurchasesConfiguration purchasesConfiguration =
            PurchasesConfiguration(_apiKeyIos);
        purchasesConfiguration.appUserID = generatedId;

        return await Purchases.configure(purchasesConfiguration).then((value) {
          Purchases.setPhoneNumber(phone);
        });
      } else {
        PurchasesConfiguration purchasesConfiguration =
            PurchasesConfiguration(_apiKeyIos);
        return await Purchases.configure(purchasesConfiguration);
      }
    }
  }

/*
  Future init() async {
    await Purchases.setDebugLogsEnabled(true);

    if (Platform.isAndroid) {
      String? phone =
          AppCacheManager.instance.getItem(PreferencesKeys.phone.name);




      if (phone != null) {
        DeviceInfoPlugin deviceInfo2 = DeviceInfoPlugin();
        AndroidDeviceInfo androidInfo = await deviceInfo2.androidInfo;
        var a =
            "cn-central-1b-d9aaf45301596181555256-3580069677-xx9nn"; //furkan huawei phone id

        String generatedId = (phone + "--" + androidInfo.host!);


        Purchases.logIn("generatedId").then((value) async {
          await Purchases.setDebugLogsEnabled(true);
          await Purchases.setPhoneNumber(phone);





          return await Purchases.setup(_apiKeyAndroid, appUserId: generatedId);
        });
      } else {


        return await Purchases.setup(_apiKeyAndroid);
      }

      // await Purchases.configure(PurchasesConfiguration("public_sdk_key")
      // ..appUserID = "my_app_user_id");

      //await Purchases.setup(_apiKeyAndroid);
    } else {
      String? phone =
          AppCacheManager.instance.getItem(PreferencesKeys.phone.name);




      if (phone != null) {
        DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;



        var a =
            "cn-central-1b-d9aaf45301596181555256-3580069677-xx9nn"; //furkan huawei phone id

        String generatedId = (phone + "--" + iosInfo.identifierForVendor!);


        Purchases.logIn(generatedId).then((value) async {
          await Purchases.setDebugLogsEnabled(true);

          Purchases.setPhoneNumber(phone);





          return await Purchases.setup(_apiKeyIos, appUserId: generatedId);
        });
      } else {


        return await Purchases.setup(
          _apiKeyIos,
        );
      }
    }
  }
*/
  Future<List<Offering>> fetchOffers() async {
    try {
      final offerings = await Purchases.getOfferings();
      final current = offerings.current;
      return current == null ? [] : [current];
    } catch (e) {
      return [];
    }
  }

  Future<List<Package>> fetchAvailablePackages() async {
    try {
      final offerings = await Purchases.getOfferings();
      final List<Package> current =
          offerings.current != null ? offerings.current!.availablePackages : [];
      return current;
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  Future<void> getSubscriptionStatus() async {
    try {
      CustomerInfo purchaserInfo = await Purchases.getCustomerInfo();

      if (purchaserInfo.entitlements.all["trial_1w"] != null &&
          purchaserInfo.entitlements.all["trial_1w"]!.isActive == true) {
      } else {}
    } on PlatformException {
      // Error fetching purchaser info
    }
  }

  Future<String> purchasePackage(Package package) async {
    try {
      await Purchases.purchasePackage(package);
      return "true";
    } catch (e) {
      return e.toString();
    }
  }
}
