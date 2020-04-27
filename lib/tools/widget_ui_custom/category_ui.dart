import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warranzy_demo/tools/config/text_style.dart';
import 'package:warranzy_demo/tools/export_lib.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/text_builder.dart';

class CategoryUI extends StatefulWidget {
  final String title;
  final List<Map<String, dynamic>> category;
  final Map<String, dynamic> selected;
  final bool showLogo;

  CategoryUI(
      {Key key, this.title, this.category, this.selected, this.showLogo = true})
      : super(key: key);
  @override
  _CategoryUIState createState() => _CategoryUIState();
}

class _CategoryUIState extends State<CategoryUI> {
  final ecsLib = getIt.get<ECSLib>();
  final allTranslations = getIt.get<GlobalTranslations>();
  List<String> imagePath = [];
  List<Image> images = List<Image>();
  @override
  void initState() {
    super.initState();
    print("initState");
    print(widget.category.first);
    // widget.category.forEach((v) {
    //   images.add(Image.asset(
    //     v['Logo'],
    //     fit: BoxFit.contain,
    //     width: 30,
    //     height: 30,
    //   ));
    // });
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   print("didChangeDependencies");
  //   images.forEach((v) {
  //     precacheImage(v.image, context);
  //   });
  // }

  @override
  void dispose() {
    images.clear();
    imageCache.clear();
    print("images clear , dispose()");

    super.dispose();
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
                  // leading:
                      //widget.showLogo == true
                      //     ? CachedNetworkImage(
                      //         imageUrl: v['Logo'],
                      //         placeholder: (context, path) =>
                      //             CircularProgressIndicator(),
                      //         errorWidget: (context, path, object) =>
                      //             Icon(Icons.error, color: Colors.red),
                      //         width: 30,
                      //         height: 30,
                      //         fit: BoxFit.contain,
                      //       )
                      //     : Container(),
                      // images[widget.category.indexOf(v)],
                      // ImageView.show(
                      //     path: v[
                      // 'LogoAsset']), //imagePath[widget.category.indexOf(v)]
                      // Image.asset("${v['LogoAsset']}",
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
