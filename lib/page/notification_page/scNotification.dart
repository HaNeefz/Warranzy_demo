import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:warranzy_demo/services/providers/notification_state.dart';
import 'package:warranzy_demo/tools/config/text_style.dart';
import 'package:warranzy_demo/tools/theme_color.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/text_builder.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: COLOR_WHITE,
        elevation: 0.0,
        title: TextBuilder.build(
            title: "Notification", style: TextStyleCustom.STYLE_APPBAR),
      ),
      body: Container(child: ShowMessage()),
    );
  }
}

class ShowMessage extends StatelessWidget {
  const ShowMessage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationState>(
        builder: (BuildContext context, NotificationState message, _) {
      if (message.messageList.length > 0)
        return ListView.separated(
          itemCount: message.messageList.length,
          itemBuilder: (BuildContext context, int index) {
            bool actived = message.messageList[index].active == true;
            return ListTile(
              title: Row(
                children: <Widget>[
                  actived == false
                      ? Container(
                          width: 15,
                          height: 15,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Colors.red),
                        )
                      : Container(),
                  actived == false
                      ? SizedBox(
                          width: 5,
                        )
                      : Container(),
                  TextBuilder.build(
                      title: "${message.messageList[index].title}",
                      style: TextStyleCustom.STYLE_LABEL_BOLD),
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextBuilder.build(
                      title: "${message.messageList[index].body}",
                      style: TextStyleCustom.STYLE_CONTENT
                          .copyWith(color: COLOR_BLACK)),
                  TextBuilder.build(
                      title: "${message.messageList[index].dateTime}",
                      style:
                          TextStyleCustom.STYLE_CONTENT.copyWith(fontSize: 14)),
                ],
              ),
              onTap: () {
                message.activeChange(index);
                message.decrementCounter();
              },
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return Divider(
              color: COLOR_GREY,
            );
          },
        );
      else
        return Center(
          child: TextBuilder.build(title: "Empty message"),
        );
    });
  }
}

class NotificationModel {
  final Widget image;
  final String title;
  final String subTitle;
  final String dateTime;
  final int id;
  bool activeRead;

  NotificationModel(
      {this.image,
      this.title,
      this.subTitle,
      this.dateTime,
      this.id,
      this.activeRead});
}

class NotificationWidget extends StatefulWidget {
  @override
  _NotificationWidgetState createState() => _NotificationWidgetState();
}

class _NotificationWidgetState extends State<NotificationWidget> {
  List<NotificationModel> _model = List<NotificationModel>();
  @override
  void initState() {
    super.initState();
    for (var i = 0; i < 10; i++) {
      _model.add(NotificationModel(
        id: i,
        activeRead: false,
        image: FlutterLogo(
          size: 50.0,
          colors: COLOR_THEME_APP,
        ),
        title: "Cliam - Dyson V7 Trigger",
        subTitle: "Simply dummy text of the printing and typesetting industry",
        dateTime: "Yesterday at 20:01",
      ));
    }
  }

  TextStyle textStyleCustom(int id) {
    if (_model[id].activeRead == false)
      return TextStyleCustom.STYLE_LABEL;
    else {
      return TextStyleCustom.STYLE_CONTENT;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: _model.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          leading: _model[index].image,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextBuilder.build(
                  title: _model[index].title,
                  style: TextStyleCustom.STYLE_LABEL_BOLD),
              TextBuilder.build(
                  title: _model[index].subTitle,
                  style: textStyleCustom(index),
                  textOverflow: TextOverflow.ellipsis,
                  maxLine: 2),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: TextBuilder.build(
                    title: _model[index].dateTime,
                    style: textStyleCustom(index)),
              ),
            ],
          ),
          onTap: () {
            setState(() {
              _model[index].activeRead = !_model[index].activeRead;
            });
          },
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return Divider();
      },
    );
  }
}
