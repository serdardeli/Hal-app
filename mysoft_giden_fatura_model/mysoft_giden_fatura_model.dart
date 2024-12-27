class MySoftGidenFatura {
  List<GidenFaturaData>? data;
  bool? succeed;
  Null? message;
  Null? errorCode;
  int? afterValue;

  MySoftGidenFatura(
      {this.data, this.succeed, this.message, this.errorCode, this.afterValue});

  MySoftGidenFatura.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <GidenFaturaData>[];
      json['data'].forEach((v) {
        data!.add(new GidenFaturaData.fromJson(v));
      });
    }
    succeed = json['succeed'];
    message = json['message'];
    errorCode = json['errorCode'];
    afterValue = json['afterValue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['succeed'] = this.succeed;
    data['message'] = this.message;
    data['errorCode'] = this.errorCode;
    data['afterValue'] = this.afterValue;
    return data;
  }
}

class GidenFaturaData {
  int? id;
  String? profile;
  String? invoiceStatusText;
  String? invoiceType;
  String? ettn;
  String? docNo;
  String? docDate;
  String? pkAlias;
  String? gbAlias;
  String? vknTckn;
  String? accountName;
  double? lineExtensionAmount;
  double? taxExclusiveAmount;
  double? taxInclusiveAmount;
  double? payableRoundingAmount;
  double? payableAmount;
  double? allowanceTotalAmount;
  double? taxTotalTra;
  String? currencyCode;
  double? currencyRate;
  String? createDate;

  GidenFaturaData(
      {this.id,
      this.profile,
      this.invoiceStatusText,
      this.invoiceType,
      this.ettn,
      this.docNo,
      this.docDate,
      this.pkAlias,
      this.gbAlias,
      this.vknTckn,
      this.accountName,
      this.lineExtensionAmount,
      this.taxExclusiveAmount,
      this.taxInclusiveAmount,
      this.payableRoundingAmount,
      this.payableAmount,
      this.allowanceTotalAmount,
      this.taxTotalTra,
      this.currencyCode,
      this.currencyRate,
      this.createDate});

  GidenFaturaData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    profile = json['profile'];
    invoiceStatusText = json['invoiceStatusText'];
    invoiceType = json['invoiceType'];
    ettn = json['ettn'];
    docNo = json['docNo'];
    docDate = json['docDate'];
    pkAlias = json['pkAlias'];
    gbAlias = json['gbAlias'];
    vknTckn = json['vknTckn'];
    accountName = json['accountName'];
    lineExtensionAmount = json['lineExtensionAmount'];
    taxExclusiveAmount = json['taxExclusiveAmount'];
    taxInclusiveAmount = json['taxInclusiveAmount'];
    payableRoundingAmount = json['payableRoundingAmount'];
    payableAmount = json['payableAmount'];
    allowanceTotalAmount = json['allowanceTotalAmount'];
    taxTotalTra = json['taxTotalTra'];
    currencyCode = json['currencyCode'];
    currencyRate = json['currencyRate'];
    createDate = json['createDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['profile'] = this.profile;
    data['invoiceStatusText'] = this.invoiceStatusText;
    data['invoiceType'] = this.invoiceType;
    data['ettn'] = this.ettn;
    data['docNo'] = this.docNo;
    data['docDate'] = this.docDate;
    data['pkAlias'] = this.pkAlias;
    data['gbAlias'] = this.gbAlias;
    data['vknTckn'] = this.vknTckn;
    data['accountName'] = this.accountName;
    data['lineExtensionAmount'] = this.lineExtensionAmount;
    data['taxExclusiveAmount'] = this.taxExclusiveAmount;
    data['taxInclusiveAmount'] = this.taxInclusiveAmount;
    data['payableRoundingAmount'] = this.payableRoundingAmount;
    data['payableAmount'] = this.payableAmount;
    data['allowanceTotalAmount'] = this.allowanceTotalAmount;
    data['taxTotalTra'] = this.taxTotalTra;
    data['currencyCode'] = this.currencyCode;
    data['currencyRate'] = this.currencyRate;
    data['createDate'] = this.createDate;
    return data;
  }
}
