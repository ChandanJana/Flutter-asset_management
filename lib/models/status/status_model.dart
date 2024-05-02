import 'package:mindteck_iot/models/status/status_data.dart';

class StatusModel {
  List<StatusData> data = [];
  String? responseMessage;
  int? responseId;
  int? responseCode;

  StatusModel(
      {required this.data,
      this.responseMessage,
      this.responseId,
      this.responseCode});

  StatusModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <StatusData>[];
      json['data'].forEach((v) {
        data.add(StatusData.fromJson(v));
      });
    }
    responseMessage = json['responseMessage'];
    responseId = json['responseId'];
    responseCode = json['responseCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
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
