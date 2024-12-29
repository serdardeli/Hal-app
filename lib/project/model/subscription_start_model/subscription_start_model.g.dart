// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_start_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SubscriptionStartModelAdapter
    extends TypeAdapter<SubscriptionStartModel> {
  @override
  final int typeId = 1;

  @override
  SubscriptionStartModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SubscriptionStartModel(
      isFreeSubscriptionUsed: fields[1] as String?,
      subscriptionStartDate: fields[0] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, SubscriptionStartModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.subscriptionStartDate)
      ..writeByte(1)
      ..write(obj.isFreeSubscriptionUsed);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubscriptionStartModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubscriptionStartModel _$SubscriptionStartModelFromJson(
        Map<String, dynamic> json) =>
    SubscriptionStartModel(
      isFreeSubscriptionUsed: json['isFreeSubscriptionUsed'] as String?,
      subscriptionStartDate: json['subscriptionStartDate'] as String?,
    );

Map<String, dynamic> _$SubscriptionStartModelToJson(
        SubscriptionStartModel instance) =>
    <String, dynamic>{
      'subscriptionStartDate': instance.subscriptionStartDate,
      'isFreeSubscriptionUsed': instance.isFreeSubscriptionUsed,
    };
