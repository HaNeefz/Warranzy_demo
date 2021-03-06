import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';
import 'package:warranzy_demo/models/model_mas_cust.dart';
import 'package:warranzy_demo/services/method/methode_helper.dart';
import 'package:warranzy_demo/services/sqflit/db_customers.dart';

class JWTService {
  static const String _key = 'ECS';
  Dio dio = Dio();
  ModelCustomers customers;

  static Future<String> getTokenJWT() async {
    var customer = await DBProviderCustomer.db.getDataCustomer();
    var claimSet = JwtClaim(
        defaultIatExp: true,
        otherClaims: <String, dynamic>{
          "CustUserID": customer.custUserID,
          "CountryCode": await MethodHelper.countryCode,
          "MobilePhone": customer.mobilePhone,
          "TimeZone": await MethodHelper.timeZone
        },
        maxAge: Duration(minutes: 1));

    String token = issueJwtHS256(claimSet, _key);
    // print(token);
    return token;
  }
  // String token = issueJwtHS256(claimSet, hmacKey)
}
