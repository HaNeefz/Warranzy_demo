class ModelMasCustomer {
  String fullName;
  String gender;
  String address;
  String email;
  String mobileNumber;
  String countryCode;
  String countryNumberPhoneCode;
  String birthYear;
  String pinCode;
  String deviceID;
  String notificationID;
  Config config;

  ModelMasCustomer(
      {this.fullName,
      this.gender,
      this.address,
      this.email,
      this.mobileNumber,
      this.countryCode,
      this.countryNumberPhoneCode,
      this.birthYear,
      this.pinCode,
      this.deviceID,
      this.notificationID,
      this.config});

  ModelMasCustomer.fromJson(Map<String, dynamic> json) {
    fullName = json['CustName'];
    gender = json['CustGender'];
    address = json['CustAddress'];
    email = json['CustEmail'];
    mobileNumber = json['MobilePhone'];
    countryCode = json['CustCountryCode'];
    countryNumberPhoneCode = json['CustcountryNumberPhoneCode'];
    birthYear = json['CustBirthYear'];
    deviceID = json['DeviceID'];
    pinCode = json['PINCode'];
    notificationID = json['NotificationID'];
    config =
        json['config'] != null ? new Config.fromJson(json['config']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CustName'] = this.fullName;
    data['CustGender'] = this.gender;
    data['CustAddress'] = this.address;
    data['CustEmail'] = this.email;
    data['CustMobileNumber'] = this.mobileNumber;
    data['CustCountryCode'] = this.countryCode;
    data['CustcountryNumberPhoneCode'] = this.countryNumberPhoneCode;
    data['CustBirthYear'] = this.birthYear;
    data['CustDeviceID'] = this.deviceID;
    data['PINCode'] = this.pinCode;
    data['notificationID'] = this.notificationID;
    if (this.config != null) {
      data['config'] = this.config.toJson();
    }
    return data;
  }
}

class Config {
  String language;
  bool scanToAuthen;

  Config({this.language, this.scanToAuthen});

  Config.fromJson(Map<String, dynamic> json) {
    language = json['language'];
    scanToAuthen = json['scanToAuthen'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['language'] = this.language;
    data['scanToAuthen'] = this.scanToAuthen;
    return data;
  }
}
