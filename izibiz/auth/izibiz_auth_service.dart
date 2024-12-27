import 'package:hal_app/core/model/error_model/base_error_model.dart';
import 'package:hal_app/core/model/response_model/response_model.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';

import '../../../../core/model/response_model/IResponse_model.dart';

class IzibizAuthService {
  static IzibizAuthService? _instance;
  static IzibizAuthService get instance => _instance ?? IzibizAuthService._();

  IzibizAuthService._();

  Future<IResponseModel<String?>> login(
      String userName, String password) async {
    try {
      var result = await http.post(
          Uri.parse("https://efaturatest.izibiz.com.tr:443/AuthenticationWS"),
          body: '''
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:wsdl="http://schemas.i2i.com/ei/wsdl">
    <soapenv:Header/>
    <soapenv:Body>
        <wsdl:LoginRequest>
            <USER_NAME>$userName</USER_NAME>
            <PASSWORD>$password</PASSWORD>
        </wsdl:LoginRequest>
    </soapenv:Body>
</soapenv:Envelope>''',
          headers: {"Content-Type": "text/xml; charset=utf-8"});

      if (result.statusCode == 200) {
        var document = XmlDocument.parse(result.body);
        if (document.findAllElements("SESSION_ID").isNotEmpty) {
          String? session = document
              .findAllElements("SESSION_ID")
              .first
              .firstChild
              .toString();
          if (session != "") {
            return ResponseModel(data: session);
          } else {
            return ResponseModel(
                error: BaseError(
                    message: "session id boş izibiz error", statusCode: 400));
          }
        } else {
          if (document.findAllElements("ERROR_SHORT_DES").isNotEmpty) {
            String result = document
                .findAllElements("ERROR_SHORT_DES")
                .first
                .firstChild
                .toString();
            if (result.contains(
                "Gönderilen istek geçersizdir. Kullanıcı adı veya şifre hatalı!")) {
              result = "İzibiz kullanıcı adı veya şifre hatalı";
             }
            return ResponseModel(
                error: BaseError(message: result, statusCode: 400));
          } else {
            return ResponseModel(
                error: BaseError(message: "izibiz error", statusCode: 400));
          }
        }
      } else {
        return ResponseModel(
            error: BaseError(
                message: "error izibiz", statusCode: result.statusCode));
      }
    } catch (e) {
      return ResponseModel(
          error: BaseError(message: "network error izibiz catch", statusCode: 400));
    }
  }
}
