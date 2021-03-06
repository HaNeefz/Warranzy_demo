class InformationMasCustomners {
  bool status;
  ModelCustomers data;
  String message;

  InformationMasCustomners({this.status, this.data, this.message});

  InformationMasCustomners.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    message = json['Message'];
    data =
        json['Data'] != null ? new ModelCustomers.fromJson(json['Data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    data['Message'] = this.message;
    if (this.data != null) {
      data['Data'] = this.data.toJson();
    }
    return data;
  }
}

class ModelCustomers {
  String custUserID;
  String custName;
  String homeAddress;
  String countryCode;
  String custEmail;
  String mobilePhone;
  String notificationID;
  String pINcode;
  String deviceID;
  String gender;
  String birthYear;
  String specialPass;
  String packageType;

  ModelCustomers(
      {this.custUserID,
      this.custName,
      this.homeAddress,
      this.countryCode,
      this.custEmail,
      this.mobilePhone,
      this.notificationID,
      this.pINcode,
      this.deviceID,
      this.gender,
      this.birthYear,
      this.specialPass,
      this.packageType});

  ModelCustomers.fromJson(Map<String, dynamic> json) {
    custUserID = json['CustUserID'];
    custName = json['CustName'];
    homeAddress = json['HomeAddress'];
    countryCode = json['CountryCode'];
    custEmail = json['CustEmail'];
    mobilePhone = json['MobilePhone'];
    notificationID = json['NotificationID'];
    pINcode = json['PINcode'];
    deviceID = json['DeviceID'];
    gender = json['Gender'];
    birthYear = json['BirthYear'];
    specialPass = json['SpecialPass'];
    packageType = json['PackageType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.custUserID != null) {
      data['CustUserID'] = this.custUserID;
    }
    data['CustName'] = this.custName;
    data['HomeAddress'] = this.homeAddress;
    data['CountryCode'] = this.countryCode;
    data['CustEmail'] = this.custEmail;
    data['MobilePhone'] = this.mobilePhone;
    data['NotificationID'] = this.notificationID;
    data['PINcode'] = this.pINcode;
    data['DeviceID'] = this.deviceID;
    data['Gender'] = this.gender;
    data['BirthYear'] = this.birthYear;
    data['SpecialPass'] = this.specialPass;
    data['PackageType'] = this.packageType;
    return data;
  }
}
