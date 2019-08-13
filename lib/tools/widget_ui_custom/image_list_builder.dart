import 'dart:io';

import 'package:flutter/material.dart';
import 'package:extended_image/extended_image.dart';
import 'package:provider/provider.dart';
import 'package:warranzy_demo/services/providers/provier_image.dart';
import 'package:warranzy_demo/tools/config/text_style.dart';
import 'package:warranzy_demo/tools/export_lib.dart';
import '../theme_color.dart';

final ecsLib = getIt.get<ECSLib>();

class ImageListBuilder {
  static Widget build(
      {@required BuildContext context,
      @required List<File> filePath,
      bool editAble = false,
      double cornerRadius = 20.0,
      String heroTag = "",
      Function onPressed}) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 2,
      margin: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
          border: null, borderRadius: BorderRadius.circular(20.0)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: filePath.length ?? 0,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(TransparentMaterialPageRoute(
                      fullscreenDialog: true,
                      builder: (BuildContext context) => PhotoViewPage(
                            image: filePath,
                            heroTag: "${heroTag}image$index",
                            currentIndex: index,
                          )));
                },
                child: Stack(
                  children: <Widget>[
                    Hero(
                        tag: "${heroTag}image$index",
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(cornerRadius),
                          child: ecsLib.modelImageFile(
                            file: filePath[index],
                          ),
                        )),
                    editAble == true ? numberImage(index + 1) : Container(),
                    editAble == true
                        ? removeImage(context, index)
                        : Container(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class ImageEditable extends StatefulWidget {
  @override
  _ImageEditableState createState() => _ImageEditableState();
}

class _ImageEditableState extends State<ImageEditable> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

Positioned removeImage(BuildContext context, int index) {
  final imageState = Provider.of<ImageDataState>(context);
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
        onPressed: () {
          imageState.remove = index;
          // Provider.of<ImageDataProvider>(context).remove(index);
        }),
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
  final List<File> image;
  final String heroTag;
  int currentIndex;
  PhotoViewPage({
    Key key,
    this.image,
    this.heroTag,
    this.currentIndex,
  }) : super(key: key);
  @override
  _PhotoViewPageState createState() => _PhotoViewPageState();
}

class _PhotoViewPageState extends State<PhotoViewPage> {
  PageController _pageController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageController = PageController(
      initialPage: widget.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Container(
            child: buildImageList(context),
          ),
        ));
  }

  Widget buildImageList(BuildContext context) {
    return Stack(children: <Widget>[
      ExtendedImageGesturePageView.builder(
        controller: _pageController,
        scrollDirection: Axis.horizontal,
        itemCount: widget.image.length,
        onPageChanged: (i) {
          setState(() {
            widget.currentIndex = i;
          });
        },
        itemBuilder: (BuildContext context, int index) {
          return Stack(
            children: <Widget>[
              buildHeroImage(context, index),
              buildBtClose(context),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 80.0,
                  child: Center(
                      child: Text(
                    "${widget.currentIndex + 1}/${widget.image.length}",
                    style: TextStyleCustom.STYLE_LABEL_BOLD,
                  )),
                ),
              ),
            ],
          );
        },
      ),
    ]);
  }

  Widget buildHeroImage(BuildContext context, int index) {
    return Hero(
        tag: widget.heroTag,
        child: ExtendedImageSlidePage(
          child: ExtendedImage.file(
            widget.image[index],
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

class PageViewImage extends StatefulWidget {
  PageViewImage({Key key}) : super(key: key);

  _PageViewImageState createState() => _PageViewImageState();
}

class _PageViewImageState extends State<PageViewImage> {
  @override
  Widget build(BuildContext context) {
    return PageView();
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
