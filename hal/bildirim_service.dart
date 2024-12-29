import 'dart:io';

import 'package:hal_app/project/model/kayitli_kisi_model/kayitli_kisi_model.dart';

import '../../fake_response/bildirim_kayit_response/bildirim_kayit_cevap_multi.dart';
import '../../model/hks_bildirim_model/hks_bildirim_model.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:xml/xml.dart';

import '../../../core/model/error_model/base_error_model.dart';
import '../../../core/model/response_model/response_model.dart';
import '../../model/bildirim_kayit_response_model.dart/bildirim_kayit_response_model.dart';
import '../../model/hks_user/hks_user.dart';
import '../../model/referans_kunye/referans_kunye_model.dart';

class BildirimService {
  static BildirimService? _instance;

  static BildirimService get instance => _instance ??= BildirimService._init();

  BildirimService._init();

  Map<String, String> headers = {"Content-Type": "text/xml"};
  String soapAction = 'http://www.gtb.gov.tr//WebServices/IBildirimService/';
  Uri url = Uri.parse('https://hks.hal.gov.tr/WebServices/BildirimService.svc');
  late String password;
  late String servicePassword;
  late String userName;
  Future<ResponseModel> customHttpPost(Uri url,
      {Map<String, String>? headers, Object? body}) async {
    try {
      var response = await http.post(url, headers: headers, body: body);

      switch (response.statusCode) {
        case HttpStatus.ok:
        case HttpStatus.accepted:
          return ResponseModel<dynamic>(data: response.body);

        default:
          return ResponseModel<dynamic>(
              error: BaseError(
                  message: response.body.toString(),
                  statusCode: response.statusCode));
      }
    } catch (e) {
      return ResponseModel<dynamic>(
          error: BaseError(message: e.toString(), statusCode: 400));
    }
  }

  void assignHksUserInfo(HksUser user) {
    password = user.password;
    servicePassword = user.webServicePassword;
    userName = user.userName;
  }

  Future<Response> customPost(Uri url,
      {Map<String, String>? headers, Object? body}) async {
    try {
      var result = await http.post(url, headers: headers, body: body);

      return result;
    } catch (e) {
      return http.Response("<Error>Error</Error>", 400);
    }
  }

  bildirimTurleri() async {
    Map<String, String> bildirimTurleriMap = {};

    headers
        .addAll({"SOAPAction": "${soapAction}BildirimServisBildirimTurleri"});
    final result = await customPost(url,
        headers: headers, body: '''<?xml version="1.0" encoding="utf-8"?>
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:web="http://www.gtb.gov.tr//WebServices">
    <soapenv:Body>
        <web:BaseRequestMessageOf_BildirimTurleriIstek>
            <web:Istek/>
            <web:Password>$password</web:Password>
          <web:ServicePassword>$servicePassword</web:ServicePassword>
          <web:UserName>$userName</web:UserName>
        </web:BaseRequestMessageOf_BildirimTurleriIstek>
    </soapenv:Body>
</soapenv:Envelope>
''');

    var document = XmlDocument.parse(result.body);
    document.findAllElements('b:BildirimTuruDTO').forEach((element) {
      bildirimTurleriMap.addAll({
        element.findElements("b:Id").first.children.first.toString(): element
            .findElements("b:BildirimTuruAdi")
            .first
            .children
            .first
            .toString()
      });
    });
    headers.remove("SOAPAction");
    return bildirimTurleriMap;
  }

  Future<Map<String, String>> bildirimSifatListesi() async {
    Map<String, String> sifatListesi = {};

    headers.addAll({"SOAPAction": "${soapAction}BildirimServisSifatListesi"});
    final result = await customPost(url,
        headers: headers, body: '''<?xml version="1.0" encoding="utf-8"?>
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:web="http://www.gtb.gov.tr//WebServices">
    <soapenv:Body>
        <web:BaseRequestMessageOf_SifatIstek>
            <web:Istek/>
            <web:Password>$password</web:Password>
          <web:ServicePassword>$servicePassword</web:ServicePassword>
          <web:UserName>$userName</web:UserName>
        </web:BaseRequestMessageOf_SifatIstek>
    </soapenv:Body>
</soapenv:Envelope> 
''');
    var document = XmlDocument.parse(result.body);
    document.findAllElements('b:SifatDTO').forEach((element) {
      sifatListesi.addAll({
        element.findElements("b:Id").first.children.first.toString():
            element.findElements("b:SifatAdi").first.children.first.toString()
      });
    });
    headers.remove("SOAPAction");
    return sifatListesi;
  }

