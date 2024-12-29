import 'package:cloud_firestore/cloud_firestore.dart';
import '../../service/firebase/firestore/firestore_service.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../core/model/base_model/base_model.dart';
import '../user/my_user_model.dart';

part 'subscription_model.g.dart';

@JsonSerializable()
class Subscription implements BaseModel {

  //@JsonKey(name: 'time', toJson: timeToJson)
  DateTime? time;
  @JsonKey(name: 'user', toJson: userToJson)
  MyUser? user;

  Subscription({this.user,required this.time}) {
    //var date = new DateTime.fromMicrosecondsSinceEpoch();
    // var date = new DateTime.fromMicrosecondsSinceEpoch(timestamp);
    // time = FieldValue.serverTimestamp();
    // time = FieldValue.serverTimestamp().toString();
  }
 

  factory Subscription.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionFromJson(json);

  @override
  fromJson(Map<String,  dynamic> json) => _$SubscriptionFromJson(json);

  @override
  Map<String, Object?> toJson() => _$SubscriptionToJson(this);
}

Map<String, Object?>? userToJson(MyUser? user) {
  return user?.toJson();
}

//FieldValue timeToJson(String? a) {
//  return FieldValue.serverTimestamp();
//}
