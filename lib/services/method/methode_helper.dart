import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:warranzy_demo/services/sqflit/db_initial_app.dart';

class MethodHelper {
  static Future<String> _timeZone;
  static Future<String> _countryCode;

  static clearTimeZoneAndCountryCode() {
    _timeZone = null;
    _countryCode = null;
    print("Clear => TimeZone : $_timeZone, CountryCode : $_countryCode");
  }

  static Future<String> get timeZone async {
    if (await _timeZone != null) {
      return _timeZone;
    } else {
      print("_timeZone is null");
      _timeZone = _repositoryTimeZone();
      return _timeZone ?? "";
    }
  }

  static Future<String> get countryCode async {
    if (await _countryCode != null) {
      return _countryCode;
    } else {
      print("_countryCode is null");
      _countryCode = _repositoryCountryCode();
      return await _countryCode ?? "";
    }
  }

  static Future<String> _repositoryCountryCode() async {
    String countryCode =
        await DBProviderInitialApp.db.getCountryCodeByTimeZone(await timeZone);

    return countryCode ?? "countryCode is null";
  }

  static Future<String> _repositoryTimeZone() async {
    return await FlutterNativeTimezone.getLocalTimezone() ?? "";
  }
}
