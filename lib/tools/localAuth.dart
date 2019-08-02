import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';

import 'const.dart';

class LocalAuth {
  final LocalAuthentication auth = LocalAuthentication();

  Future<bool> checkBiometrics() async {
    bool canCheckBiometrics;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      print(e);
    }

    return canCheckBiometrics;
  }

  Future<List<BiometricType>> getAvailableBiometrics() async {
    List<BiometricType> availableBiometrics;
    try {
      availableBiometrics = await auth.getAvailableBiometrics();
      print(availableBiometrics);
    } on PlatformException catch (e) {
      print(e);
    }
    return availableBiometrics;
  }

  Future<bool> authenticate() async {
    bool authenticated = false;
    bool canCheckBiometrics = false;
    bool correct = false;
    List<BiometricType> availableBiometrics;
    try {
      canCheckBiometrics = await checkBiometrics();
      availableBiometrics = await getAvailableBiometrics();
      authenticated = await auth.authenticateWithBiometrics(
          localizedReason: "Scan your fingerprint to authenticate",
          useErrorDialogs: true,
          stickyAuth: false,
          androidAuthStrings: androidStrings,
          iOSAuthStrings: iosStrings);
    } on PlatformException catch (e) {
      print(e);
    }

    if (canCheckBiometrics == true) {
      // print(canCheckBiometrics);
      // print(availableBiometrics);
      if (authenticated == true) {
        print("Authorized");
        correct = true;
      } else {
        print("Not Authorized");
        correct = false;
      }
    } else {
      print("can't CheckBiometrics");
    }
    return correct;
  }
}

LocalAuth localAuth = LocalAuth();
