import 'package:xml/xml.dart';

import '../../../core/model/base_model/base_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';

import '../bildirim/bildirim_model.dart';
part 'kayitli_kisi_model.g.dart';

@HiveType(typeId: 13)
@JsonSerializable()
class KayitliKisi extends HiveObject implements BaseModel {
  @HiveField(0)
  String? kayitliKisimi;
  @HiveField(1, defaultValue: [])
  List<String> sifatlar;

  factory KayitliKisi.fromXmlElement (XmlElement xmlElement) {
    List<String> listOfSifatlar = [];
    xmlElement.findElements("b:Sifatlari").first.children.isNotEmpty
        ? xmlElement
            .findElements("b:Sifatlari")
            .first
            .findElements("c:int")
            .forEach((element) {
            listOfSifatlar.add(element.children.first.toString());
          })
        : "null";
    return KayitliKisi(
        kayitliKisimi: (xmlElement.findElements('b:KayitliKisiMi').isNotEmpty
            ? (xmlElement
                .findElements('b:KayitliKisiMi')
                .single
                .text
                .toString())
            : null),
        sifatlar: listOfSifatlar);
  }
  KayitliKisi({this.kayitliKisimi, this.sifatlar = const []});
  factory KayitliKisi.fromJson(Map<String, dynamic> json) =>
      _$KayitliKisiFromJson(json);

  static KayitliKisi getFakeModel() {
    return KayitliKisi();
  }

  @override
  fromJson(Map<String, dynamic> json) => _$KayitliKisiFromJson(json);
  @override
  Map<String, Object?> toJson() => _$KayitliKisiToJson(this);
}
