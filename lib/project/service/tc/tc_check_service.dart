import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';

class TcCheckService {
  static TcCheckService? _instance;

  static TcCheckService get instance => _instance ??= TcCheckService._();

  TcCheckService._();
  final String url = "https://tckimlik.nvi.gov.tr/Service/KPSPublic.asmx";

  Future<bool> tcCheck(
      {required String tc,
      required String name,
      required String surname,
      required String year}) async {


    try {
      var result = await http.post(Uri.parse(url), body: '''
<?xml version="1.0" encoding="utf-8"?>
<soap12:Envelope xmlns:soap12="http://www.w3.org/2003/05/soap-envelope">
  <soap12:Body>
    <TCKimlikNoDogrula xmlns="http://tckimlik.nvi.gov.tr/WS">
      <TCKimlikNo>$tc</TCKimlikNo>
      <Ad>$name</Ad>
      <Soyad>$surname</Soyad>
      <DogumYili>$year</DogumYili>
    </TCKimlikNoDogrula>
  </soap12:Body>
</soap12:Envelope>
''', headers: {
        'SOAPAction': 'http://tckimlik.nvi.gov.tr/WS/TCKimlikNoDogrula',
        'Content-Type': 'text/xml; charset=utf-8'
      });


      var document = XmlDocument.parse(result.body);
      String? finalResult;
      document.findAllElements('TCKimlikNoDogrulaResult').forEach((element) {
         finalResult = element.children.first.toString().toLowerCase();
      });
      if (finalResult == "true") {
        return true;
      } else {
        return false;
      }
       
    } catch (e) {

      return false;
    }

    // return result.body;
  }
}
