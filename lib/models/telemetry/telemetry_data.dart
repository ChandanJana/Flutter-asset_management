import 'package:mindteck_iot/models/telemetry/sensor_data.dart';
import 'package:mindteck_iot/models/telemetry/value_data.dart';

/// Created by Chandan Jana on 28-03-2024.
/// Company name: Mindteck
/// Email: chandan.jana@mindteck.com
///

class TelemetryData {
  String? hardwareId;
  int? timestamp;
  double? latitude;
  double? longitude;
  List<ValueData> valueList = [];
  List<SensorData> sensorList = [];

  TelemetryData(
      {this.hardwareId,
      this.timestamp,
      this.latitude,
      this.longitude,
      required this.valueList,
      required this.sensorList});

  TelemetryData.fromJson(Map<String, dynamic> json) {
    hardwareId = json['HardwareId'];
    timestamp = json['Timestamp'];
    latitude = json['Latitude'];
    longitude = json['Longitude'];
    if (json['ValueList'] != null) {
      valueList = <ValueData>[];
      json['ValueList'].forEach((v) {
        valueList.add(new ValueData.fromJson(v));
      });
    }
    if (json['SensorList'] != null) {
      sensorList = <SensorData>[];
      json['SensorList'].forEach((v) {
        sensorList.add(new SensorData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['HardwareId'] = this.hardwareId;
    data['Timestamp'] = this.timestamp;
    data['Latitude'] = this.latitude;
    data['Longitude'] = this.longitude;
    data['ValueList'] = this.valueList.map((v) => v.toJson()).toList();
    data['SensorList'] = this.sensorList.map((v) => v.toJson()).toList();
    return data;
  }

  @override
  String toString() {
    // TODO: implement toString
    return toJson().toString();
  }
}
