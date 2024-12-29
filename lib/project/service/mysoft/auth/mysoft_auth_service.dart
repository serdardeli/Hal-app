import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/model/error_model/base_error_model.dart';
import '../../../../core/model/response_model/IResponse_model.dart';
import '../../../../core/model/response_model/response_model.dart';
import '../../../../feature/helper/test.dart';

class MySoftAuthService {
  static MySoftAuthService? _instance;
  static MySoftAuthService get instance => _instance ?? MySoftAuthService._();

  MySoftAuthService._();
  final String baseUrl = "https://edocumentapi.mysoft.com.tr";
  final String baseUrlTest = "https://edocumentapitest.mysoft.com.tr";

  Future<IResponseModel<String?>> getToken(
      String userName, String password) async {
    final response = await http.post(
      Uri.parse(
          '${TestApp.instance.isTest ? baseUrlTest : baseUrl}/oauth/token'),
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
      encoding: Encoding.getByName('utf-8'),
      body: {
        "username": userName,
        "password": password,
        "grant_type": "password"
      },
    );

    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      if (result["access_token"] != null) {
        return ResponseModel(data: result["access_token"]);
      } else {
        return ResponseModel(
            error: BaseError(
                message: "my soft access token boş ",
                statusCode: response.statusCode));
      }
    } else {
      if (response.body.isNotEmpty) {
        var result = jsonDecode(response.body);

        if (result["error_description"].toString().trim() != "") {
          return ResponseModel(
              error: BaseError(
                  message: result["error_description"].toString().trim(),
                  statusCode: response.statusCode));
        } else {
          return ResponseModel(
              error: BaseError(
                  message: "My soft auth 1 code error",
                  statusCode: response.statusCode));
        }
      }
      return ResponseModel(
          error: BaseError(
              message: "My soft auth 2 code error",
              statusCode: response.statusCode));
    }
  }
}
