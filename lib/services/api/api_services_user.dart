import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
// import 'package:warranzy_demo/models/model_mas_cust.dart';
import 'package:warranzy_demo/models/model_user.dart';
import 'package:warranzy_demo/models/model_verify_login.dart';
import 'package:warranzy_demo/models/model_verify_phone.dart';
import 'package:warranzy_demo/tools/export_lib.dart';

import 'base_url.dart';

class ShowDataAPI {
  static void printAPIName(String apiName) {
    print("<------------------------------ $apiName");
  }

  static void printAPIRequestUrl(String requestApiUrl) {
    print("<+++++++++++++++++++++++++ $requestApiUrl");
  }

  static void printResponse(String response) {
    print(
        "<===================== Response\n$response\n<======================================");
  }
}

class APIServiceUser {
  static const int TIMEOUT = 60;
  static final String baseUrl = BaseUrl.baseUrl;
  // static Future apiVerifyNumberTest({String url, dynamic postData}) async {
  //   printAPIName("apiVerfyNumber");
  //   String urlPost = "http://192.168.0.36:9999/API/v1/User/CheckVerifyPhone";
  //   print(postData);
  //   try {
  //     final response = await dio.post(urlPost, data: postData);
  //     if (response.statusCode == 200) {
  //       return response.data;
  //     } else
  //       Exception("Failed to load post");
  //   } on TimeoutException catch (_) {
  //     print("TimeOut");
  //   } catch (e) {
  //     print("Catch => " + "$e");
  //   }
  // }

  static Future<ModelVerifyNumber> apiVerifyNumber({dynamic postData}) async {
    ShowDataAPI.printAPIName("apiVerfyNumber");
    ShowDataAPI.printAPIRequestUrl("$baseUrl/User/CheckVerifyPhone");
    String urlPost = "$baseUrl/User/CheckVerifyPhone"; //User/CheckVerifyPhone;
    try {
      final response = await http
          .post(urlPost, body: postData)
          .timeout(Duration(seconds: TIMEOUT));
      if (response.statusCode == 200) {
        ShowDataAPI.printResponse("${json.decode(response.body)}");
        return ModelVerifyNumber.fromJson(json.decode(response.body));
      } else
        throw Exception("Failed to load");
    } on TimeoutException catch (_) {
      print("TimeOut");
      return ModelVerifyNumber(message: "Time Out. Try again.");
    } on Exception catch (e) {
      print("Catch on Exception => $e");
      return ModelVerifyNumber(message: "$e");
    } catch (e) {
      print("Error => $e");
      return ModelVerifyNumber(message: "Error => $e");
    }
  }

  static Future<ModelVerifyNumber> apiVerifyNumberTryRequest(
      {dynamic postData}) async {
    ShowDataAPI.printAPIName("apiVerfyNumberTryRequest");
    ShowDataAPI.printAPIRequestUrl("$baseUrl/User/RequestVerifyCode");
    String urlPost = "$baseUrl/User/RequestVerifyCode"; //User/CheckVerifyPhone;
    try {
      final response = await http
          .post(urlPost, body: postData)
          .timeout(Duration(seconds: TIMEOUT));
      if (response.statusCode == 200) {
        ShowDataAPI.printResponse("${json.decode(response.body)}");
        return ModelVerifyNumber.fromJson(json.decode(response.body));
      } else
        throw Exception("Failed to load");
    } on TimeoutException catch (_) {
      print("TimeOut");
      return ModelVerifyNumber(message: "Time Out. Try again.");
    } on Exception catch (e) {
      print("Catch on Exception => $e");
      return ModelVerifyNumber(message: "$e");
    } catch (e) {
      print("Error => $e");
      return ModelVerifyNumber(message: "Error => $e");
    }
  }

  static Future<RepositoryUser> apiRegister({dynamic postData}) async {
    ShowDataAPI.printAPIName("apiRegister");
    ShowDataAPI.printAPIRequestUrl("$baseUrl/User/UserRegister");
    String urlPost = "$baseUrl/User/UserRegister"; //User/CheckVerifyPhone;
    try {
      final response = await http
          .post(urlPost, body: postData)
          .timeout(Duration(seconds: TIMEOUT));
      if (response.statusCode == 200) {
        ShowDataAPI.printResponse("${json.decode(response.body)}");
        return RepositoryUser.fromJson(json.decode(response.body));
      } else
        throw Exception("Failed to load");
    } on TimeoutException catch (_) {
      print("TimeOut");
      return RepositoryUser(message: "Time Out. Try again.");
    } on Exception catch (e) {
      print("Catch on Exception => $e");
      return RepositoryUser(message: "$e");
    } catch (e) {
      print("$baseUrl/User/UserRegister => Catch Error $e");
      return RepositoryUser(message: "Error => $e");
    }
  }

