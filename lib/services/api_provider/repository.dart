import 'package:warranzy_demo/models/model_verify_login.dart';

import 'api_base_helper.dart';

class FetchRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future login(String url, dynamic body) async {
    final response = await _helper.post(url, body);
    return ModelVerifyLogin.fromJson(response);
  }
}
