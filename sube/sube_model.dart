import 'package:xml/xml.dart';

import '../../../core/model/base_model/base_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';

import '../bildirim/bildirim_model.dart';
part 'sube_model.g.dart';

Map<String, String> malinGidecegiYerler = {
  "1": "Şube",
  "4": "Tasnifleme ve Ambalajlama",
  "5": "Hal İçi Deposu",
  "6": "Hal Dışı Deposu",
  "7": "Hal İçi İşyeri",
  "8": "Hal Dışı İşyeri",
  "9": "Sınai İşletme",
  "12": "Dağıtım Merkezi",
  "16": "Yurt Dışı",
  "18": "Bireysel Tüketim",
  "19": "Perakende Satiş Yeri",
};

@HiveType(typeId: 10)
@JsonSerializable()
class Sube extends HiveObject implements BaseModel {
  @HiveField(0)
  String? adres;
  @HiveField(1)
  String? beldeId;
  @HiveField(2)
  String? subeId;
  @HiveField(3)
  String? ilId;
  @HiveField(4)
  String? ilceId;
  @HiveField(5)
  String? isletmeTuruId;
  @HiveField(6)
  String? isletmeTuruAdi;
  factory Sube.fromXmlElement(XmlElement xmlElement) {
    String? isletmeTuruId = xmlElement.findElements('b:IsyeriTuru').isNotEmpty
        ? xmlElement.findElements('b:IsyeriTuru').single.text
        : null;
    String? isletmeTuruAdi = null;
    malinGidecegiYerler.forEach(
      (key, value) {
        if (isletmeTuruId == key) {
          isletmeTuruAdi = value;
        }
      },
    );
    return Sube(
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
        isletmeTuruId: xmlElement.findElements('b:IsyeriTuru').isNotEmpty
            ? xmlElement.findElements('b:IsyeriTuru').single.text
            : null,
        subeId: xmlElement.findElements('b:Id').isNotEmpty
            ? xmlElement.findElements('b:Id').single.text
            : null,
        isletmeTuruAdi: isletmeTuruAdi);
  }
  Sube(
      {this.adres,
      this.beldeId,
      this.subeId,
      this.ilId,
      this.ilceId,
      this.isletmeTuruId,
      this.isletmeTuruAdi});
  factory Sube.fromJson(Map<String, dynamic> json) => _$SubeFromJson(json);

  static Sube getFakeModel() {
    return Sube();
  }

  @override
  fromJson(Map<String, dynamic> json) => _$SubeFromJson(json);
  @override
  Map<String, Object?> toJson() => _$SubeToJson(this);
}
