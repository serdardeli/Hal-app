import 'dart:convert';
import 'dart:developer';

import 'package:hal_app/project/model/driver_model/driver_model.dart';
import 'package:hal_app/project/model/musteri_model/musteri_model.dart';
import 'package:http/http.dart';

import '../../../../core/model/error_model/base_error_model.dart';
import '../../../../core/model/response_model/IResponse_model.dart';
import '../../../../core/model/response_model/response_model.dart';
import 'package:http/http.dart' as http;

import '../../../../feature/helper/active_tc.dart';
import '../../../../feature/helper/test.dart';
import '../../../cache/mysoft_user_cache_mananger.dart';
import '../../../model/bildirimci/bildirimci_model.dart';
import '../../../model/malin_gidecegi_yer/malin_gidecegi_yer_model.dart';
import '../../../model/referans_kunye/referans_kunye_model.dart';
import '../../../model/uretici_model/uretici_model.dart';
import '../../../model/urun/urun.dart';

class MySoftFaturaService {
  static MySoftFaturaService? _instance;
  static MySoftFaturaService get instance =>
      _instance ?? MySoftFaturaService._();

  MySoftFaturaService._();
  final String baseUrl = "https://edocumentapi.mysoft.com.tr";
  final String baseUrlTest = "https://edocumentapitest.mysoft.com.tr";

  List<Map> generateProduct(List<Urun> urunler) {
    List<Map> newMap = [];
    for (var element in urunler) {
      newMap.add({
        "productCode": element.urunId,
        "productName": "${element.urunAdi}  Kunye: ${element.kunyeNo ?? ""}",
        "unitCode": element.urunMiktarBirimId == "74" ? "KGM" : "C62",
        "qty": element.urunMiktari,
        "unitPriceTra": element.urunFiyati,
        "amtTra": (double.parse(element.urunMiktari) *
            double.parse(element.urunFiyati ?? "1")),
        "taxableAmtTra": 0,
        "taxExemptionReasonCode": "201",
        "taxExemptionReasonName": "0",
        "withholdingTaxableAmount": 0,
        "withholdingTaxAmount": 0,
        "tax": [
          {
            "taxName": "Gelir Vergisi Stopajı",
            "taxCode": "0003",
            "taxRate": "2",
            "taxAmount": (double.parse(element.urunMiktari) *
                    double.parse(element.urunFiyati ?? "1")) *
                (0.02),
            "taxableAmount": (double.parse(element.urunMiktari) *
                double.parse(element.urunFiyati ?? "1")),
            "taxExemptionReasonCode": null,
            "taxExemptionReasonName": null
          }
        ]
      });
    }
    return newMap;
  }

  List<Map> generateProductForFatura(
      List<ReferansKunye> urunler, Bildirimci bildirimci) {
    List<Map> newMap = [];
    for (var element in urunler) {
      newMap.add({
        "productName": element.malinAdi,
        "unitCode": element.malinMiktarBirimId == "74" ? "KGM" : "C62",
        "qty": element.kalanMiktar,
        "unitPriceTra": element.malinSatisFiyati,
        "amtTra": (double.parse(element.kalanMiktar ?? "0") *
            double.parse(element.malinSatisFiyati ?? "1")),
        "vatRate": "1",
        "amtVatTra": (double.parse(element.kalanMiktar ?? "0") *
                double.parse(element.malinSatisFiyati ?? "1")) *
            .01,
        "hksTagNumber": element.kunyeNo,
        "taxableAmtTra": (double.parse(element.kalanMiktar ?? "0") *
            double.parse(element.malinSatisFiyati ?? "1")),
        "hksOwnerFullName": bildirimci.bildirimciAdiSoyadi,
        "hksOwnerIdentifier": bildirimci.bildirimciTc
      });
    }
    return newMap;
  }

