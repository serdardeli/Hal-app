class MySoftGidenIrsaliye {
  List<GidenIrsaliyeData>? data;
  bool? succeed;
  Null? message;
  Null? errorCode;
  int? afterValue;

  MySoftGidenIrsaliye(
      {this.data, this.succeed, this.message, this.errorCode, this.afterValue});

  MySoftGidenIrsaliye.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <GidenIrsaliyeData>[];
      json['data'].forEach((v) {
        data!.add(new GidenIrsaliyeData.fromJson(v));
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

class GidenIrsaliyeData {
  int? id;
  String? eDespatchType;
  String? despatchStatusText;
  String? ettn;
  String? docNo;
  String? docDate;
  String? pkAlias;
  String? gbAlias;
  String? vknTckn;
  String? accountName;
  double? lineExtensionAmount;
  double? payableAmount;
  Null? createDate;

  GidenIrsaliyeData(
      {this.id,
      this.eDespatchType,
      this.despatchStatusText,
      this.ettn,
      this.docNo,
      this.docDate,
      this.pkAlias,
      this.gbAlias,
      this.vknTckn,
      this.accountName,
      this.lineExtensionAmount,
      this.payableAmount,
      this.createDate});

  GidenIrsaliyeData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    eDespatchType = json['eDespatchType'];
    despatchStatusText = json['despatchStatusText'];
    ettn = json['ettn'];
    docNo = json['docNo'];
    docDate = json['docDate'];
    pkAlias = json['pkAlias'];
    gbAlias = json['gbAlias'];
    vknTckn = json['vknTckn'];
    accountName = json['accountName'];
    lineExtensionAmount = json['lineExtensionAmount'];
    payableAmount = json['payableAmount'];
    createDate = json['createDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['eDespatchType'] = this.eDespatchType;
    data['despatchStatusText'] = this.despatchStatusText;
    data['ettn'] = this.ettn;
    data['docNo'] = this.docNo;
    data['docDate'] = this.docDate;
    data['pkAlias'] = this.pkAlias;
    data['gbAlias'] = this.gbAlias;
    data['vknTckn'] = this.vknTckn;
    data['accountName'] = this.accountName;
    data['lineExtensionAmount'] = this.lineExtensionAmount;
    data['payableAmount'] = this.payableAmount;
    data['createDate'] = this.createDate;
    return data;
  }
}
