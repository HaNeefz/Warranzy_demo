import 'package:flutter/material.dart';
import 'package:warranzy_demo/tools/assets.dart';
import 'package:warranzy_demo/tools/config/text_style.dart';
import 'package:warranzy_demo/tools/theme_color.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/text_builder.dart';

class TradePage extends StatefulWidget {
  @override
  _TradePageState createState() => _TradePageState();
}

class _TradePageState extends State<TradePage> {
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      initialIndex: _currentPage,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: COLOR_WHITE,
          leading: Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: IconButton(
              icon: Icon(
                Icons.supervisor_account,
                color: COLOR_THEME_APP,
                size: 40,
              ),
              onPressed: () {},
            ),
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: IconButton(
                icon: Icon(
                  Icons.search,
                  size: 40,
                  color: COLOR_THEME_APP,
                ),
                onPressed: () {},
              ),
            )
          ],
          title: TextBuilder.build(
              title: "Trade Market", style: TextStyleCustom.STYLE_APPBAR),
          bottom: TabBar(
            indicatorColor: COLOR_THEME_APP,
            onTap: (i) {
              setState(() {
                _currentPage = i;
              });
            },
            labelPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            tabs: <Widget>[
              TextBuilder.build(
                  title: "Popular",
                  style:
                      TextStyleCustom.STYLE_LABEL_BOLD.copyWith(fontSize: 14)),
              TextBuilder.build(
                  title: "Electronics",
                  style:
                      TextStyleCustom.STYLE_LABEL_BOLD.copyWith(fontSize: 14)),
              TextBuilder.build(
                  title: "Tablet",
                  style:
                      TextStyleCustom.STYLE_LABEL_BOLD.copyWith(fontSize: 14)),
              TextBuilder.build(
                  title: "Cleaning",
                  style:
                      TextStyleCustom.STYLE_LABEL_BOLD.copyWith(fontSize: 14)),
            ],
          ),
        ),
        body: Container(
          child: TabBarView(
            children: <Widget>[
              Scaffold(
                backgroundColor: COLOR_GREY.withOpacity(0.3),
                body: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: GridView.builder(
                    itemCount: 10,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 6 / 9),
                    itemBuilder: (BuildContext context, int index) {
                      return ModelTrade(
                        id: index,
                        image: Image.asset(
                          Assets.BACK_GROUND_APP,
                          fit: BoxFit.cover,
                        ),
                        price: "1,000 B",
                        title: "Dyson V7 Trigger",
                        subTitle:
                            "Simply dummy text of the printing and df;isdfsdalf;sdfhasd",
                        category: "Cleaning",
                      );
                    },
                  ),
                ),
              ),
              TextBuilder.build(
                  title: "Electronics",
                  style:
                      TextStyleCustom.STYLE_LABEL_BOLD.copyWith(fontSize: 14)),
              TextBuilder.build(
                  title: "Tablet",
                  style:
                      TextStyleCustom.STYLE_LABEL_BOLD.copyWith(fontSize: 14)),
              TextBuilder.build(
                  title: "Cleaning",
                  style:
                      TextStyleCustom.STYLE_LABEL_BOLD.copyWith(fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }
}

class ModelTrade extends StatelessWidget {
  final Widget image;
  final int id;
  final String price;
  final String title;
  final String subTitle;
  final String category;

  const ModelTrade(
      {Key key,
      this.image,
      this.price,
      this.title,
      this.subTitle,
      this.category,
      this.id})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: COLOR_WHITE,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: GestureDetector(
        onTap: () {
          print(id);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(),
                child: ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0)),
                    child: Hero(
                      child: image,
                      tag: "Image$id",
                    )),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextBuilder.build(
                        title: price, style: TextStyleCustom.STYLE_CONTENT),
                    TextBuilder.build(
                        title: title, style: TextStyleCustom.STYLE_LABEL_BOLD),
                    TextBuilder.build(
                        title: subTitle,
                        style: TextStyleCustom.STYLE_CONTENT
                            .copyWith(fontSize: 14),
                        textOverflow: TextOverflow.ellipsis,
                        maxLine: 2),
                    SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      // padding: EdgeInsets.only(top: 10.0),
                      width: 100,
                      height: 25,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: COLOR_GREY.withOpacity(0.3)),
                      child: Center(
                        child: TextBuilder.build(
                            title: category,
                            style: TextStyleCustom.STYLE_LABEL
                                .copyWith(fontSize: 14)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
