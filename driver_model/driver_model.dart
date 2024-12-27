import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';
part 'driver_model.g.dart';

@HiveType(typeId: 19)
@JsonSerializable()
class DriverModel {
  @HiveField(0)
  String userName;
  @HiveField(1)
  String tc;

  DriverModel({required this.tc, required this.userName});

  factory DriverModel.fromJson(Map<String, dynamic> json) =>
      _$DriverModelFromJson(json);

  @override
  fromJson(Map<String, dynamic> json) => _$DriverModelFromJson(json);

  @override
  Map<String, Object?> toJson() => _$DriverModelToJson(this);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DriverModel &&
          runtimeType == other.runtimeType &&
          tc == other.tc;

  @override
  int get hashCode => Object.hash(tc, tc);
}
