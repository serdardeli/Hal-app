// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custom_notification_save_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CustomNotificationSaveModelAdapter
    extends TypeAdapter<CustomNotificationSaveModel> {
  @override
  final int typeId = 6;

  @override
  CustomNotificationSaveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CustomNotificationSaveModel(
      uretici: (fields[0] as Map?)?.cast<dynamic, dynamic>(),
      isToplama: fields[1] as bool,
      totalAddedCount: fields[2] as int?,
      urunList: (fields[3] as List)
          .map((dynamic e) => (e as Map).cast<dynamic, dynamic>())
          .toList(),
      bildirimAdi: fields[4] as String,
      plaka: fields[11] == null ? '' : fields[11] as String,
      adres: fields[23] as String?,
      beldeAdi: fields[7] == null ? '' : fields[7] as String?,
      beldeId: fields[9] == null ? '' : fields[9] as String?,
      ilAdi: fields[5] == null ? '' : fields[5] as String?,
      ilId: fields[8] == null ? '' : fields[8] as String?,
      ilceAdi: fields[6] == null ? '' : fields[6] as String?,
      ilceId: fields[10] == null ? '' : fields[10] as String?,
      kunyeNo: fields[12] as String?,
      weeklyAddedCount: fields[14] as int?,
      date: fields[15] as String?,
      gidecegiYerAdi: fields[16] as String?,
      gidecegiYerType: fields[17] as String?,
      selectedSifatType: fields[18] as String?,
      selectedSifatId: fields[19] as String?,
      gidecegiYerIsletmeTuruAdi: fields[21] as String?,
      gidecegiYerIsletmeTuruId: fields[20] as String?,
      gidecegiIsyeriId: fields[22] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, CustomNotificationSaveModel obj) {
    writer
      ..writeByte(23)
      ..writeByte(0)
      ..write(obj.uretici)
      ..writeByte(1)
      ..write(obj.isToplama)
      ..writeByte(2)
      ..write(obj.totalAddedCount)
      ..writeByte(3)
      ..write(obj.urunList)
      ..writeByte(4)
      ..write(obj.bildirimAdi)
      ..writeByte(5)
      ..write(obj.ilAdi)
      ..writeByte(6)
      ..write(obj.ilceAdi)
      ..writeByte(7)
      ..write(obj.beldeAdi)
      ..writeByte(8)
      ..write(obj.ilId)
      ..writeByte(9)
      ..write(obj.beldeId)
      ..writeByte(10)
      ..write(obj.ilceId)
      ..writeByte(11)
      ..write(obj.plaka)
      ..writeByte(12)
      ..write(obj.kunyeNo)
      ..writeByte(14)
      ..write(obj.weeklyAddedCount)
      ..writeByte(15)
      ..write(obj.date)
      ..writeByte(16)
      ..write(obj.gidecegiYerAdi)
      ..writeByte(17)
      ..write(obj.gidecegiYerType)
      ..writeByte(18)
      ..write(obj.selectedSifatType)
      ..writeByte(19)
      ..write(obj.selectedSifatId)
      ..writeByte(20)
      ..write(obj.gidecegiYerIsletmeTuruId)
      ..writeByte(21)
      ..write(obj.gidecegiYerIsletmeTuruAdi)
      ..writeByte(22)
      ..write(obj.gidecegiIsyeriId)
      ..writeByte(23)
      ..write(obj.adres);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CustomNotificationSaveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomNotificationSaveModel _$CustomNotificationSaveModelFromJson(
        Map<String, dynamic> json) =>
    CustomNotificationSaveModel(
      uretici: ureticiFromJson(json['uretici']),
      isToplama: json['isToplama'] as bool,
      totalAddedCount: json['totalAddedCount'] as int?,
      urunList: urunListFromJson(json['urunList']),
      bildirimAdi: json['bildirimAdi'] as String,
      plaka: json['plaka'] as String,
      adres: json['adres'] as String?,
      beldeAdi: json['beldeAdi'] as String?,
      beldeId: json['beldeId'] as String?,
      ilAdi: json['ilAdi'] as String?,
      ilId: json['ilId'] as String?,
      ilceAdi: json['ilceAdi'] as String?,
      ilceId: json['ilceId'] as String?,
      kunyeNo: json['kunyeNo'] as String?,
      weeklyAddedCount: json['weeklyAddedCount'] as int?,
      date: json['date'] as String?,
      gidecegiYerAdi: json['gidecegiYerAdi'] as String?,
      gidecegiYerType: json['gidecegiYerType'] as String?,
      selectedSifatType: json['selectedSifatType'] as String?,
      selectedSifatId: json['selectedSifatId'] as String?,
      gidecegiYerIsletmeTuruAdi: json['gidecegiYerIsletmeTuruAdi'] as String?,
      gidecegiYerIsletmeTuruId: json['gidecegiYerIsletmeTuruId'] as String?,
      gidecegiIsyeriId: json['gidecegiIsyeriId'] as String?,
    );

Map<String, dynamic> _$CustomNotificationSaveModelToJson(
        CustomNotificationSaveModel instance) =>
    <String, dynamic>{
      'uretici': instance.uretici,
      'isToplama': instance.isToplama,
      'totalAddedCount': instance.totalAddedCount,
      'urunList': instance.urunList,
      'bildirimAdi': instance.bildirimAdi,
      'ilAdi': instance.ilAdi,
      'ilceAdi': instance.ilceAdi,
      'beldeAdi': instance.beldeAdi,
      'ilId': instance.ilId,
      'beldeId': instance.beldeId,
      'ilceId': instance.ilceId,
      'plaka': instance.plaka,
      'kunyeNo': instance.kunyeNo,
      'weeklyAddedCount': instance.weeklyAddedCount,
      'date': instance.date,
      'gidecegiYerAdi': instance.gidecegiYerAdi,
      'gidecegiYerType': instance.gidecegiYerType,
      'selectedSifatType': instance.selectedSifatType,
      'selectedSifatId': instance.selectedSifatId,
      'gidecegiYerIsletmeTuruId': instance.gidecegiYerIsletmeTuruId,
      'gidecegiYerIsletmeTuruAdi': instance.gidecegiYerIsletmeTuruAdi,
      'gidecegiIsyeriId': instance.gidecegiIsyeriId,
      'adres': instance.adres,
    };
