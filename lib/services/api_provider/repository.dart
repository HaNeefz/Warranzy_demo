import 'package:warranzy_demo/models/model_respository_asset.dart';
import 'package:warranzy_demo/models/model_verify_login.dart';

import 'api_base_helper.dart';

class FetchRepository<T> {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<T> login(String url, dynamic body) async {
    final response = await _helper.post(url, body);
    return ModelVerifyLogin.fromJson(response) as T;
  }

  Future<T> getAllAsset(String url) async {
    final response = await _helper.get(url);
    return ResponseAssetOnline.fromJson(response) as T;
  }

  Future<T> getDetailAsset(String url, dynamic body) async {
    final response = await _helper.post(url, body);
    print("\n\n $response \n\n");
    return ResponseDetailOfAsset.fromJson(response) as T;
  }
}
