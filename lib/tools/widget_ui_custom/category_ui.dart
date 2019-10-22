import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
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
        child: ListView(
            shrinkWrap: true,
            children: widget.category.map((v) {
              // print(widget.selected['Logo']);
              // print(widget.selected['Logo'] == v["Logo"]);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ListTile(
                    leading: Image.asset("${v['Logo']}",
                        width: 30, height: 30, fit: BoxFit.contain),
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
    );
  }
}
