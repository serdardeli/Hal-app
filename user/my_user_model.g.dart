// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_user_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MyUserAdapter extends TypeAdapter<MyUser> {
  @override
  final int typeId = 1;

  @override
  MyUser read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MyUser(
      name: fields[0] as String?,
      level: fields[1] as int?,
      phoneNumber: fields[2] as String?,
      subscriptionId: fields[4] as String?,
      tcList: (fields[3] as List?)?.cast<String>(),
      revenueCatSubscriptionId: fields[5] as String?,
      subscriptionNumber: fields[6] == null ? 0 : fields[6] as int?,
      password: fields[7] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, MyUser obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.level)
      ..writeByte(2)
      ..write(obj.phoneNumber)
      ..writeByte(3)
      ..write(obj.tcList)
      ..writeByte(4)
      ..write(obj.subscriptionId)
      ..writeByte(5)
      ..write(obj.revenueCatSubscriptionId)
      ..writeByte(6)
      ..write(obj.subscriptionNumber)
      ..writeByte(7)
      ..write(obj.password);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MyUserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyUser _$MyUserFromJson(Map<String, dynamic> json) => MyUser(
      name: json['name'] as String?,
      updatedAt: json['updatedAt'],
      level: json['level'] as int?,
      phoneNumber: json['phoneNumber'] as String?,
      subscriptionId: json['subscriptionId'] as String?,
      tcList:
          (json['tcList'] as List<dynamic>?)?.map((e) => e as String).toList(),
      revenueCatSubscriptionId: json['revenueCatSubscriptionId'] as String?,
      subscriptionNumber: json['subscriptionNumber'] as int?,
      password: json['password'] as String?,
    );

Map<String, dynamic> _$MyUserToJson(MyUser instance) => <String, dynamic>{
      'name': instance.name,
      'updatedAt': instance.updatedAt,
      'level': instance.level,
      'phoneNumber': instance.phoneNumber,
      'tcList': instance.tcList,
      'subscriptionId': instance.subscriptionId,
      'revenueCatSubscriptionId': instance.revenueCatSubscriptionId,
      'subscriptionNumber': instance.subscriptionNumber,
      'password': instance.password,
    };
