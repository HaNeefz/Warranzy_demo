import 'package:flutter/material.dart';
import 'package:warranzy_demo/page/login_first/scLogin.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:warranzy_demo/tools/export_lib.dart';

class SplashScreenPage extends StatefulWidget {
  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  final ecsLib = getIt.get<ECSLib>();
  final allTranslations = getIt.get<GlobalTranslations>();

  @override
  void initState() {
    super.initState();
    Future.delayed(
        Duration(milliseconds: 3000),
        () => ecsLib.pushPageReplacement(
            context: context, pageWidget: LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ControlledAnimation(
          duration: Duration(milliseconds: 1500),
          tween: Tween(begin: 0.0, end: 1.0),
          builder: (context, opacity) {
            return Opacity(opacity: opacity, child: ecsLib.logoApp());
          },
        ),
      ),
    );
  }
}
