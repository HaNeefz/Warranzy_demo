import 'package:global_configuration/global_configuration.dart';

class BaseUrl {
  static final _baseUrl = GlobalConfiguration().getString("BaseUrl");
  static final _baseUrlLocal = GlobalConfiguration().getString("BaseUrlTest");
  static final _versionApp = GlobalConfiguration().getString("appVersion");

  static get baseUrl => _baseUrlLocal;
  static get versionApp => _versionApp;
}
