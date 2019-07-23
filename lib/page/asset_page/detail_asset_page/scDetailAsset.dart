import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:warranzy_demo/tools/config/text_style.dart';
import 'package:warranzy_demo/tools/theme_color.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/carouselImage.dart';
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
      body: Container(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: 300,
              backgroundColor: COLOR_WHITE,
              automaticallyImplyLeading: false,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: COLOR_BLACK,
                ),
                onPressed: () => Navigator.pop(context),
              ),
              flexibleSpace: widget.image ??
                  CarouselWithIndicator(
                    autoPlay: false,
                    height: 400,
                    viewportFraction: 1.0,
                    items: <Widget>[
                      testImage(),
                      testImage(),
                      testImage(),
                      testImage(),
                      testImage(),
                    ],
                  ),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 20, 10, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 20,
                      ),
                      TextBuilder.build(
                          title: widget.title,
                          style: TextStyleCustom.STYLE_TITLE),
                      SizedBox(
                        height: 20,
                      ),
                      TextBuilder.build(
                          title: widget.content,
                          style: TextStyleCustom.STYLE_CONTENT),
                      TextBuilder.build(title: widget.expire),
                    ],
                  ),
                ),
              ]),
            )
          ],
        ),
      ),
    );
  }

  Widget testImage() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 300,
      decoration: BoxDecoration(
          gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: <Color>[COLOR_BLACK.withOpacity(0.6), COLOR_TRANSPARENT],
      )),
      child: Center(
        child: FlutterLogo(
          size: 300,
          colors: COLOR_THEME_APP,
        ),
      ),
    );
  }
}
