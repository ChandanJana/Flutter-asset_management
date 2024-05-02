import 'application_data.dart';

class ApplicationModel {
  List<ApplicationData> data = [];
  String? responseMessage;
  int? responseId;
  int? responseCode;

  ApplicationModel(
      {required this.data,
      this.responseMessage,
      this.responseId,
      this.responseCode});

  ApplicationModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <ApplicationData>[];
      json['data'].forEach((v) {
        data!.add(new ApplicationData.fromJson(v));
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
    return toJson().toString();
  }
}
