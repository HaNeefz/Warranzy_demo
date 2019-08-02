class ModelMasCustomer {
  String fullName;
  String gender;
  String address;
  String email;
  String mobilePhone;
  String countryCode;
  String countryNumberPhoneCode;
  String birthYear;
  String pinCode;
  String timeZone;
  String deviceID;
  String notificationID;
  Config config;

  ModelMasCustomer(
      {this.fullName,
      this.gender,
      this.address,
      this.email,
      this.mobilePhone,
      this.countryCode,
      this.countryNumberPhoneCode,
      this.birthYear,
      this.timeZone,
      this.pinCode,
      this.deviceID,
      this.notificationID,
      this.config});

  ModelMasCustomer.fromJson(Map<String, dynamic> json) {
    fullName = json['CustName'];
    gender = json['CustGender'];
    address = json['CustAddress'];
    email = json['CustEmail'];
    mobilePhone = json['MobilePhone'];
    countryCode = json['CountryCode'];
    countryNumberPhoneCode = json['CountryNumberPhoneCode'];
    birthYear = json['CustBirthYear'];
    deviceID = json['DeviceID'];
    pinCode = json['PINCode'];
    timeZone = json['TimeZone'];
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
    data['CustMobileNumber'] = this.mobilePhone;
    data['CountryCode'] = this.countryCode;
    data['CountryNumberPhoneCode'] = this.countryNumberPhoneCode;
    data['CustBirthYear'] = this.birthYear;
    data['CustDeviceID'] = this.deviceID;
    data['PINCode'] = this.pinCode;
    data['TimeZone'] = this.timeZone;
    data['notificationID'] = this.notificationID;
    if (this.config != null) {
      data['config'] = this.config.toJson();
    }
    return data;
  }
}

class Config {
  String language;
  String spacialPass = "F";

  Config({this.language, this.spacialPass});

  Config.fromJson(Map<String, dynamic> json) {
    language = json['language'];
    spacialPass = json['spacialPass'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['language'] = this.language;
    data['scanToAuthen'] = this.spacialPass;
    return data;
  }
}
