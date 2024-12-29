// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kayitli_kisi_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class KayitliKisiAdapter extends TypeAdapter<KayitliKisi> {
  @override
  final int typeId = 13;

  @override
  KayitliKisi read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return KayitliKisi(
      kayitliKisimi: fields[0] as String?,
      sifatlar: fields[1] == null ? [] : (fields[1] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, KayitliKisi obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.kayitliKisimi)
      ..writeByte(1)
      ..write(obj.sifatlar);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is KayitliKisiAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KayitliKisi _$KayitliKisiFromJson(Map<String, dynamic> json) => KayitliKisi(
      kayitliKisimi: json['kayitliKisimi'] as String?,
      sifatlar: (json['sifatlar'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$KayitliKisiToJson(KayitliKisi instance) =>
    <String, dynamic>{
      'kayitliKisimi': instance.kayitliKisimi,
      'sifatlar': instance.sifatlar,
    };
