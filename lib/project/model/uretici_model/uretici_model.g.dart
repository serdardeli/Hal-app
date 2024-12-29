// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'uretici_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UreticiAdapter extends TypeAdapter<Uretici> {
  @override
  final int typeId = 7;

  @override
  Uretici read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Uretici(
      ureticiAdiSoyadi: fields[0] as String,
      ureticiSifatId: fields[3] as String,
      ureticiTc: fields[2] as String,
      ureticiTel: fields[1] as String,
      ureticiBeldeAdi: fields[6] as String,
      ureticiBeldeId: fields[9] as String,
      ureticiIlAdi: fields[4] as String,
      ureticiIlId: fields[7] as String,
      ureticiIlceAdi: fields[5] as String,
      ureticiIlceId: fields[8] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Uretici obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.ureticiAdiSoyadi)
      ..writeByte(1)
      ..write(obj.ureticiTel)
      ..writeByte(2)
      ..write(obj.ureticiTc)
      ..writeByte(3)
      ..write(obj.ureticiSifatId)
      ..writeByte(4)
      ..write(obj.ureticiIlAdi)
      ..writeByte(5)
      ..write(obj.ureticiIlceAdi)
      ..writeByte(6)
      ..write(obj.ureticiBeldeAdi)
      ..writeByte(7)
      ..write(obj.ureticiIlId)
      ..writeByte(8)
      ..write(obj.ureticiIlceId)
      ..writeByte(9)
      ..write(obj.ureticiBeldeId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UreticiAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Uretici _$UreticiFromJson(Map<String, dynamic> json) => Uretici(
      ureticiAdiSoyadi: json['ureticiAdiSoyadi'] as String,
      ureticiSifatId: json['ureticiSifatId'] as String,
      ureticiTc: json['ureticiTc'] as String,
      ureticiTel: json['ureticiTel'] as String,
      ureticiBeldeAdi: json['ureticiBeldeAdi'] as String,
      ureticiBeldeId: json['ureticiBeldeId'] as String,
      ureticiIlAdi: json['ureticiIlAdi'] as String,
      ureticiIlId: json['ureticiIlId'] as String,
      ureticiIlceAdi: json['ureticiIlceAdi'] as String,
      ureticiIlceId: json['ureticiIlceId'] as String,
    );

Map<String, dynamic> _$UreticiToJson(Uretici instance) => <String, dynamic>{
      'ureticiAdiSoyadi': instance.ureticiAdiSoyadi,
      'ureticiTel': instance.ureticiTel,
      'ureticiTc': instance.ureticiTc,
      'ureticiSifatId': instance.ureticiSifatId,
      'ureticiIlAdi': instance.ureticiIlAdi,
      'ureticiIlceAdi': instance.ureticiIlceAdi,
      'ureticiBeldeAdi': instance.ureticiBeldeAdi,
      'ureticiIlId': instance.ureticiIlId,
      'ureticiIlceId': instance.ureticiIlceId,
      'ureticiBeldeId': instance.ureticiBeldeId,
    };
