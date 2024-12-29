import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:xml/xml.dart';

import '../../model/hks_user/hks_user.dart';

class UrunService {
  static UrunService? _instance;

  static UrunService get instance => _instance ??= UrunService._init();

  UrunService._init();

  Map<String, String> headers = {"Content-Type": "text/xml"};
  String soapAction = 'http://www.gtb.gov.tr//WebServices/IUrunService/';
  Uri url = Uri.parse('https://hks.hal.gov.tr/WebServices/UrunService.svc');
  late String password;
  late String servicePassword;
  late String userName;
  Future<Response> customPost(Uri url,
      {Map<String, String>? headers, Object? body}) async {
    try {
      var result = await http.post(url, headers: headers, body: body);

      return result;
    } catch (e) {


      return http.Response("<Error>Error</Error>", 400);
    }
  }

  void assignHksUserInfo(HksUser user) {
    password = user.password;
    servicePassword = user.webServicePassword;
    userName = user.userName;
  }

  Future<Map<String, String>> fetchMalinNiteligi() async {
    Map<String, String> malinNiteligi = {};

    headers.addAll({"SOAPAction": "${soapAction}UrunServiceMalinNiteligi"});
    final result = await customPost(url,
        headers: headers,
        body:
            '''<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:web="http://www.gtb.gov.tr//WebServices">
   <soapenv:Header/>
   <soapenv:Body>
      <web:BaseRequestMessageOf_MalinNiteligiIstek>
          <web:Istek/>
            <web:Password>$password</web:Password>
          <web:ServicePassword>$servicePassword</web:ServicePassword>
          <web:UserName>$userName</web:UserName>
      </web:BaseRequestMessageOf_MalinNiteligiIstek>
   </soapenv:Body>
</soapenv:Envelope>''');
    var document = XmlDocument.parse(result.body);
    document.findAllElements('b:MalinNiteligiDTO').forEach((element) {
      malinNiteligi.addAll({
        element.findElements("b:Id").first.children.first.toString(): element
            .findElements("b:MalinNiteligiAdi")
            .first
            .children
            .first
            .toString()
      });
    });
    headers.remove("SOAPAction");
    return malinNiteligi;
  }

  Future<Map<String, String>> fetchUrunler() async {
    Map<String, String> urunler = {};

    headers.addAll({"SOAPAction": "${soapAction}UrunServiceUrunler"});
    final result = await customPost(url,
        headers: headers, body: '''<?xml version="1.0" encoding="utf-8"?>
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:web="http://www.gtb.gov.tr//WebServices">
   <soapenv:Header/>
   <soapenv:Body>
      <web:BaseRequestMessageOf_UrunlerIstek>
         <web:Istek/>
         <web:Password>$password</web:Password>
          <web:ServicePassword>$servicePassword</web:ServicePassword>
          <web:UserName>$userName</web:UserName>
      </web:BaseRequestMessageOf_UrunlerIstek>
   </soapenv:Body>
</soapenv:Envelope>
''');
    var document = XmlDocument.parse(result.body);
    document.findAllElements('b:UrunDTO').forEach((element) {
      urunler.addAll({
        element.findElements("b:Id").first.children.first.toString():
            element.findElements("b:UrunAdi").first.children.first.toString()
      });
    });
    headers.remove("SOAPAction");
    return urunler;
  }

  Future<Map<String, String>> fetchUrunBirimleri() async {
    Map<String, String> urunBirimleri = {};

    headers.addAll({"SOAPAction": "${soapAction}UrunServiceUrunBirimleri"});
    final result = await customPost(url,
        headers: headers,
        body:
            '''<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:web="http://www.gtb.gov.tr//WebServices">
   <soapenv:Header/>
   <soapenv:Body>
      <web:BaseRequestMessageOf_UrunBirimleriIstek>
          <web:Istek/>
          <web:Password>$password</web:Password>
          <web:ServicePassword>$servicePassword</web:ServicePassword>
          <web:UserName>$userName</web:UserName>
      </web:BaseRequestMessageOf_UrunBirimleriIstek>
   </soapenv:Body>
</soapenv:Envelope>
''');
    var document = XmlDocument.parse(result.body);
    document.findAllElements('b:UrunBirimiDTO').forEach((element) {
      urunBirimleri.addAll({
        element.findElements("b:Id").first.children.first.toString(): element
            .findElements("b:UrunBirimAdi")
            .first
            .children
            .first
            .toString()
      });
    });
    headers.remove("SOAPAction");
    return urunBirimleri;
  }

