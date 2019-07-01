import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
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
    // TODO: implement initState
    super.initState();
    _initLangeuage("en");

    allTranslations.onLocaleChangedCallback = _onLocaleChanged;
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
