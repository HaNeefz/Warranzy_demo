import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:warranzy_demo/models/model_verify_phone.dart';

final String baseUrl = "http://192.168.0.36:9999/API/v1";
//https://testwarranty-239103.appspot.com
final Dio dio = Dio();
Future apiVerifyNumberTest({String url, dynamic postData}) async {
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

Future<ModelVerifyNumber> apiVerifyNumber({dynamic postData}) async {
  print("apiVerfyNumber");
  ModelVerifyNumber data;
  String urlPost = "$baseUrl/User/CheckVerifyPhone"; //User/CheckVerifyPhone;
  try {
    final response = await http.post(urlPost, body: postData)
        // .timeout(Duration(seconds: 30))
        ; //dio.post(urlPost, data: postData);
    if (response.statusCode == 200) {
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

Future<ModelVerifyNumber> apiVerifyNumberTryRequest({dynamic postData}) async {
  print("apiVerfyNumberTryRequest");
  ModelVerifyNumber data;
  String urlPost =
      "http://192.168.0.36:9999/API/v1/User/RequestVerifyCode"; //User/CheckVerifyPhone;
  try {
    final response = await http.post(urlPost,
        body: postData); //dio.post(urlPost, data: postData);
    if (response.statusCode == 200) {
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

Future apiRegister({dynamic postData}) async {
  print("apiRegister");
  String urlPost = "$baseUrl/User/UserRegister"; //User/CheckVerifyPhone;
  try {
    final response = await http.post(urlPost, body: postData)
        // .timeout(Duration(seconds: 30))
        ; //dio.post(urlPost, data: postData);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else
      Exception("Failed to load post");
  } on TimeoutException catch (_) {
    print("TimeOut");
  } catch (e) {
    print("Error => $e");
  }
}

/*

*/
