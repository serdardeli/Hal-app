import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';
part 'mysoft_user_model.g.dart';

@HiveType(typeId: 18)
@JsonSerializable()
class MySoftUserModel {
  @HiveField(1)
  String userName;
  @HiveField(2)
  String password;
  @HiveField(3)
  String firmaAdi;

  MySoftUserModel(
      {required this.password, required this.userName, required this.firmaAdi});

  factory MySoftUserModel.fromJson(Map<String, dynamic> json) =>
      _$MySoftUserModelFromJson(json);

  @override
  fromJson(Map<String, dynamic> json) => _$MySoftUserModelFromJson(json);

  @override
  Map<String, Object?> toJson() => _$MySoftUserModelToJson(this);
}
