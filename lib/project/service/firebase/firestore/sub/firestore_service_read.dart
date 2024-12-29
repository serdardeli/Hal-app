part of '../firestore_service.dart';

extension FirestoreReadExtension on FirestoreService {
  @override
  Future<IResponseModel<SubscriptionStartModel?>>
      readUserSubscriptionInfo() async {
    //userId equal phone number and phone model
    SubscriptionStartModel? userFromMap;
    String? id;
    if (Platform.isAndroid) {
      String? phone =
          AppCacheManager.instance.getItem(PreferencesKeys.phone.name);

      DeviceInfoPlugin deviceInfo2 = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo2.androidInfo;
      if (phone != null) {
        String generatedId = (phone +
            "--" +
            (androidInfo.model != null
                ? androidInfo.model!
                : "nullPhoneIdAndroid"));
        id = generatedId;
      }
    } else {
      String? phone =
          AppCacheManager.instance.getItem(PreferencesKeys.phone.name);
      if (phone != null) {
        DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        String generatedId =
            ("$phone--${iosInfo.utsname.machine != null ? iosInfo.utsname.machine! : "nuulPhoneModelIos"}");

        id = generatedId;
      } else {}
    }
    try {
      DocumentSnapshot _user =
          await _firestore.collection("subscriptionStartInfo").doc(id).get();
      Map<String, dynamic> _userMap;
      if (_user.data() != null) {
        print(_user.data());
        if (_user.data() is Map) {
          _userMap = (_user.data() as Map<String, dynamic>);
          userFromMap = SubscriptionStartModel.fromJson(_userMap);
        }
      }
    } catch (e) {
      return ResponseModel(
          error: BaseError(message: e.toString(), statusCode: 400));
    }
    return ResponseModel(data: userFromMap);
  }

  @override
  Future<IResponseModel<MyUser?>> readBildirimciInformations(
      String phoneNumber) async {
    MyUser? userFromMap;
    try {
      DocumentSnapshot _user =
          await _firestore.collection("users").doc(phoneNumber).get();
      Map<String, dynamic> _userMap;
      if (_user.data() != null) {
        if (_user.data() is Map) {
          _userMap = (_user.data() as Map<String, dynamic>);
          userFromMap = MyUser.fromJson(_userMap);
        }
      }
    } catch (e) {
      return ResponseModel(
          error: BaseError(message: e.toString(), statusCode: 400));
    }
    return ResponseModel(data: userFromMap);
  }

  Future<MyUser?> fetchJustUserData() async {
    String? phone =
        AppCacheManager.instance.getItem(PreferencesKeys.phone.name);
    if (phone != null) {
      var result = await _firestore.collection("users").doc(phone).get();
      if (result.data() != null) {
        MyUser.fromJson(result.data()!);
      }
    }
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
      fetchAllUsersData() async {
    var result = await _firestore.collection("users").get();

    return result.docs;
  }

  Future<void> fetchUserAllData() async {
    String? phone =
        AppCacheManager.instance.getItem(PreferencesKeys.phone.name);
    if (phone != null) {
      var result = await _firestore.collection("users").doc(phone).get();

      var list = BildirimciCacheManager.instance.getkeys();
      list?.forEach((element) async {
        var result = await _firestore
            .collection("users")
            .doc(phone)
            .collection("tc")
            .doc(element)
            .get();

        if (result.data() != null) {
          List<CustomNotificationSaveModel> bildirimList = [];
          List<Uretici> ureticiList = [];

          Bildirimci.fromJson(result.data()!).bildirimList?.forEach(
            (element) {
              bildirimList.add(CustomNotificationSaveModel.fromJson(
                  Map<String, dynamic>.from(element)));
            },
          );
          Bildirimci.fromJson(result.data()!).ureticiList?.forEach(
            (element) {
              ureticiList
                  .add(Uretici.fromJson(Map<String, dynamic>.from(element)));
            },
          );

          bildirimList.forEach(
            (element2) {
              CustomNotificationSaveCacheManager.instance
                  .addItemCopy3(element, element2);
            },
          );

          ureticiList.forEach(
            (element2) {
              UreticiListCacheManager.instance.addItem(element, element2);
            },
          );
        }
      });
    }
  }
}
