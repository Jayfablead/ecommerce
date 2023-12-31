class PaymethodModal {
  bool? status;
  Data? data;

  PaymethodModal({this.status, this.data});

  PaymethodModal.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  Cod? cod;
  BankTransfer? bankTransfer;
  Paypal? paypal;
  Stripe? stripe;
  RazorpayData? razorpayData;

  Data(
      {this.cod,
      this.bankTransfer,
      this.paypal,
      this.stripe,
      this.razorpayData});

  Data.fromJson(Map<String, dynamic> json) {
    cod = json['cod'] != null ? new Cod.fromJson(json['cod']) : null;
    bankTransfer = json['bank_transfer'] != null
        ? new BankTransfer.fromJson(json['bank_transfer'])
        : null;
    paypal =
        json['paypal'] != null ? new Paypal.fromJson(json['paypal']) : null;
    stripe =
        json['stripe'] != null ? new Stripe.fromJson(json['stripe']) : null;
    razorpayData = json['razorpay_data'] != null
        ? new RazorpayData.fromJson(json['razorpay_data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.cod != null) {
      data['cod'] = this.cod!.toJson();
    }
    if (this.bankTransfer != null) {
      data['bank_transfer'] = this.bankTransfer!.toJson();
    }
    if (this.paypal != null) {
      data['paypal'] = this.paypal!.toJson();
    }
    if (this.stripe != null) {
      data['stripe'] = this.stripe!.toJson();
    }
    if (this.razorpayData != null) {
      data['razorpay_data'] = this.razorpayData!.toJson();
    }
    return data;
  }
}

class Cod {
  bool? status;

  Cod({this.status});

  Cod.fromJson(Map<String, dynamic> json) {
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    return data;
  }
}

class BankTransfer {
  bool? status;
  String? name;
  String? bankName;
  String? accountNo;
  String? iFSCNo;

  BankTransfer(
      {this.status, this.name, this.bankName, this.accountNo, this.iFSCNo});

  BankTransfer.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    name = json['name'];
    bankName = json['bank_name'];
    accountNo = json['account_no'];
    iFSCNo = json['IFSC_no'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['name'] = this.name;
    data['bank_name'] = this.bankName;
    data['account_no'] = this.accountNo;
    data['IFSC_no'] = this.iFSCNo;
    return data;
  }
}

class Paypal {
  bool? status;
  String? clientID;
  String? secretKey;
  String? merchantEmail;
  String? liveSts;

  Paypal(
      {this.status,
      this.clientID,
      this.secretKey,
      this.merchantEmail,
      this.liveSts});

  Paypal.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    clientID = json['clientID'];
    secretKey = json['secret_key'];
    merchantEmail = json['merchant_email'];
    liveSts = json['live_sts'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['clientID'] = this.clientID;
    data['secret_key'] = this.secretKey;
    data['merchant_email'] = this.merchantEmail;
    data['live_sts'] = this.liveSts;
    return data;
  }
}

class Stripe {
  bool? status;
  String? publicKey;
  String? secretKey;

  Stripe({this.status, this.publicKey, this.secretKey});

  Stripe.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    publicKey = json['public_key'];
    secretKey = json['secret_key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['public_key'] = this.publicKey;
    data['secret_key'] = this.secretKey;
    return data;
  }
}

class RazorpayData {
  bool? status;
  String? keyId;
  String? keySecret;

  RazorpayData({this.status, this.keyId, this.keySecret});

  RazorpayData.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    keyId = json['keyId'];
    keySecret = json['key_secret'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['keyId'] = this.keyId;
    data['key_secret'] = this.keySecret;
    return data;
  }
}
