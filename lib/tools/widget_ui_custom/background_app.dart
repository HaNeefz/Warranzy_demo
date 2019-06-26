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
          decoration: BoxDecoration(
            color: COLOR_TEXT_THEME,
            image: DecorationImage(
                image: AssetImage("${Assets.BACK_GROUND_APP}"),
                fit: BoxFit.cover),
          ),
        ),
        child,
      ],
    );
  }
}
