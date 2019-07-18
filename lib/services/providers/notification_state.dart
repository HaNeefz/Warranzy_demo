import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:onesignal/onesignal.dart';
import 'package:warranzy_demo/models/receive_message_model.dart';

class NotificationState extends ChangeNotifier {
  List<MessageModel> _messageList = [];
  List<MessageModel> get messageList => _messageList;
  int _counterMessage = 0;

  int get counterMessage => _counterMessage;
  resetCounterMessage() {
    _counterMessage = 0;
    notifyListeners();
  }

  bool get emptyMessage => _counterMessage == 0;

  decrementCounter() {
    _counterMessage--;
    notifyListeners();
  }

  clearAllMessage() {
    _messageList.clear();
    notifyListeners();
  }

  _addMessage(title, body) {
    DateTime now = DateTime.now();
    var dateTime = DateFormat("EEE 'at' H:mm a, M/d/y").format(now);
    _messageList
        .add(MessageModel(title: title, body: body, dateTime: dateTime));
    _counterMessage++;
    notifyListeners();
  }

  activeChange(index) {
    if (_messageList[index].active == false) {
      _messageList[index].active = true;
      notifyListeners();
    }
  }

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
      // print("ReceiveHandler => ${notification.payload}");
      print(
          'TITLE : ${notification.payload.title} | BODY : ${notification.payload.body}');
      print("RawPayload => ${notification.payload.rawPayload}");
      print("NotificationID => ${notification.payload.notificationId}");

      _addMessage(
          "${notification.payload.title}", "${notification.payload.body}");
    });
    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      // will be called whenever a notification is opened/button pressed.
      print("OpenedHandler $result");
    });
  }
}
