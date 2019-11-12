import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:provider/provider.dart';
import 'package:warranzy_demo/services/providers/asset_state.dart';
import 'package:warranzy_demo/tools/export_lib.dart';
import 'package:warranzy_demo/tools/theme_color.dart';

import 'page/splash_screen/scSplash_screen.dart';
import 'services/providers/network_provider.dart';
import 'services/providers/notification_state.dart';

var getIt = GetIt();

class HttpService {
  static Dio _dio = Dio();
  static Dio get dio => _dio;
}

setupApp() {
  getIt.registerSingleton<ECSLib>(ECSLib());
  getIt.registerSingleton<GlobalTranslations>(GlobalTranslations());
  getIt.registerSingleton<HttpService>(HttpService());
  getIt.registerSingleton<NotificationState>(NotificationState());
}

void main() {
  Provider.debugCheckInvalidValueType = null;
  // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
  //     statusBarColor: Colors.black,
  //     statusBarBrightness: Brightness.dark,
  //     systemNavigationBarColor: Colors.white,
  //     statusBarIconBrightness: Brightness.dark,
  //     systemNavigationBarIconBrightness: Brightness.dark)
  //     );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((_) async {
    setupApp();
    runApp(MultiProvider(
        providers: [
          ChangeNotifierProvider<NotificationState>(
            builder: (_) => NotificationState(),
          ),
          ChangeNotifierProvider<AssetState>(
            builder: (_) => AssetState(),
          ),
        ],
        child: StreamProvider<ConnectivityStatus>(
          builder: (context) =>
              ConnectivityService().connectionStatusController.stream,
          child: Consumer<NotificationState>(
            builder: (BuildContext context, _notitState, _) => MyHomePage(
              notiState: _notitState,
            ),
          ),
        )));
  });
}

class MyHomePage extends StatefulWidget {
  final NotificationState notiState;

  const MyHomePage({Key key, @required this.notiState}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  NotificationState get notiState => widget.notiState;
  @override
  void initState() {
    super.initState();
    _initLangeuage("en");
    initialConfig();
    initNoti();
    // notiState.initialFirebaseMessage();
    allTranslations.onLocaleChangedCallback = _onLocaleChanged;
  }

  initNoti() {
    setState(() {
      notiState.initNotification();
    });
  }

  initialConfig() async {
    await GlobalConfiguration().loadFromAsset("app_settings");
  }

  _onLocaleChanged() async {
    // do anything you need to do if the language changes
    print('Language has been changed to: ${allTranslations.currentLanguage}');
  }

  final allTranslations = getIt.get<GlobalTranslations>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // showPerformanceOverlay: true,

      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: allTranslations.supportedLocales(),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      title: 'Flutter Demo',
      theme: ThemeData(
          primarySwatch: Colors.teal,
          brightness: Brightness.light,
          // primaryColor: Colors.white,
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: AppBarTheme(brightness: Brightness.light),
          iconTheme: IconThemeData(color: ThemeColors.COLOR_THEME_APP)
          // fontFamily: "Ekkamai"
          ), //Supermarket
      darkTheme: ThemeData(brightness: Brightness.dark),
      home: SplashScreenPage(),
    );
  }

  _initLangeuage(String lang) async {
    await allTranslations.setNewLanguage(lang);
    setState(() {});
  }
}
