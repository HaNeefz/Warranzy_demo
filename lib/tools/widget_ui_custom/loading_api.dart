import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:warranzy_demo/tools/config/text_style.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/text_builder.dart';

import '../assets.dart';

class LoadingApi extends StatelessWidget {
  final String loadingMessage;
  const LoadingApi({Key key, this.loadingMessage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          // color: Colors.black54,
        ),
        Align(
          alignment: Alignment.center,
          child: HeartbeatProgressIndicator(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Image.asset(
                  Assets.LOGO_APP_LOADING,
                  scale: 0.2,
                  width: 80,
                  height: 80,
                ),
                Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: TextBuilder.build(
                      title: "${loadingMessage ?? ""}",
                      style: TextStyleCustom.STYLE_LABEL_BOLD
                          .copyWith(color: Colors.white, fontSize: 12),
                    ))
              ],
            ),
          ),
        )
      ],
    );
  }
}
