class ModelVerifyNumber {
  bool status;
  int codeVerify;
  String phoneNumber;
  String createDate;

  ModelVerifyNumber(
      {this.status, this.codeVerify, this.phoneNumber, this.createDate});

  ModelVerifyNumber.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    codeVerify = json['CodeVerify'];
    phoneNumber = json['PhoneNumber'];
    createDate = json['CreateDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    data['CodeVerify'] = this.codeVerify;
    data['PhoneNumber'] = this.phoneNumber;
    data['CreateDate'] = this.createDate;
    return data;
  }
}