  static Future<RepositoryUser> apiVerifyChangeDevice(
      {dynamic postData}) async {
    ShowDataAPI.printAPIName("apiVerifyChangeDevice");
    ShowDataAPI.printAPIRequestUrl("$baseUrl/User/VerifyChangeDevice");
    String urlPost =
        "$baseUrl/User/VerifyChangeDevice"; //User/CheckVerifyPhone;
    try {
      final response = await http
          .post(urlPost, body: postData)
          .timeout(Duration(seconds: TIMEOUT));
      if (response.statusCode == 200) {
        ShowDataAPI.printResponse("${json.decode(response.body)}");
        return RepositoryUser.fromJson(json.decode(response.body));
      } else
        throw Exception("Failed to load");
    } on TimeoutException catch (_) {
      print("TimeOut");
      return RepositoryUser(message: "Time Out. Try again.");
    } on Exception catch (e) {
      print("Catch on Exception => $e");
      return RepositoryUser(message: "$e");
    } catch (e) {
      print("Catch Error => $e");
      return RepositoryUser(message: "Error => $e");
    }
  }

  static Future<ModelVerifyNumber> apiChangeDevice({dynamic postData}) async {
    String urlPost = "$baseUrl/User/ChangeDevice"; //User/CheckVerifyPhone;
    ShowDataAPI.printAPIName("apiChangeDevice");
    ShowDataAPI.printAPIRequestUrl("$baseUrl/User/ChangeDevice");
    try {
      final response = await http
          .post(urlPost, body: postData)
          .timeout(Duration(seconds: TIMEOUT));
      if (response.statusCode == 200) {
        ShowDataAPI.printResponse("${json.decode(response.body)}");
        return ModelVerifyNumber.fromJson(json.decode(response.body));
      } else
        throw Exception("Failed to load");
    } on TimeoutException catch (_) {
      print("TimeOut");
      return ModelVerifyNumber(message: "Time out. Try again");
    } on Exception catch (e) {
      print("Catch on Exception => $e");
      return ModelVerifyNumber(message: "$e");
    } catch (e) {
      print("Catch Error => $e");
      return ModelVerifyNumber(message: "Error => $e");
    }
  }

  static Future<ModelVerifyLogin> apiVerifyLogin({dynamic postData}) async {
    ShowDataAPI.printAPIName("apiLogin");
    String urlPost = "$baseUrl/User/Login"; //User/CheckVerifyPhone;
    ShowDataAPI.printAPIRequestUrl("$baseUrl/User/Login");
    try {
      final response = await http
          .post(urlPost, body: postData)
          .timeout(Duration(seconds: TIMEOUT));
      if (response.statusCode == 200) {
        ShowDataAPI.printResponse("${json.decode(response.body)}");
        return ModelVerifyLogin.fromJson(json.decode(response.body));
      } else {
        throw Exception("Failed to load");
      } //ModelVerifyLogin(message: "Error ${response.statusCode}")
    } on SocketException catch (e) {
      print(e);
      return ModelVerifyLogin(message: "Error ${e.message}");
    } on TimeoutException catch (_) {
      print("TimeOut");
      return ModelVerifyLogin(message: "Request time out. Try again.");
    } on Exception catch (e) {
      print("Catch on Exception => $e");
      return ModelVerifyLogin(message: "$e");
    } catch (e) {
      print("Catch Error $baseUrl/User/Login => : $e");
      return ModelVerifyLogin(message: "Catch $e");
    }
  }

  static Future<ModelVerifyLogin> apiVerifyLoginTest({dynamic postData}) async {
    ShowDataAPI.printAPIName("apiLogin");
    String urlPost = "$baseUrl/User/Login"; //User/CheckVerifyPhone;
    ShowDataAPI.printAPIRequestUrl("$baseUrl/User/Login");
    FormData formData = FormData.from(postData);
    try {
      final response = await HttpService.dio
          .post("$urlPost", data: formData)
          // await http
          // .post(urlPost, body: postData)
          .timeout(Duration(seconds: TIMEOUT));
      if (response.statusCode == 200) {
        ShowDataAPI.printResponse("${json.decode(response.data)}");
        return ModelVerifyLogin.fromJson(json.decode(response.data));
      } else {
        throw Exception("Failed to load");
      }
    } on DioError catch (e) {
      print("DioError ${e.request}");
      return ModelVerifyLogin(message: "Error ${e.message}");
    } on SocketException catch (e) {
      print(e);
      return ModelVerifyLogin(message: "Error ${e.message}");
    } on TimeoutException catch (_) {
      print("TimeOut");
      return ModelVerifyLogin(message: "Request time out. Try again.");
    } on Exception catch (e) {
      print("Catch on Exception => $e");
      return ModelVerifyLogin(message: "$e");
    } catch (e, s) {
      print("Catch Error $baseUrl/User/Login => : $e | $s");
      return ModelVerifyLogin(message: "Error");
    }
  }
}

class SendAPI<T> {
  Map<String, dynamic> body;
  String url;

  SendAPI({this.url, this.body});

  sendingAPI() {}
}
