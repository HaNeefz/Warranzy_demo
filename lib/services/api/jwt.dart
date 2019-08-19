import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';

class JWTService {
  final String key = 'ECS';
  String custID;
  String phoneNumber;
  String countryCode;
  Dio dio = Dio();
  JWTService(
      {@required this.custID,
      @required this.phoneNumber,
      @required this.countryCode});

  sendApiTokenJWT() async {
    var claimSet = JwtClaim(
        defaultIatExp: true,
        otherClaims: <String, dynamic>{
          "CustUserID": custID,
          "CountryCode": phoneNumber,
          "MobilePhone": countryCode
        },
        maxAge: Duration(minutes: 1));

    String token = issueJwtHS256(claimSet, key);
    print(token);
    // final JwtClaim decClaimSet = verifyJwtHS256Signature(token, "ECS");
    // try {
    //   await dio.post("http://192.168.0.36:9999/API/v1",
    //       data: {"Token": token}).then((res) {
    //     print(res);
    //   });
    // } catch (e) {
    //   print(e);
    // }
  }
  // String token = issueJwtHS256(claimSet, hmacKey)
}
