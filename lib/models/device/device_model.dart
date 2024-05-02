import 'device_data.dart';

class DeviceModel {
  List<DeviceData> data = [];
  String? responseMessage;
  int? responseId;
  int? responseCode;

  DeviceModel(
      {required this.data,
      this.responseMessage,
      this.responseId,
      this.responseCode});

  DeviceModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <DeviceData>[];
      json['data'].forEach((v) {
        data.add(DeviceData.fromJson(v));
      });
    }
    responseMessage = json['responseMessage'];
    responseId = json['responseId'];
    responseCode = json['responseCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['data'] = this.data.map((v) => v.toJson()).toList();
    data['responseMessage'] = responseMessage;
    data['responseId'] = responseId;
    data['responseCode'] = responseCode;
    return data;
  }
}
