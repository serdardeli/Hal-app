import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';
part 'musteri_model.g.dart';

@JsonSerializable()
@HiveType(typeId: 15)
class Musteri {
  @HiveField(0)
  String musteriAdiSoyadi;
  @HiveField(1)
  String? musteriTel;
  @HiveField(2)
  String musteriTc;
  @HiveField(3)
  List<String> musteriSifatIdList;
  @HiveField(4)
  List<String> musteriSifatNameList;
  @HiveField(5)
  bool isregisteredToHks;
  @HiveField(6)
  String? musteriIlAdi;
  @HiveField(7)
  String? musteriIlceAdi;
  @HiveField(8)
  String? musteriBeldeAdi;
  @HiveField(9)
  String? musteriIlId;
  @HiveField(10)
  String? musteriIlceId;
  @HiveField(11)
  String? musteriBeldeId;
  @HiveField(12)
  String? selectedNotFoundMalinGidecegiYerAdi;
  @HiveField(13)
  String? selectedNotFoundMalinGidecegiYerId;

  Musteri(
      {required this.musteriAdiSoyadi,
      required this.musteriSifatIdList,
      required this.musteriSifatNameList,
      required this.musteriTc,
      this.musteriTel,
      required this.isregisteredToHks,
      this.musteriBeldeAdi,
      this.musteriBeldeId,
      this.musteriIlAdi,
      this.musteriIlId,
      this.musteriIlceAdi,
      this.musteriIlceId,
      this.selectedNotFoundMalinGidecegiYerAdi,
      this.selectedNotFoundMalinGidecegiYerId});
  factory Musteri.fromJson(Map<String, dynamic> json) =>
      _$MusteriFromJson(json);

  @override
  fromJson(Map<String, dynamic> json) => _$MusteriFromJson(json);

  @override
  Map<String, Object?> toJson() => _$MusteriToJson(this);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Musteri &&
          runtimeType == other.runtimeType &&
          musteriAdiSoyadi == other.musteriAdiSoyadi;

  @override
  int get hashCode => Object.hash(musteriAdiSoyadi, musteriAdiSoyadi);
}
