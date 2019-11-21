import 'package:flutter/cupertino.dart';
import 'package:warranzy_demo/models/model_repository_asset_scan.dart';
import 'package:warranzy_demo/models/model_repository_init_app.dart';
import 'package:warranzy_demo/models/model_response_boolean.dart';
import 'package:warranzy_demo/models/model_respository_asset.dart';
import 'package:warranzy_demo/models/model_user.dart';
import 'package:warranzy_demo/models/model_verify_login.dart';
import 'package:warranzy_demo/models/model_verify_phone.dart';
import 'package:warranzy_demo/services/api_provider/api_base_helper.dart';

class Repository {
  static ApiBaseHelper _helper = ApiBaseHelper();

  static Future<ModelVerifyLogin> apiLogin({@required dynamic body}) async {
    try {
      final response = await _helper.post("/User/Login", body);

      return ModelVerifyLogin.fromJson(response);
    } catch (e) {
      return ModelVerifyLogin(message: "$e");
    }
  }

  static Future<ModelVerifyNumber> apiVerifyNumber({dynamic body}) async {
    try {
      final response = await _helper.postNoJWT("/User/CheckVerifyPhone", body);
      return ModelVerifyNumber.fromJson(response);
    } catch (e) {
      return ModelVerifyNumber(message: "$e");
    }
  }

  static Future<ModelVerifyNumber> apiVerifyNumberUsedEditAccount(
      {dynamic body}) async {
    try {
      final response = await _helper.post("/User/VerifyNumber", body);

      return ModelVerifyNumber.fromJson(response);
    } catch (e) {
      return ModelVerifyNumber(message: "$e");
    }
  }

  static Future<ModelVerifyNumber> apiVerifyNumberTryRequest(
      {dynamic body}) async {
    try {
      final response = await _helper.post("/User/RequestVerifyCode", body);

      return ModelVerifyNumber.fromJson(response);
    } catch (e) {
      return ModelVerifyNumber(message: "$e");
    }
  }

  static Future<RepositoryUser> apiRegister({dynamic body}) async {
    try {
      final response = await _helper.postNoJWT("/User/UserRegister", body);

      return RepositoryUser.fromJson(response);
    } catch (e) {
      return RepositoryUser(message: "$e");
    }
  }

  static Future<RepositoryUser> apiVerifyChangeDevice({dynamic body}) async {
    try {
      final response =
          await _helper.postNoJWT("/User/VerifyChangeDevice", body);

      return RepositoryUser.fromJson(response);
    } catch (e) {
      return RepositoryUser(message: "$e");
    }
  }

  static Future<ModelVerifyNumber> apiChangeDevice({dynamic body}) async {
    try {
      final response = await _helper.postNoJWT("/User/ChangeDevice", body);

      return ModelVerifyNumber.fromJson(response);
    } catch (e) {
      return ModelVerifyNumber(message: "$e");
    }
  }

  static Future<ModelVerifyLogin> apiVerifyLogin({dynamic body}) async {
    try {
      final response = await _helper.post("/User/Login", body);

      return ModelVerifyLogin.fromJson(response);
    } catch (e) {
      return ModelVerifyLogin(message: "$e");
    }
  }

  static Future<ModelReturnBoolean> apiEditProfile({dynamic body}) async {
    try {
      final response = await _helper.post("/User/EditProfile", body);
      return ModelReturnBoolean.fromJson(response);
    } catch (e) {
      return ModelReturnBoolean(message: "$e");
    }
  }

  static Future<ModelReturnBoolean> apiChangePINCode({dynamic body}) async {
    try {
      final response = await _helper.post("/User/ChangePincode", body);
      return ModelReturnBoolean.fromJson(response);
    } catch (e) {
      return ModelReturnBoolean(message: "$e");
    }
  }

  static Future<ModelReturnBoolean> apiChangeSpecialPass({dynamic body}) async {
    try {
      final response = await _helper.post("/User/ChangeSpecialPass", body);
      return ModelReturnBoolean.fromJson(response);
    } catch (e) {
      return ModelReturnBoolean(message: "$e");
    }
  }

  static Future<ModelReturnBoolean> apiUpdateImageProfile(
      {dynamic body}) async {
    try {
      final response = await _helper.post("/User/UpdateImageProfile", body);
      return ModelReturnBoolean.fromJson(response);
    } catch (e) {
      return ModelReturnBoolean(message: "$e");
    }
  }

  //--------------------------------------------Asset------------------------
  static Future<RepositoryInitalApp> initialApplication() async {
    try {
      final response = await _helper.getDio("/User/InitialApp");
      return RepositoryInitalApp.fromJson(response);
    } catch (e) {
      return RepositoryInitalApp(message: "$e");
    }
  }

  static Future<ResponseAssetOnline> getAllAseet() async {
    try {
      final response = await _helper.get("/Asset/getMyAsset");

      return ResponseAssetOnline.fromJson(response);
    } catch (e) {
      return ResponseAssetOnline(message: "$e");
    }
  }

  static Future<RepositoryOfAsset> addAsset({dynamic body}) async {
    try {
      final response = await _helper.postDio("/Asset/AddAsset", body);

      return RepositoryOfAsset.fromJson(response);
    } catch (e) {
      return RepositoryOfAsset(message: "$e");
    }
  }

  static Future<ResponseDetailOfAsset> getDetailAseet({dynamic body}) async {
    try {
      final response = await _helper.postDio("/Asset/getDetailAsset", body);

      return ResponseDetailOfAsset.fromJson(response);
    } catch (e) {
      return ResponseDetailOfAsset(message: "$e");
    }
  }

  static Future<ResponseDetailOfAsset> deleteAseet({dynamic body}) async {
    try {
      final response = await _helper.postDio("/Asset/deleteAsset", body);

      return ResponseDetailOfAsset.fromJson(response);
    } catch (e) {
      return ResponseDetailOfAsset(message: "$e");
    }
  }

  static Future<ResponseDetailOfAsset> updateData({dynamic body}) async {
    try {
      final response = await _helper.postDio("/Asset/editDetailAsset", body);

      return ResponseDetailOfAsset.fromJson(response);
    } catch (e) {
      return ResponseDetailOfAsset(message: "$e");
    }
  }

  static Future<ResponseImage> updateImage({dynamic body}) async {
    try {
      final response = await _helper.postDio("/Asset/UpdateImagesAsset", body);

      return ResponseImage.fromJson(response);
    } catch (e) {
      return ResponseImage(message: "$e");
    }
  }

  static Future<RepositoryAssetScan> getDataFromQRofAsset(
      {dynamic body}) async {
    try {
      final response = await _helper.postDio("/Asset/getDataFromQR", body);

      return RepositoryAssetScan.fromJson(response);
    } catch (e) {
      print("$e");
      return RepositoryAssetScan(message: e);
    }
  }
}