  Future<ResponseModel> bildirimKaydet(HksBildirim bildirim) async {
    headers.addAll({"SOAPAction": "${soapAction}BildirimServisBildirimKaydet"});
    ResponseModel result;

    result = await customHttpPost(url, headers: headers, body: '''
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:web="http://www.gtb.gov.tr//WebServices" xmlns:gtb="http://schemas.datacontract.org/2004/07/GTB.HKS.Bildirim.ServiceContract" xmlns:gtb1="http://schemas.datacontract.org/2004/07/GTB.HKS.Bildirim.Model">
    <soapenv:Header/>
    <soapenv:Body>
        <web:BaseRequestMessageOf_ListOf_BildirimKayitIstek>
            <web:Istek>
                <gtb:BildirimKayitIstek>
                    <gtb:BildirimMalBilgileri>
                        <gtb1:AnalizeGonderilecekMi>false</gtb1:AnalizeGonderilecekMi>
                        <gtb1:GelenUlkeId>201</gtb1:GelenUlkeId>
                        <gtb1:MalinCinsiId>${bildirim.malinCinsiId}</gtb1:MalinCinsiId>
                        <gtb1:MalinKodNo>${bildirim.malId}</gtb1:MalinKodNo>
                        <gtb1:MalinMiktari>${bildirim.malinMiktari}</gtb1:MalinMiktari>
                        <gtb1:MalinNiteligi>${bildirim.malinNiteligiId}</gtb1:MalinNiteligi>
                        <gtb1:MalinSatisFiyat>${bildirim.malinSatisFiyat}</gtb1:MalinSatisFiyat>
                        <gtb1:MiktarBirimId>${bildirim.malinMiktarBirimId}</gtb1:MiktarBirimId>
                        <gtb1:UretimBeldeId>${bildirim.uretimBeldeId}</gtb1:UretimBeldeId>
                        <gtb1:UretimIlId>${bildirim.uretimIlId}</gtb1:UretimIlId>
                        <gtb1:UretimIlceId>${bildirim.uretimIlceId}</gtb1:UretimIlceId>
                        <gtb1:UretimSekli>${bildirim.uretimSekliId}</gtb1:UretimSekli>
                    </gtb:BildirimMalBilgileri>
                    <gtb:BildirimTuru>${bildirim.bilidirimTuruId}</gtb:BildirimTuru>
                    <gtb:BildirimciBilgileri>
                        <gtb1:KisiSifat>${bildirim.bildirimciKisiSifatId}</gtb1:KisiSifat>
                    </gtb:BildirimciBilgileri>
                    <gtb:IkinciKisiBilgileri>
                        <gtb1:AdSoyad>${bildirim.ikinciKisiAdiSoyadi}</gtb1:AdSoyad>
                        <gtb1:CepTel>${bildirim.ceptel}</gtb1:CepTel>
                        <gtb1:Eposta></gtb1:Eposta>
                        <gtb1:KisiSifat>${bildirim.ikinciKisiSifat}</gtb1:KisiSifat>
                        <gtb1:TcKimlikVergiNo>${bildirim.ikinciKisiTcVergiNo}</gtb1:TcKimlikVergiNo>
                        <gtb1:YurtDisiMi>false</gtb1:YurtDisiMi>
                    </gtb:IkinciKisiBilgileri>
                    <gtb:MalinGidecekYerBilgileri>
                        <gtb1:AracPlakaNo>${bildirim.aracPlakaNo}</gtb1:AracPlakaNo>
                        <gtb1:BelgeNo>${bildirim.belgeNo}</gtb1:BelgeNo>
                        <gtb1:BelgeTipi>${bildirim.belgeTipi}</gtb1:BelgeTipi>
                        <gtb1:GidecekIsyeriId>${bildirim.gidecegiIsyeriId}</gtb1:GidecekIsyeriId>
                        <gtb1:GidecekUlkeId>201</gtb1:GidecekUlkeId>
                        <gtb1:GidecekYerBeldeId>${bildirim.gidecegiYerBeldeId}</gtb1:GidecekYerBeldeId>
                        <gtb1:GidecekYerIlId>${bildirim.gidecegiYerIlId}</gtb1:GidecekYerIlId>
                        <gtb1:GidecekYerIlceId>${bildirim.gidecegiYerIlceId}</gtb1:GidecekYerIlceId>
                        <gtb1:GidecekYerIsletmeTuruId>${bildirim.gidecegiYerIsletmeTuruId}</gtb1:GidecekYerIsletmeTuruId>
                    </gtb:MalinGidecekYerBilgileri>
                    <gtb:ReferansBildirimKunyeNo>${bildirim.referansBildirimKunyeNo}</gtb:ReferansBildirimKunyeNo>
                    <gtb:UniqueId>${bildirim.uniqueId}</gtb:UniqueId>
                </gtb:BildirimKayitIstek>
            </web:Istek>
      <web:Password>$password</web:Password>
          <web:ServicePassword>$servicePassword</web:ServicePassword>
          <web:UserName>$userName</web:UserName>
        </web:BaseRequestMessageOf_ListOf_BildirimKayitIstek>
    </soapenv:Body>
</soapenv:Envelope>''');
    headers.remove("SOAPAction");

    if (result.error != null) {
      return result;
    } else {
      var document = XmlDocument.parse(result.data);

      BildirimKayitResponseModel result2 =
          BildirimKayitResponseModel.fromXmlElement(document);
      return ResponseModel(data: result2);
    }
  }

