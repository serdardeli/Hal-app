import 'dart:convert';
import 'dart:developer';

import 'package:json_annotation/json_annotation.dart';
import 'package:xml/xml.dart';
part 'bildirim_kayit_cevap_model.g.dart';

@JsonSerializable()
class BildirimKayitCevapModel {
  String? aracPlakaNo;
  String? kunyeNo;
  String? kayitTarihi;
  String? uniqueId;
  String? malinId;
  String? malinCinsiId;
  String? message;
  String? malinAdi;
  String? malinCinsi;
  String? malinMiktari;
  String? malinMiktarBirimId;
  String? malinMiktarBirimAdi;

  BildirimKayitCevapModel(
      {this.aracPlakaNo,
      this.kunyeNo,
      this.kayitTarihi,
      this.uniqueId,
      this.malinId,
      this.malinCinsiId,
      this.message,
      this.malinAdi,
      this.malinCinsi,
      this.malinMiktari,
      this.malinMiktarBirimId});
  factory BildirimKayitCevapModel.fromXmlElementt(XmlElement xmlElement) {
    return BildirimKayitCevapModel(
        aracPlakaNo: (xmlElement.findElements('a:AracPlakaNo').isNotEmpty
            ? (xmlElement.findElements('a:AracPlakaNo').single.text.toString())
            : null),
        kunyeNo: xmlElement.findElements('a:YeniKunyeNo').isNotEmpty
            ? xmlElement.findElements('a:YeniKunyeNo').single.text
            : null,
        kayitTarihi: xmlElement.findElements('a:KayitTarihi').isNotEmpty
            ? xmlElement.findElements('a:KayitTarihi').single.text
            : null,
        uniqueId: xmlElement.findElements('a:UniqueId').isNotEmpty
            ? xmlElement.findElements('a:UniqueId').single.text
            : null,
        malinId: xmlElement.findElements('a:MalinKodNo').isNotEmpty
            ? xmlElement.findElements('a:MalinKodNo').single.text
            : null,
        malinCinsiId: xmlElement.findElements('a:MalinCinsiId').isNotEmpty
            ? xmlElement.findElements('a:MalinCinsiId').single.text
            : null,
        malinMiktari: xmlElement.findElements('a:MalinMiktari').isNotEmpty
            ? xmlElement.findElements('a:MalinMiktari').single.text
            : null,
        malinMiktarBirimId:
            xmlElement.findElements('a:MiktarBirimId').isNotEmpty
                ? xmlElement.findElements('a:MiktarBirimId').single.text
                : null,
        message: xmlElement.findElements('a:Mesaj').isNotEmpty
            ? xmlElement.findElements('a:Mesaj').single.text
            : null);
  }
  Map<String, Object?> toJson() => _$BildirimKayitCevapModelToJson(this);

  static BildirimKayitCevapModel fromJson(Map<String, dynamic> json) =>
      _$BildirimKayitCevapModelFromJson(json);
}
