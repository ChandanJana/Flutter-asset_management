import 'package:mindteck_iot/models/top_ten_device_id.dart';

/// Created by Chandan Jana on 07-03-2024.
/// Company name: Mindteck
/// Email: chandan.jana@mindteck.com
///

class TopTenDeviceData {
  String? deviceId;
  String? deviceName;
  num? activityCount;
  String? tenantID;
  TopTenDeviceId? iId;

  TopTenDeviceData(
      {this.deviceId,
      this.deviceName,
      this.activityCount,
      this.tenantID,
      this.iId});

  TopTenDeviceData.fromJson(Map<String, dynamic> json) {
    deviceId = json['deviceId'];
    deviceName = json['deviceName'];
    activityCount = json['activityCount'];
    tenantID = json['tenantID'];
    iId = json['_id'] != null ? new TopTenDeviceId.fromJson(json['_id']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['deviceId'] = this.deviceId;
    data['deviceName'] = this.deviceName;
    data['activityCount'] = this.activityCount;
    data['tenantID'] = this.tenantID;
    if (this.iId != null) {
      data['_id'] = this.iId!.toJson();
    }
    return data;
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
