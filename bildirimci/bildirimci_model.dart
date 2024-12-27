import '../../../core/model/base_model/base_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';

import '../bildirim/bildirim_model.dart';
part 'bildirimci_model.g.dart';

@HiveType(typeId: 2)
@JsonSerializable()
class Bildirimci extends HiveObject implements BaseModel {
  @HiveField(0)
  String? phoneNumber;
  @HiveField(1)
  String? bildirimciTc;
  @HiveField(2)
  String? hksSifre;
  @HiveField(3)
  String? bildirimciAdiSoyadi;
  @HiveField(4)
  String? webServiceSifre;
  @HiveField(5, defaultValue: [])
  List<String>? kayitliKisiSifatIdList;
  @HiveField(6, defaultValue: [])
  List<String>? kayitliKisiSifatNameList;

  @HiveField(8)
  String? isyeriAdi;
  @HiveField(9)
  @JsonKey(fromJson: bildirimListFromJson)
  List<Map>? bildirimList;
  @HiveField(10)
  List<Map>? ureticiList;

  @HiveField(12)
  dynamic updateAt;

  @HiveField(14)
  bool? hasHalIciIsyeri;
  @HiveField(15)
  bool? hasDepo;
  @HiveField(16)
  bool? hasSube;
  @HiveField(17)
  bool? gidecegiYerUpdated;

  Bildirimci(
      {this.bildirimciTc,
      this.hksSifre,
      this.kayitliKisiSifatIdList,
      this.webServiceSifre,
      this.phoneNumber,
      this.isyeriAdi,
      this.bildirimList,
      this.bildirimciAdiSoyadi,
      this.kayitliKisiSifatNameList,
      this.ureticiList,
      this.updateAt,
      this.hasDepo,
      this.hasHalIciIsyeri,
      this.hasSube,
      this.gidecegiYerUpdated});
  factory Bildirimci.fromJson(Map<String, dynamic> json) =>
      _$BildirimciFromJson(json);

  @override
  fromJson(Map<String, dynamic> json) => _$BildirimciFromJson(json);
  @override
  Map<String, Object?> toJson() => _$BildirimciToJson(this);
}

bildirimListFromJson(dynamic map) {

  if (map != null) {
    return (map as List<dynamic>?)
        ?.map((e) => e as Map<dynamic, dynamic>)
        .toList();
  }

  return null;
}
