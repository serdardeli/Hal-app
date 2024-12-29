import 'package:hive_flutter/adapters.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../core/model/base_model/base_model.dart';

part 'subscription_start_model.g.dart';

@HiveType(typeId: 1)
@JsonSerializable()
class SubscriptionStartModel extends HiveObject implements BaseModel {
  @HiveField(0)
  String? subscriptionStartDate;
  @HiveField(1)
  String? isFreeSubscriptionUsed;

  SubscriptionStartModel(
      {this.isFreeSubscriptionUsed, this.subscriptionStartDate});

  factory SubscriptionStartModel.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionStartModelFromJson(json);

  @override
  fromJson(Map<String, dynamic> json) => _$SubscriptionStartModelFromJson(json);

  @override
  Map<String, Object?> toJson() => _$SubscriptionStartModelToJson(this);
}
