// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sube_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SubeAdapter extends TypeAdapter<Sube> {
  @override
  final int typeId = 10;

  @override
  Sube read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Sube(
      adres: fields[0] as String?,
      beldeId: fields[1] as String?,
      subeId: fields[2] as String?,
      ilId: fields[3] as String?,
      ilceId: fields[4] as String?,
      isletmeTuruId: fields[5] as String?,
      isletmeTuruAdi: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Sube obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.adres)
      ..writeByte(1)
      ..write(obj.beldeId)
      ..writeByte(2)
      ..write(obj.subeId)
      ..writeByte(3)
      ..write(obj.ilId)
      ..writeByte(4)
      ..write(obj.ilceId)
      ..writeByte(5)
      ..write(obj.isletmeTuruId)
      ..writeByte(6)
      ..write(obj.isletmeTuruAdi);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Sube _$SubeFromJson(Map<String, dynamic> json) => Sube(
      adres: json['adres'] as String?,
      beldeId: json['beldeId'] as String?,
      subeId: json['subeId'] as String?,
      ilId: json['ilId'] as String?,
      ilceId: json['ilceId'] as String?,
      isletmeTuruId: json['isletmeTuruId'] as String?,
      isletmeTuruAdi: json['isletmeTuruAdi'] as String?,
    );

Map<String, dynamic> _$SubeToJson(Sube instance) => <String, dynamic>{
      'adres': instance.adres,
      'beldeId': instance.beldeId,
      'subeId': instance.subeId,
      'ilId': instance.ilId,
      'ilceId': instance.ilceId,
      'isletmeTuruId': instance.isletmeTuruId,
      'isletmeTuruAdi': instance.isletmeTuruAdi,
    };
