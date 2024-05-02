import 'deallocation_reason_data.dart';

/// Created by Chandan Jana on 22-02-2024.
/// Company name: Mindteck
/// Email: chandan.jana@mindteck.com
///

class DeallocationReasonModel {
  List<DeallocationReasonData> data = [];
  String? responseMessage;
  int? responseId;
  int? responseCode;

  DeallocationReasonModel(
      {required this.data,
      this.responseMessage,
      this.responseId,
      this.responseCode});

  DeallocationReasonModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <DeallocationReasonData>[];
      json['data'].forEach((v) {
        data!.add(new DeallocationReasonData.fromJson(v));
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
