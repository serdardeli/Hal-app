part of '../firestore_service.dart';

extension FirestoreWriteExtension on FirestoreService {
  @override
  Future<IResponseModel<void>> saveStartSubscriptionInfo(
      SubscriptionStartModel model) async {
    //userId equal phone number and phone model
    SubscriptionStartModel? userFromMap;
    String? id;
    if (Platform.isAndroid) {
      String? phone =
          AppCacheManager.instance.getItem(PreferencesKeys.phone.name);

      DeviceInfoPlugin deviceInfo2 = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo2.androidInfo;

      if (phone != null) {
        String generatedId = ("$phone--${androidInfo.model ?? "nullPhoneIdAndroid"}");
        id = generatedId;
      }
    } else {
      String? phone =
          AppCacheManager.instance.getItem(PreferencesKeys.phone.name);
      if (phone != null) {
        DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        String generatedId =
            ("$phone--${iosInfo.utsname.machine ?? "nuulPhoneModelIos"}");

        id = generatedId;
      } else {}
    }
    try {
      await _firestore
          .collection("subscriptionStartInfo")
          .doc(id)
          .set(model.toJson());
    } catch (e) {
      return ResponseModel(
          error: BaseError(message: e.toString(), statusCode: 400));
    }
    return ResponseModel(data: userFromMap);
  }

  @override
  Future<IResponseModel<void>> savefirstUserInfoDetail(
      String phone, Map<String, dynamic> map2) async {
    //userId equal phone number and phone model
    SubscriptionStartModel? userFromMap;
    String? id;
    if (Platform.isAndroid) {
      DeviceInfoPlugin deviceInfo2 = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo2.androidInfo;

      String generatedId = ("$phone--${androidInfo.model ?? "nullPhoneIdAndroid"}");
      id = generatedId;
        } else {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      String generatedId =
          ("$phone--${iosInfo.utsname.machine ?? "nuulPhoneModelIos"}");

      id = generatedId;
        }
    map2.addAll({
      "startDate":
          ((await TimeService.instance.getTime()) ?? DateTime.now()).toString()
    });
    try {
      await _firestore.collection("logFirstInfo").doc(id).set(map2);
    } catch (e) {
      return ResponseModel(
          error: BaseError(message: e.toString(), statusCode: 400));
    }
    return ResponseModel(data: userFromMap);
  }

  @override
  Future<IResponseModel<void>> savefirstUserInfo(String phone) async {
    //userId equal phone number and phone model
    SubscriptionStartModel? userFromMap;
    String? id;
    if (Platform.isAndroid) {
      DeviceInfoPlugin deviceInfo2 = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo2.androidInfo;

      String generatedId = ("$phone--${androidInfo.model ?? "nullPhoneIdAndroid"}");
      id = generatedId;
        } else {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      String generatedId =
          ("$phone--${iosInfo.utsname.machine ?? "nuulPhoneModelIos"}");

      id = generatedId;
        }
    try {
      await _firestore.collection("logFirstInfo").doc(id).set({
        "startDate": ((await TimeService.instance.getTime()) ?? DateTime.now())
            .toString()
      });
    } catch (e) {
      return ResponseModel(
          error: BaseError(message: e.toString(), statusCode: 400));
    }
    return ResponseModel(data: userFromMap);
  }

  @override
  Future<IResponseModel<MyUser?>> readUserInformations(
      String phoneNumber) async {
    MyUser? userFromMap;
    try {
      DocumentSnapshot user =
          await _firestore.collection("users").doc(phoneNumber).get();
      Map<String, dynamic> userMap;
      if (user.data() != null) {
        if (user.data() is Map) {
          userMap = (user.data() as Map<String, dynamic>);
          userFromMap = MyUser.fromJson(userMap);
        }
      }
    } catch (e) {
      return ResponseModel(
          error: BaseError(message: e.toString(), statusCode: 400));
    }
    return ResponseModel(data: userFromMap);
  }

  Future<IResponseModel<MyUser?>> saveSubscriptionInfo(
      Subscription subscription) async {
    try {
      _firestore
          .collection("subscriptions")
          .doc(subscription.user!.phoneNumber != null
              ? (subscription.user?.phoneNumber!)
              : (""))
          .set({
        'subscriptionsList': FieldValue.arrayUnion([subscription.toJson()])
      }, SetOptions(merge: true));

      return ResponseModel();
    } catch (e) {
      return ResponseModel(
          error: BaseError(message: e.toString(), statusCode: 400));
    }
  }

