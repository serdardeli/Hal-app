// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'musteri_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MusteriAdapter extends TypeAdapter<Musteri> {
  @override
  final int typeId = 15;

  @override
  Musteri read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Musteri(
      musteriAdiSoyadi: fields[0] as String,
      musteriSifatIdList: (fields[3] as List).cast<String>(),
      musteriSifatNameList: (fields[4] as List).cast<String>(),
      musteriTc: fields[2] as String,
      musteriTel: fields[1] as String?,
      isregisteredToHks: fields[5] as bool,
      musteriBeldeAdi: fields[8] as String?,
      musteriBeldeId: fields[11] as String?,
      musteriIlAdi: fields[6] as String?,
      musteriIlId: fields[9] as String?,
      musteriIlceAdi: fields[7] as String?,
      musteriIlceId: fields[10] as String?,
      selectedNotFoundMalinGidecegiYerAdi: fields[12] as String?,
      selectedNotFoundMalinGidecegiYerId: fields[13] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Musteri obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.musteriAdiSoyadi)
      ..writeByte(1)
      ..write(obj.musteriTel)
      ..writeByte(2)
      ..write(obj.musteriTc)
      ..writeByte(3)
      ..write(obj.musteriSifatIdList)
      ..writeByte(4)
      ..write(obj.musteriSifatNameList)
      ..writeByte(5)
      ..write(obj.isregisteredToHks)
      ..writeByte(6)
      ..write(obj.musteriIlAdi)
      ..writeByte(7)
      ..write(obj.musteriIlceAdi)
      ..writeByte(8)
      ..write(obj.musteriBeldeAdi)
      ..writeByte(9)
      ..write(obj.musteriIlId)
      ..writeByte(10)
      ..write(obj.musteriIlceId)
      ..writeByte(11)
      ..write(obj.musteriBeldeId)
      ..writeByte(12)
      ..write(obj.selectedNotFoundMalinGidecegiYerAdi)
      ..writeByte(13)
      ..write(obj.selectedNotFoundMalinGidecegiYerId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MusteriAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Musteri _$MusteriFromJson(Map<String, dynamic> json) => Musteri(
      musteriAdiSoyadi: json['musteriAdiSoyadi'] as String,
      musteriSifatIdList: (json['musteriSifatIdList'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      musteriSifatNameList: (json['musteriSifatNameList'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      musteriTc: json['musteriTc'] as String,
      musteriTel: json['musteriTel'] as String?,
      isregisteredToHks: json['isregisteredToHks'] as bool,
      musteriBeldeAdi: json['musteriBeldeAdi'] as String?,
      musteriBeldeId: json['musteriBeldeId'] as String?,
      musteriIlAdi: json['musteriIlAdi'] as String?,
      musteriIlId: json['musteriIlId'] as String?,
      musteriIlceAdi: json['musteriIlceAdi'] as String?,
      musteriIlceId: json['musteriIlceId'] as String?,
      selectedNotFoundMalinGidecegiYerAdi:
          json['selectedNotFoundMalinGidecegiYerAdi'] as String?,
      selectedNotFoundMalinGidecegiYerId:
          json['selectedNotFoundMalinGidecegiYerId'] as String?,
    );

Map<String, dynamic> _$MusteriToJson(Musteri instance) => <String, dynamic>{
      'musteriAdiSoyadi': instance.musteriAdiSoyadi,
      'musteriTel': instance.musteriTel,
      'musteriTc': instance.musteriTc,
      'musteriSifatIdList': instance.musteriSifatIdList,
      'musteriSifatNameList': instance.musteriSifatNameList,
      'isregisteredToHks': instance.isregisteredToHks,
      'musteriIlAdi': instance.musteriIlAdi,
      'musteriIlceAdi': instance.musteriIlceAdi,
      'musteriBeldeAdi': instance.musteriBeldeAdi,
      'musteriIlId': instance.musteriIlId,
      'musteriIlceId': instance.musteriIlceId,
      'musteriBeldeId': instance.musteriBeldeId,
      'selectedNotFoundMalinGidecegiYerAdi':
          instance.selectedNotFoundMalinGidecegiYerAdi,
      'selectedNotFoundMalinGidecegiYerId':
          instance.selectedNotFoundMalinGidecegiYerId,
    };
