part of '../saved_notifications_cubit.dart';

extension CheckGidecegiYerUpdate on SavedNotificationsCubit {
  void fetchInfosAndAddToDb(Bildirimci bildirimciOut) {
    fetchAllDepoSubeHalIciIsyerleri(bildirimciOut).then((value) {
      if (value) {
        try {
          List<Map> listOfBildirim = [];
          CustomNotificationSaveCacheManager.instance
              .getItem(bildirimciOut.bildirimciTc!)
              .forEach((element) {
            listOfBildirim.add(element.toJson());
          });
          Bildirimci bildirimci = Bildirimci(
              phoneNumber:
                  AppCacheManager.instance.getItem(PreferencesKeys.phone.name),
              hasDepo: depolar.isNotEmpty,
              hasSube: subeler.isNotEmpty,
              hasHalIciIsyeri: halIciIsyerleriNew.isNotEmpty,
              kayitliKisiSifatIdList: kayitliKisi?.sifatlar,
              hksSifre: bildirimciOut.hksSifre,
              webServiceSifre: bildirimciOut.webServiceSifre,
              bildirimciTc: bildirimciOut.bildirimciTc,
              bildirimList: listOfBildirim,
              gidecegiYerUpdated: true);

          BildirimciCacheManager.instance
              .putItem(bildirimciOut.bildirimciTc!, bildirimci)
              .then((value) {
            addBildirimciToService(bildirimci);
          });
        } catch (e) {

        }
      } else {
        return;
      }
    });
  }

  Future<void> addBildirimciToService(Bildirimci bildirimciout) async {
    if (kayitliKisi!.sifatlar.ext.isNotNullOrEmpty) {
      var response =
          await FirestoreService.instance.saveBildirimciTc(bildirimciout);
      await addUserToService(bildirimciout);

      if (response.error != null) {
      } else {

      }
    } else {}
  }

  Future<void> addUserToService(Bildirimci bildirimci) async {
    String? number =
        AppCacheManager.instance.getItem(PreferencesKeys.phone.name);
    if (number != null) {
      MyUser? user = UserCacheManager.instance.getItem(number);
      if (user != null) {
        MyUser userForService = MyUser.fromJson(user.toJson());
        userForService.tcList ??= [];
        userForService.tcList!.add(bildirimci.bildirimciTc!);

        var response =
            await FirestoreService.instance.saveUserInformations(user);
        if (response.error != null) {
        } else {

        }
      } else {}
    } else {}
  }

  Future<bool> kayitliKisiSorguNew(Bildirimci bildirimci) async {
    var result = await BildirimService.instance
        .bildirimKayitliKisiSorguWithModel(bildirimci.bildirimciTc!);
    if (result != null) {
      if (result.kayitliKisimi?.toLowerCase() == true.toString()) {
        if (result.sifatlar.isEmpty) {
          return false;
        }

        kayitliKisi = result;

        return true;
      }
    }
    return false;
  }

  clearAllGidecegiYerInfos() {
    halIciIsyerleriNew = [];
    subeler = [];
    depolar = [];
    kayitliKisi = null;
  }

  Future<void> checkGidecegiYerUpdateExtension() async {
    BildirimciCacheManager.instance.getValues()?.forEach((element) async {
      clearAllGidecegiYerInfos();




      if (element.gidecegiYerUpdated != true) {


        var result = await kayitliKisiSorguNew(element);
        if (result) {
          await fetchAllDepoSubeHalIciIsyerleri(element).then(
            (value) {
              fetchInfosAndAddToDb(element);
            },
          );

          //  emit(UpdateUserInformationsUserFound());
        } else {
          return;
        }
        // fetchAllDepoSubeHalIciIsyerleri(element);
      }
    });
  }

  Future<bool> fetchAllDepoSubeHalIciIsyerleri(Bildirimci bildirimci) async {
    try {
      return Future.wait([
        halIciIsyeriSorguNew(bildirimci),
        depolarSorgu(bildirimci),
        subelerSorgu(bildirimci)
      ]).then((value) {
        if (halIciIsyerleriNew.isEmpty && depolar.isEmpty && subeler.isEmpty) {
          return false;
        }
        return true;
      });
    } catch (e) {
      return false;
    }
  }

  Future<void> halIciIsyeriSorguNew(Bildirimci bildirimci) async {


    var result = await GeneralService.instance
        .fetchAllHalIciIsyerleriWithModelNew(bildirimci.bildirimciTc!);


    for (var element in result) {


    }
    if (result.isNotEmpty) {
      halIciIsyerleriNew = result;
      List<HalIciIsyeri> listForDb = [];

      for (var element in halIciIsyerleriNew) {
        listForDb.add(HalIciIsyeri.fromJson(element.toJson()));
      }
      await HalIciIsyeriCacheManager.instance
          .putItem(bildirimci.bildirimciTc!, listForDb);
    }
  }

  Future<void> subelerSorgu(Bildirimci bildirimci) async {
    var result = await GeneralService.instance
        .fetchSubelerWithModel(bildirimci.bildirimciTc!);


    for (var element in result) {


    }
    if (result.isNotEmpty) {
      subeler = result;
      List<Sube> listForDb = [];

      for (var element in subeler) {
        listForDb.add(Sube.fromJson(element.toJson()));
      }
      await SubelerCacheManager.instance
          .putItem(bildirimci.bildirimciTc!, listForDb);
    }
  }

  Future<void> depolarSorgu(Bildirimci bildirimci) async {
    var result = await GeneralService.instance
        .fetchDepolarWithModel(bildirimci.bildirimciTc!);


    for (var element in result) {


    }
    if (result.isNotEmpty) {
      depolar = result;
      List<Depo> listForDb = [];

      for (var element in depolar) {
        listForDb.add(Depo.fromJson(element.toJson()));
      }
      await DepolarCacheManager.instance
          .putItem(bildirimci.bildirimciTc!, listForDb);
    }
  }
}