  String xmlGeneratorSingle(HksBildirim bildirim) {
    return '''<gtb:BildirimKayitIstek>
                    <gtb:BildirimMalBilgileri>
                        <gtb1:AnalizeGonderilecekMi>false</gtb1:AnalizeGonderilecekMi>
                        <gtb1:GelenUlkeId>201</gtb1:GelenUlkeId>
                        <gtb1:MalinCinsiId>${bildirim.malinCinsiId}</gtb1:MalinCinsiId>
                        <gtb1:MalinKodNo>${bildirim.malId}</gtb1:MalinKodNo>
                        <gtb1:MalinMiktari>${bildirim.malinMiktari}</gtb1:MalinMiktari>
                        <gtb1:MalinNiteligi>${bildirim.malinNiteligiId}</gtb1:MalinNiteligi>
                        <gtb1:MalinSatisFiyat>${bildirim.malinSatisFiyat}</gtb1:MalinSatisFiyat>
                        <gtb1:MiktarBirimId>${bildirim.malinMiktarBirimId}</gtb1:MiktarBirimId>
                        <gtb1:UretimBeldeId>${bildirim.uretimBeldeId}</gtb1:UretimBeldeId>
                        <gtb1:UretimIlId>${bildirim.uretimIlId}</gtb1:UretimIlId>
                        <gtb1:UretimIlceId>${bildirim.uretimIlceId}</gtb1:UretimIlceId>
                        <gtb1:UretimSekli>${bildirim.uretimSekliId}</gtb1:UretimSekli>
                    </gtb:BildirimMalBilgileri>
                    <gtb:BildirimTuru>${bildirim.bilidirimTuruId}</gtb:BildirimTuru>
                    <gtb:BildirimciBilgileri>
                        <gtb1:KisiSifat>${bildirim.bildirimciKisiSifatId}</gtb1:KisiSifat>
                    </gtb:BildirimciBilgileri>
                    <gtb:IkinciKisiBilgileri>
                        <gtb1:AdSoyad>${bildirim.ikinciKisiAdiSoyadi}</gtb1:AdSoyad>
                        <gtb1:CepTel>${bildirim.ceptel}</gtb1:CepTel>
                        <gtb1:Eposta></gtb1:Eposta>
                        <gtb1:KisiSifat>${bildirim.ikinciKisiSifat}</gtb1:KisiSifat>
                        <gtb1:TcKimlikVergiNo>${bildirim.ikinciKisiTcVergiNo}</gtb1:TcKimlikVergiNo>
                        <gtb1:YurtDisiMi>false</gtb1:YurtDisiMi>
                    </gtb:IkinciKisiBilgileri>
                    <gtb:MalinGidecekYerBilgileri>
                        <gtb1:AracPlakaNo>${bildirim.aracPlakaNo}</gtb1:AracPlakaNo>
                        <gtb1:BelgeNo>${bildirim.belgeNo}</gtb1:BelgeNo>
                        <gtb1:BelgeTipi>${bildirim.belgeTipi}</gtb1:BelgeTipi>
                        <gtb1:GidecekIsyeriId>${bildirim.gidecegiIsyeriId}</gtb1:GidecekIsyeriId>
                        <gtb1:GidecekUlkeId>201</gtb1:GidecekUlkeId>
                        <gtb1:GidecekYerBeldeId>${bildirim.gidecegiYerBeldeId}</gtb1:GidecekYerBeldeId>
                        <gtb1:GidecekYerIlId>${bildirim.gidecegiYerIlId}</gtb1:GidecekYerIlId>
                        <gtb1:GidecekYerIlceId>${bildirim.gidecegiYerIlceId}</gtb1:GidecekYerIlceId>
                        <gtb1:GidecekYerIsletmeTuruId>${bildirim.gidecegiYerIsletmeTuruId}</gtb1:GidecekYerIsletmeTuruId>
                    </gtb:MalinGidecekYerBilgileri>
                    <gtb:ReferansBildirimKunyeNo>${bildirim.referansBildirimKunyeNo}</gtb:ReferansBildirimKunyeNo>
                    <gtb:UniqueId>${bildirim.uniqueId}</gtb:UniqueId>
                </gtb:BildirimKayitIstek>
''';
  }

