// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mysoft_user_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MySoftUserModelAdapter extends TypeAdapter<MySoftUserModel> {
  @override
  final int typeId = 18;

  @override
  MySoftUserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MySoftUserModel(
      password: fields[2] as String,
      userName: fields[1] as String,
      firmaAdi: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, MySoftUserModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(1)
      ..write(obj.userName)
      ..writeByte(2)
      ..write(obj.password)
      ..writeByte(3)
      ..write(obj.firmaAdi);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MySoftUserModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MySoftUserModel _$MySoftUserModelFromJson(Map<String, dynamic> json) =>
    MySoftUserModel(
      password: json['password'] as String,
      userName: json['userName'] as String,
      firmaAdi: json['firmaAdi'] as String,
    );

Map<String, dynamic> _$MySoftUserModelToJson(MySoftUserModel instance) =>
    <String, dynamic>{
      'userName': instance.userName,
      'password': instance.password,
      'firmaAdi': instance.firmaAdi,
    };
