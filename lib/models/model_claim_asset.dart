import 'package:intl/intl.dart';

class ModelClaimProductAsset {
  final int id;
  final String assetsName;
  final String assetsDetailData;
  final String serviceType;
  final String requsetDate;
  String status;

  ModelClaimProductAsset(
      {this.id,
      this.assetsName,
      this.assetsDetailData,
      this.serviceType,
      this.requsetDate,
      this.status});

  List<ModelClaimProductAsset> pushData() {
    List<ModelClaimProductAsset> list = [];
    for (var i = 0; i < 10; i++) {
      list.add(ModelClaimProductAsset(
        id: i,
        assetsName: "Dyson V7 Trigger",
        assetsDetailData:
            "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s",
        serviceType: "Fix service",
        requsetDate: DateFormat("d.MM.yyyy").format(DateTime.utc(2019, i, i)),
        status: i.isOdd ? "Pending" : "Waiting service",
      ));
    }
    return list;
  }
}