  String xmlGeneratorMulti(List<HksBildirim> listOfBildirimler) {
    String newList = "";
    for (var element in listOfBildirimler) {
      newList += xmlGeneratorSingle(element);
    }

    return newList;
  }

  Future<ResponseModel> fakeCokluBildirimKaydet(
      List<HksBildirim> bildirim) async {
    Response result;

    String xmlList = xmlGeneratorMulti(bildirim);
    var document = XmlDocument.parse(
        FakeBildirimKayitCevap.instance.getCokluBildirimKayitCevapGuncelOlumlu);

    BildirimKayitResponseModel? result2 =
        BildirimKayitResponseModel.fromXmlElement(document);

    return Future.value(ResponseModel(data: result2));
  }

  Future<ResponseModel> cokluBildirimKaydet(List<HksBildirim> bildirim) async {
    headers.addAll({"SOAPAction": "${soapAction}BildirimServisBildirimKaydet"});
    ResponseModel result;

    String xmlList = xmlGeneratorMulti(bildirim);

    var a = '''
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:web="http://www.gtb.gov.tr//WebServices" xmlns:gtb="http://schemas.datacontract.org/2004/07/GTB.HKS.Bildirim.ServiceContract" xmlns:gtb1="http://schemas.datacontract.org/2004/07/GTB.HKS.Bildirim.Model">
    <soapenv:Header/>
    <soapenv:Body>
        <web:BaseRequestMessageOf_ListOf_BildirimKayitIstek>
            <web:Istek>
              $xmlList
            </web:Istek>
      <web:Password>$password</web:Password>
          <web:ServicePassword>$servicePassword</web:ServicePassword>
          <web:UserName>$userName</web:UserName>
        </web:BaseRequestMessageOf_ListOf_BildirimKayitIstek>
    </soapenv:Body>
</soapenv:Envelope>''';

    var document = XmlDocument.parse(a);

    result = await customHttpPost(url, headers: headers, body: a);
    if (result.error != null) {
      return result;
    } else {
      BildirimKayitResponseModel result2 =
          BildirimKayitResponseModel.fromXmlElement(
              XmlDocument.parse(result.data));
      var document2 = XmlDocument.parse(result.data);

      return ResponseModel(data: result2);
    }
  }

