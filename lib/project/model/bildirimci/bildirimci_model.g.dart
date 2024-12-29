// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bildirimci_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BildirimciAdapter extends TypeAdapter<Bildirimci> {
  @override
  final int typeId = 2;

  @override
  Bildirimci read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Bildirimci(
      bildirimciTc: fields[1] as String?,
      hksSifre: fields[2] as String?,
      kayitliKisiSifatIdList:
          fields[5] == null ? [] : (fields[5] as List?)?.cast<String>(),
      webServiceSifre: fields[4] as String?,
      phoneNumber: fields[0] as String?,
      isyeriAdi: fields[8] as String?,
      bildirimList: (fields[9] as List?)
          ?.map((dynamic e) => (e as Map).cast<dynamic, dynamic>())
          .toList(),
      bildirimciAdiSoyadi: fields[3] as String?,
      kayitliKisiSifatNameList:
          fields[6] == null ? [] : (fields[6] as List?)?.cast<String>(),
      ureticiList: (fields[10] as List?)
          ?.map((dynamic e) => (e as Map).cast<dynamic, dynamic>())
          .toList(),
      updateAt: fields[12] as dynamic,
      hasDepo: fields[15] as bool?,
      hasHalIciIsyeri: fields[14] as bool?,
      hasSube: fields[16] as bool?,
      gidecegiYerUpdated: fields[17] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, Bildirimci obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.phoneNumber)
      ..writeByte(1)
      ..write(obj.bildirimciTc)
      ..writeByte(2)
      ..write(obj.hksSifre)
      ..writeByte(3)
      ..write(obj.bildirimciAdiSoyadi)
      ..writeByte(4)
      ..write(obj.webServiceSifre)
      ..writeByte(5)
      ..write(obj.kayitliKisiSifatIdList)
      ..writeByte(6)
      ..write(obj.kayitliKisiSifatNameList)
      ..writeByte(8)
      ..write(obj.isyeriAdi)
      ..writeByte(9)
      ..write(obj.bildirimList)
      ..writeByte(10)
      ..write(obj.ureticiList)
      ..writeByte(12)
      ..write(obj.updateAt)
      ..writeByte(14)
      ..write(obj.hasHalIciIsyeri)
      ..writeByte(15)
      ..write(obj.hasDepo)
      ..writeByte(16)
      ..write(obj.hasSube)
      ..writeByte(17)
      ..write(obj.gidecegiYerUpdated);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BildirimciAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Bildirimci _$BildirimciFromJson(Map<String, dynamic> json) => Bildirimci(
      bildirimciTc: json['bildirimciTc'] as String?,
      hksSifre: json['hksSifre'] as String?,
      kayitliKisiSifatIdList: (json['kayitliKisiSifatIdList'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      webServiceSifre: json['webServiceSifre'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      isyeriAdi: json['isyeriAdi'] as String?,
      bildirimList: bildirimListFromJson(json['bildirimList']),
      bildirimciAdiSoyadi: json['bildirimciAdiSoyadi'] as String?,
      kayitliKisiSifatNameList:
          (json['kayitliKisiSifatNameList'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList(),
      ureticiList: (json['ureticiList'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
      updateAt: json['updateAt'],
      hasDepo: json['hasDepo'] as bool?,
      hasHalIciIsyeri: json['hasHalIciIsyeri'] as bool?,
      hasSube: json['hasSube'] as bool?,
      gidecegiYerUpdated: json['gidecegiYerUpdated'] as bool?,
    );

Map<String, dynamic> _$BildirimciToJson(Bildirimci instance) =>
    <String, dynamic>{
      'phoneNumber': instance.phoneNumber,
      'bildirimciTc': instance.bildirimciTc,
      'hksSifre': instance.hksSifre,
      'bildirimciAdiSoyadi': instance.bildirimciAdiSoyadi,
      'webServiceSifre': instance.webServiceSifre,
      'kayitliKisiSifatIdList': instance.kayitliKisiSifatIdList,
      'kayitliKisiSifatNameList': instance.kayitliKisiSifatNameList,
      'isyeriAdi': instance.isyeriAdi,
      'bildirimList': instance.bildirimList,
      'ureticiList': instance.ureticiList,
      'updateAt': instance.updateAt,
      'hasHalIciIsyeri': instance.hasHalIciIsyeri,
      'hasDepo': instance.hasDepo,
      'hasSube': instance.hasSube,
      'gidecegiYerUpdated': instance.gidecegiYerUpdated,
    };
