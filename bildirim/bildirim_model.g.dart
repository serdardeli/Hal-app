// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bildirim_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BildirimAdapter extends TypeAdapter<Bildirim> {
  @override
  final int typeId = 3;

  @override
  Bildirim read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Bildirim(
      bildirimciSoyadi: fields[5] as String?,
      malId: fields[0] as String?,
      malinCinsiId: fields[1] as String?,
      malinMiktarBirimId: fields[4] as String?,
      malinNiteligiId: fields[3] as String?,
      uretimBeldeId: fields[6] as String?,
      uretimIlId: fields[7] as String?,
      uretimIlceId: fields[8] as String?,
      uretimSekliId: fields[2] as String?,
      ikiniciKisiSirketAdi: fields[9] as String?,
      malAdi: fields[10] as String?,
      addedCount: fields[11] == null ? 0 : fields[11] as int?,
      bildirimId: fields[12] as String?,
      selectedUretici: (fields[13] as Map?)?.cast<dynamic, dynamic>(),
      isToplamaMal: fields[14] as String?,
      bildirimAdi: fields[15] as String?,
      malCinsAdi: fields[16] as String?,
      plakaNo: fields[18] as String?,
      kunyeNo: fields[17] as String?,
      islemKodu: fields[19] as String?,
    )..kayitTarihi = fields[20] as String?;
  }

  @override
  void write(BinaryWriter writer, Bildirim obj) {
    writer
      ..writeByte(21)
      ..writeByte(0)
      ..write(obj.malId)
      ..writeByte(1)
      ..write(obj.malinCinsiId)
      ..writeByte(2)
      ..write(obj.uretimSekliId)
      ..writeByte(3)
      ..write(obj.malinNiteligiId)
      ..writeByte(4)
      ..write(obj.malinMiktarBirimId)
      ..writeByte(5)
      ..write(obj.bildirimciSoyadi)
      ..writeByte(6)
      ..write(obj.uretimBeldeId)
      ..writeByte(7)
      ..write(obj.uretimIlId)
      ..writeByte(8)
      ..write(obj.uretimIlceId)
      ..writeByte(9)
      ..write(obj.ikiniciKisiSirketAdi)
      ..writeByte(10)
      ..write(obj.malAdi)
      ..writeByte(11)
      ..write(obj.addedCount)
      ..writeByte(12)
      ..write(obj.bildirimId)
      ..writeByte(13)
      ..write(obj.selectedUretici)
      ..writeByte(14)
      ..write(obj.isToplamaMal)
      ..writeByte(15)
      ..write(obj.bildirimAdi)
      ..writeByte(16)
      ..write(obj.malCinsAdi)
      ..writeByte(17)
      ..write(obj.kunyeNo)
      ..writeByte(18)
      ..write(obj.plakaNo)
      ..writeByte(19)
      ..write(obj.islemKodu)
      ..writeByte(20)
      ..write(obj.kayitTarihi);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BildirimAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Bildirim _$BildirimFromJson(Map<String, dynamic> json) => Bildirim(
      bildirimciSoyadi: json['bildirimciSoyadi'] as String?,
      malId: json['malId'] as String?,
      malinCinsiId: json['malinCinsiId'] as String?,
      malinMiktarBirimId: json['malinMiktarBirimId'] as String?,
      malinNiteligiId: json['malinNiteligiId'] as String?,
      uretimBeldeId: json['uretimBeldeId'] as String?,
      uretimIlId: json['uretimIlId'] as String?,
      uretimIlceId: json['uretimIlceId'] as String?,
      uretimSekliId: json['uretimSekliId'] as String?,
      ikiniciKisiSirketAdi: json['ikiniciKisiSirketAdi'] as String?,
      malAdi: json['malAdi'] as String?,
      addedCount: json['addedCount'] as int?,
      bildirimId: json['bildirimId'] as String?,
      selectedUretici: userFromJson(json['selectedUretici']),
      isToplamaMal: json['isToplamaMal'] as String?,
      bildirimAdi: json['bildirimAdi'] as String?,
      malCinsAdi: json['malCinsAdi'] as String?,
      plakaNo: json['plakaNo'] as String?,
      kunyeNo: json['kunyeNo'] as String?,
      islemKodu: json['islemKodu'] as String?,
    )..kayitTarihi = json['kayitTarihi'] as String?;

Map<String, dynamic> _$BildirimToJson(Bildirim instance) => <String, dynamic>{
      'malId': instance.malId,
      'malinCinsiId': instance.malinCinsiId,
      'uretimSekliId': instance.uretimSekliId,
      'malinNiteligiId': instance.malinNiteligiId,
      'malinMiktarBirimId': instance.malinMiktarBirimId,
      'bildirimciSoyadi': instance.bildirimciSoyadi,
      'uretimBeldeId': instance.uretimBeldeId,
      'uretimIlId': instance.uretimIlId,
      'uretimIlceId': instance.uretimIlceId,
      'ikiniciKisiSirketAdi': instance.ikiniciKisiSirketAdi,
      'malAdi': instance.malAdi,
      'addedCount': instance.addedCount,
      'bildirimId': instance.bildirimId,
      'selectedUretici': instance.selectedUretici,
      'isToplamaMal': instance.isToplamaMal,
      'bildirimAdi': instance.bildirimAdi,
      'malCinsAdi': instance.malCinsAdi,
      'kunyeNo': instance.kunyeNo,
      'plakaNo': instance.plakaNo,
      'islemKodu': instance.islemKodu,
      'kayitTarihi': instance.kayitTarihi,
    };