  bildirimReferansKunyeler() async {
    headers
        .addAll({"SOAPAction": "${soapAction}BildirimServisReferansKunyeler"});
    final result = await customPost(url,
        headers: headers, body: '''<?xml version="1.0" encoding="utf-8"?>
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:web="http://www.gtb.gov.tr//WebServices" xmlns:gtb="http://schemas.datacontract.org/2004/07/GTB.HKS.Bildirim.ServiceContract">
   <soapenv:Header/>
   <soapenv:Body>
      <web:BaseRequestMessageOf_ReferansKunyeIstek>
          <web:Istek>
             <gtb:BaslangicTarihi>2022-01-30T09:00:00</gtb:BaslangicTarihi>
             <gtb:BitisTarihi>2022-02-25T09:00:00</gtb:BitisTarihi>
             <gtb:KalanMiktariSifirdanBuyukOlanlar>true</gtb:KalanMiktariSifirdanBuyukOlanlar>
             <gtb:KisiSifat>6</gtb:KisiSifat>
             <gtb:KunyeNo>0</gtb:KunyeNo>
             <gtb:MalinSahibiTcKimlikVergiNo>8920308978</gtb:MalinSahibiTcKimlikVergiNo>
             <gtb:UrunId>462</gtb:UrunId>
         </web:Istek>
         <web:Password>$password</web:Password>
          <web:ServicePassword>$servicePassword</web:ServicePassword>
          <web:UserName>$userName</web:UserName>
      </web:BaseRequestMessageOf_ReferansKunyeIstek>
   </soapenv:Body>
</soapenv:Envelope>
''');
    headers.remove("SOAPAction");
    return result.body;
  }

  Future<Map<String, dynamic>> bildirimKayitliKisiSorgu(String tc) async {
    Map<String, dynamic> kayitliKisiMap = {};

    headers
        .addAll({"SOAPAction": "${soapAction}BildirimServisKayitliKisiSorgu"});
    final result = await customPost(url,
        headers: headers, body: '''<?xml version="1.0" encoding="utf-8"?>
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:web="http://www.gtb.gov.tr//WebServices" xmlns:gtb="http://schemas.datacontract.org/2004/07/GTB.HKS.Bildirim.ServiceContract" xmlns:arr="http://schemas.microsoft.com/2003/10/Serialization/Arrays">
    <soapenv:Header/>
    <soapenv:Body>
        <web:BaseRequestMessageOf_KayitliKisiSorguIstek>
            <web:Istek>
                <gtb:TcKimlikVergiNolar>
                    <arr:string>$tc</arr:string>
                </gtb:TcKimlikVergiNolar>
            </web:Istek>
           <web:Password>$password</web:Password>
          <web:ServicePassword>$servicePassword</web:ServicePassword>
          <web:UserName>$userName</web:UserName>
        </web:BaseRequestMessageOf_KayitliKisiSorguIstek>
    </soapenv:Body>
</soapenv:Envelope>
''');

    var document = XmlDocument.parse(result.body);
    document.findAllElements('b:KayitliKisiSorguDTO').forEach((element) {
      kayitliKisiMap.addAll({
        "KayitliKisiMi": element
            .findElements("b:KayitliKisiMi")
            .first
            .children
            .first
            .toString()
      });
      List<String> listOfSifatlar = [];
      element.findElements("b:Sifatlari").first.children.isNotEmpty
          ? element
              .findElements("b:Sifatlari")
              .first
              .findElements("c:int")
              .forEach((element) {
              listOfSifatlar.add(element.children.first.toString());
            })
          : "null";
      kayitliKisiMap.addAll({"Sifatlari": listOfSifatlar});

      kayitliKisiMap.addAll({
        "TcKimlikVergiNo": element
            .findElements("b:TcKimlikVergiNo")
            .first
            .children
            .first
            .toString()
      });
    });
    headers.remove("SOAPAction");
    return kayitliKisiMap;
  }

