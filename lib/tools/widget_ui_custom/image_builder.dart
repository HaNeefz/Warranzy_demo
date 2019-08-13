import 'dart:io';

import 'package:flutter/material.dart';
import 'package:extended_image/extended_image.dart';
import 'package:warranzy_demo/tools/config/text_style.dart';
import 'package:warranzy_demo/tools/export_lib.dart';
import '../theme_color.dart';

final ecsLib = getIt.get<ECSLib>();

class ImageBuilder {
  static Widget build(
      {@required BuildContext context,
      @required File filePath,
      int index,
      bool editAble = false,
      double cornerRadius = 20.0,
      String heroTag = "",
      Function onPressed}) {
    return GestureDetector(
      onTap: () {
        // Navigator.of(context).push(ScaleRoute(
        //     page: PhotoViewPage(
        //   image: filePath,
        //   heroTag: "${heroTag}image$index",
        // )));
        Navigator.of(context).push(TransparentMaterialPageRoute(
            fullscreenDialog: true,
            builder: (BuildContext context) => PhotoViewPage(
                  image: filePath,
                  heroTag: "${heroTag}image$index",
                )));
        // ecsLib.pushPage(
        //     context: context,
        //     pageWidget: PhotoViewPage(
        //       image: filePath,
        //       heroTag: "${heroTag}image$index",
        //     ));
      },
      child: Stack(
        children: <Widget>[
          Hero(
              tag: "${heroTag}image$index",
              child: ClipRRect(
                borderRadius: BorderRadius.circular(cornerRadius),
                child: ecsLib.modelImageFile(
                  file: filePath,
                ),
              )),
          editAble == true ? numberImage(index) : Container(),
          editAble == true ? removeImage(onPressed) : Container(),
        ],
      ),
    );
  }
}

Positioned removeImage(Function onPressed) {
  return Positioned(
    bottom: 0.0,
    right: 0.0,
    child: IconButton(
        icon: CircleAvatar(
          backgroundColor: Colors.black,
          child: Icon(
            Icons.close,
            color: ThemeColors.COLOR_TEXT_ICON_WHITE,
          ),
        ),
        onPressed: onPressed),
  );
}

Positioned numberImage(int index) {
  return Positioned(
    top: 5.0,
    left: 5.0,
    child: SizedBox(
      width: 35.0,
      height: 35.0,
      child: CircleAvatar(
        backgroundColor: ThemeColors.COLOR_BLACK,
        child: Text(
          "$index",
          style: TextStyleCustom.STYLE_LABEL,
        ),
      ),
    ),
  );
}

class PhotoViewPage extends StatefulWidget {
  final File image;
  final String heroTag;
  PhotoViewPage({
    Key key,
    this.image,
    this.heroTag,
  }) : super(key: key);
  @override
  _PhotoViewPageState createState() => _PhotoViewPageState();
}

class _PhotoViewPageState extends State<PhotoViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   automaticallyImplyLeading: false,
        //   elevation: 0.0,
        //   backgroundColor: Colors.transparent,
        //   actions: <Widget>[
        //     IconButton(
        //       icon: Icon(
        //         Icons.close,
        //         color: Colors.white,
        //       ),
        //       onPressed: () {
        //         Navigator.pop(context);
        //       },
        //     ),
        //   ],
        // ),
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Container(
            // width: MediaQuery.of(context).size.width,
            // height: MediaQuery.of(context).size.height,
            child: buildHero(context),
            // Stack(fit: StackFit.expand, children: <Widget>[
            //   PhotoView(
            //     imageProvider: FileImage(widget.image),
            //     heroTag: widget.heroTag,
            //     maxScale: PhotoViewComputedScale.covered * 2,
            //     minScale: PhotoViewComputedScale.contained * 0.8,
            //     backgroundDecoration: BoxDecoration(color: Colors.transparent),
            //     transitionOnUserGestures: true,
            //     loadingChild: Center(child: CircularProgressIndicator()),
            //   ),
            // ]),
          ),
        ));
  }

  Widget buildHero(BuildContext context) {
    return Stack(
      children: <Widget>[
        buildHeroImage(context),
        buildBtClose(context),
      ],
    );
  }

  Hero buildHeroImage(BuildContext context) {
    return Hero(
        tag: widget.heroTag,
        child: ExtendedImageSlidePage(
          child: ExtendedImage.file(
            widget.image,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            enableSlideOutPage: true,
            mode: ExtendedImageMode.Gesture,
            filterQuality: FilterQuality.high,
            fit: BoxFit.contain,
            clearMemoryCacheIfFailed: true,
            enableMemoryCache: true,
          ), //Image.file(widget.image),
          slideAxis: SlideAxis.vertical,
          slideType: SlideType.onlyImage,
          resetPageDuration: Duration(milliseconds: 300),
        ));
  }

  Padding buildBtClose(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: Alignment.topRight,
        child: Container(
          width: 40.0,
          height: 40.0,
          decoration: BoxDecoration(shape: BoxShape.circle, color: ThemeColors.COLOR_BLACK),
          child: Center(
            child: IconButton(
              icon: Icon(
                Icons.close,
                color: ThemeColors.COLOR_THEME_APP,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
      ),
    );
  }
}

// ExtendedImageSlidePage(
//     child: Hero(
//       tag: "${heroTag}image$index",
//       child: ExtendedImage.file(
//         filePath,
//         enableSlideOutPage: true,
//         mode: ExtendedImageMode.Gesture,
//       ),
//     ), //Image.file(widget.image),
//     slideAxis: SlideAxis.both,
//     slideType: SlideType.onlyImage,
//     resetPageDuration: Duration(milliseconds: 300))
