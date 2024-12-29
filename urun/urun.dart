import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';
part 'urun.g.dart';

@HiveType(typeId: 8)
@JsonSerializable()
class Urun {
  @HiveField(0)
  String urunAdi;
  @HiveField(1)
  String urunId;
  @HiveField(2)
  String urunCinsi;
  @HiveField(3)
  String urunCinsId;
  @HiveField(4)
  String urunMiktarBirimId;
  @HiveField(5)
  String urunBirimAdi;
  @HiveField(6)
  String isToplamaMal;
  @HiveField(7)
  String urunMiktari;
  @HiveField(8)
  String? urunFiyati;
  @HiveField(9)
  String? kunyeNo;

  String? gonderilmekIstenenMiktar;
  String? gonderilmekIstenenFiyat;

  Urun(
      {required this.urunAdi,
      required this.urunId,
      required this.urunCinsId,
      required this.urunCinsi,
      this.urunFiyati = "0",
      required this.urunMiktarBirimId,
      required this.urunMiktari,
      required this.urunBirimAdi,
      required this.isToplamaMal,
      this.gonderilmekIstenenFiyat,
      this.gonderilmekIstenenMiktar,
      this.kunyeNo});

  static fromJson(Map<String, dynamic> item) => _$UrunFromJson(item);
  toJson() => _$UrunToJson(this);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Urun &&
          runtimeType == other.runtimeType &&
          urunId == other.urunId &&
          urunCinsId == other.urunCinsId;

  @override
  int get hashCode => Object.hash(urunId, urunCinsId);
}