  List<Map> generateProductForFaturForKomisyoncu(
      List<ReferansKunye> urunler, Bildirimci bildirimci) {
    List<Map> newMap = [];
    for (var element in urunler) {
      newMap.add({
        "productName": element.malinAdi,
        "unitCode": element.malinMiktarBirimId == "74" ? "KGM" : "C62",
        "qty": element.kalanMiktar,
        "unitPriceTra": element.malinSatisFiyati,
        "amtTra": (double.parse(element.kalanMiktar ?? "0") *
            double.parse(element.malinSatisFiyati ?? "1")),
        "vatRate": "0",
        "amtVatTra": "0",
        "taxableAmtTra": (double.parse(element.kalanMiktar ?? "0") *
            double.parse(element.malinSatisFiyati ?? "1")),
        "hksTagNumber": element.kunyeNo,
        "hksOwnerFullName": bildirimci.bildirimciAdiSoyadi,
        "hksOwnerIdentifier": bildirimci.bildirimciTc,
        "taxExemptionReasonCode": "351",
        "taxExemptionReasonName": "Diger Istisna",
        "tax": [
          {
            "taxName": "Hal Rüsumu",
            "taxCode": "9944",
            "taxRate": "1",
            "taxAmount": (double.parse(element.kalanMiktar ?? "0") *
                    double.parse(element.malinSatisFiyati ?? "1")) *
                .01,
            "taxableAmount": (double.parse(element.kalanMiktar ?? "0") *
                double.parse(element.malinSatisFiyati ?? "1")),
            "taxExemptionReasonCode": null,
            "taxExemptionReasonName": null
          }
        ]
      });
    }
    return newMap;
  }

  List<Map> generateProductForIrsaliye(List<Urun> urunler) {
    List<Map> newMap = [];
    for (var element in urunler) {
      newMap.add({
        "product": {
          "productCode": element.urunId,
          "productName": "${element.urunAdi}  Kunye: ${element.kunyeNo ?? ""}"
        },
        "unitCode": element.urunMiktarBirimId == "74" ? "KGM" : "C62",
        "qty": element.urunMiktari,
        "currencyCode": "TRY"
      });
    }
    return newMap;
  }

  List<Map> generateProductForIrsaliyeForSevk(List<ReferansKunye> urunler) {
    List<Map> newMap = [];
    for (var element in urunler) {
      newMap.add({
        "product": {
          "productCode": element.malinKodNo,
          "productName": "${element.malinAdi ?? "boş ad"}  Kunye: ${element.kunyeNo ?? ""}"
        },
        "unitCode": element.malinMiktarBirimId == "74" ? "KGM" : "C62",
        "qty": element.kalanMiktar,
        "currencyCode": "TRY"
      });
    }
    return newMap;
  }

  Future<IResponseModel<String?>> sendMustahsil(
      String token, List<Urun> urunler, Uretici uretici) async {
    final msg = jsonEncode({
      "isCalculateByApi": false,
      "id": 0,
      "eDocumentType": "EMM",
      "profile": "HKS",
      "invoiceType": "HKSSATIS",
      "DocDate": DateTime.now().toString(),
      "DocTime": DateTime.now().toString(),
      "currencyCode": "TRY",
      "currencyRate": 1,
      "senderType": "ELEKTRONIK",
      "invoiceAccount": {
        "vknTckn": uretici.ureticiTc,
        "accountName": uretici.ureticiAdiSoyadi,
        "cityName": uretici.ureticiIlAdi,
        "region": uretici.ureticiIlceAdi,
        "countryName": "TÜRKİYE",
        "citySubdivision": uretici.ureticiBeldeAdi
      },
      "isManuelCalculation": false,
      "additionalDocumentRef": null,
      "invoiceDetail": [...generateProduct(urunler)]
    });

    final response = await http.post(
      Uri.parse(
          '${TestApp.instance.isTest ? baseUrlTest : baseUrl}/api/InvoiceOutbox/invoiceOutbox'),
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
        return ResponseModel(data: result.toString());
      } else {
        return ResponseModel(
            error: BaseError(
                message: "my soft müstahsil başarısız",
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
                  message: "My soft müstahsil hata 1",
                  statusCode: response.statusCode));
        }
      }
      return ResponseModel(
          error: BaseError(
              message: "My soft müstahsil hata 2",
              statusCode: response.statusCode));
    }
  }

  Future<IResponseModel<String?>> sendIrsaliye(
      {required String token,
      required List<Urun> urunler,
      required GidecegiYer gidecegiYer,
      required Bildirimci bildirimci,
      required DriverModel driver,
      required String plaka}) async {
    final msg = jsonEncode({
      "eDespatchType": "SEVK",
      "isNotControlSchemaSchematron": false,
      "docDate": DateTime.now().toString(),
      "docTime": DateTime.now().toString(),
      "actualReferalDate": DateTime.now().toString(),
      "actualReferalTime": DateTime.now().toString(),
      "supplierAgentAccount": null,
      "deliveryAccount": {
        "identifierNumber": bildirimci.bildirimciTc,
        "accountName": MySoftUserCacheManager.instance
            .getItem(ActiveTc.instance.activeTc)!
            .firmaAdi,
        "taxOffice": null,
        "city": {"name": gidecegiYer.adres},
        "country": {"name": "TÜRKİYE"},
      },
      "deliveryAgentAccount": null,
      "account": null,
      "sellerAccount": null,
      "originatorAccount": null,
      "deliveryAddress": {
        "city": {"name": gidecegiYer.adres},
        "country": {"name": "TÜRKİYE"},
        "postalCode": "34220",
        "citySubdivision": gidecegiYer.adres,
        "telephone1": null
      },
      "shipmentNumber": null,
      "driverPhone": null,
      "driverIdentifierNumber": driver.tc,
      "driverName": driver.userName,
      "driverSurname": driver.userName,
      "lisancePlate": plaka,
      "despatchDetail": [...generateProductForIrsaliye(urunler)]
    });


    final response = await http.post(
      Uri.parse(
          '${TestApp.instance.isTest ? baseUrlTest : baseUrl}/api/DespatchOutbox/despatchOutbox'),
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
        return ResponseModel(data: result.toString());
      } else {
        return ResponseModel(
            error: BaseError(
                message: "my soft irsaliye başarısız",
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
                  message: "My soft irsaliye hata 1",
                  statusCode: response.statusCode));
        }
      }
      return ResponseModel(
          error: BaseError(
              message: "My soft irsaliye hata 2",
              statusCode: response.statusCode));
    }
  }

