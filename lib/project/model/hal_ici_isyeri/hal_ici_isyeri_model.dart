import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:xml/xml.dart';
part 'hal_ici_isyeri_model.g.dart';

@HiveType(typeId: 12)
@JsonSerializable()
class HalIciIsyeri extends HiveObject {
  @HiveField(0)
  String? halAdi;
  @HiveField(1)
  String? halId;
  @HiveField(2)
  String? isyeriId;
  @HiveField(3)
  String? isyeriAdi;
  @HiveField(4)
  String? isYeriSahibiTc;
  String isletmeTuruId = "7";
  String isletmeTuruAdi = "Hal İçi İşyeri";

  HalIciIsyeri(
      {this.halAdi,
      this.halId,
      this.isYeriSahibiTc,
      this.isyeriAdi,
      this.isyeriId});
  factory HalIciIsyeri.fromXmlElement(XmlElement xmlElement) => HalIciIsyeri(
        halAdi: (xmlElement.findElements('b:HalAdi').isNotEmpty
            ? (xmlElement.findElements('b:HalAdi').single.text.toString())
            : null),
        halId: xmlElement.findElements('b:HalId').isNotEmpty
            ? xmlElement.findElements('b:HalId').single.text
            : null,
        isYeriSahibiTc: xmlElement.findElements('b:TcKimlikVergiNo').isNotEmpty
            ? xmlElement.findElements('b:TcKimlikVergiNo').single.text
            : null,
        isyeriAdi: xmlElement.findElements('b:IsyeriAdi').isNotEmpty
            ? xmlElement.findElements('b:IsyeriAdi').single.text
            : null,
        isyeriId: xmlElement.findElements('b:Id').isNotEmpty
            ? xmlElement.findElements('b:Id').single.text
            : null,
      );
  factory HalIciIsyeri.fromJson(Map<String, dynamic> json) =>
      _$HalIciIsyeriFromJson(json);

  static HalIciIsyeri getFakeModel() {
    return HalIciIsyeri();
  }

  @override
  fromJson(Map<String, dynamic> json) => _$HalIciIsyeriFromJson(json);
  @override
  Map<String, Object?> toJson() => _$HalIciIsyeriToJson(this);
}
