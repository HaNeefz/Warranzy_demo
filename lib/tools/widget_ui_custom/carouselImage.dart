import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:warranzy_demo/tools/config/text_style.dart';

import '../theme_color.dart';
import 'text_builder.dart';

class CarouselWithIndicator extends StatefulWidget {
  final List<dynamic> items;
  final double height;
  final bool autoPlay;
  final num viewportFraction;
  final bool indiCatorIsLight;

  CarouselWithIndicator(
      {Key key,
      this.items,
      this.height = 100,
      this.autoPlay = true,
      this.viewportFraction = 0.9,
      this.indiCatorIsLight = false})
      : super(key: key);
  @override
  _CarouselWithIndicatorState createState() => _CarouselWithIndicatorState();
}

class _CarouselWithIndicatorState extends State<CarouselWithIndicator> {
  int _current = 0;
  List<dynamic> get items => widget.items;
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      CarouselSlider(
        items: items.map((i) {
          if (i is Widget)
            return Container(
              width: MediaQuery.of(context).size.width,
              height: widget.height,
              child: i,
            );
          else
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
              decoration: BoxDecoration(
                  color: ThemeColors.COLOR_THEME_APP,
                  borderRadius: BorderRadius.circular(10)),
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: TextBuilder.build(
                    title: "$i",
                    style: TextStyleCustom.STYLE_LABEL
                        .copyWith(color: ThemeColors.COLOR_WHITE)),
              ),
            );
        }).toList(),
        autoPlay: widget.autoPlay,
        aspectRatio: 2.0,
        viewportFraction: widget.viewportFraction,
        enlargeCenterPage: items[0] is Widget ? false : true,
        height: widget.height,
        onPageChanged: (index) {
          setState(() {
            _current = index;
          });
        },
      ),
      Positioned(
          bottom: 0.0,
          left: 0.0,
          right: 0.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: Iterable.generate(items.length, (index) {
              return Container(
                width: 8.0,
                height: 8.0,
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.indiCatorIsLight == false
                        ? _current == index
                            ? Color.fromRGBO(0, 0, 0, 0.9)
                            : Color.fromRGBO(0, 0, 0, 0.4)
                        : _current == index
                            ? Color.fromRGBO(255, 255, 255, 0.9)
                            : Color.fromRGBO(255, 255, 255, 0.4)),
              );
            }).toList(),
          ))
    ]);
  }
}
