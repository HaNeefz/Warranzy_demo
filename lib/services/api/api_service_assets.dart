import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:warranzy_demo/models/model_respository_asset.dart';
import 'package:warranzy_demo/services/api/base_url.dart';
import 'dart:io';
import 'jwt_service.dart';

class APIServiceAssets {
  static final Dio _dio = Dio();
  static final String _baseUrl = BaseUrl.baseUrl;

  static Future<RepositoryOfAsset> addAsset({postData}) async {
    FormData formData = FormData.from(postData);
    try {
      var res = await _dio.post("$_baseUrl/Asset/AddAsset",
          data: formData,
          options: Options(
              headers: {"Authorization": await JWTService.getTokenJWT()}));
      if (res.statusCode == 200) {
        print("<----- respone => ${res.data}");
        return RepositoryOfAsset.fromJson(jsonDecode(res.data));
      } else
        throw Exception("Failed to load post");
    } on SocketException catch (e) {
      print("SocketException => $e");
      return RepositoryOfAsset(message: "SocketException : $e");
    } on FormatException catch (e) {
      print("FormatException => $e");
      return RepositoryOfAsset(message: "FormatException : $e");
    } on Exception catch (e) {
      print("Exception => $e");
      return RepositoryOfAsset(message: "Exception : $e");
    } catch (e) {
      print("catch => $e");
      return RepositoryOfAsset(message: "catch : $e");
    }
  }

  static Future<ResponseDetailOfAsset> getDetailAseet({String wtokenID}) async {
    print(wtokenID);
    FormData formData = FormData.from({"WTokenID": wtokenID});

    try {
      var res = await _dio.post("$_baseUrl/Asset/getDetailAsset",
          data: formData,
          options: Options(
              headers: {"Authorization": await JWTService.getTokenJWT()}));
      if (res.statusCode == 200) {
        print("<----- respone => ${res.data}");
        return ResponseDetailOfAsset.fromJson(jsonDecode(res.data));
      } else
        throw Exception("Failed to load post");
    } on SocketException catch (e) {
      print("SocketException => $e");
      return ResponseDetailOfAsset(message: "SocketException : $e");
    } on FormatException catch (e) {
      print("FormatException => $e");
      return ResponseDetailOfAsset(message: "FormatException : $e");
    } on Exception catch (e) {
      print("Exception => $e");
      return ResponseDetailOfAsset(message: "Exception : $e");
    } catch (e) {
      print("catch => $e");
      return ResponseDetailOfAsset(message: "catch : $e");
    }
  }

  static Future<ResponseDetailOfAsset> deleteAseet(String wtokenID) async {
    print(wtokenID);
    FormData formData = FormData.from({"WTokenID": wtokenID});
    try {
      var res = await _dio.post("$_baseUrl/Asset/deleteAsset",
          data: formData,
          options: Options(
              headers: {"Authorization": await JWTService.getTokenJWT()}));
      if (res.statusCode == 200) {
        print(res.data);
        return ResponseDetailOfAsset.fromJson(jsonDecode(res.data));
      } else
        throw Exception("Failed to load post");
    } on SocketException catch (e) {
      print("SocketException => $e");
      return ResponseDetailOfAsset(message: "SocketException => $e");
    } on FormatException catch (e) {
      print("FormatException => $e");
      return ResponseDetailOfAsset(message: "FormatException => $e");
    } on Exception catch (e) {
      print("Exception => $e");
      return ResponseDetailOfAsset(message: "Exception => $e");
    } catch (e) {
      print("catch => $e");
      return ResponseDetailOfAsset(message: "catch => $e");
    }
  }

  static Future<ResponseDetailOfAsset> editAseet({dynamic postData}) async {
    FormData formData = FormData.from(postData);
    try {
      var res = await _dio.post("$_baseUrl/Asset/editDetailAsset",
          data: formData,
          options: Options(
              headers: {"Authorization": await JWTService.getTokenJWT()}));
      if (res.statusCode == 200) {
        print(res.data);
        return ResponseDetailOfAsset.fromJson(jsonDecode(res.data));
      } else
        throw Exception("Failed to load post");
    } on SocketException catch (e) {
      print("SocketException => $e");
      return ResponseDetailOfAsset(message: "SocketException => $e");
    } on FormatException catch (e) {
      print("FormatException => $e");
      return ResponseDetailOfAsset(message: "FormatException => $e");
    } on Exception catch (e) {
      print("Exception => $e");
      return ResponseDetailOfAsset(message: "Exception => $e");
    } catch (e) {
      print("catch => $e");
      return ResponseDetailOfAsset(message: "catch => $e");
    }
  }
}
