import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:warranzy_demo/models/model_user.dart';
import 'package:warranzy_demo/tools/config/text_style.dart';
import 'package:warranzy_demo/tools/export_lib.dart';
import 'package:warranzy_demo/tools/widget_ui_custom/text_builder.dart';

import '../theme_color.dart';

class ImageProfile extends StatefulWidget {
  final bool hasImage;
  final String imagesMySelf;
  final ModelCustomers modelCustomer;
  final Function(Map<String, dynamic>) onContinue;

  const ImageProfile(
      {Key key,
      this.hasImage = false,
      this.imagesMySelf,
      this.modelCustomer,
      this.onContinue})
      : super(key: key);
  @override
  _ImageProfileState createState() => _ImageProfileState();
}

class _ImageProfileState extends State<ImageProfile> {
  final ecsLib = getIt.get<ECSLib>();
  final allTranslations = getIt.get<GlobalTranslations>();
  final pathAvatar = const [
    "assets/icons/avatars/A1.png",
    "assets/icons/avatars/A2.png",
    "assets/icons/avatars/A3.png",
    "assets/icons/avatars/A4.png",
    "assets/icons/avatars/A5.png",
    "assets/icons/avatars/A6.png",
    "assets/icons/avatars/A7.png",
    "assets/icons/avatars/A8.png",
    "assets/icons/avatars/A9.png",
    ""
  ];

  List<String> imageData = [];
  bool get hasImage => widget.hasImage;
  bool imageMySelf = false;
  bool selectedAvatar = true;
  String defaultImage;
  String imageBase64;

  @override
  void initState() {
    super.initState();
    if (hasImage == false)
      defaultImage = pathAvatar.elementAt(0);
    else {
      imageMySelf = true;
      if (widget.imagesMySelf.startsWith("A") == true) {
        defaultImage = "assets/icons/avatars/${widget.imagesMySelf}.png";
      } else {
        imageBase64 = widget.imagesMySelf;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextBuilder.build(
            title: hasImage == false
                ? "Choose Image profile"
                : "Edit Image profile",
            style: TextStyleCustom.STYLE_APPBAR),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[chooseImage()],
          ),
        ),
      ),
      floatingActionButton: Container(
        margin: EdgeInsets.only(left: 40),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FlatButton(
              child: Text(""),
              onPressed: () {},
            ),
            FlatButton.icon(
              icon: TextBuilder.build(title: allTranslations.text("continue")),
              label: Icon(Icons.arrow_forward_ios),
              onPressed: onContinue,
            ),
          ],
        ),
      ),
    );
  }

  Widget chooseImage() {
    return Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15.0),
            child: Align(
              alignment: Alignment.center,
              child: CircleAvatar(
                maxRadius: 100,
                child: CircleAvatar(
                  maxRadius: 95,
                  backgroundColor: Colors.white,
                  child: defaultImage != "" && imageMySelf == false
                      ? showImageAsset(defaultImage, 200, 200)
                      : imageBase64 != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(95),
                              child: showImageBase64(imageBase64, 200, 200))
                          : Icon(Icons.error, size: 50),
                ),
              ),
            ),
          ),
          showImageAvatar(),
          showImageMySelf()
        ],
      ),
    );
  }

  Future buildShowModalBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) => Container(
        height: 200,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(
                Icons.photo_library,
                size: 35,
                color: ThemeColors.COLOR_BLACK,
              ),
              title: TextBuilder.build(title: "Gallery"),
              onTap: () async {
                var _file = await ecsLib.getImageFromGallery();
                await setImage(_file);
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(
                Icons.add_a_photo,
                color: ThemeColors.COLOR_BLACK,
                size: 35,
              ),
              title: TextBuilder.build(title: "Take a photo"),
              onTap: () async {
                var _file = await ecsLib.getImage();
                await setImage(_file);
              },
            ),
          ],
        ),
      ),
    );
  }

  setImage(File image) async {
    var dir = await getTemporaryDirectory();
    if (image != null) {
      imageMySelf = true;
      selectedAvatar = false;
      var _newImage = await ecsLib.compressFile(
          file: image, targetPath: dir.path + "/${image.path.split("/").last}");

      setState(() {
        imageBase64 = base64Encode(_newImage.readAsBytesSync());
        imageData.add(imageBase64);
      });
      Navigator.pop(context);
    }
  }

  Widget showImageMySelf() {
    return Container(
      height: 100,
      child: ListView(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        children: imageData.map((v) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 5),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  imageBase64 = v;
                  defaultImage = "";
                  imageMySelf = true;
                });
              },
              child: CircleAvatar(
                radius: 45,
                backgroundColor: v == imageBase64 ? Colors.teal : Colors.white,
                child: CircleAvatar(
                  radius: 40,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(60),
                      child: showImageBase64(v)),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget showImageAvatar() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GridView.builder(
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: pathAvatar.length ?? 0,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
              onTap: () {
                imageMySelf = false;
                selectedAvatar = true;
                imageBase64 = "";
                setState(() => defaultImage = pathAvatar[index]);
              },
              child: pathAvatar[index] != ""
                  ? CircleAvatar(
                      radius: 50,
                      backgroundColor: defaultImage == pathAvatar[index]
                          ? Colors.teal
                          : Colors.white,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: showImageAsset(pathAvatar[index]),
                      ),
                    )
                  : GestureDetector(
                      onTap: () async {
                        defaultImage = "";
                        await buildShowModalBottomSheet(context);
                      },
                      child: CircleAvatar(
                        radius: 30,
                        child: Icon(Icons.add, size: 50),
                      ),
                    ));
        },
      ),
    );
  }

  Widget showImageBase64(data, [double width = 80, double height = 80]) {
    return data != null
        ? Image.memory(
            base64Decode(data),
            width: width,
            height: height,
            fit: BoxFit.cover,
          )
        : Icon(Icons.error, size: 80);
  }

  Widget showImageAsset(data, [double width = 80, double height = 80]) {
    return data != null
        ? Image.asset(
            data,
            width: width,
            height: height,
            fit: BoxFit.cover,
          )
        : Icon(
            Icons.error,
            size: 80,
          );
  }

  onSkip() {}
  onContinue() async {
    var body = {
      "CustUserID": widget?.modelCustomer?.custUserID ?? "",
      "StatusImage": imageMySelf == true ? "Y" : "N",
      "ImageProfile": imageMySelf == true
          ? imageBase64
          : defaultImage.split("/").last.substring(0, 2)
    };
    if (widget.onContinue != null) {
      widget.onContinue(body);
    } else {
      print("onTap");
      print(body);
    }
  }

  sendAPIEdit() {}
}
