import 'package:flutter/material.dart';
import 'package:warranzy_demo/tools/config/text_style.dart';
import 'package:warranzy_demo/tools/theme_color.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/text_builder.dart';

class ModelProcessData {
  final String title;
  final String content;
  final String typeService;
  final requestDate;
  final status;

  ModelProcessData(
      {this.title,
      this.content,
      this.typeService,
      this.requestDate,
      this.status});
}

class ProcessPage extends StatefulWidget {
  @override
  _ProcessPageState createState() => _ProcessPageState();
}

class _ProcessPageState extends State<ProcessPage> {
  List<ModelProcessData> listModelProcess = List<ModelProcessData>();

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < 10; i++) {
      listModelProcess.add(ModelProcessData(
          title: "Dyson V7 Trigger",
          content: "Simple dummy text of the printing industy...",
          typeService: "Fix Service",
          requestDate: "24.05.2019",
          status: "Pending"));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          margin: EdgeInsets.all(10),
          child: ListView.builder(
            itemCount: listModelProcess.length,
            itemBuilder: (BuildContext context, int index) {
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
                        buildImage(index),
                        buildDetailService(index),
                      ],
                    ),
                  ),
                ),
              );
            },
          )
          // Column(
          //   children: Iterable.generate(2, (index) {
          //     return SizedBox(
          //       height: 160,
          //       child: Card(
          //         elevation: 5,
          //         shape: RoundedRectangleBorder(
          //             borderRadius: BorderRadius.circular(10.0)),
          //         child: InkWell(
          //           onTap: () {
          //             print(index);
          //           },
          //           child: Row(
          //             children: <Widget>[
          //               buildImage(),
          //               buildDetailService(),
          //             ],
          //           ),
          //         ),
          //       ),
          //     );
          //   }).toList(),
          // ),
          ),
    );
  }

  Expanded buildImage(int index) {
    var listData = listModelProcess[index];
    return Expanded(
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
              child: Hero(
                tag: "thumnail_sv_$index",
                child: FlutterLogo(
                  colors: COLOR_THEME_APP,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 30,
                decoration: BoxDecoration(
                    color: Colors.teal[200],
                    gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: <Color>[Colors.teal[200], COLOR_TRANSPARENT]),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10.0),
                        bottomRight: Radius.circular(10.0))),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Icon(Icons.directions_car),
                      TextBuilder.build(
                          title: "Delivery",
                          style: TextStyleCustom.STYLE_LABEL
                              .copyWith(fontSize: 14, color: COLOR_WHITE))
                    ],
                  ),
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }

  Expanded buildDetailService(int index) {
    var listData = listModelProcess[index];
    return Expanded(
      flex: 2,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextBuilder.build(
                title: listData.title ?? "Dyson V7 Trigger",
                style: TextStyleCustom.STYLE_LABEL_BOLD),
            TextBuilder.build(
                title: listData.content ??
                    "Simple dummy text of the printing industy...",
                style: TextStyleCustom.STYLE_CONTENT),
            SizedBox(
              height: 5.0,
            ),
            TextDescriptions(
                title: "Type service",
                description: listData.typeService ?? "Fix Service"),
            TextDescriptions(
                title: "Request Date",
                description: listData.requestDate ?? "24.05.2019"),
            TextDescriptions(
                title: "Status", description: listData.status ?? "Pending"),
          ],
        ),
      ),
    );
  }
}

class TextDescriptions extends StatelessWidget {
  final String title;
  final String description;

  const TextDescriptions({Key key, this.title, this.description})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
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
