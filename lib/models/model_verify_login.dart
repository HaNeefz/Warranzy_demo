class ModelVerifyLogin {
  bool status;
  String mssage;

  ModelVerifyLogin({this.status, this.mssage});

  ModelVerifyLogin.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    mssage = json['Mssage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    data['Mssage'] = this.mssage;
    return data;
  }
}
