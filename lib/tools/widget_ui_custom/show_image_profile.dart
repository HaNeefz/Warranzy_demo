import 'dart:convert';

import 'package:flutter/material.dart';

class ShowImageProfile extends StatelessWidget {
  final String imagePath;
  final double radius;
  final double minRadius;
  final double maxRadius;
  final Color backgroundColor;
  final Color borderColor;
  final Color foregroundColor;

  const ShowImageProfile(
      {Key key,
      @required this.imagePath,
      @required this.radius,
      this.minRadius,
      this.maxRadius,
      this.borderColor = Colors.teal,
      this.foregroundColor,
      this.backgroundColor = Colors.white})
      : super(key: key);

  getImage() {
    if (imagePath != null) {
      if (imagePath.startsWith("A") == true) {
        return AssetImage("assets/icons/avatars/$imagePath.png");
      } else {
        return MemoryImage(base64Decode(imagePath));
      }
    } else
      return null;
  }

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: borderColor,
      child: CircleAvatar(
        backgroundImage: getImage(),
        radius: radius - 5,
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        minRadius: minRadius,
        maxRadius: maxRadius,
      ),
    );
  }
}
