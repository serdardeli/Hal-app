// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bildirim_kayit_cevap_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BildirimKayitCevapModel _$BildirimKayitCevapModelFromJson(
        Map<String, dynamic> json) =>
    BildirimKayitCevapModel(
      aracPlakaNo: json['aracPlakaNo'] as String?,
      kunyeNo: json['kunyeNo'] as String?,
      kayitTarihi: json['kayitTarihi'] as String?,
      uniqueId: json['uniqueId'] as String?,
      malinId: json['malinId'] as String?,
      malinCinsiId: json['malinCinsiId'] as String?,
      message: json['message'] as String?,
      malinAdi: json['malinAdi'] as String?,
      malinCinsi: json['malinCinsi'] as String?,
      malinMiktari: json['malinMiktari'] as String?,
      malinMiktarBirimId: json['malinMiktarBirimId'] as String?,
    )..malinMiktarBirimAdi = json['malinMiktarBirimAdi'] as String?;

Map<String, dynamic> _$BildirimKayitCevapModelToJson(
        BildirimKayitCevapModel instance) =>
    <String, dynamic>{
      'aracPlakaNo': instance.aracPlakaNo,
      'kunyeNo': instance.kunyeNo,
      'kayitTarihi': instance.kayitTarihi,
      'uniqueId': instance.uniqueId,
      'malinId': instance.malinId,
      'malinCinsiId': instance.malinCinsiId,
      'message': instance.message,
      'malinAdi': instance.malinAdi,
      'malinCinsi': instance.malinCinsi,
      'malinMiktari': instance.malinMiktari,
      'malinMiktarBirimId': instance.malinMiktarBirimId,
      'malinMiktarBirimAdi': instance.malinMiktarBirimAdi,
    };
