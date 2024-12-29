import '../../../core/model/base_model/base_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';
part 'bildirim_model.g.dart';

@HiveType(typeId: 3)
@JsonSerializable()
class Bildirim extends HiveObject implements BaseModel {
  @HiveField(0)
  String? malId;
  @HiveField(1)
  String? malinCinsiId;
  @HiveField(2)
  String? uretimSekliId;
  @HiveField(3)
  String? malinNiteligiId;
  @HiveField(4)
  String? malinMiktarBirimId;
  @HiveField(5)
  String? bildirimciSoyadi;
  @HiveField(6)
  String? uretimBeldeId;
  @HiveField(7)
  String? uretimIlId;
  @HiveField(8)
  String? uretimIlceId;
  @HiveField(9)
  String? ikiniciKisiSirketAdi;
  @HiveField(10)
  String? malAdi;
  @HiveField(11, defaultValue: 0)
  int? addedCount;
  @HiveField(12)
  String? bildirimId;
  @HiveField(13)
  @JsonKey(name: 'selectedUretici', fromJson: userFromJson)
  Map? selectedUretici;
  @HiveField(14)
  String? isToplamaMal;
  @HiveField(15)
  String? bildirimAdi;
  @HiveField(16)
  String? malCinsAdi;
  @HiveField(17)
  String? kunyeNo;
  @HiveField(18)
  String? plakaNo;
  @HiveField(19)
  String? islemKodu;
  @HiveField(20)
  String? kayitTarihi;
  Bildirim(
      {this.bildirimciSoyadi,
      this.malId,
      this.malinCinsiId,
      this.malinMiktarBirimId,
      this.malinNiteligiId,
      this.uretimBeldeId,
      this.uretimIlId,
      this.uretimIlceId,
      this.uretimSekliId,
      this.ikiniciKisiSirketAdi,
      this.malAdi,
      this.addedCount,
      this.bildirimId,
      this.selectedUretici,
      this.isToplamaMal,
      this.bildirimAdi,
      this.malCinsAdi,
      this.plakaNo,
      this.kunyeNo,
      this.islemKodu});
  factory Bildirim.fromJson(Map<String, dynamic> json) =>
      _$BildirimFromJson(json);
  incrementAddedCount() {
    this.addedCount = ((addedCount!) + 1);
  }

  @override
  fromJson(Map<String, dynamic> json) => _$BildirimFromJson(json);
  @override
  Map<String, Object?> toJson() => _$BildirimToJson(this);

  //TODO: SADECE MALIN ADI(MAL ID)  VE IKINCI KISI SIRKET ADI YAZMAM YETERLI OLABILIR ?? BÖYLE OLURSA ORGANİKTIR FİLAN KISIMLARI FARKLI OLUR??
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Bildirim &&
          runtimeType == other.runtimeType &&
          uretimIlId == other.uretimIlId &&
          uretimIlceId == other.uretimIlceId &&
          uretimBeldeId == other.uretimBeldeId &&
          malId == other.malId &&
          malinCinsiId == other.malinCinsiId &&
          malinMiktarBirimId == other.malinMiktarBirimId &&
          malinNiteligiId == other.malinNiteligiId;

  @override
  int get hashCode => Object.hash(uretimIlId, uretimIlceId, uretimBeldeId,
      malId, malinCinsiId, malinMiktarBirimId, malinNiteligiId);
}

Map<String, Object?>? userFromJson(dynamic map) {
  if (map != null) {
    return Map<String, dynamic>.from(map);
  }

  return null;
}
