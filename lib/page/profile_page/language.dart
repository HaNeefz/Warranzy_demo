import 'package:flutter/material.dart';
import 'package:warranzy_demo/models/model_language.dart';
import 'package:warranzy_demo/services/sqflit/db_language.dart';
import 'package:warranzy_demo/tools/assets.dart';
import 'package:warranzy_demo/tools/config/text_style.dart';
import 'package:warranzy_demo/tools/export_lib.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/text_builder.dart';

class LanguagePage extends StatefulWidget {
  LanguagePage({Key key}) : super(key: key);

  @override
  _LanguagePageState createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  final ecsLib = getIt.get<ECSLib>();
  final allTranslations = getIt.get<GlobalTranslations>();

  ModelLanguage listLanguage;

  Map<String, dynamic> dataLang = {
    "langEN": {"Name": "English", "Prefix": "en"},
    "langTH": {"Name": "ภาษาไทย", "Prefix": "th"}
  };

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: TextBuilder.build(
                title: "Language", style: TextStyleCustom.STYLE_APPBAR)),
        body: Container(
          margin: EdgeInsets.all(10),
          child: ListView(
            children: <Widget>[
              listTile(
                pathImage: Assets.LOGO_ENG_LANGUAGE,
                title: dataLang['langEN']["Name"],
                prefix: dataLang['langEN']["Prefix"],
              ),
              Divider(),
              listTile(
                pathImage: Assets.LOGO_THAI_LANGUAGE,
                title: dataLang['langTH']["Name"],
                prefix: dataLang['langTH']["Prefix"],
              )
            ],
          ),
        ));
  }

  Widget listTile(
      {String pathImage, String title, String prefix, Function onTap}) {
    return Container(
      // height: 100,
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: AssetImage("$pathImage"),
          radius: 25,
        ),
        title: TextBuilder.build(title: title ?? ""),
        trailing: checkCurrentLang(prefix),
        onTap: () => onChangeLanguage(title, prefix),
      ),
    );
  }

  Widget checkCurrentLang(String prefix) {
    if (allTranslations.currentLanguage == prefix) {
      return Icon(Icons.check);
    } else
      return Text("");
  }

  onChangeLanguage(String lang, String prefix) async {
    if (allTranslations.currentLanguage == prefix) {
      showAlert(content: "This language is currently used.");
    } else {
      showAlertAction(content: "Are you sure to change language.")
          .then((onClick) async {
        if (onClick == true) {
          ModelLanguage listLanguage = ModelLanguage()
            ..id = 1
            ..name = lang
            ..prefix = prefix;
          await DBProviderLanguage.db
              .rawUpdateLanguage(listLanguage)
              .then((success) {
            if (success == true) {
              allTranslations.setNewLanguage("$prefix", true);
              setState(() {});
              showAlert(content: "Changed language.");
            } else {
              showAlert(content: "Can't Change language.");
            }
          });
        }
      });
    }
  }

  showAlert({String title, String content}) {
    ecsLib.showDialogLib(context,
        title: title ?? "CHANGE LANGUAGE",
        content: content ?? "",
        textOnButton: allTranslations.text("close"));
  }

  Future<bool> showAlertAction({String title, String content}) {
    return ecsLib.showDialogAction(context,
        title: title ?? "CHANGE LANGUAGE",
        content: content ?? "",
        textOk: allTranslations.text("ok"),
        textCancel: allTranslations.text("cancel"));
  }
}
