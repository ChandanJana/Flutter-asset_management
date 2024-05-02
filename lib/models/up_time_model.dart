import 'notification_data.dart';

/// Created by Chandan Jana on 04-04-2024.
/// Company name: Mindteck
/// Email: chandan.jana@mindteck.com
///

class UpTimeModel {
  String? responseMessage;
  List<NotificationData> data = [];
  int? responseId;
  int? responseCode;

  UpTimeModel({this.responseMessage, this.responseId, this.responseCode});

  UpTimeModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <NotificationData>[];
      json['data'].forEach((v) {
        data!.add(NotificationData.fromJson(v));
      });
    }
    responseMessage = json['responseMessage'];
    responseId = json['responseId'];
    responseCode = json['responseCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['responseMessage'] = this.responseMessage;
    data['responseId'] = this.responseId;
    data['responseCode'] = this.responseCode;
    return data;
  }

  @override
  String toString() {
    // TODO: implement toString
    return toJson().toString();
  }
}
