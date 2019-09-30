class ModelVerifyLogin {
  bool status;
  bool session;
  String message;

  ModelVerifyLogin({this.status, this.message, this.session});

  ModelVerifyLogin.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    message = json['Mssage'];
    session = json['Status_ses'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    data['Mssage'] = this.message;
    return data;
  }
}
