import 'package:mindteck_iot/models/trace_history_data.dart';

/// Created by Chandan Jana on 18-03-2024.
/// Company name: Mindteck
/// Email: chandan.jana@mindteck.com
///

class TraceHistoryModel {
  List<TraceHistoryData> data = [];
  String? responseMessage;
  int? responseId;
  int? responseCode;
  int? errorCode;

  TraceHistoryModel(
      {required this.data,
      this.responseMessage,
      this.responseId,
      this.responseCode,
      this.errorCode});

  TraceHistoryModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <TraceHistoryData>[];
      json['data'].forEach((v) {
        data!.add(new TraceHistoryData.fromJson(v));
      });
    }
    responseMessage = json['responseMessage'];
    responseId = json['responseId'];
    responseCode = json['responseCode'];
    errorCode = json['errorCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['responseMessage'] = this.responseMessage;
    data['responseId'] = this.responseId;
    data['responseCode'] = this.responseCode;
    data['errorCode'] = this.errorCode;
    return data;
  }

  @override
  String toString() {
    // TODO: implement toString
    return toJson().toString();
  }
}
