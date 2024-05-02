import 'package:mindteck_iot/models/unitMeasurement/unit_measurement_data.dart';

/// Created by Chandan Jana on 14-02-2024.
/// Company name: Mindteck
/// Email: chandan.jana@mindteck.com

class UnitOfMeasurementModel {
  List<UnitOfMeasurementData> data = [];
  String? responseMessage;
  int? responseId;
  int? responseCode;

  UnitOfMeasurementModel(
      {required this.data,
      this.responseMessage,
      this.responseId,
      this.responseCode});

  UnitOfMeasurementModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <UnitOfMeasurementData>[];
      json['data'].forEach((v) {
        data!.add(new UnitOfMeasurementData.fromJson(v));
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
