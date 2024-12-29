import 'package:hive_flutter/adapters.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../core/model/base_model/base_model.dart';

part 'my_user_model.g.dart';

@HiveType(typeId: 1)
@JsonSerializable()
class MyUser extends HiveObject implements BaseModel {
  @HiveField(0)
  String? name;
  //@JsonKey(ignore: true)
  var updatedAt;
  @HiveField(1)
  int? level;
  @HiveField(2)
  String? phoneNumber;
  @HiveField(3)
  List<String>? tcList;
  @HiveField(4)
  String? subscriptionId;
  @HiveField(5)
  String? revenueCatSubscriptionId;
  @HiveField(6, defaultValue: 0)
  int? subscriptionNumber;
  @HiveField(7)
  String? password;

  MyUser(
      {this.name,
      this.updatedAt,
      this.level,
      this.phoneNumber,
      this.subscriptionId,
      this.tcList,
      this.revenueCatSubscriptionId,
      this.subscriptionNumber,
      this.password});

  factory MyUser.fromJson(Map<String, dynamic> json) => _$MyUserFromJson(json);

  @override
  fromJson(Map<String, dynamic> json) => _$MyUserFromJson(json);

  @override
  Map<String, Object?> toJson() => _$MyUserToJson(this);

  @override
  String toString() {
    // TODO: implement toString
    return "name: $name, level: $level, phoneNumber: $phoneNumber, tcList: $tcList, subscriptionId: $subscriptionId, revenueCatSubscriptionId: $revenueCatSubscriptionId, subscriptionNumber: $subscriptionNumber, password: $password";
  }
}
