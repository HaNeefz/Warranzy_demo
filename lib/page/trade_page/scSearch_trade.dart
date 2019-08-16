import 'package:flutter/material.dart';
import 'package:warranzy_demo/tools/export_lib.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/text_builder.dart';

class SearchTrade extends StatefulWidget {
  @override
  _SearchTradeState createState() => _SearchTradeState();
}

class _SearchTradeState extends State<SearchTrade> {
  final ecsLib = getIt.get<ECSLib>();
  final allTranslations = getIt.get<GlobalTranslations>();

  TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ecsLib.dismissedKeyboard(
        context,
        child: SafeArea(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: <Widget>[
                      Flexible(
                          child: TextField(
                        controller: _textEditingController,
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.search),
                            suffixIcon: IconButton(
                              icon: Icon(Icons.close),
                              onPressed: () {
                                setState(() {
                                  _textEditingController.clear();
                                });
                              },
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 0, horizontal: 0),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(40))),
                      )),
                      SizedBox(
                        width: 5,
                      ),
                      GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: TextBuilder.build(
                              title: allTranslations.text("cancel"))),
                    ],
                  ),
                ),
                Divider()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
