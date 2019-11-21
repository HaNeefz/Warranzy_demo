import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:onesignal/onesignal.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warranzy_demo/models/receive_message_model.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';

Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

class NotificationState extends ChangeNotifier {
  // final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  NotificationState();
  List<MessageModel> _messageList = [];
  List<MessageModel> get messageList => _messageList;
  int _counterMessage = 0;
  String _playerID = "Unknow";
  String get playerID => _playerID;

  int get counterMessage => _counterMessage;
  resetCounterMessage() {
    _counterMessage = 0;
    notifyListeners();
  }

  bool get emptyMessage => _counterMessage == 0;

  decrementCounter(index) {
    if (_messageList[index].active == false && _counterMessage > 0) {
      _counterMessage--;
      notifyListeners();
    }
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

    await OneSignal.shared.init("138414dc-cb53-43e0-bc67-49fc9b7a99f4");
    await OneSignal.shared
        .init("138414dc-cb53-43e0-bc67-49fc9b7a99f4", iOSSettings: _settings);
    OneSignal.shared.getPermissionSubscriptionState();
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
    notifyListeners();
  }

  getNotificationID() async {
    try {
      await OneSignal.shared
          .getPermissionSubscriptionState()
          .then((status) async {
        _playerID = status.subscriptionStatus.userId;
        await SharedPreferences.getInstance().then((prefs) async {
          await prefs.setString("NotificationID", _playerID);
        });
        var pID = await SharedPreferences.getInstance();
        print("PlayerID : " + "${pID.getString("NotificationID")}");
      });
    } catch (e) {
      print("ERROR get NotificationID => $e");
    }
  }

  initialFirebaseMessage() {
    // _firebaseMessaging.

    //   _firebaseMessaging.configure(
    //       onMessage: (Map<String, dynamic> message) async {
    //     print("onMessage: $message");
    //     // final notification = message['notification'];
    //     // _addMessage(notification);
    //     // setState(() {
    //     //   messages.add(MessageData(
    //     //       title: notification['title'], body: notification['body']));
    //     // });
    //   }, onLaunch: (Map<String, dynamic> message) async {
    //     print("onLaunch: $message");
    //     // final notification = message['notification'];
    //     // addData(notification);
    //     // setState(() {
    //     //   messages.add(MessageData(title: '$message', body: 'onLauncher'));
    //     // });
    //     // final notification = message['data'];
    //     // setState(() {
    //     //   messages.add(MessageData(
    //     //       title: 'onLaunch : ${notification['title']}',
    //     //       body: 'onLaunch : ${notification['body']}'));
    //     // });
    //   }, onResume: (Map<String, dynamic> message) async {
    //     print("onResume: $message");
    //     // final notification = message['notification'];
    //     // addData(notification);
    //     // final notification = message['notification'];
    //     // setState(() {
    //     //   messages.add(MessageData(
    //     //       title: 'onResume : ${notification['title']}',
    //     //       body: 'onResume : ${notification['body']}'));
    //     // });
    //   });
    //   _firebaseMessaging.requestNotificationPermissions(
    //       const IosNotificationSettings(sound: true, badge: true, alert: true));
    //   _firebaseMessaging.onIosSettingsRegistered
    //       .listen((IosNotificationSettings settings) {
    //     print("Settings registered: $settings");
    //   });

    //   _firebaseMessaging.getToken().then((token) {
    //     print("TOKEN is : " + token);
    //   });

    //   print("started");
    //   // notifyListeners();
  }
}
