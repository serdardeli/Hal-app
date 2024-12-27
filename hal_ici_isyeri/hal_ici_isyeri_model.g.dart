// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hal_ici_isyeri_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HalIciIsyeriAdapter extends TypeAdapter<HalIciIsyeri> {
  @override
  final int typeId = 12;

  @override
  HalIciIsyeri read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HalIciIsyeri(
      halAdi: fields[0] as String?,
      halId: fields[1] as String?,
      isYeriSahibiTc: fields[4] as String?,
      isyeriAdi: fields[3] as String?,
      isyeriId: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, HalIciIsyeri obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.halAdi)
      ..writeByte(1)
      ..write(obj.halId)
      ..writeByte(2)
      ..write(obj.isyeriId)
      ..writeByte(3)
      ..write(obj.isyeriAdi)
      ..writeByte(4)
      ..write(obj.isYeriSahibiTc);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HalIciIsyeriAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HalIciIsyeri _$HalIciIsyeriFromJson(Map<String, dynamic> json) => HalIciIsyeri(
      halAdi: json['halAdi'] as String?,
      halId: json['halId'] as String?,
      isYeriSahibiTc: json['isYeriSahibiTc'] as String?,
      isyeriAdi: json['isyeriAdi'] as String?,
      isyeriId: json['isyeriId'] as String?,
    )
      ..isletmeTuruId = json['isletmeTuruId'] as String
      ..isletmeTuruAdi = json['isletmeTuruAdi'] as String;

Map<String, dynamic> _$HalIciIsyeriToJson(HalIciIsyeri instance) =>
    <String, dynamic>{
      'halAdi': instance.halAdi,
      'halId': instance.halId,
      'isyeriId': instance.isyeriId,
      'isyeriAdi': instance.isyeriAdi,
      'isYeriSahibiTc': instance.isYeriSahibiTc,
      'isletmeTuruId': instance.isletmeTuruId,
      'isletmeTuruAdi': instance.isletmeTuruAdi,
    };
