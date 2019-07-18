import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:warranzy_demo/tools/export_lib.dart';

final ecsLib = getIt.get<ECSLib>();
final allTranslations = getIt.get<GlobalTranslations>();

class MethodLib {
  static Future<String> scanQR(BuildContext context) async {
    String barcode = "";
    try {
      barcode = await BarcodeScanner.scan();
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        // The user did not grant the camera permission.
        ecsLib.showDialogLib(
            context: context,
            title: "PlatformException",
            content: "$e",
            textOnButton: "close");
      } else {
        // Unknown error.
        ecsLib.showDialogLib(
            context: context,
            title: "Unknown error",
            content: "$e",
            textOnButton: "close");
      }
    } on FormatException {
      // User returned using the "back"-button before scanning anything.
    } catch (e) {
      ecsLib.showDialogLib(
          context: context,
          title: "Unknown error",
          content: "$e",
          textOnButton: "close");
      // Unknown error.
    }
    if (barcode.isNotEmpty) {
      return barcode;
    } else {
      return "null";
      // _strBarCode.sink.add("Data is Empty");
    }
  }
}
