import 'package:flutter/material.dart';
import 'package:warranzy_demo/tools/config/text_style.dart';

import '../assets.dart';
import '../theme_color.dart';
import 'text_builder.dart';

class AppBarThemes {
  static AppBar appBarStyle(
      {@required BuildContext context,
      String title = "",
      TextStyle style,
      Color background,
      List<Widget> actions}) {
    return AppBar(
      title: TextBuilder.build(
          title: title, style: TextStyleCustom.STYLE_LABEL_BOLD),
      backgroundColor: Colors.white,
      centerTitle: true,
      elevation: 0.0,
      actions: actions,
      flexibleSpace: Container(
        child: Image.asset(
          Assets.TOP_APPBAR,
          fit: BoxFit.cover,
          height: 80,
        ),
      ),
      // Stack(
      //   children: <Widget>[

      //     // Positioned(
      //     //   top: -MediaQuery.of(context).size.width - 315,
      //     //   left: -MediaQuery.of(context).size.width / 2,
      //     //   right: -MediaQuery.of(context).size.width / 2,
      //     //   child: Container(
      //     //     width: MediaQuery.of(context).size.width * 2,
      //     //     height: MediaQuery.of(context).size.width * 2,
      //     //     decoration: BoxDecoration(
      //     //         gradient: LinearGradient(
      //     //             colors: <Color>[Colors.teal[300], Colors.teal[100]]),
      //     //         borderRadius:
      //     //             BorderRadius.circular(MediaQuery.of(context).size.width)),
      //     //   ),
      //     // ),
      //     // Positioned(
      //     //   top: -MediaQuery.of(context).size.width / 2 - 110,
      //     //   left: 0,
      //     //   right: 0,
      //     //   child: Container(
      //     //     width: MediaQuery.of(context).size.width,
      //     //     height: MediaQuery.of(context).size.width,
      //     //     decoration: BoxDecoration(
      //     //         gradient: LinearGradient(
      //     //             colors: <Color>[Colors.teal[500], Colors.teal[100]]),
      //     //         borderRadius: BorderRadius.circular(
      //     //             MediaQuery.of(context).size.width / 2)),
      //     //   ),
      //     // )
      //   ],
      // ),
      leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: ThemeColors.COLOR_BLACK,
          ),
          onPressed: () => Navigator.pop(context)),
    );
  }
}
