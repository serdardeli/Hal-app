import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import '../urun/urun.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../core/model/base_model/base_model.dart';
import '../uretici_model/uretici_model.dart';

part 'custom_notification_save_model.g.dart';

urunListFromJson(dynamic map) {
  if (map != null) {


    if (map.runtimeType.toString() == "List<Urun>") {
      return map;
    } else {
      return (map as List<dynamic>)
          .map((e) => Map<String, dynamic>.from(e))
          .toList()
          .cast<Map>();
    }
  }

  return null;
}

ureticiFromJson(dynamic map) {
  if (map != null) {
    return Map<String, dynamic>.from(map);
  }

  return null;
}

@HiveType(typeId: 6)
@JsonSerializable()
class CustomNotificationSaveModel extends HiveObject {
  @HiveField(0)
  @JsonKey(fromJson: ureticiFromJson)
  Map? uretici;
  @HiveField(1)
  bool isToplama;
  @HiveField(2)
  int? totalAddedCount;
  @JsonKey(fromJson: urunListFromJson)
  @HiveField(3)
  List<Map> urunList;
  @HiveField(4)
  String bildirimAdi;
  @HiveField(5, defaultValue: "")
  String? ilAdi;
  @HiveField(6, defaultValue: "")
  String? ilceAdi;
  @HiveField(7, defaultValue: "")
  String? beldeAdi;
  @HiveField(8, defaultValue: "")
  String? ilId;
  @HiveField(9, defaultValue: "")
  String? beldeId;
  @HiveField(10, defaultValue: "")
  String? ilceId;
  @HiveField(11, defaultValue: "")
  String plaka;
  @HiveField(12)
  String? kunyeNo;
  @HiveField(14)
  int? weeklyAddedCount;
  @HiveField(15)
  String? date;
  @HiveField(16)
  String? gidecegiYerAdi;
  @HiveField(17)
  String? gidecegiYerType;
  @HiveField(18)
  String? selectedSifatType;
  @HiveField(19)
  String? selectedSifatId;
  @HiveField(20)
  String? gidecegiYerIsletmeTuruId;
  @HiveField(21)
  String? gidecegiYerIsletmeTuruAdi;
  @HiveField(22)
  String? gidecegiIsyeriId;
    @HiveField(23)
  String? adres;

  static CustomNotificationSaveModel getFakeModel() {
    return CustomNotificationSaveModel(
        bildirimAdi: "", isToplama: false, urunList: [], plaka: "");
  }

  CustomNotificationSaveModel(
      {this.uretici,
      required this.isToplama,
      this.totalAddedCount,
      required this.urunList,
      required this.bildirimAdi,
      required this.plaka,
      this.adres,
      this.beldeAdi,
      this.beldeId,
      this.ilAdi,
      this.ilId,
      this.ilceAdi,
      this.ilceId,
      this.kunyeNo,
      this.weeklyAddedCount,
      this.date,
      this.gidecegiYerAdi,
      this.gidecegiYerType,
      this.selectedSifatType,
      this.selectedSifatId,
      this.gidecegiYerIsletmeTuruAdi,
      this.gidecegiYerIsletmeTuruId,
      this.gidecegiIsyeriId});
  @override
  bool operator ==(Object other) {
    Function unOrdDeepEq = const DeepCollectionEquality.unordered().equals;
    List<Urun> thisUrunList = urunList
        .map((e) => Urun.fromJson(Map<String, dynamic>.from(e)))
        .toList()
        .cast<Urun>();
    List<Urun> otherUrunList = (other as CustomNotificationSaveModel).urunList
        .map((e) => Urun.fromJson(Map<String, dynamic>.from(e)))
        .toList()
        .cast<Urun>();




    return identical(this, other) ||
        runtimeType == other.runtimeType &&
            compareUretici(other.uretici) &&
            isToplama == other.isToplama &&
            unOrdDeepEq(thisUrunList, otherUrunList);
  }

  compareUretici(Map<dynamic, dynamic>? other) {
    if (uretici == null && other == null) {
      return true;
    } else if (uretici != null && other == null) {
      return false;
    } else if (uretici == null && other != null) {
      return false;
    } else {
      return Uretici.fromJson(Map<String, dynamic>.from(uretici!)) ==
          Uretici.fromJson(Map<String, dynamic>.from(other!));
    }
  }

  @override
  int get hashCode => Object.hash(uretici, isToplama, urunList);
  //factory MyUser.fromJson(Map<String, dynamic> json) => _$MyUserFromJson(json);

  static fromJson(Map<String, dynamic> json) =>
      _$CustomNotificationSaveModelFromJson(json);

  @override
  Map<String, Object?> toJson() => _$CustomNotificationSaveModelToJson(this);

  int incrementTotalAddedCount() {
    totalAddedCount = ((totalAddedCount ?? 0) + 1);
    return totalAddedCount!;
  }

  int incrementWeeklyAddedCount() {
    weeklyAddedCount = ((weeklyAddedCount ?? 0) + 1);
    return weeklyAddedCount!;
  }
}
/**
 * {three_person_one_month: EntitlementInfo(identifier: three_person_one_month, isActive: true, willRenew: true, latestPurchaseDate: 2022-07-27T15:21:00.000Z, originalPurchaseDate: 2022-07-27T15:21:00.000Z, productIdentifier: three_person_one_month, isSandbox: true, ownershipType: OwnershipType.unknown, store: Store.playStore, periodType: PeriodType.normal, expirationDate: 2022-07-27T15:27:57.000Z, unsubscribeDetectedAt: null, billingIssueDetectedAt: null)}
 */