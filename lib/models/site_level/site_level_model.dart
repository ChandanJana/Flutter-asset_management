import 'package:mindteck_iot/models/site_level/site_level_data.dart';

/// Created by Chandan Jana on 21-02-2024.
/// Company name: Mindteck
/// Email: chandan.jana@mindteck.com
///

class SiteLevelModel {
  List<SiteLevelData> data = [];
  String? responseMessage;
  int? responseId;
  int? responseCode;

  SiteLevelModel(
      {required this.data,
      this.responseMessage,
      this.responseId,
      this.responseCode});

  SiteLevelModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <SiteLevelData>[];
      json['data'].forEach((v) {
        data.add(new SiteLevelData.fromJson(v));
      });
    }
    responseMessage = json['responseMessage'];
    responseId = json['responseId'];
    responseCode = json['responseCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = this.data.map((v) => v.toJson()).toList();
    data['responseMessage'] = this.responseMessage;
    data['responseId'] = this.responseId;
    data['responseCode'] = this.responseCode;
    return data;
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
