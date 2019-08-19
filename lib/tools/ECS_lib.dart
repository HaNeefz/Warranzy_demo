import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:page_transition/page_transition.dart';
import 'package:warranzy_demo/tools/config/text_style.dart';
import 'package:warranzy_demo/tools/theme_color.dart';
import 'assets.dart';

class ECSLib {
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

  Future<bool> showDialogLib({
    @required BuildContext context,
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
              title,
            ),
            content: Text(content),
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
          return Container(
            margin: EdgeInsets.all(50.0),
            child: AlertDialog(
              // elevation: 20,
              backgroundColor: Colors.black.withOpacity(0.3),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              // backgroundColor: Theme.of(context).backgroundColor,
              title: Text(
                title ?? "",
                // style: normalText.copyWith(fontWeight: FontWeight.bold),
              ),
              content: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SpinKitCircle(
                      color: Colors.teal[300],
                      size: 80,
                    ),
                    SizedBox(
                      height: 40.0,
                    ),
                    Text(
                      content ?? "",
                      style: TextStyleCustom.STYLE_LABEL_BOLD
                          .copyWith(color: ThemeColors.COLOR_WHITE),
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  Future<String> showDialogWithTextFieldLib({
    @required BuildContext context,
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
              title,
              // style: normalText.copyWith(fontWeight: FontWeight.bold),
            ),
            content: TextField(
              controller: _txtController,
              maxLength: 32,
              textInputAction: TextInputAction.done,
              // style: normalText.copyWith(color: Colors.grey),
              decoration: InputDecoration(
                labelText: label,
                // labelStyle: normalText.copyWith(color: Colors.white),
                hintText: hintText,
                // hintStyle: normalText.copyWith(color: Colors.grey),
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  textOnButton,
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

  Future<bool> showDialogAction({
    @required BuildContext context,
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
              title,
              // style: normalText.copyWith(fontWeight: FontWeight.bold),
            ),
            content: Text(
              content,
              // style: normalText
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  textCancel,
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

  Future<File> getImage() async {
    var image;
    try {
      image = await ImagePicker.pickImage(source: ImageSource.camera);
    } on PlatformException catch (e) {
      print("Error $e");
    }
    return image;
  }

  Future<File> getImageFromGallery() async {
    var image;
    try {
      image = await ImagePicker.pickImage(source: ImageSource.gallery);
    } on PlatformException catch (e) {
      print("Error $e");
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
}

