import 'dart:developer';
import 'dart:io';

import 'package:hal_app/project/model/depo/depo_model.dart';
import 'package:hal_app/project/model/sube/sube_model.dart';

import '../../model/hks_user/hks_user.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:xml/xml.dart';

import '../../../core/model/error_model/base_error_model.dart';
import '../../../core/model/response_model/response_model.dart';
import '../../model/hal_ici_isyeri/hal_ici_isyeri_model.dart';

class GeneralService {
  static GeneralService? _instance;

  static GeneralService get instance => _instance ??= GeneralService._init();
  GeneralService._init();
  String soapAction = 'http://www.gtb.gov.tr//WebServices/IGenelService/';
  Uri url = Uri.parse('https://hks.hal.gov.tr/WebServices/GenelService.svc');
  late String password;
  late String servicePassword;
  late String userName;

  void assignHksUserInfo(HksUser user) {
    password = user.password;
    servicePassword = user.webServicePassword;
    userName = user.userName;
  }

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
                  message: response.statusCode.toString(),
                  statusCode: response.statusCode));
      }
    } catch (e) {

      return ResponseModel<dynamic>(
          error: BaseError(message: e.toString(), statusCode: 400));
    }
  }

  Future<Response> customPost(Uri url,
      {Map<String, String>? headers, Object? body}) async {
    try {
      return await http.post(url, headers: headers, body: body);
    } catch (e) {

      return http.Response("<Error>Error</Error>", 400);
    }
  }

  Map<String, String> headers = {"Content-Type": "text/xml"};

  Future<ResponseModel> fetchAllCities() async {
    Map<String, String> iller = {};
    headers.addAll({"SOAPAction": "${soapAction}GenelServisIller"});
    final result = await customHttpPost(url,
        headers: headers, body: '''<?xml version="1.0" encoding="utf-8"?>
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:web="http://www.gtb.gov.tr//WebServices">
   <soapenv:Body>
      <web:BaseRequestMessageOf_IllerIstek>
          <web:Istek/>
          <web:Password>$password</web:Password>
          <web:ServicePassword>$servicePassword</web:ServicePassword>
          <web:UserName>$userName</web:UserName>
      </web:BaseRequestMessageOf_IllerIstek>
   </soapenv:Body>
</soapenv:Envelope>
''');

    /* final result = await customPost(url,
        headers: headers, body: '''<?xml version="1.0" encoding="utf-8"?>
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:web="http://www.gtb.gov.tr//WebServices">
   <soapenv:Body>
      <web:BaseRequestMessageOf_IllerIstek>
          <web:Istek/>
          <web:Password>$password</web:Password>
          <web:ServicePassword>$servicePassword</web:ServicePassword>
          <web:UserName>$userName</web:UserName>
      </web:BaseRequestMessageOf_IllerIstek>
   </soapenv:Body>
</soapenv:Envelope>
''');*/
    headers.remove("SOAPAction");

    if (result.error != null) {
      return result;
    } else {
      var document = XmlDocument.parse(result.data);
      document.findAllElements('b:IlDTO').forEach((element) {
        iller.addAll({
          element.findElements("b:Id").first.children.first.toString():
              element.findElements("b:IlAdi").first.children.first.toString()
        });
      });

      return ResponseModel(data: iller);
    }
  }

  Future<Map<String, String>> fetchAllIlceler(String id) async {
    Map<String, String> ilceler = {};

    headers.addAll({"SOAPAction": "${soapAction}GenelServisIlceler"});
    final result = await customPost(url,
        headers: headers,
        body:
            '''<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:web="http://www.gtb.gov.tr//WebServices" xmlns:gtb="http://schemas.datacontract.org/2004/07/GTB.HKS.Genel.ServiceContract">
   <soapenv:Body>
      <web:BaseRequestMessageOf_IlcelerIstek>
          <web:Istek>
             <gtb:IlId>$id</gtb:IlId>
         </web:Istek>
           <web:Password>$password</web:Password>
          <web:ServicePassword>$servicePassword</web:ServicePassword>
          <web:UserName>$userName</web:UserName>
      </web:BaseRequestMessageOf_IlcelerIstek>
   </soapenv:Body>
</soapenv:Envelope>''');
    var document = XmlDocument.parse(result.body);
    document.findAllElements('b:IlceDTO').forEach((element) {
      ilceler.addAll({
        element.findElements("b:Id").first.children.first.toString():
            element.findElements("b:IlceAdi").first.children.first.toString()
      });
    });
    headers.remove("SOAPAction");

    return ilceler;
  }

  Future<Map<String, String>> fetchAllBeldeler(String id) async {
    Map<String, String> beldeler = {};

    headers.addAll({"SOAPAction": "${soapAction}GenelServisBeldeler"});
    final result = await customPost(url,
        headers: headers,
        body:
            '''<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:web="http://www.gtb.gov.tr//WebServices" xmlns:gtb="http://schemas.datacontract.org/2004/07/GTB.HKS.Genel.ServiceContract">
   <soapenv:Header/>
   <soapenv:Body>
      <web:BaseRequestMessageOf_BeldelerIstek>
          <web:Istek>
             <gtb:IlceId>$id</gtb:IlceId>
         </web:Istek>
          <web:Password>$password</web:Password>
          <web:ServicePassword>$servicePassword</web:ServicePassword>
          <web:UserName>$userName</web:UserName>
      </web:BaseRequestMessageOf_BeldelerIstek>
   </soapenv:Body>
</soapenv:Envelope>''');
    var document = XmlDocument.parse(result.body);
    document.findAllElements('b:BeldeDTO').forEach((element) {
      beldeler.addAll({
        element.findElements("b:Id").first.children.first.toString():
            element.findElements("b:BeldeAdi").first.children.first.toString()
      });
    });
    headers.remove("SOAPAction");
    return beldeler;
  }

  Future<Map<String, String>> fetchAllCountries() async {
    Map<String, String> contries = {};

    headers.addAll({"SOAPAction": "${soapAction}GenelServisUlkeler"});
    final result = await customPost(url,
        headers: headers, body: '''<?xml version="1.0" encoding="utf-8"?>
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:web="http://www.gtb.gov.tr//WebServices">
   <soapenv:Body>
      <web:BaseRequestMessageOf_UlkelerIstek>
         <web:Istek/>
           <web:Password>$password</web:Password>
          <web:ServicePassword>$servicePassword</web:ServicePassword>
          <web:UserName>$userName</web:UserName>
      </web:BaseRequestMessageOf_UlkelerIstek>
   </soapenv:Body>
</soapenv:Envelope>''');
    var document = XmlDocument.parse(result.body);
    document.findAllElements('b:UlkeDTO').forEach((element) {
      contries.addAll({
        element.findElements("b:Id").first.children.first.toString():
            element.findElements("b:UlkeAdi").first.children.first.toString()
      });
    });
    headers.remove("SOAPAction");
    return contries;
  }

  Future<Map<String, String>> fetchAllHalIciIsyeri(String tc) async {
    Map<String, String> isyeri = {};
    headers.addAll({"SOAPAction": "${soapAction}GenelServisHalIciIsyeri"});
    final result = await customPost(url,
        headers: headers,
        body:
            '''<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:web="http://www.gtb.gov.tr//WebServices" xmlns:gtb="http://schemas.datacontract.org/2004/07/GTB.HKS.Genel.ServiceContract">
   <soapenv:Header/>
   <soapenv:Body>
      <web:BaseRequestMessageOf_HalIciIsyeriIstek>
          <web:Istek>
             <gtb:TcKimlikVergiNo>$tc</gtb:TcKimlikVergiNo>
         </web:Istek>
          <web:Password>$password</web:Password>
          <web:ServicePassword>$servicePassword</web:ServicePassword>
          <web:UserName>$userName</web:UserName>
      </web:BaseRequestMessageOf_HalIciIsyeriIstek>
   </soapenv:Body>
</soapenv:Envelope>''');

    var document = XmlDocument.parse(result.body);
    document.findAllElements('b:HalIciIsyeriDTO').forEach((element) {
      isyeri.addAll({
        "HalAdi":
            element.findElements("b:HalAdi").first.children.first.toString()
      });
      isyeri.addAll({
        "HalId": element.findElements("b:HalId").first.children.first.toString()
      });
      isyeri.addAll(
          {"Id": element.findElements("b:Id").first.children.first.toString()});
      isyeri.addAll({
        "IsyeriAdi":
            element.findElements("b:IsyeriAdi").first.children.first.toString()
      });
      isyeri.addAll({
        "TcKimlikVergiNo": element
            .findElements("b:TcKimlikVergiNo")
            .first
            .children
            .first
            .toString()
      });
    });
    headers.remove("SOAPAction");
    return isyeri;
  }

  Future<List<HalIciIsyeri>> fetchAllHalIciIsyerleriWithModelNew(
      String tc) async {
    List<HalIciIsyeri> isyerleri = [];

    headers.addAll({"SOAPAction": "${soapAction}GenelServisHalIciIsyeri"});
    final result = await customPost(url,
        headers: headers,
        body:
            '''<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:web="http://www.gtb.gov.tr//WebServices" xmlns:gtb="http://schemas.datacontract.org/2004/07/GTB.HKS.Genel.ServiceContract">
   <soapenv:Header/>
   <soapenv:Body>
      <web:BaseRequestMessageOf_HalIciIsyeriIstek>
          <web:Istek>
             <gtb:TcKimlikVergiNo>$tc</gtb:TcKimlikVergiNo>
         </web:Istek>
          <web:Password>$password</web:Password>
          <web:ServicePassword>$servicePassword</web:ServicePassword>
          <web:UserName>$userName</web:UserName>
      </web:BaseRequestMessageOf_HalIciIsyeriIstek>
   </soapenv:Body>
</soapenv:Envelope>''');
    var document = XmlDocument.parse(result.body);
    document.findAllElements('b:HalIciIsyeriDTO').forEach((element) {
      isyerleri.add(HalIciIsyeri.fromXmlElement(element));
    });
    headers.remove("SOAPAction");
    return isyerleri;
  }

  Future<HalIciIsyeri?> fetchAllHalIciIsyeriWithModel(String tc) async {
    HalIciIsyeri? isyeri;
    headers.addAll({"SOAPAction": "${soapAction}GenelServisHalIciIsyeri"});
    final result = await customPost(url,
        headers: headers,
        body:
            '''<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:web="http://www.gtb.gov.tr//WebServices" xmlns:gtb="http://schemas.datacontract.org/2004/07/GTB.HKS.Genel.ServiceContract">
   <soapenv:Header/>
   <soapenv:Body>
      <web:BaseRequestMessageOf_HalIciIsyeriIstek>
          <web:Istek>
             <gtb:TcKimlikVergiNo>$tc</gtb:TcKimlikVergiNo>
         </web:Istek>
          <web:Password>$password</web:Password>
          <web:ServicePassword>$servicePassword</web:ServicePassword>
          <web:UserName>$userName</web:UserName>
      </web:BaseRequestMessageOf_HalIciIsyeriIstek>
   </soapenv:Body>
</soapenv:Envelope>''');

    var document = XmlDocument.parse(result.body);
    document.findAllElements('b:HalIciIsyeriDTO').forEach((element) {
      isyeri = HalIciIsyeri.fromXmlElement(element);
    });
    headers.remove("SOAPAction");
    return isyeri;
  }

  Future<List<Sube>> fetchSubelerWithModel(String tc) async {
    List<Sube> subeler = [];
    headers.addAll({"SOAPAction": "${soapAction}GenelServisSubeler"});

    final result = await customPost(url,
        headers: headers,
        body:
            '''<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:web="http://www.gtb.gov.tr//WebServices" xmlns:gtb="http://schemas.datacontract.org/2004/07/GTB.HKS.Genel.ServiceContract">
   <soapenv:Header/>
   <soapenv:Body>
      <web:BaseRequestMessageOf_SubelerIstek>
          <web:Istek>
             <gtb:TcKimlikVergiNo>$tc</gtb:TcKimlikVergiNo>
         </web:Istek>
          <web:Password>$password</web:Password>
          <web:ServicePassword>$servicePassword</web:ServicePassword>
          <web:UserName>$userName</web:UserName>
      </web:BaseRequestMessageOf_SubelerIstek>
   </soapenv:Body>
</soapenv:Envelope>''');

    var document = XmlDocument.parse(result.body);
    document.findAllElements('b:SubeDTO').forEach((element) {
      subeler.add(Sube.fromXmlElement(element));
    });
    headers.remove("SOAPAction");
    return subeler;
  }

