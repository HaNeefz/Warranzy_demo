import 'package:flutter/cupertino.dart';
import 'package:warranzy_demo/models/model_user.dart';
import 'package:warranzy_demo/services/sqflit/db_customers.dart';

class CustomerState extends ChangeNotifier {
  ModelCustomers _dataCustomer;
  bool _isFetchingData = false;

  bool get isFetchingData => _isFetchingData;

  getDataCustomer() async {
    _dataCustomer = await DBProviderCustomer.db.getDataCustomer();
    _dataCustomer != null ? _isFetchingData = true : _isFetchingData = false;
    notifyListeners();
  }

  changePinCode() async {}
}
