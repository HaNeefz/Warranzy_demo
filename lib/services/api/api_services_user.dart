import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:warranzy_demo/models/model_mas_cust.dart';
import 'package:warranzy_demo/models/model_verify_login.dart';
import 'package:warranzy_demo/models/model_verify_phone.dart';

// final String baseUrl = "https://testwarranty-239103.appspot.com/API/v1";
final String baseUrl = "http://192.168.0.36:9999/API/v1";
final Dio dio = Dio();

class APIServiceUser {

  static Future apiVerifyNumberTest({String url, dynamic postData}) async {
    print("apiVerfyNumber");
    String urlPost = "http://192.168.0.36:9999/API/v1/User/CheckVerifyPhone";
    print(postData);
    try {
      final response = await dio.post(urlPost, data: postData);
      if (response.statusCode == 200) {
        return response.data;
      } else
        Exception("Failed to load post");
    } on TimeoutException catch (_) {
      print("TimeOut");
    } catch (e) {
      print("Catch => " + "$e");
    }
  }

  static Future<ModelVerifyNumber> apiVerifyNumber({dynamic postData}) async {
    print("apiVerfyNumber");
    ModelVerifyNumber data;
    String urlPost = "$baseUrl/User/CheckVerifyPhone"; //User/CheckVerifyPhone;
    try {
      final response = await http
          .post(urlPost, body: postData)
          .timeout(Duration(seconds: 30));
      if (response.statusCode == 200) {
        print(
            "$baseUrl/User/CheckVerifyPhone => Response:============\n ${json.decode(response.body)}\n ===============");
        return data = ModelVerifyNumber.fromJson(json.decode(response.body));
      } else
        Exception("Failed to load post");
    } on TimeoutException catch (_) {
      print("TimeOut");
    } catch (e) {
      print("Error => $e");
    }
    return data;
  }

  static Future<ModelVerifyNumber> apiVerifyNumberTryRequest(
      {dynamic postData}) async {
    print("apiVerfyNumberTryRequest");
    ModelVerifyNumber data;
    String urlPost = "$baseUrl/User/RequestVerifyCode"; //User/CheckVerifyPhone;
    try {
      final response = await http
          .post(urlPost, body: postData)
          .timeout(Duration(seconds: 30)); //dio.post(urlPost, data: postData);
      if (response.statusCode == 200) {
        print(
            "$baseUrl/User/RequestVerifyCode => Response:============\n ${json.decode(response.body)}\n ===============");
        return data = ModelVerifyNumber.fromJson(json.decode(response.body));
      } else
        Exception("Failed to load post");
    } on TimeoutException catch (_) {
      print("TimeOut");
    } catch (e) {
      print("Error => $e");
    }
    return data;
  }

  static Future<InformationMasCustomners> apiRegister(
      {dynamic postData}) async {
    print("apiRegister");
    InformationMasCustomners dataCustomers;
    String urlPost = "$baseUrl/User/UserRegister"; //User/CheckVerifyPhone;
    try {
      final response = await http
          .post(urlPost, body: postData)
          .timeout(Duration(seconds: 30));
      if (response.statusCode == 200) {
        print(
            "$baseUrl/User/UserRegister => Response:============\n ${json.decode(response.body)}\n ===============");
        return dataCustomers =
            InformationMasCustomners.fromJson(json.decode(response.body));
      } else
        throw Exception("Failed to load post");
    } on TimeoutException catch (_) {
      print("TimeOut");
    } catch (e) {
      print("$baseUrl/User/UserRegister => Catch Error $e");
    }
    return dataCustomers;
  }

  static Future<InformationMasCustomners> apiVerifyChangeDevice(
      {dynamic postData}) async {
    print("apiVerifyChangeDevice");
    InformationMasCustomners dataCustomers;
    String urlPost =
        "$baseUrl/User/VerifyChangeDevice"; //User/CheckVerifyPhone;
    try {
      final response = await http
          .post(urlPost, body: postData)
          .timeout(Duration(seconds: 30));
      if (response.statusCode == 200) {
        print(
            "$baseUrl/User/VerifyChangeDevice Response:============\n ${json.decode(response.body)}\n ===============");
        return dataCustomers =
            InformationMasCustomners.fromJson(json.decode(response.body));
      } else
        Exception("Failed to load post");
    } on TimeoutException catch (_) {
      print("TimeOut");
    } catch (e) {
      print("Catch Error => $e");
    }
    return dataCustomers;
  }

  static Future<ModelVerifyNumber> apiChangeDevice({dynamic postData}) async {
    print("apiChangeDevice");
    ModelVerifyNumber data;
    String urlPost = "$baseUrl/User/ChangeDevice"; //User/CheckVerifyPhone;
    try {
      final response = await http
          .post(urlPost, body: postData)
          .timeout(Duration(seconds: 60));
      if (response.statusCode == 200) {
        print(
            "$baseUrl/User/ChangeDevice =>Response:============\n ${json.decode(response.body)}\n ===============");
        return data = ModelVerifyNumber.fromJson(json.decode(response.body));
      } else
        Exception("Failed to load post");
    } on TimeoutException catch (_) {
      print("TimeOut");
    } catch (e) {
      print("Catch Error => $e");
    }
    return data;
  }

  static Future<ModelVerifyLogin> apiVerifyLogin({dynamic postData}) async {
    print("apiLogin");
    String urlPost = "$baseUrl/User/Login"; //User/CheckVerifyPhone;
    try {
      final response = await http
          .post(urlPost, body: postData)
          .timeout(Duration(seconds: 30));
      print(
          "$baseUrl/User/Login => Response:============\n ${json.decode(response.body)}\n ===============");
      return ModelVerifyLogin.fromJson(json.decode(response.body));
    } on TimeoutException catch (_) {
      print("TimeOut");
      return null;
    } catch (e) {
      print("$baseUrl/User/Login => Catch Error : $e");
      return null;
    }
  }
}
