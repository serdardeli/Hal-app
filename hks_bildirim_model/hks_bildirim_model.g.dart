// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hks_bildirim_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HksBildirim _$HksBildirimFromJson(Map<String, dynamic> json) => HksBildirim(
      malId: json['malId'] as String,
      malinCinsiId: json['malinCinsiId'] as String,
      uretimSekliId: json['uretimSekliId'] as String,
      malinMiktarBirimId: json['malinMiktarBirimId'] as String,
      malinNiteligiId: json['malinNiteligiId'] as String,
      uretimBeldeId: json['uretimBeldeId'] as String,
      uretimIlId: json['uretimIlId'] as String,
      uretimIlceId: json['uretimIlceId'] as String,
      malinMiktari: json['malinMiktari'] as String,
      malinSatisFiyat: json['malinSatisFiyat'] as String? ?? "0",
      bilidirimTuruId: json['bilidirimTuruId'] as String,
      bildirimciKisiSifatId: json['bildirimciKisiSifatId'] as String,
      ikinciKisiAdiSoyadi: json['ikinciKisiAdiSoyadi'] as String? ?? "",
      ceptel: json['ceptel'] as String? ?? "",
      ikinciKisiSifat: json['ikinciKisiSifat'] as String? ?? "",
      ikinciKisiTcVergiNo: json['ikinciKisiTcVergiNo'] as String? ?? "",
      aracPlakaNo: json['aracPlakaNo'] as String,
      belgeNo: json['belgeNo'] as String? ?? "0",
      belgeTipi: json['belgeTipi'] as String,
      gidecegiIsyeriId: json['gidecegiIsyeriId'] as String,
      gidecegiYerBeldeId: json['gidecegiYerBeldeId'] as String? ?? "0",
      gidecegiYerIlId: json['gidecegiYerIlId'] as String? ?? "0",
      gidecegiYerIlceId: json['gidecegiYerIlceId'] as String? ?? "0",
      gidecegiYerIsletmeTuruId: json['gidecegiYerIsletmeTuruId'] as String,
      uniqueId: json['uniqueId'] as String,
      referansBildirimKunyeNo:
          json['referansBildirimKunyeNo'] as String? ?? "0",
    )..isAnaliz = json['isAnaliz'] as bool;

Map<String, dynamic> _$HksBildirimToJson(HksBildirim instance) =>
    <String, dynamic>{
      'malId': instance.malId,
      'malinCinsiId': instance.malinCinsiId,
      'uretimSekliId': instance.uretimSekliId,
      'malinNiteligiId': instance.malinNiteligiId,
      'malinMiktarBirimId': instance.malinMiktarBirimId,
      'uretimBeldeId': instance.uretimBeldeId,
      'uretimIlId': instance.uretimIlId,
      'uretimIlceId': instance.uretimIlceId,
      'isAnaliz': instance.isAnaliz,
      'malinMiktari': instance.malinMiktari,
      'malinSatisFiyat': instance.malinSatisFiyat,
      'bilidirimTuruId': instance.bilidirimTuruId,
      'bildirimciKisiSifatId': instance.bildirimciKisiSifatId,
      'ikinciKisiAdiSoyadi': instance.ikinciKisiAdiSoyadi,
      'ceptel': instance.ceptel,
      'ikinciKisiSifat': instance.ikinciKisiSifat,
      'ikinciKisiTcVergiNo': instance.ikinciKisiTcVergiNo,
      'aracPlakaNo': instance.aracPlakaNo,
      'belgeNo': instance.belgeNo,
      'belgeTipi': instance.belgeTipi,
      'gidecegiIsyeriId': instance.gidecegiIsyeriId,
      'gidecegiYerBeldeId': instance.gidecegiYerBeldeId,
      'gidecegiYerIlId': instance.gidecegiYerIlId,
      'gidecegiYerIlceId': instance.gidecegiYerIlceId,
      'gidecegiYerIsletmeTuruId': instance.gidecegiYerIsletmeTuruId,
      'referansBildirimKunyeNo': instance.referansBildirimKunyeNo,
      'uniqueId': instance.uniqueId,
    };
