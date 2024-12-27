// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_user_for_sort.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyUserForSort _$MyUserForSortFromJson(Map<String, dynamic> json) =>
    MyUserForSort(
      name: json['name'] as String?,
      updatedAt: json['updatedAt'],
      level: json['level'] as int?,
      phoneNumber: json['phoneNumber'] as String?,
      subscriptionId: json['subscriptionId'] as String?,
      tcList:
          (json['tcList'] as List<dynamic>?)?.map((e) => e as String).toList(),
      revenueCatSubscriptionId: json['revenueCatSubscriptionId'] as String?,
      subscriptionNumber: json['subscriptionNumber'] as int?,
      bildirimci: (json['bildirimci'] as List<dynamic>?)
          ?.map((e) => Bildirimci.fromJson(e as Map<String, dynamic>))
          .toList(),
      startModel: json['startModel'] == null
          ? null
          : SubscriptionStartModel.fromJson(
              json['startModel'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MyUserForSortToJson(MyUserForSort instance) =>
    <String, dynamic>{
      'name': instance.name,
      'updatedAt': instance.updatedAt,
      'level': instance.level,
      'phoneNumber': instance.phoneNumber,
      'tcList': instance.tcList,
      'subscriptionId': instance.subscriptionId,
      'revenueCatSubscriptionId': instance.revenueCatSubscriptionId,
      'subscriptionNumber': instance.subscriptionNumber,
      'startModel': instance.startModel,
      'bildirimci': instance.bildirimci,
    };
