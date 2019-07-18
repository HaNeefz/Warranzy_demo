import 'package:flutter/foundation.dart';

class MessageModel {
  final String title;
  final String body;
  final String dateTime;
  bool active;

  MessageModel(
      {@required this.title,
      @required this.body,
      @required this.dateTime,
      this.active = false});
}