  Future<KayitliKisi?> bildirimKayitliKisiSorguWithModel(String tc) async {
    KayitliKisi? kayitliKisi;
    headers
        .addAll({"SOAPAction": "${soapAction}BildirimServisKayitliKisiSorgu"});
    final result = await customPost(url,
        headers: headers, body: '''<?xml version="1.0" encoding="utf-8"?>
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:web="http://www.gtb.gov.tr//WebServices" xmlns:gtb="http://schemas.datacontract.org/2004/07/GTB.HKS.Bildirim.ServiceContract" xmlns:arr="http://schemas.microsoft.com/2003/10/Serialization/Arrays">
    <soapenv:Header/>
    <soapenv:Body>
        <web:BaseRequestMessageOf_KayitliKisiSorguIstek>
            <web:Istek>
                <gtb:TcKimlikVergiNolar>
                    <arr:string>$tc</arr:string>
                </gtb:TcKimlikVergiNolar>
            </web:Istek>
           <web:Password>$password</web:Password>
          <web:ServicePassword>$servicePassword</web:ServicePassword>
          <web:UserName>$userName</web:UserName>
        </web:BaseRequestMessageOf_KayitliKisiSorguIstek>
    </soapenv:Body>
</soapenv:Envelope>
''');

    var document = XmlDocument.parse(result.body);
    document.findAllElements('b:KayitliKisiSorguDTO').forEach((element) {
      kayitliKisi = KayitliKisi.fromXmlElement(element);
    });
    headers.remove("SOAPAction");
    return kayitliKisi;
  }

  bildirimTopluKunye() async {
    headers.addAll({"SOAPAction": "${soapAction}BildirimServisSifatListesi"});
    final result = await customPost(url,
        headers: headers,
        body:
            '''<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:web="http://www.gtb.gov.tr//WebServices" xmlns:gtb="http://schemas.datacontract.org/2004/07/GTB.HKS.Bildirim.ServiceContract">
   <soapenv:Header/>
   <soapenv:Body>
      <web:BaseRequestMessageOf_TopluKunyeIstek>
         <!--Optional:-->
         <web:Istek>
            <!--Optional:-->
            <gtb:AracPlakaNo>?</gtb:AracPlakaNo>
            <!--Optional:-->
            <gtb:BelgeNo>?</gtb:BelgeNo>
            <!--Optional:-->
            <gtb:BildirimTarihi>?</gtb:BildirimTarihi>
         </web:Istek>
         <!--Optional:-->
         <web:Password>?</web:Password>
         <!--Optional:-->
         <web:ServicePassword>?</web:ServicePassword>
         <!--Optional:-->
         <web:UserName>?</web:UserName>
      </web:BaseRequestMessageOf_TopluKunyeIstek>
   </soapenv:Body>
</soapenv:Envelope>
''');
    headers.remove("SOAPAction");
    return result.body;
  }

  bildirimEtiket() async {
    headers.addAll({"SOAPAction": "${soapAction}BildirimServisBildirimEtiket"});
    final result = await customPost(url,
        headers: headers,
        body:
            '''<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:web="http://www.gtb.gov.tr//WebServices" xmlns:gtb="http://schemas.datacontract.org/2004/07/GTB.HKS.Bildirim.ServiceContract">
   <soapenv:Header/>
   <soapenv:Body>
      <web:BaseRequestMessageOf_TopluKunyeIstek>
         <!--Optional:-->
         <web:Istek>
            <!--Optional:-->
            <gtb:AracPlakaNo>?</gtb:AracPlakaNo>
            <!--Optional:-->
            <gtb:BelgeNo>?</gtb:BelgeNo>
            <!--Optional:-->
            <gtb:BildirimTarihi>?</gtb:BildirimTarihi>
         </web:Istek>
         <!--Optional:-->
         <web:Password>?</web:Password>
         <!--Optional:-->
         <web:ServicePassword>?</web:ServicePassword>
         <!--Optional:-->
         <web:UserName>?</web:UserName>
      </web:BaseRequestMessageOf_TopluKunyeIstek>
   </soapenv:Body>
</soapenv:Envelope>
''');
    headers.remove("SOAPAction");
    return result.body;
  }

