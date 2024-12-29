import 'dart:convert';
import 'dart:developer';

import 'package:hal_app/feature/helper/test.dart';
import 'package:hal_app/project/model/driver_model/driver_model.dart';
import 'package:hal_app/project/model/musteri_model/musteri_model.dart';
import 'package:hal_app/project/model/mysoft_giden_irsaliye_model.dart/mysoft_giden_irsaliye_model.dart';

import '../../../../core/model/error_model/base_error_model.dart';
import '../../../../core/model/response_model/IResponse_model.dart';
import '../../../../core/model/response_model/response_model.dart';
import 'package:http/http.dart' as http;

import '../../../model/bildirimci/bildirimci_model.dart';
import '../../../model/malin_gidecegi_yer/malin_gidecegi_yer_model.dart';
import '../../../model/mysoft_giden_fatura_model/mysoft_giden_fatura_model.dart';
import '../../../model/referans_kunye/referans_kunye_model.dart';
import '../../../model/uretici_model/uretici_model.dart';
import '../../../model/urun/urun.dart';

class MySoftGidenFaturaService {
  static MySoftGidenFaturaService? _instance;
  static MySoftGidenFaturaService get instance =>
      _instance ?? MySoftGidenFaturaService._();

  MySoftGidenFaturaService._();

  final String baseUrl = "https://edocumentapi.mysoft.com.tr";
  final String baseUrlTest = "https://edocumentapitest.mysoft.com.tr";

  Future<IResponseModel> fetchGidenFatura(String token) async {
    try {
      final msg = jsonEncode({
        "startDate":
            DateTime.now().subtract(const Duration(days: 1)).toString(),
        "endDate": DateTime.now().add(const Duration(days: 1)).toString(),
        "eDocumentType": null,
        "isUseDocDate": true,
        "afterValue": 0,
        "limit": 100,
        "tenantIdentifierNumber": null
      });
      final response = await http.post(
        Uri.parse(
            '${TestApp.instance.isTest ? baseUrlTest : baseUrl}/api/InvoiceOutbox/getInvoiceOutboxWithHeaderInfoList'),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        },
        body: msg,
      );

      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        if (result["succeed"] != null &&
            result["succeed"].toString().toLowerCase() == "true") {

          var data = MySoftGidenFatura.fromJson(result).data;
          return ResponseModel(data: data);
        } else {
          return ResponseModel(
              error: BaseError(
                  message: "My soft fatura komisyoncu başarısız",
                  statusCode: response.statusCode));
        }
      } else {
        if (response.body.isNotEmpty) {
          var result = jsonDecode(response.body);

          if (result["message"].toString().trim() != "") {
            return ResponseModel(
                error: BaseError(
                    message: result["message"].toString().trim(),
                    statusCode: response.statusCode));
          } else {
            return ResponseModel(
                error: BaseError(
                    message: "My soft fatura komisyoncu hata 1",
                    statusCode: response.statusCode));
          }
        }
        return ResponseModel(
            error: BaseError(
                message: "My soft fatura komisyoncu hata 2",
                statusCode: response.statusCode));
      }
    } catch (e) {

      return ResponseModel(
          error: BaseError(message: "My soft fatura hata 2", statusCode: 400));
    }
  }

  Future<IResponseModel> fetchGidenIrsaliye(String token) async {
    try {
      final msg = jsonEncode({
        "startDate":
            DateTime.now().subtract(const Duration(days: 1)).toString(),
        "endDate": DateTime.now().add(const Duration(days: 1)).toString(),
        "afterValue": 0,
        "limit": 100,
        "tenantIdentifierNumber": null
      });
      final response = await http.post(
        Uri.parse(
            '${TestApp.instance.isTest ? baseUrlTest : baseUrl}/api/DespatchOutbox/getDespatchOutboxWithHeaderInfoList'),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        },
        body: msg,
      );

      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        if (result["succeed"] != null &&
            result["succeed"].toString().toLowerCase() == "true") {

          var data = MySoftGidenIrsaliye.fromJson(result).data;
          return ResponseModel(data: data);
        } else {
          return ResponseModel(
              error: BaseError(
                  message: "My soft fatura komisyoncu başarısız",
                  statusCode: response.statusCode));
        }
      } else {
        if (response.body.isNotEmpty) {
          var result = jsonDecode(response.body);

          if (result["message"].toString().trim() != "") {
            return ResponseModel(
                error: BaseError(
                    message: result["message"].toString().trim(),
                    statusCode: response.statusCode));
          } else {
            return ResponseModel(
                error: BaseError(
                    message: "My soft fatura komisyoncu hata 1",
                    statusCode: response.statusCode));
          }
        }
        return ResponseModel(
            error: BaseError(
                message: "My soft fatura komisyoncu hata 2",
                statusCode: response.statusCode));
      }
    } catch (e) {

      return ResponseModel(
          error: BaseError(message: "My soft fatura hata 2", statusCode: 400));
    }
  }
}
