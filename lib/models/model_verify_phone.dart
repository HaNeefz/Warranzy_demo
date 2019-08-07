class ModelVerifyNumber {
  bool status;
  int codeVerify;
  String phoneNumber;
  String createDate;
  String message;

  ModelVerifyNumber(
      {this.status,
      this.codeVerify,
      this.phoneNumber,
      this.createDate,
      this.message});

  ModelVerifyNumber.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    codeVerify = json['CodeVerify'];
    phoneNumber = json['PhoneNumber'];
    createDate = json['CreateDate'];
    message = json['Message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    data['CodeVerify'] = this.codeVerify;
    data['PhoneNumber'] = this.phoneNumber;
    data['CreateDate'] = this.createDate;
    data['Message'] = this.message;
    return data;
  }
}