  belgeTipleriListesi() async {
    Map<String, String> belgeTipleri = {};

    headers.addAll(
        {"SOAPAction": "${soapAction}BildirimServisBelgeTipleriListesi"});
    final result = await customPost(url,
        headers: headers, body: '''<?xml version="1.0" encoding="utf-8"?>
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:web="http://www.gtb.gov.tr//WebServices">
    <soapenv:Body>
        <web:BaseRequestMessageOf_BelgeTipleriIstek>
            <web:Istek/>
            <web:Password>$password</web:Password>
          <web:ServicePassword>$servicePassword</web:ServicePassword>
          <web:UserName>$userName</web:UserName>
        </web:BaseRequestMessageOf_BelgeTipleriIstek>
    </soapenv:Body>
</soapenv:Envelope> 
''');

    var document = XmlDocument.parse(result.body);
    document.findAllElements('a:BelgeTipiDTO').forEach((element) {
      belgeTipleri.addAll({
        element.findElements("a:Id").first.children.first.toString(): element
            .findElements("a:BelgeTipiAdi")
            .first
            .children
            .first
            .toString()
      });
    });
    headers.remove("SOAPAction");
    return belgeTipleri;
  }

  Future<String> bildirimBildirimcininYaptigiBildirimListi(
      String baslangicTarihi, String bitisTarihi) async {
    headers.addAll({
      "SOAPAction":
          "${soapAction}BildirimServisBildirimcininYaptigiBildirimListesi"
    });
    //2022-07-25T10:00:00.000
    //2022-08-04T20:00:00.000

    final result = await customPost(url,
        headers: headers,
        body:
            '''<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:web="http://www.gtb.gov.tr//WebServices" xmlns:gtb="http://schemas.datacontract.org/2004/07/GTB.HKS.Bildirim.ServiceContract">
    <soapenv:Header/>
    <soapenv:Body>
        <web:BaseRequestMessageOf_BildirimSorguIstek>
            <web:Istek>
                <gtb:BaslangicTarihi>$baslangicTarihi</gtb:BaslangicTarihi>
                <gtb:BitisTarihi>$bitisTarihi</gtb:BitisTarihi>
                <gtb:KalanMiktariSifirdanBuyukOlanlar>true</gtb:KalanMiktariSifirdanBuyukOlanlar>
                <gtb:KunyeNo>0</gtb:KunyeNo>
                <gtb:KunyeTuru>1</gtb:KunyeTuru>
                <gtb:Sifat>0</gtb:Sifat>
                <gtb:UniqueId></gtb:UniqueId>
            </web:Istek>
            <web:Password>$password</web:Password>
            <web:ServicePassword>$servicePassword</web:ServicePassword>
            <web:UserName>$userName</web:UserName>
        </web:BaseRequestMessageOf_BildirimSorguIstek>
    </soapenv:Body>
</soapenv:Envelope>''');
    headers.remove("SOAPAction");
    return result.body;
  }

  Future<ResponseModel> bildirimBildirimcininYaptigiBildirimListesiWithObject(
      String baslangicTarihi, String bitisTarihi) async {
    List<ReferansKunye> listKunyeBildirimcininYaptigi = [];

    headers.addAll({
      "SOAPAction":
          "${soapAction}BildirimServisBildirimcininYaptigiBildirimListesi"
    });

    final result = await customHttpPost(url,
        headers: headers,
        body:
            '''<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:web="http://www.gtb.gov.tr//WebServices" xmlns:gtb="http://schemas.datacontract.org/2004/07/GTB.HKS.Bildirim.ServiceContract">
    <soapenv:Header/>
    <soapenv:Body>
        <web:BaseRequestMessageOf_BildirimSorguIstek>
            <web:Istek>
                <gtb:BaslangicTarihi>$baslangicTarihi</gtb:BaslangicTarihi>
                <gtb:BitisTarihi>$bitisTarihi</gtb:BitisTarihi>
                <gtb:KalanMiktariSifirdanBuyukOlanlar>true</gtb:KalanMiktariSifirdanBuyukOlanlar>
                <gtb:KunyeNo>0</gtb:KunyeNo>
                <gtb:KunyeTuru>1</gtb:KunyeTuru>
                <gtb:Sifat>0</gtb:Sifat>
                <gtb:UniqueId></gtb:UniqueId>
            </web:Istek>
            <web:Password>$password</web:Password>
            <web:ServicePassword>$servicePassword</web:ServicePassword>
            <web:UserName>$userName</web:UserName>
        </web:BaseRequestMessageOf_BildirimSorguIstek>
    </soapenv:Body>
</soapenv:Envelope>''');
    headers.remove("SOAPAction");

    if (result.error != null) {
      return result;
    } else {
      final document = XmlDocument.parse(result.data);
      var result1 = document.findAllElements('b:BildirimSorguDTO');

      for (var element in result1) {
        listKunyeBildirimcininYaptigi
            .add(ReferansKunye.fromXmlElement(element));
        ReferansKunye.fromXmlElement(element);
      }
      return ResponseModel(data: listKunyeBildirimcininYaptigi);
    }
  }

