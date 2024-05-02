/// Created by Chandan Jana on 05-02-2024.
/// Company name: Mindteck
/// Email: chandan.jana@mindteck.com

class StatusData {
  String? deviceLifeCycleId;
  String? deviceLifeCycleName;
  bool? isDeallocationReason;
  List<StatusData>? tblIotDeviceMasters;

  StatusData(
      {this.deviceLifeCycleId,
      this.deviceLifeCycleName,
      this.isDeallocationReason,
      this.tblIotDeviceMasters});

  StatusData.fromJson(Map<String, dynamic> json) {
    deviceLifeCycleId = json['deviceLifeCycleId'];
    deviceLifeCycleName = json['deviceLifeCycleName'];
    isDeallocationReason = json['isDeallocationReason'];
    if (json['tblIotDeviceMasters'] != null) {
      tblIotDeviceMasters = <StatusData>[];
      json['tblIotDeviceMasters'].forEach((v) {
        tblIotDeviceMasters!.add(StatusData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['deviceLifeCycleId'] = this.deviceLifeCycleId;
    data['deviceLifeCycleName'] = this.deviceLifeCycleName;
    data['isDeallocationReason'] = this.isDeallocationReason;
    if (this.tblIotDeviceMasters != null) {
      data['tblIotDeviceMasters'] =
          this.tblIotDeviceMasters!.map((v) => v?.toJson()).toList();
    }
    return data;
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
