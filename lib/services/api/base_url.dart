import 'package:global_configuration/global_configuration.dart';

class BaseUrl {
  static final baseUrl = GlobalConfiguration().getString("BaseUrl");
  static final baseUrlLocal = GlobalConfiguration().getString("BaseUrlTest");
  static final versionApp = GlobalConfiguration().getString("appVersion");
}
