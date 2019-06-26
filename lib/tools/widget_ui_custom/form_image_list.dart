import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:warranzy_demo/tools/config/text_style.dart';
import 'package:warranzy_demo/tools/provider_image/provier_image.dart';

import '../theme_color.dart';
import 'image_builder.dart';

class FormImageList {
  static Widget build(
      {@required BuildContext context,
      @required List<File> path,
      bool editAble = false}) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 2,
        margin: EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
            border: path.length == 0
                ? Border.all(width: 0.5, color: COLOR_THEME_APP)
                : null,
            borderRadius: BorderRadius.circular(20.0)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: path.length > 0
              ? ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: path.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ImageBuilder.build(
                        context: context,
                        filePath: path[index],
                        index: index + 1,
                        editAble: editAble,
                        onPressed: () {
                          Provider.of<ImageDataState>(context).remove = index;
                        },
                      ),
                    );
                  },
                )
              : imageEmpty(),
        ));
  }
}

Column imageEmpty() {
  return Column(children: <Widget>[
    Spacer(),
    RichText(
      text: TextSpan(
        text: "Image empty.",
        style: TextStyleCustom.STYLE_LABEL,
      ),
    ),
    RichText(
      text: TextSpan(
        text: "limit 4 photos.",
        style: TextStyleCustom.STYLE_DESCRIPTION,
      ),
    ),
    Spacer(),
    Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () {
            print("Get Premium.");
          },
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
                text: "if you're premium, you can store up to 10 photos.",
                style: TextStyleCustom.STYLE_DESCRIPTION,
                children: [
                  TextSpan(
                    text: "\tGet Premium.",
                    style: TextStyleCustom.STYLE_DESCRIPTION,
                  )
                ]),
          ),
        )),
  ]);
}
// Widget cropImages({List<File> path, bool editAble = false}) {
//     return Container(
//         width: MediaQuery.of(context).size.width,
//         height: MediaQuery.of(context).size.height / 2,
//         margin: EdgeInsets.symmetric(vertical: 8),
//         decoration: BoxDecoration(
//             border: imageList.length == 0
//                 ? Border.all(width: 0.5, color: COLOR_THEME_APP)
//                 : null,
//             borderRadius: BorderRadius.circular(20.0)),
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(20),
//           child: imageList.length > 0
//               ? ListView.builder(
//                   scrollDirection: Axis.horizontal,
//                   itemCount: imageList.length,
//                   itemBuilder: (BuildContext context, int index) {
//                     return Padding(
//                       padding: const EdgeInsets.only(right: 8.0),
//                       child: ImageBuilder.build(
//                         context: context,
//                         filePath: imageList[index],
//                         index: index+1,
//                         editAble: editAble,
//                         onPressed: () {
//                           setState(() {
//                             imageList.removeAt(index);
//                           });
//                         },
//                       ),
//                     );
//                   },
//                 )
//               : imageEmpty(),
//         ));
//   }
