// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'depo_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DepoAdapter extends TypeAdapter<Depo> {
  @override
  final int typeId = 11;

  @override
  Depo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Depo(
      adres: fields[0] as String?,
      beldeId: fields[1] as String?,
      depoId: fields[2] as String?,
      ilId: fields[3] as String?,
      depoAdi: fields[7] as String?,
      ilceId: fields[4] as String?,
      isletmeTuruId: fields[5] as String?,
      halIcimi: fields[6] as String?,
      isletmeTuruAdi: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Depo obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.adres)
      ..writeByte(1)
      ..write(obj.beldeId)
      ..writeByte(2)
      ..write(obj.depoId)
      ..writeByte(3)
      ..write(obj.ilId)
      ..writeByte(4)
      ..write(obj.ilceId)
      ..writeByte(5)
      ..write(obj.isletmeTuruId)
      ..writeByte(6)
      ..write(obj.halIcimi)
      ..writeByte(7)
      ..write(obj.depoAdi)
      ..writeByte(8)
      ..write(obj.isletmeTuruAdi);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DepoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Depo _$DepoFromJson(Map<String, dynamic> json) => Depo(
      adres: json['adres'] as String?,
      beldeId: json['beldeId'] as String?,
      depoId: json['depoId'] as String?,
      ilId: json['ilId'] as String?,
      depoAdi: json['depoAdi'] as String?,
      ilceId: json['ilceId'] as String?,
      isletmeTuruId: json['isletmeTuruId'] as String?,
      halIcimi: json['halIcimi'] as String?,
      isletmeTuruAdi: json['isletmeTuruAdi'] as String?,
    );

Map<String, dynamic> _$DepoToJson(Depo instance) => <String, dynamic>{
      'adres': instance.adres,
      'beldeId': instance.beldeId,
      'depoId': instance.depoId,
      'ilId': instance.ilId,
      'ilceId': instance.ilceId,
      'isletmeTuruId': instance.isletmeTuruId,
      'halIcimi': instance.halIcimi,
      'depoAdi': instance.depoAdi,
      'isletmeTuruAdi': instance.isletmeTuruAdi,
    };
