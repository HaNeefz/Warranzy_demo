import 'package:flutter/material.dart';

import '../assets.dart';
import '../theme_color.dart';

class BackGroundApp {
  static Widget build({BuildContext context, Widget child}) {
    return Stack(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
        ),
        Positioned(
          top: -MediaQuery.of(context).size.width / 2 * 3.7,
          left: -MediaQuery.of(context).size.width / 2,
          right: -MediaQuery.of(context).size.width /
              2, //-MediaQuery.of(context).size.height+100,
          child: Container(
            width: MediaQuery.of(context).size.width * 2,
            height: MediaQuery.of(context).size.width * 2,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: <Color>[Colors.teal[300], Colors.teal[100]]),
                borderRadius:
                    BorderRadius.circular(MediaQuery.of(context).size.width)),
          ),
        ),
        Positioned(
          top: -MediaQuery.of(context).size.width / 2 * 1.7,
          left: 0,
          right: 0, //-MediaQuery.of(context).size.height+100,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: <Color>[Colors.teal[700], Colors.teal[100]]),
                borderRadius: BorderRadius.circular(
                    MediaQuery.of(context).size.width / 2)),
          ),
        ),
        child,
      ],
    );
  }
}
