import 'package:mindteck_iot/models/site/site_data.dart';

class SiteModel {
  List<SiteData> data = [];
  String? responseMessage;
  int? responseId;
  int? responseCode;

  SiteModel(
      {required this.data,
      this.responseMessage,
      this.responseId,
      this.responseCode});

  SiteModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <SiteData>[];
      json['data'].forEach((v) {
        data.add(new SiteData.fromJson(v));
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
