// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bildirim_kayit_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BildirimKayitResponseModel _$BildirimKayitResponseModelFromJson(
        Map<String, dynamic> json) =>
    BildirimKayitResponseModel(
      islemKodu: json['islemKodu'] as String?,
      message:
          (json['message'] as List<dynamic>?)?.map((e) => e as String).toList(),
      kayitCevapList: (json['kayitCevapList'] as List<dynamic>?)
          ?.map((e) =>
              BildirimKayitCevapModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$BildirimKayitResponseModelToJson(
        BildirimKayitResponseModel instance) =>
    <String, dynamic>{
      'islemKodu': instance.islemKodu,
      'message': instance.message,
      'kayitCevapList': instance.kayitCevapList,
    };