// <b:Id>5</b:Id>
//                        <b:IsletmeTuruAdi>Hal İçi Deposu</b:IsletmeTuruAdi>
  //                   </b:IsletmeTuruDTO>
  //                   <b:IsletmeTuruDTO>
  //                       <b:Id>6</b:Id>
  //                       <b:IsletmeTuruAdi>Hal Dışı Deposu</b:IsletmeTuruAdi>
  Future<List<Depo>> fetchDepolarWithModel(String tc) async {
    List<Depo> depolar = [];
    headers.addAll({"SOAPAction": "${soapAction}GenelServisDepolar"});

    final result = await customPost(url,
        headers: headers,
        body:
            '''<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:web="http://www.gtb.gov.tr//WebServices" xmlns:gtb="http://schemas.datacontract.org/2004/07/GTB.HKS.Genel.ServiceContract">
   <soapenv:Header/>
   <soapenv:Body>
      <web:BaseRequestMessageOf_DepolarIstek>
          <web:Istek>
             <gtb:TcKimlikVergiNo>$tc</gtb:TcKimlikVergiNo>
         </web:Istek>
          <web:Password>$password</web:Password>
          <web:ServicePassword>$servicePassword</web:ServicePassword>
          <web:UserName>$userName</web:UserName>
      </web:BaseRequestMessageOf_DepolarIstek>
   </soapenv:Body>
</soapenv:Envelope>''');

    var document = XmlDocument.parse(result.body);
    document.findAllElements('b:DepoDTO').forEach((element) {
      depolar.add(Depo.fromXmlElement(element));
    });
    headers.remove("SOAPAction");
    return depolar;
  }

  Future<Map<String, String>> fetchAllHalIsletmeTurleri() async {
    Map<String, String> isletmeTurleri = {};

    headers.addAll({"SOAPAction": "${soapAction}GenelServisIsletmeTurleri"});
    final result = await customPost(url,
        headers: headers,
        body:
            '''<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:web="http://www.gtb.gov.tr//WebServices">
   <soapenv:Header/>
   <soapenv:Body>
      <web:BaseRequestMessageOf_IsletmeTurleriIstek>
         <web:Istek/>
           <web:Password>$password</web:Password>
          <web:ServicePassword>$servicePassword</web:ServicePassword>
          <web:UserName>$userName</web:UserName>
      </web:BaseRequestMessageOf_IsletmeTurleriIstek>
   </soapenv:Body>
</soapenv:Envelope>''');
    var document = XmlDocument.parse(result.body);
    document.findAllElements('b:IsletmeTuruDTO').forEach((element) {
      isletmeTurleri.addAll({
        element.findElements("b:Id").first.children.first.toString(): element
            .findElements("b:IsletmeTuruAdi")
            .first
            .children
            .first
            .toString()
      });
    });
    headers.remove("SOAPAction");
    return isletmeTurleri;
  }

  fetchAllDepolar(String tc) async {
    //BOŞ DÖNÜYO SORR!!!!
    headers.addAll({"SOAPAction": "${soapAction}GenelServisDepolar"});
    final result = await customPost(url,
        headers: headers,
        body:
            '''<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:web="http://www.gtb.gov.tr//WebServices" xmlns:gtb="http://schemas.datacontract.org/2004/07/GTB.HKS.Genel.ServiceContract">
    <soapenv:Header/>
    <soapenv:Body>
        <web:BaseRequestMessageOf_DepolarIstek>
            <web:Istek>
                <gtb:TcKimlikVergiNo>$tc</gtb:TcKimlikVergiNo>
            </web:Istek>
            <web:Password>$password</web:Password>
          <web:ServicePassword>$servicePassword</web:ServicePassword>
          <web:UserName>$userName</web:UserName>
        </web:BaseRequestMessageOf_DepolarIstek>
    </soapenv:Body>
</soapenv:Envelope>''');
    headers.remove("SOAPAction");
    return result.body;
  }

  fetchAllSubeler(String tc) async {
    //BOŞ DÖNÜYO SORR!!!!
    headers.addAll({"SOAPAction": "${soapAction}GenelServisSubeler"});
    final result = await customPost(url,
        headers: headers,
        body:
            '''<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:web="http://www.gtb.gov.tr//WebServices" xmlns:gtb="http://schemas.datacontract.org/2004/07/GTB.HKS.Genel.ServiceContract">
    <soapenv:Header/>
    <soapenv:Body>
        <web:BaseRequestMessageOf_SubelerIstek>
            <web:Istek>
                <gtb:TcKimlikVergiNo>$tc</gtb:TcKimlikVergiNo>
            </web:Istek>
            <web:Password>$password</web:Password>
          <web:ServicePassword>$servicePassword</web:ServicePassword>
          <web:UserName>$userName</web:UserName>
        </web:BaseRequestMessageOf_SubelerIstek>
    </soapenv:Body>
</soapenv:Envelope>''');
    headers.remove("SOAPAction");
    return result.body;
  }
}