  Future<ResponseModel> bildirimBildirimciyeYapilanBildirimListesiWithObject(
      String baslangicTarihi, String bitisTarihi) async {
    List<ReferansKunye> listKunyeBildirimciyeYapilan = [];

    headers.addAll({
      "SOAPAction":
          "${soapAction}BildirimServisBildirimciyeYapilanBildirimListesi"
    });

    final result = await customHttpPost(url,
        headers: headers,
        body:
            '''<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:web="http://www.gtb.gov.tr//WebServices" xmlns:gtb="http://schemas.datacontract.org/2004/07/GTB.HKS.Bildirim.ServiceContract">
    <soapenv:Header/>
    <soapenv:Body>
        <web:BaseRequestMessageOf_BildirimSorguIstek>
            <web:Istek>
                <gtb:BaslangicTarihi>$baslangicTarihi</gtb:BaslangicTarihi>
                <gtb:BitisTarihi>$bitisTarihi</gtb:BitisTarihi>
                <gtb:KalanMiktariSifirdanBuyukOlanlar>true</gtb:KalanMiktariSifirdanBuyukOlanlar>
                <gtb:KunyeNo>0</gtb:KunyeNo>
                <gtb:KunyeTuru>1</gtb:KunyeTuru>
                <gtb:Sifat>0</gtb:Sifat>
                <gtb:UniqueId></gtb:UniqueId>
            </web:Istek>
            <web:Password>$password</web:Password>
            <web:ServicePassword>$servicePassword</web:ServicePassword>
            <web:UserName>$userName</web:UserName>
        </web:BaseRequestMessageOf_BildirimSorguIstek>
    </soapenv:Body>
</soapenv:Envelope>''');
    headers.remove("SOAPAction");
    if (result.error != null) {
      return result;
    } else {
      final document = XmlDocument.parse(result.data);
      var result1 = document.findAllElements('b:BildirimSorguDTO');

      for (var element in result1) {
        listKunyeBildirimciyeYapilan.add(ReferansKunye.fromXmlElement(element));
        ReferansKunye.fromXmlElement(element);
      }
      return ResponseModel(data: listKunyeBildirimciyeYapilan);
    }
  }

  bildirimBildirimciyeYapilanBildirimListesi(
      String baslangicTarihi, String bitisTarihi) async {
    headers.addAll({
      "SOAPAction":
          "${soapAction}BildirimServisBildirimciyeYapilanBildirimListesi"
    });
    final result = await customPost(url,
        headers: headers,
        body:
            '''<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:web="http://www.gtb.gov.tr//WebServices" xmlns:gtb="http://schemas.datacontract.org/2004/07/GTB.HKS.Bildirim.ServiceContract">
    <soapenv:Header/>
    <soapenv:Body>
        <web:BaseRequestMessageOf_BildirimSorguIstek>
            <web:Istek>
                <gtb:BaslangicTarihi>$baslangicTarihi</gtb:BaslangicTarihi>
                <gtb:BitisTarihi>$bitisTarihi</gtb:BitisTarihi>
                <gtb:KalanMiktariSifirdanBuyukOlanlar>true</gtb:KalanMiktariSifirdanBuyukOlanlar>
                <gtb:KunyeNo>0</gtb:KunyeNo>
                <gtb:KunyeTuru>1</gtb:KunyeTuru>
                <gtb:Sifat>0</gtb:Sifat>
                <gtb:UniqueId></gtb:UniqueId>
            </web:Istek>
            <web:Password>$password</web:Password>
            <web:ServicePassword>$servicePassword</web:ServicePassword>
            <web:UserName>$userName</web:UserName>
        </web:BaseRequestMessageOf_BildirimSorguIstek>
    </soapenv:Body>
</soapenv:Envelope>''');
    headers.remove("SOAPAction");
    return result.body;
  }
}
