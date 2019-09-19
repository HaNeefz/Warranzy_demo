import 'dart:io';

import 'package:flutter/material.dart';
import 'package:extended_image/extended_image.dart';
import 'package:provider/provider.dart';
import 'package:warranzy_demo/services/providers/provier_image.dart';
import 'package:warranzy_demo/tools/config/text_style.dart';
import 'package:warranzy_demo/tools/export_lib.dart';
import '../theme_color.dart';

class ImageListBuilder {
  static final _ecsLib = getIt.get<ECSLib>();
  static Widget build(
      {@required BuildContext context,
      @required List imageData,
      bool editAble = false,
      double cornerRadius = 20.0,
      int crossAxisCount = 3,
      String heroTag = "",
      Function(int) onClicked}) {
    return Container(
      // width: MediaQuery.of(context).size.width,
      // height: MediaQuery.of(context).size.height / 2,
      // margin: EdgeInsets.symmetric(vertical: 8),
      // decoration: BoxDecoration(
      // color: Colors.red,
      //     border: null, borderRadius: BorderRadius.circular(20.0)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 0,
            mainAxisSpacing: 5,
          ),
          // scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: imageData.length ?? 0,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(TransparentMaterialPageRoute(
                    fullscreenDialog: true,
                    builder: (BuildContext context) => PhotoViewPage(
                          image: imageData,
                          heroTag: "${heroTag}image$index",
                          currentIndex: index,
                        )));
              },
              child: Stack(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.all(8),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Hero(
                        tag: "${heroTag}image$index",
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(cornerRadius),
                          child: imageData is List<File>
                              ? _ecsLib.modelImageFile(
                                  file: imageData[index],
                                )
                              : _ecsLib.modelImageUint8List(
                                  file: imageData[index], fit: BoxFit.cover),
                        )),
                  ),
                  // removeImageTest(index, onClicked),
                  editAble == true
                      ? Positioned(
                          top: 0.0,
                          right: 0.0,
                          child: IconButton(
                              icon: CircleAvatar(
                                backgroundColor: Colors.black,
                                child: Icon(
                                  Icons.close,
                                  color: ThemeColors.COLOR_TEXT_ICON_WHITE,
                                ),
                              ),
                              onPressed: () => onClicked(index)),
                        )
                      : Container(),
                  // editAble == true ? numberImage(index + 1) : Container(),
                  // editAble == true ? removeImage(context, index) : Container(),
                ],
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
  final List image;
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
          child: widget.image is List<File>
              ? ExtendedImage.file(
                  widget.image[index],
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  enableSlideOutPage: true,
                  mode: ExtendedImageMode.gesture,
                  filterQuality: FilterQuality.high,
                  fit: BoxFit.contain,
                  clearMemoryCacheIfFailed: true,
                  enableMemoryCache: true,
                  initGestureConfigHandler: (state) {
                    return GestureConfig(
                        minScale: 0.9,
                        animationMinScale: 0.7,
                        maxScale: 3.0,
                        animationMaxScale: 3.5,
                        speed: 1.0,
                        initialScale: 1.0,
                        inertialSpeed: 100,
                        inPageView: false);
                  },
                  // initEditorConfigHandler: (state) {
                  //   return EditorConfig(
                  //     maxScale: 8.0,
                  //     cropRectPadding: EdgeInsets.all(20.0),
                  //     hitTestSize: 20.0,
                  //   );
                  // },
                )
              : widget.image is List<String>
                  ? ExtendedImage.network(
                      widget.image[index],
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      enableSlideOutPage: true,
                      mode: ExtendedImageMode.gesture,
                      filterQuality: FilterQuality.high,
                      fit: BoxFit.contain,
                      clearMemoryCacheIfFailed: true,
                      enableMemoryCache: true,
                      initGestureConfigHandler: (state) {
                        return GestureConfig(
                            minScale: 0.9,
                            animationMinScale: 0.7,
                            maxScale: 3.0,
                            animationMaxScale: 3.5,
                            speed: 1.0,
                            initialScale: 1.0,
                            inertialSpeed: 100,
                            inPageView: false);
                      },
                      // initEditorConfigHandler: (state) {
                      //   return EditorConfig(
                      //     maxScale: 8.0,
                      //     cropRectPadding: EdgeInsets.all(20.0),
                      //     hitTestSize: 20.0,
                      //   );
                      // },
                    )
                  : ExtendedImage.memory(
                      widget.image[index],
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      enableSlideOutPage: true,
                      mode: ExtendedImageMode.gesture,
                      filterQuality: FilterQuality.high,
                      fit: BoxFit.contain,
                      clearMemoryCacheIfFailed: true,
                      enableMemoryCache: true,
                      initGestureConfigHandler: (state) {
                        return GestureConfig(
                            minScale: 0.9,
                            animationMinScale: 0.7,
                            maxScale: 3.0,
                            animationMaxScale: 3.5,
                            speed: 1.0,
                            initialScale: 1.0,
                            inertialSpeed: 100,
                            inPageView: false);
                      },
                      // initEditorConfigHandler: (state) {
                      //   return EditorConfig(
                      //     maxScale: 8.0,
                      //     cropRectPadding: EdgeInsets.all(20.0),
                      //     hitTestSize: 20.0,
                      //   );
                      // },
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
                color: ThemeColors.COLOR_BLACK,
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
