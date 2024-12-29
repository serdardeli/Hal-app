import 'package:hal_app/project/model/subscription_start_model/subscription_start_model.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../core/model/base_model/base_model.dart';
import '../bildirimci/bildirimci_model.dart';

part 'my_user_for_sort.g.dart';

@JsonSerializable()
class MyUserForSort implements BaseModel {
  String? name;
  //@JsonKey(ignore: true)
  var updatedAt;
  int? level;
  String? phoneNumber;
  List<String>? tcList;
  String? subscriptionId;
  String? revenueCatSubscriptionId;
  int? subscriptionNumber;
  SubscriptionStartModel? startModel;
  List<Bildirimci>? bildirimci = [];

  MyUserForSort(
      {this.name,
      this.updatedAt,
      this.level,
      this.phoneNumber,
      this.subscriptionId,
      this.tcList,
      this.revenueCatSubscriptionId,
      this.subscriptionNumber,
      this.bildirimci,this.startModel});

  factory MyUserForSort.fromJson(Map<String, dynamic> json) =>
      _$MyUserForSortFromJson(json);

  @override
  fromJson(Map<String, dynamic> json) => _$MyUserForSortFromJson(json);
  addBildirimci(Bildirimci bildirimci) {
    if (this.bildirimci == null) {
      this.bildirimci = [];
    }
    (this.bildirimci)!.add(bildirimci);
  }

  @override
  Map<String, Object?> toJson() => _$MyUserForSortToJson(this);
}
/**
 * {three_person_one_month: EntitlementInfo(identifier: three_person_one_month, isActive: true, willRenew: true, latestPurchaseDate: 2022-07-27T15:21:00.000Z, originalPurchaseDate: 2022-07-27T15:21:00.000Z, productIdentifier: three_person_one_month, isSandbox: true, ownershipType: OwnershipType.unknown, store: Store.playStore, periodType: PeriodType.normal, expirationDate: 2022-07-27T15:27:57.000Z, unsubscribeDetectedAt: null, billingIssueDetectedAt: null)}
 */