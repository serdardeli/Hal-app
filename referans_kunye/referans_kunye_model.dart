import 'package:json_annotation/json_annotation.dart';
import 'package:xml/xml.dart';
part 'referans_kunye_model.g.dart';

@JsonSerializable()
class ReferansKunye extends Comparable<ReferansKunye> {
  String? aracPlakaNo;
  String? bildirimTuru;
  String? bildirimciTckimlikVergiNo;
  String? bildirimTarihi;
  String? kalanMiktar;
  String? kunyeNo;
  String? malinAdi;
  String? malinCinsiKodNo;
  String? malinCinsi;
  String? malinKodNo;
  String? malinMiktari;
  String? malinSahibiTc;
  String? malinSatisFiyati;
  String? gonderilmekIstenenMiktar;
  String? gonderilmekIstenenFiyat;

  String?
      malinTuru; //bunu servisten alıyorum default almıyorum adam ne verdiyse alıyorum
  String? malinTuruKodNo;
  String? malinMiktarBirimId;
  String? malinMiktarBirimAd;
  String? RusumMiktari;
  String? sifat;
  String? uniqueId;
  String? ureticiTcKimlikVergiNo;
  ReferansKunye(
      {this.RusumMiktari,
      this.aracPlakaNo,
      this.bildirimTuru,
      this.kalanMiktar,
      this.bildirimciTckimlikVergiNo,
      this.kunyeNo,
      this.malinAdi,
      this.malinCinsi,
      this.malinCinsiKodNo,
      this.malinKodNo,
      this.malinMiktarBirimAd,
      this.malinMiktarBirimId,
      this.malinMiktari,
      this.malinSahibiTc,
      this.malinSatisFiyati,
      this.malinTuru,
      this.malinTuruKodNo,
      this.sifat,
      this.uniqueId,
      this.ureticiTcKimlikVergiNo,
      this.bildirimTarihi,
      this.gonderilmekIstenenMiktar,
      this.gonderilmekIstenenFiyat});
  factory ReferansKunye.fromXmlElement(XmlElement xmlElement) => ReferansKunye(
      aracPlakaNo:
          (xmlElement.findElements('b:AracPlakaNo').single.text.toString()),
      bildirimciTckimlikVergiNo:
          xmlElement.findElements('b:BildirimciTcKimlikVergiNo').single.text,
      bildirimTuru: xmlElement.findElements('b:BildirimTuru').single.text,
      kalanMiktar: xmlElement.findElements('b:KalanMiktar').single.text,
      kunyeNo: xmlElement.findElements('b:KunyeNo').single.text,
      malinAdi: xmlElement.findElements('b:MalinAdi').single.text,
      malinCinsiKodNo: xmlElement.findElements('b:MalinCinsKodNo').single.text,
      malinCinsi: xmlElement.findElements('b:MalinCinsi').single.text,
      malinKodNo: xmlElement.findElements('b:MalinKodNo').single.text,
      malinMiktari: xmlElement.findElements('b:MalinMiktari').single.text,
      malinSahibiTc:
          xmlElement.findElements('b:MalinSahibiTcKimlikVergiNo').single.text,
      malinSatisFiyati:
          xmlElement.findElements('b:MalinSatisFiyati').single.text,
      malinTuru: xmlElement.findElements('b:MalinTuru').single.text,
      malinTuruKodNo: xmlElement.findElements('b:MalinTuruKodNo').single.text,
      malinMiktarBirimId:
          xmlElement.findElements('b:MiktarBirimId').single.text,
      malinMiktarBirimAd:
          xmlElement.findElements('b:MiktarBirimiAd').single.text,
      RusumMiktari: xmlElement.findElements('b:RusumMiktari').single.text,
      sifat: xmlElement.findElements('b:Sifat').single.text,
      uniqueId: xmlElement.findElements('b:UniqueId').single.text,
      ureticiTcKimlikVergiNo:
          xmlElement.findElements('b:UreticiTcKimlikVergiNo').single.text,
      bildirimTarihi: xmlElement.findElements('b:BildirimTarihi').single.text);

  @override
  int compareTo(ReferansKunye other) {
    // TODO: implement compareTo
    return DateTime.parse(this.bildirimTarihi!)
        .compareTo(DateTime.parse(other.bildirimTarihi!));
  }

  @override
  @override
  Map<String, Object?> toJson() => _$ReferansKunyeToJson(this);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReferansKunye &&
          runtimeType == other.runtimeType &&
          kunyeNo == other.kunyeNo;

  @override
  int get hashCode => kunyeNo.hashCode;
}
