import 'package:json_annotation/json_annotation.dart';
part 'hks_bildirim_model.g.dart';

@JsonSerializable()
class HksBildirim {
  //mal
  String malId;
  String malinCinsiId;
  String uretimSekliId; //geleneksek -..
  String malinNiteligiId; //yerli ithal toplama
  String malinMiktarBirimId; //kg
  String uretimBeldeId;
  String uretimIlId;
  String uretimIlceId;
  bool isAnaliz = false;
  String malinMiktari;
  String? malinSatisFiyat;
  String bilidirimTuruId;
  //bildirimci
  String bildirimciKisiSifatId;
  //2. kişi
  String ikinciKisiAdiSoyadi = "";
  String ceptel;
  String ikinciKisiSifat;
  String ikinciKisiTcVergiNo;
  String aracPlakaNo;
  String belgeNo = "0";
  String belgeTipi;
  String gidecegiIsyeriId;
  String gidecegiYerBeldeId = "0";
  String gidecegiYerIlId = "0";
  String gidecegiYerIlceId = "0";
  String gidecegiYerIsletmeTuruId = "0";
  String referansBildirimKunyeNo = "0";
  String uniqueId;

  HksBildirim(
      {required this.malId,
      required this.malinCinsiId,
      required this.uretimSekliId,
      required this.malinMiktarBirimId,
      required this.malinNiteligiId,
      required this.uretimBeldeId,
      required this.uretimIlId,
      required this.uretimIlceId,
      required this.malinMiktari,
      this.malinSatisFiyat = "0",
      required this.bilidirimTuruId,
      required this.bildirimciKisiSifatId,
      this.ikinciKisiAdiSoyadi = "",
      this.ceptel = "",
      this.ikinciKisiSifat = "",
      this.ikinciKisiTcVergiNo = "",
      required this.aracPlakaNo,
      this.belgeNo = "0",
      required this.belgeTipi,
      required this.gidecegiIsyeriId,
      this.gidecegiYerBeldeId = "0",
      this.gidecegiYerIlId = "0",
      this.gidecegiYerIlceId = "0",
      required this.gidecegiYerIsletmeTuruId,
      required this.uniqueId,
      this.referansBildirimKunyeNo = "0"});

  @override
  Map<String, Object?> toJson() => _$HksBildirimToJson(this);
  //TODO: SADECE MALIN ADI(MAL ID)  VE IKINCI KISI SIRKET ADI YAZMAM YETERLI OLABILIR ?? BÖYLE OLURSA ORGANİKTIR FİLAN KISIMLARI FARKLI OLUR??

}
