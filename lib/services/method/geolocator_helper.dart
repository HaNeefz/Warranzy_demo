import 'package:geolocator/geolocator.dart';

class GeoLocationHelper {
  static final Geolocator _geolocator = Geolocator()
    ..forceAndroidLocationManager;
  static Position _userLocation;

  static Future<String> getLocation() async {
    _geolocator
        .checkGeolocationPermissionStatus()
        .then((onValue) => print("Permission : ${onValue.toString()}"));

    _userLocation = await _geolocator.getCurrentPosition().catchError((e) {
      print("getLocation error : $e");
    });
    print("timestamp : ${_userLocation.timestamp}");
    print("accuracy : ${_userLocation.accuracy}");
    print("altitude : ${_userLocation.altitude}");
    print("heading : ${_userLocation.heading}");
    print("speed : ${_userLocation.speed}");
    print("speedAccuracy : ${_userLocation.speedAccuracy}");
    print("mocked : ${_userLocation.mocked}");
    return _userLocation != null
        ? "${_userLocation.latitude}|${_userLocation.longitude}"
        : null;
  }
}
