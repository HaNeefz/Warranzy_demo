import 'package:local_auth/auth_strings.dart';

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