import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';
part 'uretici_model.g.dart';

@JsonSerializable()
@HiveType(typeId: 7)
class Uretici {
  @HiveField(0)
  String ureticiAdiSoyadi;
  @HiveField(1)
  String ureticiTel;
  @HiveField(2)
  String ureticiTc;
  @HiveField(3)
  String ureticiSifatId;
  @HiveField(4)
  String ureticiIlAdi;
  @HiveField(5)
  String ureticiIlceAdi;
  @HiveField(6)
  String ureticiBeldeAdi;
  @HiveField(7)
  String ureticiIlId;
  @HiveField(8)
  String ureticiIlceId;
  @HiveField(9)
  String ureticiBeldeId;
  Uretici(
      {required this.ureticiAdiSoyadi,
      required this.ureticiSifatId,
      required this.ureticiTc,
      required this.ureticiTel,
      required this.ureticiBeldeAdi,
      required this.ureticiBeldeId,
      required this.ureticiIlAdi,
      required this.ureticiIlId,
      required this.ureticiIlceAdi,
      required this.ureticiIlceId});
  factory Uretici.fromJson(Map<String, dynamic> json) =>
      _$UreticiFromJson(json);

  @override
  fromJson(Map<String, dynamic> json) => _$UreticiFromJson(json);

  @override
  Map<String, Object?> toJson() => _$UreticiToJson(this);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Uretici &&
          runtimeType == other.runtimeType &&
          ureticiAdiSoyadi == other.ureticiAdiSoyadi;

  @override
  int get hashCode => Object.hash(ureticiAdiSoyadi, ureticiAdiSoyadi);
}
