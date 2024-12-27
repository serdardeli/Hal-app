// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'malin_gidecegi_yer_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GidecegiYer _$GidecegiYerFromJson(Map<String, dynamic> json) => GidecegiYer(
      type: json['type'] as String,
      name: json['name'] as String,
      isletmeTuru: json['isletmeTuru'] as String,
      isletmeTuruId: json['isletmeTuruId'] as String,
      isyeriId: json['isyeriId'] as String,
      adres: json['adres'] as String,
    );

Map<String, dynamic> _$GidecegiYerToJson(GidecegiYer instance) =>
    <String, dynamic>{
      'type': instance.type,
      'name': instance.name,
      'isletmeTuru': instance.isletmeTuru,
      'isletmeTuruId': instance.isletmeTuruId,
      'isyeriId': instance.isyeriId,
      'adres': instance.adres,
    };
