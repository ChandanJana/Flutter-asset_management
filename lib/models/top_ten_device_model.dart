import 'package:mindteck_iot/models/top_ten_device_data.dart';

/// Created by Chandan Jana on 07-03-2024.
/// Company name: Mindteck
/// Email: chandan.jana@mindteck.com

class TopTenDeviceModel {
  List<TopTenDeviceData> data = [];
  String? responseMessage;
  int? responseId;
  int? responseCode;
  int? errorCode;

  TopTenDeviceModel(
      {required this.data,
      this.responseMessage,
      this.responseId,
      this.responseCode,
      this.errorCode});

  TopTenDeviceModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <TopTenDeviceData>[];
      json['data'].forEach((v) {
        data.add(new TopTenDeviceData.fromJson(v));
      });
    }
    responseMessage = json['responseMessage'];
    responseId = json['responseId'];
    responseCode = json['responseCode'];
    errorCode = json['errorCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = this.data.map((v) => v.toJson()).toList();
    data['responseMessage'] = this.responseMessage;
    data['responseId'] = this.responseId;
    data['responseCode'] = this.responseCode;
    data['errorCode'] = this.errorCode;
    return data;
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