  @override
  Future<IResponseModel<MyUser?>> saveUserInformations(MyUser user) async {
    try {
      DateTime currentTime =
          (await TimeService.instance.getTime()) ?? DateTime.now();
      user.updatedAt = currentTime;

      await _firestore
          .collection("users")
          .doc(user.phoneNumber != null ? (user.phoneNumber!) : (""))
          .set(user.toJson());
      //TODO: SAVE USER INFO DAN SONRA DATALARIMIZI TEKRAR OKUMAYA FILAN GEREK YOK ANA YAPI HER ZAMAN LOCALDE DONUCEK FIREBASE SADECE YEDEK ICIN

      // IResponseModel responseModel =
      //     await readUserInformations(user.phoneNumber ?? "null phone"); //Todo
      // MyUser? myUser = responseModel.data;
      return ResponseModel(data: user);
    } catch (e) {
      return ResponseModel(
          error: BaseError(message: e.toString(), statusCode: 400));
    }
  }

  @override
  Future<IResponseModel<MyUser?>> saveBildirimciTc(Bildirimci bildirim) async {
    String? phoneNumber =
        AppCacheManager.instance.getItem(PreferencesKeys.phone.name);

    AppCacheManager.instance.getItem(PreferencesKeys.phone.name);
    DateTime currentTime =
        (await TimeService.instance.getTime()) ?? DateTime.now();
    try {
      var collectionRef = await _firestore
          .collection("users")
          .doc(phoneNumber)
          .collection("tc")
          .doc(bildirim.bildirimciTc)
          .get();
      if (collectionRef.exists) {
        //set
        Bildirimci? model;
        if (collectionRef.data() != null) {
          model = Bildirimci.fromJson(collectionRef.data()!);
          model.bildirimciTc = bildirim.bildirimciTc;
          model.hksSifre = bildirim.hksSifre;
          model.bildirimciAdiSoyadi = bildirim.bildirimciAdiSoyadi;
          model.isyeriAdi = bildirim.isyeriAdi;
          model.kayitliKisiSifatIdList = bildirim.kayitliKisiSifatIdList;
          model.kayitliKisiSifatNameList = bildirim.kayitliKisiSifatNameList;
          model.phoneNumber = phoneNumber;
          model.webServiceSifre = bildirim.webServiceSifre;
          model.updateAt = currentTime;
        }

        await _firestore
            .collection("users")
            .doc(phoneNumber)
            .collection("tc")
            .doc(bildirim.bildirimciTc)
            .set(
              model != null
                  ? model.toJson()
                  : {
                      "bildirimciTc": bildirim.bildirimciTc,
                      "hksSifre": bildirim.hksSifre,
                      "bildirimciAdiSoyadi": bildirim.isyeriAdi,
                      "isyeriAdi": bildirim.isyeriAdi,
                      "kayitliKisiSifatIdList": bildirim.kayitliKisiSifatIdList,
                      "kayitliKisiSifatNameList":
                          bildirim.kayitliKisiSifatNameList,
                      "phoneNumber": phoneNumber,
                      "webServiceSifre": bildirim.webServiceSifre,
                      "updateAt": currentTime,
                    },
            );
      } else {
        bildirim.updateAt = currentTime;
        await _firestore
            .collection("users")
            .doc(phoneNumber)
            .collection("tc")
            .doc(bildirim.bildirimciTc)
            .set(bildirim.toJson());
      }

      return ResponseModel();
    } catch (e) {
      return ResponseModel(
          error: BaseError(message: e.toString(), statusCode: 400));
    }
  }

  Future<void> saveAllUserData() async {
    DateTime currentTime =
        (await TimeService.instance.getTime()) ?? DateTime.now();
    String? phone =
        AppCacheManager.instance.getItem(PreferencesKeys.phone.name);
    if (phone != null) {
      MyUser? user = UserCacheManager.instance.getItem(phone);
      if (user != null) {
        user.tcList = BildirimciCacheManager.instance.getkeys();
        user.updatedAt = currentTime;
        user.save();
        await _firestore.collection("users").doc(phone).set(user.toJson());
      }

      List<Bildirimci>? bildirimciList =
          BildirimciCacheManager.instance.getValues();

      List<Bildirimci>? newBildirimciList = [];
      BildirimciCacheManager.instance.getValues()?.forEach((element) {
        newBildirimciList.add(Bildirimci.fromJson(element.toJson()));
      });

      newBildirimciList.forEach((element) async {
        element.updateAt == currentTime;

        List<CustomNotificationSaveModel>? notificationList =
            CustomNotificationSaveCacheManager.instance
                .getItem(element.bildirimciTc ?? "");
        element.bildirimList ??= [];
        for (var item in notificationList) {
          element.bildirimList?.add(item.toJson());
        }
        List? ureticiListMap = UreticiListCacheManager.instance
            .getItem(element.bildirimciTc ?? "");

        element.ureticiList ??= [];
        try {
          ureticiListMap?.forEach((item) {
            element.ureticiList?.add(item as Map);
          });
        } catch (e) {}
        await _firestore
            .collection("users")
            .doc(phone)
            .collection("tc")
            .doc(element.bildirimciTc)
            .set(element.toJson());
      });
    }
  }
}
