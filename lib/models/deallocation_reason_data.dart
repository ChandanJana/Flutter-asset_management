/// Created by Chandan Jana on 22-02-2024.
/// Company name: Mindteck
/// Email: chandan.jana@mindteck.com
///

class DeallocationReasonData {
  String? deviceLifeCycleId;
  String? deviceLifeCycleName;
  bool? isDeallocationReason;
  List<String> tblIotDeviceMasters = [];

  DeallocationReasonData(
      {this.deviceLifeCycleId,
      this.deviceLifeCycleName,
      this.isDeallocationReason,
      required this.tblIotDeviceMasters});

  DeallocationReasonData.fromJson(Map<String, dynamic> json) {
    deviceLifeCycleId = json['deviceLifeCycleId'];
    deviceLifeCycleName = json['deviceLifeCycleName'];
    isDeallocationReason = json['isDeallocationReason'];
    if (json['tblIotDeviceMasters'] != null) {
      tblIotDeviceMasters = <String>[];
      json['tblIotDeviceMasters'].forEach((v) {
        tblIotDeviceMasters.add(v);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['deviceLifeCycleId'] = this.deviceLifeCycleId;
    data['deviceLifeCycleName'] = this.deviceLifeCycleName;
    data['isDeallocationReason'] = this.isDeallocationReason;
    data['tblIotDeviceMasters'] =
        this.tblIotDeviceMasters.map((v) => v).toList();
    return data;
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
