import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warranzy_demo/services/providers/theme_state.dart';
import 'package:warranzy_demo/tools/const.dart';
import 'package:warranzy_demo/tools/theme_color.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/text_builder.dart';

class ThemePage extends StatelessWidget {
  final String title;

  ThemePage({
    Key key,
    this.title,
  }) : super(key: key);

  var _darkTheme = true;
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        leading: Icon(
          Icons.color_lens,
          size: 30,
          color: ThemeColors.COLOR_BLACK,
        ),
        title: TextBuilder.build(title: title ?? ""),
        trailing: Switch(
          value: _darkTheme,
          onChanged: (bool value) async {
            (value)
                ? themeNotifier.setTheme(darkTheme)
                : themeNotifier.setTheme(lightTheme);
            var pref = await SharedPreferences.getInstance();
            pref.setBool("darkMode", value);
          },
        ),
      ),
    );
  }
}