//JUST SATIS
  Future<IResponseModel<String?>> sendIrsaliyeForSevk(
      {required String token,
      required List<ReferansKunye> urunler,
      required Musteri musteri,
      required GidecegiYer gidecegiYer,
      required Bildirimci bildirimci,
      required DriverModel driver,
      required String plaka}) async {
    final msg = jsonEncode({
      "eDespatchType": "SEVK",
      "isNotControlSchemaSchematron": false,
      "docDate": DateTime.now().toString(),
      "docTime": DateTime.now().toString(),
      "actualReferalDate": DateTime.now().toString(),
      "actualReferalTime": DateTime.now().toString(),
      "supplierAgentAccount": null,
      "deliveryAccount": {
        "identifierNumber": bildirimci.bildirimciTc,
        "accountName": MySoftUserCacheManager.instance
            .getItem(ActiveTc.instance.activeTc)!
            .firmaAdi,
        "taxOffice": null,
        "city": {"name": gidecegiYer.adres},
        "country": {"name": "TÜRKİYE"},
      },
      "deliveryAgentAccount": null,
      "account": null,
      "sellerAccount": null,
      "originatorAccount": null,
      "deliveryAddress": {
        "city": {"name": gidecegiYer.adres},
        "country": {"name": "TÜRKİYE"},
        "postalCode": "34220",
        "citySubdivision": gidecegiYer.adres,
        "telephone1": null
      },
      "shipmentNumber": null,
      "driverPhone": null,
      "driverIdentifierNumber": driver.tc,
      "driverName": driver.userName,
      "driverSurname": driver.userName,
      "lisancePlate": plaka,
      "despatchDetail": [...generateProductForIrsaliyeForSevk(urunler)]
    });


    final response = await http.post(
      Uri.parse(
          '${TestApp.instance.isTest ? baseUrlTest : baseUrl}/api/DespatchOutbox/despatchOutbox'),
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
        return ResponseModel(data: result.toString());
      } else {
        return ResponseModel(
            error: BaseError(
                message: "my soft irsaliye başarısız",
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
                  message: "My soft irsaliye hata 1",
                  statusCode: response.statusCode));
        }
      }
      return ResponseModel(
          error: BaseError(
              message: "My soft irsaliye hata 2",
              statusCode: response.statusCode));
    }
  }

