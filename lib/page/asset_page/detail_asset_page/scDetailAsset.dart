import 'package:flutter/material.dart';
import 'package:warranzy_demo/tools/config/text_style.dart';
import 'package:warranzy_demo/tools/theme_color.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/text_builder.dart';

class DetailAsset extends StatefulWidget {
  final int id;
  final String title;
  final String content;
  final String expire;
  final String category;
  final Widget image;

  const DetailAsset(
      {Key key,
      this.id,
      this.title,
      this.content,
      this.expire,
      this.category,
      this.image})
      : super(key: key);
  @override
  _DetailAssetState createState() => _DetailAssetState();
}

class _DetailAssetState extends State<DetailAsset> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextBuilder.build(
            title: "Detail Asset", style: TextStyleCustom.STYLE_APPBAR),
      ),
      body: Container(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  expandedHeight: 300,
                  backgroundColor: COLOR_WHITE,
                  automaticallyImplyLeading: false,
                  flexibleSpace: widget.image ??
                      Hero(
                        tag: "thumbnail_${widget.id}",
                        child: FlutterLogo(
                          size: 200,
                          colors: COLOR_THEME_APP,
                        ),
                      ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate([
                    Container(
                      height: 60,
                      child: TextBuilder.build(title: widget.category),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextBuilder.build(
                        title: widget.title,
                        style: TextStyleCustom.STYLE_LABEL_BOLD),
                    SizedBox(
                      height: 20,
                    ),
                    TextBuilder.build(
                        title: widget.content,
                        style: TextStyleCustom.STYLE_CONTENT),
                    TextBuilder.build(title: widget.expire),
                  ]),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
