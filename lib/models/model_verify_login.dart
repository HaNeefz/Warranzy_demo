class ModelVerifyLogin {
  bool status;
  String message;

  ModelVerifyLogin({this.status, this.message});

  ModelVerifyLogin.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    message = json['Mssage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    data['Mssage'] = this.message;
    return data;
  }
}