//JUST SEVK
  Future<IResponseModel<String?>> sendIrsaliyeForSevkJUSTSEVK(
      {required String token,
      required List<ReferansKunye> urunler,
      required Musteri musteri,
      required GidecegiYer gidecegiYer,
      required Bildirimci bildirimci,
      required DriverModel driver,
      required String plaka}) async {
    final msg = jsonEncode({
      "eDespatchType": "SEVK",
      "isNotControlSchemaSchematron": false,
      "docDate": DateTime.now().toString(),
      "docTime": DateTime.now().toString(),
      "actualReferalDate": DateTime.now().toString(),
      "actualReferalTime": DateTime.now().toString(),
      "supplierAgentAccount": null,
      "deliveryAccount": {
        "identifierNumber": musteri.musteriTc,
        "accountName": musteri.musteriAdiSoyadi,
        "taxOffice": null,
        "city": {"name": gidecegiYer.adres},
        "country": {"name": "TÜRKİYE"},
      },
      "deliveryAgentAccount": null,
      "account": null,
      "sellerAccount": null,
      "originatorAccount": null,
      "deliveryAddress": {
        "city": {"name": gidecegiYer.adres},
        "country": {"name": "TÜRKİYE"},
        "postalCode": "34220",
        "citySubdivision": gidecegiYer.adres,
        "telephone1": null
      },
      "shipmentNumber": null,
      "driverPhone": null,
      "driverIdentifierNumber": driver.tc,
      "driverName": driver.userName,
      "driverSurname": driver.userName,
      "lisancePlate": plaka,
      "despatchDetail": [...generateProductForIrsaliyeForSevk(urunler)]
    });


    final response = await http.post(
      Uri.parse(
          '${TestApp.instance.isTest ? baseUrlTest : baseUrl}/api/DespatchOutbox/despatchOutbox'),
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
        return ResponseModel(data: result.toString());
      } else {
        return ResponseModel(
            error: BaseError(
                message: "my soft irsaliye başarısız",
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
                  message: "My soft irsaliye hata 1",
                  statusCode: response.statusCode));
        }
      }
      return ResponseModel(
          error: BaseError(
              message: "My soft irsaliye hata 2",
              statusCode: response.statusCode));
    }
  }

  Future<IResponseModel<String?>> sendFatura(
      {required String token,
      required List<ReferansKunye> urunler,
      required Musteri musteri,
      required GidecegiYer gidecegiYer,
      required Bildirimci bildirimci}) async {
    final msg = jsonEncode({
      "isCalculateByApi": false,
      "invoiceType": "HKSSATIS",
      "senderType": "ELEKTRONIK",
      "profile": "HKS",
      "docDate": DateTime.now().toString(),
      "currencyCode": "TRY",
      "currencyRate": "1",
      "invoiceAccount": {
        "vknTckn": musteri.musteriTc,
        "accountName": musteri.musteriAdiSoyadi,
        "cityName": gidecegiYer.adres,
        "countryName": "TÜRKİYE",
      },
      "isManuelCalculation": false,
      "invoiceDetail": [...generateProductForFatura(urunler, bildirimci)]
    });


    final response = await http.post(
      Uri.parse(
          '${TestApp.instance.isTest ? baseUrlTest : baseUrl}/api/InvoiceOutbox/invoiceOutbox'),
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
        return ResponseModel(data: result.toString());
      } else if (result["message"] != null &&
          result["message"].toString().trim() != "") {
        return ResponseModel(
            error: BaseError(
                message: result["message"], statusCode: response.statusCode));
      } else {
        return ResponseModel(
            error: BaseError(
                message: "my soft fatura başarısız",
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
                  message: "My soft fatura hata 1",
                  statusCode: response.statusCode));
        }
      }
      return ResponseModel(
          error: BaseError(
              message: "My soft fatura hata 2",
              statusCode: response.statusCode));
    }
  }

  Future<IResponseModel<String?>> sendFaturaForKomisyoncu(
      {required String token,
      required List<ReferansKunye> urunler,
      required Musteri musteri,
      required GidecegiYer gidecegiYer,
      required Bildirimci bildirimci}) async {
    final msg = jsonEncode({
      "isCalculateByApi": false,
      "senderType": "ELEKTRONIK",
      "invoiceType": "ISTISNA",
      "profile": "HKS",
      "docDate": DateTime.now().toString(),
      "currencyCode": "TRY",
      "currencyRate": "1",
      "invoiceAccount": {
        "vknTckn": musteri.musteriTc,
        "accountName": musteri.musteriAdiSoyadi,
        "countryName": "TÜRKİYE",
        "cityName": gidecegiYer.adres,
      },
      "isManuelCalculation": false,
      "invoiceDetail": [
        ...generateProductForFaturForKomisyoncu(urunler, bildirimci)
      ]
    });


    final response = await http.post(
      Uri.parse(
          '${TestApp.instance.isTest ? baseUrlTest : baseUrl}/api/InvoiceOutbox/invoiceOutbox'),
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
        return ResponseModel(data: result.toString());
      } else if (result["message"] != null &&
          result["message"].toString().trim() != "") {
        return ResponseModel(
            error: BaseError(
                message: result["message"], statusCode: response.statusCode));
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
  }
}
