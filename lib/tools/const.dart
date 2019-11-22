import 'package:local_auth/auth_strings.dart';
import 'package:flutter/material.dart';

import 'theme_color.dart';

final iosStrings = IOSAuthMessages(
  cancelButton: 'cancel',
  goToSettingsButton: 'setting',
  goToSettingsDescription: 'Please set up your Touch ID',
  lockOut: 'Please reenable your Touch ID',
);
final androidStrings = AndroidAuthMessages(
    cancelButton: 'cancel',
    goToSettingsButton: 'setting',
    goToSettingsDescription: 'Please set up your Touch ID',
    fingerprintHint: 'Your finger',
    fingerprintNotRecognized: 'finger not recongnized',
    fingerprintSuccess: 'finger correct',
    signInTitle: 'finger');

final Pattern pattern =
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

final darkTheme = ThemeData(
  primarySwatch: Colors.grey,
  primaryColor: Colors.black,
  brightness: Brightness.dark,
  backgroundColor: const Color(0xFF212121),
  accentColor: Colors.white,
  accentIconTheme: IconThemeData(color: Colors.black),
  dividerColor: Colors.black12,
);

final lightTheme = ThemeData(
  appBarTheme: AppBarTheme(brightness: Brightness.light, color: Colors.teal),
  iconTheme: IconThemeData(color: ThemeColors.COLOR_THEME_APP),
  primarySwatch: Colors.teal,
  primaryColor: Colors.white,
  brightness: Brightness.light,
  backgroundColor: Colors.white, //const Color(0xFFE5E5E5),
  accentColor: Colors.black,
  accentIconTheme: IconThemeData(color: Colors.white),
  dividerColor: Colors.white54,
);
enum StatusAsset { delivery, none }

enum PageType { setPin, login }
enum PageAction { SCAN_QR_CODE, MANUAL_ADD }
enum PageAsset { EDIT_ABLE, NEW_ASSET }
