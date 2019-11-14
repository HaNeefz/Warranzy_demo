import 'package:flutter/material.dart';
import 'package:warranzy_demo/models/model_repository_init_app.dart';
import 'package:warranzy_demo/services/sqflit/db_initial_app.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/pin_code_ui_widget.dart';

class TestCategory extends StatefulWidget {
  @override
  _TestCategoryState createState() => _TestCategoryState();
}

class _TestCategoryState extends State<TestCategory> {
  List<Map<String, dynamic>> subCat = [];

  List<String> path = [
    "assets/icons/icons_category/A000.png",
    "assets/icons/icons_category/B000.png",
    "assets/icons/icons_category/C000.png",
    "assets/icons/icons_category/D000.png",
    "assets/icons/icons_category/G000.png",
    "assets/icons/icons_category/A001.png",
    "assets/icons/icons_category/A002.png",
    "assets/icons/icons_category/A003.png",
    "assets/icons/icons_category/A004.png",
    "assets/icons/icons_category/A005.png",
    "assets/icons/icons_category/A006.png",
    "assets/icons/icons_category/A007.png",
    "assets/icons/icons_category/A008.png",
    "assets/icons/icons_category/A009.png",
    "assets/icons/icons_category/A010.png",
    "assets/icons/icons_category/A011.png",
    "assets/icons/icons_category/A012.png",
    "assets/icons/icons_category/A013.png",
    "assets/icons/icons_category/A014.png",
    "assets/icons/icons_category/A015.png",
    "assets/icons/icons_category/A016.png",
    "assets/icons/icons_category/A017.png",
    "assets/icons/icons_category/A018.png",
    "assets/icons/icons_category/A019.png",
    "assets/icons/icons_category/A020.png",
    "assets/icons/icons_category/A998.png",
    "assets/icons/icons_category/A999.png",
    "assets/icons/icons_category/B001.png",
    "assets/icons/icons_category/B002.png",
    "assets/icons/icons_category/B003.png",
    "assets/icons/icons_category/B004.png",
    "assets/icons/icons_category/B005.png",
    "assets/icons/icons_category/B006.png",
    "assets/icons/icons_category/B007.png",
    "assets/icons/icons_category/B008.png",
    "assets/icons/icons_category/B009.png",
    "assets/icons/icons_category/B010.png",
    "assets/icons/icons_category/B011.png",
    "assets/icons/icons_category/B012.png",
    "assets/icons/icons_category/B013.png",
    "assets/icons/icons_category/C001.png",
    "assets/icons/icons_category/C002.png",
    "assets/icons/icons_category/C003.png",
    "assets/icons/icons_category/C004.png",
    "assets/icons/icons_category/C005.png",
    "assets/icons/icons_category/C006.png",
    "assets/icons/icons_category/C007.png",
    "assets/icons/icons_category/C008.png",
    "assets/icons/icons_category/C009.png",
    "assets/icons/icons_category/C010.png",
    "assets/icons/icons_category/D001.png",
    "assets/icons/icons_category/D002.png",
    'assets/icons/icons_category/D003.png',
    "assets/icons/icons_category/D004.png",
    "assets/icons/icons_category/D005.png",
    "assets/icons/icons_category/D006.png",
    "assets/icons/icons_category/D007.png",
    "assets/icons/icons_category/D008.png",
    "assets/icons/icons_category/D009.png",
    "assets/icons/icons_category/D010.png"
  ];

  Future<List<Map<String, dynamic>>> tempSubCat;
  Future<List<Map<String, dynamic>>> getSubCat() async {
    return await DBProviderInitialApp.db.getAllSubCategoryTypeListMap();
  }

  @override
  void initState() {
    super.initState();
    // tempSubCat = getSubCat();
    print("image length : ${path.length}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Test Render ImageAsset"),
      ),
      body: SingleChildScrollView(
        child:
            //     Column(
            //   children: <Widget>[
            //     PinCodeUI(
            //       usedFingerPrintORFaceID: false,
            //       pinCorrect: "111111",
            //       pinAmout: 6,
            //       padding: 50,
            //       onCheckPIN: true,
            //       pinOnCorrect: (correct, pin) {
            //         print(correct);
            //         print(pin);
            //       },
            //       onFullPIN: (fullPin) {
            //         print("full $fullPin");
            //       },
            //     ),
            //   ],
            // )
            Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: List.generate(10, (i) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text("${i + 1}"),
                      ImageClassVirwer(path: path[i]),
                      // ImageView.show(path: path[i]),
                    ],
                  );
                }).toList()),
        // FutureBuilder(
        //   future: tempSubCat,
        //   builder: (BuildContext context,
        //       AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
        //     if (snapshot.connectionState == ConnectionState.waiting) {
        //       return CircularProgressIndicator();
        //     } else {
        //       if (snapshot.data.isNotEmpty) {
        //         return Column(
        //           children: snapshot.data.map((v) {
        //             return Column(
        //               children: <Widget>[
        //                 Text("${v['CatCode']}"),
        //                 Image.asset(
        //                   "${v['Logo']}",
        //                   fit: BoxFit.contain,
        //                   width: 50,
        //                   height: 50,
        //                 )
        //               ],
        //             );
        //           }).toList(),
        //         );
        //       } else
        //         return Text('Something wrong!.');
        //     }
        //   },
        // ),
      ),
    );
  }
}

class ImageClassVirwer extends StatelessWidget {
  final String path;

  const ImageClassVirwer({Key key, this.path}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      path,
      fit: BoxFit.contain,
      width: 100,
      height: 100,
    );
  }
}

class ImageView {
  static Widget show({String path}) {
    return path != null
        ? Image.asset(
            path,
            fit: BoxFit.contain,
            width: 20,
            height: 20,
          )
        : Icon(Icons.error);
  }
}
