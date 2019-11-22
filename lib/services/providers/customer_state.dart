import 'package:flutter/cupertino.dart';
import 'package:warranzy_demo/models/model_user.dart';
import 'package:warranzy_demo/services/sqflit/db_customers.dart';

class CustomerState extends ChangeNotifier {
  ModelCustomers _dataCustomer;
  CustomerState.initial() {
    getDataCustomer();
  }

  getDataCustomer() async {
    if (_dataCustomer == null) {
      _dataCustomer = await DBProviderCustomer.db.getDataCustomer();
      notifyListeners();
    }
  }

  ModelCustomers get dataCustomer => _dataCustomer;

  set changPinCode(String newPinCode) {
    _dataCustomer.pINcode = newPinCode;
    notifyListeners();
  }

  set changSpecialPass(String newSpecialPass) {
    _dataCustomer.specialPass = newSpecialPass;
    notifyListeners();
  }

  set changProfile(String newProfile) {
    _dataCustomer.imageProfile = newProfile;
    notifyListeners();
  }

  set changDataProfile(Map<String, dynamic> newDataProfile) {
    _dataCustomer.custName = newDataProfile["CustName"];
    _dataCustomer.homeAddress = newDataProfile["HomeAddress"];
    _dataCustomer.custEmail = newDataProfile["CustEmail"];
    _dataCustomer.mobilePhone = newDataProfile["MobilePhone"];
    notifyListeners();
  }
}
