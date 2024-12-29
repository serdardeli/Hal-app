import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:xml/xml.dart';

import '../../../core/model/base_model/base_model.dart';
part 'depo_model.g.dart';

@HiveType(typeId: 11)
@JsonSerializable()
class Depo extends HiveObject implements BaseModel {
  @HiveField(0)
  String? adres;
  @HiveField(1)
  String? beldeId;
  @HiveField(2)
  String? depoId;
  @HiveField(3)
  String? ilId;
  @HiveField(4)
  String? ilceId;
  @HiveField(5)
  String? isletmeTuruId;
  @HiveField(6)
  String? halIcimi;
  @HiveField(7)
  String? depoAdi;
  @HiveField(8)
  String? isletmeTuruAdi;

  //   <b:Id>5</b:Id>
  //   <b:IsletmeTuruAdi>Hal İçi Deposu</b:IsletmeTuruAdi>

  //   <b:Id>6</b:Id>
  //   <b:IsletmeTuruAdi>Hal Dışı Deposu</b:IsletmeTuruAdi>

  Depo(
      {this.adres,
      this.beldeId,
      this.depoId,
      this.ilId,
      this.depoAdi,
      this.ilceId,
      this.isletmeTuruId,
      this.halIcimi,
      this.isletmeTuruAdi});
  factory Depo.fromJson(Map<String, dynamic> json) => _$DepoFromJson(json);
  factory Depo.fromXmlElement(XmlElement xmlElement) {
    String isletmeTuruId2 = "";
    String isletmeTuruAdi2 = "";

    String? isHalIcimi = xmlElement.findElements('b:Halicimi').isNotEmpty
        ? xmlElement.findElements('b:Halicimi').single.text
        : null;
    if (isHalIcimi != null) {
      if (isHalIcimi.toLowerCase() == "true") {
        isletmeTuruId2 = "5";
        isletmeTuruAdi2 = "Hal İçi Deposu";
      } else if (isHalIcimi.toLowerCase() == "false") {
        isletmeTuruId2 = "6";
        isletmeTuruAdi2 = "Hal Dışı Deposu";
      }
    }
    return Depo(
        adres: (xmlElement.findElements('b:Adres').isNotEmpty
            ? (xmlElement.findElements('b:Adres').single.text.toString())
            : null),
        beldeId: xmlElement.findElements('b:BeldeId').isNotEmpty
            ? xmlElement.findElements('b:BeldeId').single.text
            : null,
        ilId: xmlElement.findElements('b:IlId').isNotEmpty
            ? xmlElement.findElements('b:IlId').single.text
            : null,
        ilceId: xmlElement.findElements('b:IlceId').isNotEmpty
            ? xmlElement.findElements('b:IlceId').single.text
            : null,
        isletmeTuruId: isletmeTuruId2,
        depoId: xmlElement.findElements('b:Id').isNotEmpty
            ? xmlElement.findElements('b:Id').single.text
            : null,
        depoAdi: xmlElement.findElements('b:DepoAdi').isNotEmpty
            ? xmlElement.findElements('b:DepoAdi').single.text
            : null,
        halIcimi: isHalIcimi,
        isletmeTuruAdi: isletmeTuruAdi2);
  }
  static Depo getFakeModel() {
    return Depo();
  }

  @override
  fromJson(Map<String, dynamic> json) => _$DepoFromJson(json);
  @override
  Map<String, Object?> toJson() => _$DepoToJson(this);
}
