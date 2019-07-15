import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:onesignal/onesignal.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warranzy_demo/tools/export_lib.dart';

import 'page/splash_screen/scSplash_screen.dart';

var getIt = GetIt();
void main() {
  Provider.debugCheckInvalidValueType = null;
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.black,
    // statusBarBrightness: Brightness.light,
  ));
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((_) async {
    getIt.registerSingleton<ECSLib>(ECSLib());
    getIt.registerSingleton<GlobalTranslations>(GlobalTranslations());
    runApp(MultiProvider(providers: [
      // ChangeNotifierProvider<ImageDataState>(
      //   builder: (_) => ImageDataState(),
      // )
    ], child: MyHomePage()));
  });
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    initnotification();
    _initLangeuage("en");

    allTranslations.onLocaleChangedCallback = _onLocaleChanged;
  }

  initnotification() async {
    // OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
    var settings = {
      OSiOSSettings.autoPrompt: true,
      OSiOSSettings.promptBeforeOpeningPushUrl: true
    };
    await OneSignal.shared.getPermissionSubscriptionState();
    await OneSignal.shared.init("138414dc-cb53-43e0-bc67-49fc9b7a99f4");
    await OneSignal.shared
        .init("138414dc-cb53-43e0-bc67-49fc9b7a99f4", iOSSettings: settings);
    OneSignal.shared
        .setInFocusDisplayType(OSNotificationDisplayType.notification);
    OneSignal.shared
        .setNotificationReceivedHandler((OSNotification notification) {
      // will be called whenever a notification is received
      print("ReceiveHandler => ${notification.payload}");
    });
    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      // will be called whenever a notification is opened/button pressed.
      print("OpenedHandler $result");
    });
  }

  // initnoti() async {
  //   var settings = {
  //     OSiOSSettings.autoPrompt: true,
  //     OSiOSSettings.promptBeforeOpeningPushUrl: true
  //   };
  //   await OneSignal.shared.init("138414dc-cb53-43e0-bc67-49fc9b7a99f4");
  //   await OneSignal.shared
  //       .init("138414dc-cb53-43e0-bc67-49fc9b7a99f4", iOSSettings: settings);
  //   OneSignal.shared
  //       .setInFocusDisplayType(OSNotificationDisplayType.notification);
  //   OneSignal.shared
  //       .setNotificationReceivedHandler((OSNotification notification) {
  //     // will be called whenever a notification is received
  //   });
  //   OneSignal.shared
  //       .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
  //     // will be called whenever a notification is opened/button pressed.
  //   });
  //   OneSignal.shared.getPermissionSubscriptionState().then((status) {
  //     SharedPreferences.getInstance().then((prefs) {
  //       prefs.setString("playerID", status.subscriptionStatus.userId);
  //     });
  //   });
  // }

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
        // primaryColor: Colors.white,
        scaffoldBackgroundColor: Colors.white,
        // fontFamily: "Ekkamai"
      ), //Supermarket
      home: SplashScreenPage(),
    );
  }

  _initLangeuage(String lang) async {
    await allTranslations.setNewLanguage(lang);
    setState(() {});
  }
}
