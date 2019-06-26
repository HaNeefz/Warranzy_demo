import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import '../export_lib.dart';
import '../theme_color.dart';

final ecsLib = getIt.get<ECSLib>();
final allTranslations = getIt.get<GlobalTranslations>();

class FloatingActionBuilder {
  static Widget build({
    @required BuildContext context,
    @required List<SpeedDialChild> actionButton,
    String toolTip,
    Color backgroundColor = COLOR_THEME_APP,
    Color foregroundColor = COLOR_WHITE,
  }) {
    return SpeedDial(
      // both default to 16
      marginRight: 18,
      marginBottom: 20,
      // animatedIcon: AnimatedIcons.add_event,
      animatedIconTheme: IconThemeData(size: 22.0),
      // this is ignored if animatedIcon is non null
      // child: Icon(Icons.add),
      visible: true,
      // If true user is forced to close dial manually
      // by tapping main button and overlay is not rendered.
      closeManually: false,
      curve: Curves.bounceIn,
      overlayColor: Colors.black,
      overlayOpacity: 0.5,
      child: Icon(Icons.add),
      // onOpen: () => print('OPENING DIAL'),
      // onClose: () => print('DIAL CLOSED'),
      tooltip: toolTip,
      heroTag: 'speed-dial-hero-tag',
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      elevation: 8.0,
      shape: CircleBorder(),
      children: [
        for (var child in actionButton) child
        /* Example 
        SpeedDialChild(
              child: Icon(Icons.accessibility),
              backgroundColor: Colors.red,
              label: 'First',
              labelStyle: TextStyle(fontSize: 18.0),
              onTap: () => print('FIRST CHILD')
            ), 
        */
      ],
    );
  }
}
