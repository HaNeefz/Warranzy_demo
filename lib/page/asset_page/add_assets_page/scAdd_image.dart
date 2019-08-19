import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:warranzy_demo/models/model_repository_init_app.dart';
import 'package:warranzy_demo/tools/config/text_style.dart';
import 'package:warranzy_demo/tools/export_lib.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/button_builder.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/text_builder.dart';

import 'scAddMoreInfoAsset.dart';

class AddImage extends StatefulWidget {
  final bool hasDataAssetAlready;
  final Map<String, dynamic> dataAsset;

  AddImage({Key key, this.hasDataAssetAlready = false, this.dataAsset})
      : super(key: key);
  @override
  _AddImageState createState() => _AddImageState();
}

class _AddImageState extends State<AddImage> {
  int counterImage = 0;
  final ecsLib = getIt.get<ECSLib>();
  final allTranslations = getIt.get<GlobalTranslations>();
  final Dio dio = Dio();

  bool get hasDataAssetAlready => widget.hasDataAssetAlready == true;
  Map<String, dynamic> get dataAsset => widget.dataAsset;

  void initState() {
    super.initState();
    print(dataAsset);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: TextBuilder.build(
            title: hasDataAssetAlready ? "Edit Asset" : "New Asset",
            style: TextStyleCustom.STYLE_APPBAR),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ListView(
          children: <Widget>[
            buildHeader(),
            SizedBox(
              height: 10,
            ),
            buildImage(context),
            buildButtonAddImage(context),
            buildDetailImage(),
            RaisedButton(
              child: Text("Take a Photo"),
              onPressed: () async {
                await ecsLib.getImage().then((v) async {
                  var imageConpressed = await ecsLib.compressFile(
                      file: v,
                      targetPath: v.absolute.path,
                      minHeight: 800,
                      minWidth: 600,
                      quality: 90);
                  String imageBase64 =
                      base64Encode(imageConpressed.readAsBytesSync());
                  print("sending..");
                  FormData form = FormData.from({
                    "base64": [imageBase64, imageBase64]
                  });

                  try {
                    await dio
                        .post("192.168.0.36:9999/API/v1/User/TestLoading",
                            data: form,
                            onSendProgress: (int sent, int total) =>
                                print("$sent | $total"))
                        // await http
                        //     .post(
                        //         "http://192.168.0.36:9999/API/v1/User/TestLoading",
                        //         body: body)
                        .then((res) {
                      print(res.data);
                    }).catchError((onError) {
                      print("catchError $onError");
                    });
                  } on TimeoutException catch (_) {
                    print("TimeOut");
                  } catch (e) {
                    print("$e");
                  }
                });
              },
            ),
            RaisedButton(
              onPressed: () async {
                ecsLib.showDialogLoadingLib(context);
                try {
                  await dio
                      .get("http://192.168.0.36:9999/API/v1/User/InitialApp")
                      .then((res) {
                    ecsLib.cancelDialogLoadindLib(context);
                    var data =
                        RepositoryInitalApp.fromJson(jsonDecode(res.data));
                    // print(data.productCatagory[0].repositoryCatName.catName.eN);
                    // print(data.productCatagory[0].repositoryCatName.catName.tH);
                    var s = data.productCatagory[0].catName;
                    var temp = jsonDecode(s);
                    var catName = CatName.fromJson(temp);
                    print(catName.eN);
                    print(catName.tH);
                  });
                } catch (e) {
                  print(e);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Padding buildButtonAddImage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: ButtonBuilder.buttonCustom(
          context: context,
          label: counterImage < 10
              ? "Add Image"
              : allTranslations.text("continue"),
          paddingValue: 5,
          onPressed: () {
            setState(() {
              if (counterImage < 10)
                counterImage++;
              else {
                counterImage = 0;
                ecsLib.pushPage(
                  context: context,
                  pageWidget: AddMoreInformationAsset(
                    hasDataAssetAlready: widget.hasDataAssetAlready,
                  ),
                );
              }
            });
          }),
    );
  }

  Padding buildDetailImage() {
    return Padding(
      padding: EdgeInsets.only(top: 10, bottom: 20),
      child: TextBuilder.build(
          title:
              "There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable. If you are going to use a passage of Lorem Ipsum, you need to be sure there isn't anything embarrassing hidden in the middle of text.",
          style: TextStyleCustom.STYLE_CONTENT),
    );
  }

  Container buildImage(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 300,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(style: BorderStyle.solid)),
      child: Center(
        child: FlutterLogo(),
      ),
    );
  }

  Row buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        TextBuilder.build(
            title: "Product Photo(By Customer)",
            style: TextStyleCustom.STYLE_CONTENT),
        TextBuilder.build(title: "$counterImage/10")
      ],
    );
  }
}
