import 'package:flutter/material.dart';
import 'package:onesignal/onesignal.dart';

class NotificationState extends ChangeNotifier {
  final _settings = {
      OSiOSSettings.autoPrompt: true,
      OSiOSSettings.promptBeforeOpeningPushUrl: true
    };

  initNotification() async {
    // OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
    
    await OneSignal.shared.getPermissionSubscriptionState();
    await OneSignal.shared.init("138414dc-cb53-43e0-bc67-49fc9b7a99f4");
    await OneSignal.shared
        .init("138414dc-cb53-43e0-bc67-49fc9b7a99f4", iOSSettings: _settings);
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
}
