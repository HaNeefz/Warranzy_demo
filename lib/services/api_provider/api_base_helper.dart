import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:warranzy_demo/services/api/base_url.dart';
import 'package:warranzy_demo/services/api/jwt_service.dart';
import 'dart:convert';
import 'dart:async';

import 'app_exceptions.dart';

class ApiBaseHelper {
  final String _baseUrl = BaseUrl.baseUrl;
  final Dio _dio = Dio();
  Future<dynamic> get(String url) async {
    print('Api Get, url $url');
    var responseJson;
    try {
      final response = await http.get(_baseUrl + url, headers: {
        "Authorization": await JWTService.getTokenJWT()
      }).timeout(Duration(seconds: 60));
      responseJson = ReturnResponse.response(response);
    } on SocketException {
      print('No net');
      throw FetchDataException('No Internet connection');
    } catch (e) {
      throw FetchDataException('$e');
    }
    print('api get recieved!');
    return responseJson;
  }

  Future<dynamic> post(String url, dynamic body) async {
    print('Api Post, url $url');
    var responseJson;
    try {
      final response = await http.post(_baseUrl + url, body: body, headers: {
        "Authorization": await JWTService.getTokenJWT()
      }).timeout(Duration(seconds: 60));
      print(response.body);
      responseJson = ReturnResponse.response(response);
    } on SocketException {
      print('No net');
      throw FetchDataException('No Internet connection');
    } catch (e) {
      throw FetchDataException('$e');
    }
    print('api post recieved!.');
    return responseJson;
  }

  Future<dynamic> postDio(String url, dynamic body) async {
    print('Api Post, url $url');
    FormData _form = FormData.from(body);
    var responseJson;
    try {
      final response = await _dio.post(
        _baseUrl + url,
        data: _form,
        options: Options(
            headers: {"Authorization": await JWTService.getTokenJWT()},
            connectTimeout: 60000),
      );
      responseJson = ReturnResponse.responseDio(response);
    } on SocketException {
      print('No net');
      throw FetchDataException('No Internet connection');
    } catch (e) {
      throw FetchDataException('$e');
    }
    print('api post recieved!.');
    return responseJson;
  }
}

class ReturnResponse {
  static dynamic response(
    http.Response response,
  ) {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body);
        JsonEncoder encoder = JsonEncoder.withIndent(" ");
        String prettyprint = encoder.convert(responseJson);
        print("Response => $prettyprint");
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 408:
        throw TimeoutException(response.body.toString());
      case 500:
      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }

  static dynamic responseDio(
    Response response,
  ) {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.data);
        JsonEncoder encoder = JsonEncoder.withIndent(" ");
        String prettyprint = encoder.convert(responseJson);
        print("Response => $prettyprint");
        return responseJson;
      case 400:
        throw BadRequestException(response.data.toString());
      case 401:
      case 403:
        throw UnauthorisedException(response.data.toString());
      case 408:
        throw TimeoutException(response.data.toString());
      case 500:
      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}