  Future<Map<String, String>> fetchUretimSekiller() async {
    Map<String, String> uretimSekilleri = {};

    headers.addAll({"SOAPAction": "${soapAction}UrunServiceUretimSekilleri"});
    final result = await customPost(url,
        headers: headers,
        body:
            '''<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:web="http://www.gtb.gov.tr//WebServices">
    <soapenv:Header/>
    <soapenv:Body>
        <web:BaseRequestMessageOf_UretimSekilleriIstek>
            <web:Istek/>
           <web:Password>$password</web:Password>
          <web:ServicePassword>$servicePassword</web:ServicePassword>
          <web:UserName>$userName</web:UserName>
        </web:BaseRequestMessageOf_UretimSekilleriIstek>o
    </soapenv:Body>
</soapenv:Envelope>
''');
    var document = XmlDocument.parse(result.body);
    document.findAllElements('b:UretimSekliDTO').forEach((element) {
      uretimSekilleri.addAll({
        element.findElements("b:Id").first.children.first.toString(): element
            .findElements("b:UretimSekliAdi")
            .first
            .children
            .first
            .toString()
      });
    });

    headers.remove("SOAPAction");
    return uretimSekilleri;
  }

  Future<Map<String, Map<String, String>>> fetchUrunCinsleri(String id) async {
    Map<String, Map<String, String>> urunCinsleri = {};

    headers.addAll({"SOAPAction": "${soapAction}UrunServiceUrunCinsleri"});
    final result = await customPost(url,
        headers: headers,
        body:
            '''<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:web="http://www.gtb.gov.tr//WebServices" xmlns:gtb="http://schemas.datacontract.org/2004/07/GTB.HKS.Urun.ServiceContract">
    <soapenv:Header/>
    <soapenv:Body>
        <web:BaseRequestMessageOf_UrunCinsleriIstek>
            <web:Istek>
                <gtb:UrunId>$id</gtb:UrunId>
            </web:Istek>
            <web:Password>$password</web:Password>
          <web:ServicePassword>$servicePassword</web:ServicePassword>
          <web:UserName>$userName</web:UserName>
        </web:BaseRequestMessageOf_UrunCinsleriIstek>
    </soapenv:Body>
</soapenv:Envelope>
''');

    var document = XmlDocument.parse(result.body);
    document.findAllElements('b:UrunCinsiDTO').forEach((element) {
      Map<String, String> urunCinsi = {};

      urunCinsi.addAll(
          {"Id": element.findElements("b:Id").first.children.first.toString()});
      urunCinsi.addAll({
        "Ithalmi":
            element.findElements("b:Ithalmi").first.children.first.toString()
      });
      urunCinsi.addAll({
        "UrunCinsiAdi": element
            .findElements("b:UrunCinsiAdi")
            .first
            .children
            .first
            .toString()
      });
      urunCinsi.addAll({
        "UretimSekliId": element
            .findElements("b:UretimSekliId")
            .first
            .children
            .first
            .toString()
      });
      urunCinsi.addAll({
        "UrunId":
            element.findElements("b:UrunId").first.children.first.toString()
      });
      urunCinsi.addAll({
        "UrunKodu":
            element.findElements("b:UrunKodu").first.children.first.toString()
      });
      urunCinsleri.addAll({
        element.findElements("b:Id").first.children.first.toString(): urunCinsi
      });
    });
    headers.remove("SOAPAction");
    return urunCinsleri;
  }

  Future<Map<String, Map<String, String>>> fetchUrunMiktarBirimleri() async {
    Map<String, Map<String, String>> urunMiktarBirimleri = {};

    headers
        .addAll({"SOAPAction": "${soapAction}UrunServiceUrunMiktarBirimleri"});
    final result = await customPost(url,
        headers: headers,
        body:
            '''<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:web="http://www.gtb.gov.tr//WebServices">
   <soapenv:Header/>
   <soapenv:Body>
      <web:BaseRequestMessageOf_UrunMiktarBirimleriIstek>
          <web:Istek/>
           <web:Password>$password</web:Password>
          <web:ServicePassword>$servicePassword</web:ServicePassword>
          <web:UserName>$userName</web:UserName>
      </web:BaseRequestMessageOf_UrunMiktarBirimleriIstek>
   </soapenv:Body>
</soapenv:Envelope>
''');
    var document = XmlDocument.parse(result.body);
    String id = "";
    document.findAllElements('b:UrunMiktarBirimleriDTO').forEach((element) {
      Map<String, String> urun = {};

      id = element.findElements("b:UrunId").first.children.first.toString();
      urun.addAll({
        "MiktarBirimAd": element
            .findElements("b:MiktarBirimAd")
            .first
            .children
            .first
            .toString()
      });
      urun.addAll({
        "MiktarBirimId": element
            .findElements("b:MiktarBirimId")
            .first
            .children
            .first
            .toString()
      });
      urun.addAll({
        "UrunId":
            element.findElements("b:UrunId").first.children.first.toString()
      });
      urunMiktarBirimleri.addAll({
        element.findElements("b:UrunId").first.children.first.toString(): urun
      });
    });

    headers.remove("SOAPAction");
    return urunMiktarBirimleri;
  }
}
