import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warranzy_demo/tools/config/text_style.dart';
import 'package:warranzy_demo/tools/export_lib.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/text_builder.dart';

class CategoryUI extends StatefulWidget {
  final String title;
  final List<Map<String, dynamic>> category;
  final Map<String, dynamic> selected;

  CategoryUI({Key key, this.title, this.category, this.selected})
      : super(key: key);
  @override
  _CategoryUIState createState() => _CategoryUIState();
}

class _CategoryUIState extends State<CategoryUI> {
  final ecsLib = getIt.get<ECSLib>();
  final allTranslations = getIt.get<GlobalTranslations>();
  final Future<SharedPreferences> _pref = SharedPreferences.getInstance();

  checkTempPreference() async {
    final pref = await _pref;
    // pref.
  }

  List<String> imagePath = [];
  @override
  void initState() {
    super.initState();
    widget.category.forEach((v) {
      print(v['Logo']);
      // // setState(() => )
      // imagePath.add(v['Logo']);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: TextBuilder.build(
            title: "${widget.title}", style: TextStyleCustom.STYLE_APPBAR),
      ),
      body: Container(
        padding: EdgeInsets.all(5),
        child: SingleChildScrollView(
          child: Column(
              children: widget.category.map((v) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ListTile(
                  // leading: ImageView.show(
                  //     path: v['Logo']), //imagePath[widget.category.indexOf(v)]
                  // Image.asset("${v['Logo']}",
                  //     width: 30, height: 30, fit: BoxFit.contain),
                  title: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Expanded(
                        flex: 2,
                        child: AutoSizeText(
                          jsonDecode(v['CatName'] ?? v['GroupName'])["EN"],
                          minFontSize: 10,
                          stepGranularity: 10,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyleCustom.STYLE_LABEL
                              .copyWith(fontSize: 13),
                        ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: widget.selected['Logo'] == v['Logo']
                              ? Icon(Icons.check, color: Colors.green)
                              : Container(),
                        ),
                      )
                    ],
                  ),
                  onTap: () {
                    Navigator.pop(context, v);
                  },
                ),
                Divider()
              ],
            );
          }).toList()),
        ),
      ),
    );
  }
}

class ImageView {
  static Widget show({String path}) {
    return path != null
        ? Image.asset(
            path,
            fit: BoxFit.contain,
            width: 30,
            height: 30,
          )
        : Icon(Icons.error);
  }
}

class ImageViewer extends StatelessWidget {
  final imagePath;
  const ImageViewer({
    Key key,
    this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return imagePath != null
        ? Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(imagePath), fit: BoxFit.contain),
            ),
          )
        : Icon(Icons.error);
  }
}
