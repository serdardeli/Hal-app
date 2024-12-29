import 'dart:developer';

import 'sub/bildirim_kayit_cevap_model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:xml/xml.dart';
part 'bildirim_kayit_response_model.g.dart';

@JsonSerializable()
class BildirimKayitResponseModel {
  String? islemKodu;
  List<String>? message;
  List<BildirimKayitCevapModel>? kayitCevapList;
  BildirimKayitResponseModel(
      {this.islemKodu, this.message, this.kayitCevapList});
  factory BildirimKayitResponseModel.fromXmlElement(XmlDocument xmlElement) {
    List<String>? messages;
    List<BildirimKayitCevapModel>? kayitCevapModelList;
    xmlElement.findAllElements('a:BildirimKayitCevap').forEach(
      (element) {
        if (element.findAllElements("a:Mesaj").isNotEmpty &&
            element.findAllElements("a:Mesaj").single.text.trim() != "") {
          messages ??= [];

          messages!.add(element.findAllElements("a:Mesaj").single.text);
        }
      },
    );
    if (xmlElement.findAllElements('a:BildirimKayitCevap').isNotEmpty) {
      kayitCevapModelList ??= [];

      xmlElement.findAllElements('a:BildirimKayitCevap').forEach((element) {
        var result = BildirimKayitCevapModel.fromXmlElementt(element);
        kayitCevapModelList!.add(result);
      });
    }

    kayitCevapModelList?.forEach((element) {

    });

    return BildirimKayitResponseModel(
        islemKodu: ((xmlElement.findAllElements('IslemKodu').isEmpty
            ? "islem kodu "
            : xmlElement.findAllElements('IslemKodu').single.text)),
        message: messages,
        kayitCevapList: kayitCevapModelList);
  }
  @override
  Map<String, Object?> toJson() => _$BildirimKayitResponseModelToJson(this);
}
