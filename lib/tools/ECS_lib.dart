import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:warranzy_demo/tools/config/text_style.dart';
import 'package:warranzy_demo/tools/export_lib.dart';
import 'package:warranzy_demo/tools/theme_color.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/text_builder.dart';
import 'assets.dart';
import 'widget_ui_custom/button_builder.dart';

class ECSLib {
  final allTranslations = GlobalTranslations();
  Widget logoApp({double width = 300, double height = 300}) {
    return Image.asset(
      Assets.ICON_APP_TRANSPARENT,
      width: width,
      height: height,
    );
  }

  Future pushPage(
      {@required BuildContext context, @required Widget pageWidget}) async {
    final result = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) => pageWidget));
    return result;
  }

  Future pushPageWithAninamtion(
      {@required BuildContext context,
      @required Widget pageWidget,
      @required PageTransitionType animationType}) async {
    final result = await Navigator.of(context)
        .push(PageTransition(type: animationType, child: pageWidget));
    return result;
  }

  Future pushPageReplacement(
      {@required BuildContext context, @required Widget pageWidget}) async {
    final response = await Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (BuildContext context) => pageWidget));
    return response;
  }

  Future pushPageReplacementWithAninamtion(
      {@required BuildContext context,
      @required Widget pageWidget,
      @required PageTransitionType animationType}) async {
    final result = await Navigator.of(context)
        .push(PageTransition(type: animationType, child: pageWidget));
    return result;
  }

  Future pushPageAndClearAllScene(
      {@required BuildContext context, @required Widget pageWidget}) async {
    final response = await Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (BuildContext context) => pageWidget),
        ModalRoute.withName('/'));
    return response;
  }

  Future pushPageAndClearAllSceneWithAninamtion(
      {@required BuildContext context,
      @required Widget pageWidget,
      @required PageTransitionType animationType}) async {
    final response = await Navigator.of(context).pushAndRemoveUntil(
        PageTransition(type: animationType, child: pageWidget),
        ModalRoute.withName('/'));
    return response;
  }

  void printJson(Map json) {
    if (json is Map && json != null) {
      JsonEncoder encoder = JsonEncoder.withIndent(" ");
      String prettyprint = encoder.convert(json);
      print(prettyprint);
    } else {
      print("Empty data or Data not match format.");
    }
  }

  Future<bool> showDialogLib(
    BuildContext context, {
    @required String title,
    @required String content,
    @required String textOnButton,
    bool barrierDismissible = false,
  }) async {
    final bool response = await showDialog(
        barrierDismissible: barrierDismissible,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            elevation: 20,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            // backgroundColor: Theme.of(context).backgroundColor,
            title: Text(
              title ?? "",
            ),
            content: Text(content ?? ""),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  textOnButton ?? "",
                ),
                onPressed: () {
                  Navigator.pop(context, true);
                },
              )
            ],
          );
        });
    return response;
  }

  void cancelDialogLoadindLib(BuildContext context) {
    Navigator.pop(context);
  }

  void showDialogLoadingLib(BuildContext context,
      {String title, String content, bool barrierDismissible = true}) {
    showDialog(
        context: context,
        barrierDismissible: barrierDismissible,
        builder: (BuildContext context) {
          return DialogCustom(
            title: title,
            description: content,
          );
          // Center(
          //   child: Column(
          //     mainAxisSize: MainAxisSize.min,
          //     children: <Widget>[
          //       Text(
          //         title ?? "",
          //         style: TextStyleCustom.STYLE_LABEL_BOLD
          //             .copyWith(color: ThemeColors.COLOR_WHITE),
          //         textAlign: TextAlign.center,
          //       ),
          //       HeartbeatProgressIndicator(
          //         child: Image.asset(
          //           Assets.LOGO_APP_LOADING,
          //           scale: 0.2,
          //           width: 80,
          //           height: 80,
          //         ),
          //       ),
          //       Text(
          //         content ?? "",
          //         style: TextStyleCustom.STYLE_LABEL_BOLD
          //             .copyWith(color: ThemeColors.COLOR_WHITE),
          //         textAlign: TextAlign.center,
          //       ),
          //     ],
          //   ),
          // );
        });
  }

  Future<String> showDialogWithTextFieldLib(
    BuildContext context, {
    @required String title,
    @required String label,
    @required String hintText,
    @required String textOnButton,
  }) async {
    TextEditingController _txtController = TextEditingController();

    var res = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            elevation: 20,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            // backgroundColor: Theme.of(context).backgroundColor,
            title: Text(
              title ?? "",
              // style: normalText.copyWith(fontWeight: FontWeight.bold),
            ),
            content: TextField(
              controller: _txtController,
              maxLength: 32,
              textInputAction: TextInputAction.done,
              // style: normalText.copyWith(color: Colors.grey),
              decoration: InputDecoration(
                labelText: label ?? "",
                // labelStyle: normalText.copyWith(color: Colors.white),
                hintText: hintText ?? "",
                // hintStyle: normalText.copyWith(color: Colors.grey),
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  textOnButton ?? "",
                  // style: normalText,
                ),
                onPressed: () {
                  Navigator.pop(context, "${_txtController.text}");
                },
              )
            ],
          );
        });
    return res;
  }

  Future<bool> showDialogAction(
    BuildContext context, {
    @required String title,
    @required String content,
    @required String textCancel,
    @required String textOk,
    bool barrierDismissible = false,
  }) async {
    bool res = await showDialog(
        barrierDismissible: barrierDismissible,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            elevation: 20,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            // backgroundColor: Theme.of(context).backgroundColor,
            title: Text(
              title ?? "",
              // style: normalText.copyWith(fontWeight: FontWeight.bold),
            ),
            content: Text(
              content ?? "",
              // style: normalText
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  textCancel ?? "",
                  // style: normalText,
                ),
                onPressed: () {
                  Navigator.pop(context, false);
                },
              ),
              FlatButton(
                child: Text(
                  textOk,
                  // style: normalText,
                ),
                onPressed: () {
                  Navigator.pop(context, true);
                },
              )
            ],
          );
        });
    return res;
  }

  Widget _buttonAlert(BuildContext context,
      {String label, Function onPressed, Color colors}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: ButtonBuilder.buttonCustom(
        context: context,
        label: label,
        paddingValue: 5,
        labelStyle: TextStyleCustom.STYLE_LABEL_BOLD
            .copyWith(color: ThemeColors.COLOR_WHITE),
        colorsButton: colors,
        onPressed: onPressed,
      ),
    );
  }

  Future<String> showDialogTripleAction(
    BuildContext context, {
    String title,
    @required String content,
    @required String labelFisrt,
    @required String labelSecond,
    @required String labelThird,
    Color colorFirst,
    Color colorSecond,
    Color colorThird,
    bool barrierDismissible = false,
  }) async {
    String res = await showDialog(
        barrierDismissible: barrierDismissible,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              elevation: 20,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              title: Text(
                title ?? "Warranzy",
                // style: normalText.copyWith(fontWeight: FontWeight.bold),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(content ?? ""),
                  SizedBox(height: 20),
                  _buttonAlert(context,
                      label: labelFisrt,
                      colors: colorFirst ?? Colors.teal[200],
                      onPressed: () => Navigator.pop(context, "F")),
                  _buttonAlert(context,
                      label: labelSecond,
                      colors: colorSecond ?? Colors.blue[200],
                      onPressed: () => Navigator.pop(context, "S")),
                  _buttonAlert(context,
                      label: labelThird,
                      colors: colorThird ?? Colors.red[200],
                      onPressed: () => Navigator.pop(context, "T")),
                ],
              ));
        });
    return res;
  }

  Future<dynamic> showDialogConnectApi(context,
      {@required Widget child,
      title,
      content,
      bool barrierDismissible = true}) async {
    var res = await showDialog(
        context: context,
        barrierDismissible: barrierDismissible,
        builder: (context) => DialogCustoms(
              child: child,
            ));
    print(res);
    return res;
  }

  alertDialogSucces(context, msg) {
    return AlertDialog(
      title: TextBuilder.build(
          title: "Warranzy", style: TextStyleCustom.STYLE_LABEL_BOLD),
      content: TextBuilder.build(title: msg ?? ""),
      actions: <Widget>[
        FlatButton(
          child: TextBuilder.build(title: allTranslations.text("close")),
          onPressed: () {
            Navigator.pop(context, true);
          },
        )
      ],
    );
  }

  alertDialogError(context, msg) {
    return AlertDialog(
      title: TextBuilder.build(
          title: "Warranzy", style: TextStyleCustom.STYLE_LABEL_BOLD),
      content: TextBuilder.build(title: msg ?? ""),
      actions: <Widget>[
        FlatButton(
          child: TextBuilder.build(title: allTranslations.text("close")),
          onPressed: () {
            Navigator.pop(context, false);
          },
        )
      ],
    );
  }

  Widget loadingLogoWarranzy() {
    return Center(
      child: HeartbeatProgressIndicator(
        child: Image.asset(
          Assets.LOGO_APP_LOADING,
          scale: 0.2,
          width: 80,
          height: 80,
        ),
      ),
    );
  }

  Future<File> getImage() async {
    var image;
    try {
      image = await ImagePicker.pickImage(source: ImageSource.camera);
    } on PlatformException catch (e) {
      print("Error $e");
      image = null;
    }
    return image;
  }

  Future<File> getImageFromGallery() async {
    var image;
    try {
      image = await ImagePicker.pickImage(source: ImageSource.gallery);
    } on PlatformException catch (e) {
      print("Error $e");
      image = null;
    }
    return image;
  }

  bool overLimitPhoto({int amount}) {
    const int LIMIT = 4;
    if (amount < LIMIT) {
      return false;
    } else {
      return true;
    }
  }

  Widget dismissedKeyboard(BuildContext context, {Widget child}) {
    return GestureDetector(
      onTap: () => // FocusScope.of(context).unfocus();
          FocusScope.of(context).requestFocus(new FocusNode()),
      child: child,
    );
  }

  Widget modelImageFile({@required File file, BoxFit fit = BoxFit.cover}) {
    if (file != null) {
      return Image.file(
        file,
        fit: fit,
        filterQuality: FilterQuality.high,
      );
    } else {
      return Container(
        child: Center(
          child: Text("File empty."),
        ),
      );
    }
  }

  Widget modelImageUint8List(
      {@required Uint8List file, BoxFit fit = BoxFit.cover}) {
    if (file != null) {
      return Image.memory(
        file,
        fit: fit,
        filterQuality: FilterQuality.high,
      );
    } else {
      return Container(
        child: Center(
          child: Text("File empty."),
        ),
      );
    }
  }

  Future<File> compressFile(
      {@required File file,
      @required String targetPath,
      int quality = 60,
      int minWidth = 800,
      int minHeight = 600,
      int rotate = 0}) async {
    var result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path, targetPath,
        quality: quality,
        minWidth: minWidth,
        minHeight: minHeight,
        rotate: rotate);

    print("Image file Original : " + "${file.lengthSync()}");
    print("Image file Compress : " + "${result.lengthSync()}");
    return result;
  }

  String setDateFormat(DateTime dateTime, [formate = "yyyy-MM-dd HH:mm:ss"]) {
    DateFormat _format = DateFormat(formate);
    return _format.format(dateTime);
  }

  stepBackScene(BuildContext context, int step) {
    for (var i = 0; i < step; i++) {
      Navigator.of(context).pop();
    }
  }
}

class DialogCustoms extends StatelessWidget {
  final Widget child;

  DialogCustoms({Key key, this.child}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        child: child);
  }
}

class DialogCustom extends StatelessWidget {
  final String title;
  final String description;
  final String buttonText;
  final Widget child;

  DialogCustom(
      {Key key, this.title, this.description, this.buttonText, this.child})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            title ?? "",
            style: TextStyleCustom.STYLE_LABEL_BOLD
                .copyWith(color: ThemeColors.COLOR_WHITE),
            textAlign: TextAlign.center,
          ),
          HeartbeatProgressIndicator(
            child: Image.asset(
              Assets.LOGO_APP_LOADING,
              scale: 0.2,
              width: 80,
              height: 80,
            ),
          ),
          // SpinKitCircle(
          //   color: Colors.teal[300],
          //   size: 80,
          // ),
          SizedBox(
            height: 40.0,
          ),
          child ?? Container(),
          Text(
            description ?? "",
            style: TextStyleCustom.STYLE_LABEL_BOLD
                .copyWith(color: ThemeColors.COLOR_WHITE),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
