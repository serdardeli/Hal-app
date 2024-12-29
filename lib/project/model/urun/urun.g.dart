// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'urun.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UrunAdapter extends TypeAdapter<Urun> {
  @override
  final int typeId = 8;

  @override
  Urun read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Urun(
      urunAdi: fields[0] as String,
      urunId: fields[1] as String,
      urunCinsId: fields[3] as String,
      urunCinsi: fields[2] as String,
      urunFiyati: fields[8] as String?,
      urunMiktarBirimId: fields[4] as String,
      urunMiktari: fields[7] as String,
      urunBirimAdi: fields[5] as String,
      isToplamaMal: fields[6] as String,
      kunyeNo: fields[9] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Urun obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.urunAdi)
      ..writeByte(1)
      ..write(obj.urunId)
      ..writeByte(2)
      ..write(obj.urunCinsi)
      ..writeByte(3)
      ..write(obj.urunCinsId)
      ..writeByte(4)
      ..write(obj.urunMiktarBirimId)
      ..writeByte(5)
      ..write(obj.urunBirimAdi)
      ..writeByte(6)
      ..write(obj.isToplamaMal)
      ..writeByte(7)
      ..write(obj.urunMiktari)
      ..writeByte(8)
      ..write(obj.urunFiyati)
      ..writeByte(9)
      ..write(obj.kunyeNo);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UrunAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Urun _$UrunFromJson(Map<String, dynamic> json) => Urun(
      urunAdi: json['urunAdi'] as String,
      urunId: json['urunId'] as String,
      urunCinsId: json['urunCinsId'] as String,
      urunCinsi: json['urunCinsi'] as String,
      urunFiyati: json['urunFiyati'] as String? ?? "0",
      urunMiktarBirimId: json['urunMiktarBirimId'] as String,
      urunMiktari: json['urunMiktari'] as String,
      urunBirimAdi: json['urunBirimAdi'] as String,
      isToplamaMal: json['isToplamaMal'] as String,
      gonderilmekIstenenFiyat: json['gonderilmekIstenenFiyat'] as String?,
      gonderilmekIstenenMiktar: json['gonderilmekIstenenMiktar'] as String?,
      kunyeNo: json['kunyeNo'] as String?,
    );

Map<String, dynamic> _$UrunToJson(Urun instance) => <String, dynamic>{
      'urunAdi': instance.urunAdi,
      'urunId': instance.urunId,
      'urunCinsi': instance.urunCinsi,
      'urunCinsId': instance.urunCinsId,
      'urunMiktarBirimId': instance.urunMiktarBirimId,
      'urunBirimAdi': instance.urunBirimAdi,
      'isToplamaMal': instance.isToplamaMal,
      'urunMiktari': instance.urunMiktari,
      'urunFiyati': instance.urunFiyati,
      'kunyeNo': instance.kunyeNo,
      'gonderilmekIstenenMiktar': instance.gonderilmekIstenenMiktar,
      'gonderilmekIstenenFiyat': instance.gonderilmekIstenenFiyat,
    };
