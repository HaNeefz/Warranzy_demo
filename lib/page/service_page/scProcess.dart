import 'package:flutter/material.dart';
import 'package:warranzy_demo/tools/config/text_style.dart';
import 'package:warranzy_demo/tools/theme_color.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/text_builder.dart';

class ProcessPage extends StatefulWidget {
  @override
  _ProcessPageState createState() => _ProcessPageState();
}

class _ProcessPageState extends State<ProcessPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(10),
        child: Column(
          children: Iterable.generate(2, (index) {
            return SizedBox(
              height: 160,
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                child: InkWell(
                  onTap: () {
                    print(index);
                  },
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Container(
                            width: 120,
                            height: 130,
                            margin: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                border: Border.all(width: 1),
                                borderRadius: BorderRadius.circular(10.0)),
                            child: Stack(children: <Widget>[
                              Container(
                                width: 120,
                                height: 130,
                                child: FlutterLogo(
                                  colors: COLOR_THEME_APP,
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  height: 30,
                                  decoration: BoxDecoration(
                                      color: Colors.teal[200],
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(10.0),
                                          bottomRight: Radius.circular(10.0))),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Icon(Icons.directions_car),
                                        TextBuilder.build(
                                            title: "Delivery",
                                            style: TextStyleCustom.STYLE_LABEL
                                                .copyWith(
                                                    fontSize: 14,
                                                    color: COLOR_WHITE))
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ]),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              TextBuilder.build(
                                  title: "Dyson V7 Trigger",
                                  style: TextStyleCustom.STYLE_LABEL_BOLD),
                              TextBuilder.build(
                                  title:
                                      "Simple dummy text of the printing industy...",
                                  style: TextStyleCustom.STYLE_CONTENT),
                              SizedBox(
                                height: 5.0,
                              ),
                              textDescription(
                                  title: "Type service",
                                  description: "Fix Service"),
                              textDescription(
                                  title: "Request Date",
                                  description: "24.05.2019"),
                              textDescription(
                                  title: "Status", description: "Pending"),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget textDescription({String title, String description}) {
    return RichText(
      text: TextSpan(
          style: TextStyleCustom.STYLE_CONTENT.copyWith(fontSize: 14),
          text: "$title : ",
          children: [
            TextSpan(
                text: "$description",
                style: TextStyleCustom.STYLE_CONTENT
                    .copyWith(fontSize: 14, color: COLOR_MAJOR))
          ]),
    );
  }
}
