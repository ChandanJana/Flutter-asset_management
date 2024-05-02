/// Created by Chandan Jana on 30-01-2024.
/// Company name: Mindteck
/// Email: chandan.jana@mindteck.com

class DeviceData {
  String? deviceId;
  String? deviceCategoryId;
  String? deviceName;
  String? deviceSerialNumber;
  String? deviceHardwareId;
  String? uomid = null;
  int? upperLimit = 0;
  int? lowerLimit = 0;
  String? deviceLifeCycleId;
  String? deviceLifeCycleName;
  String? deviceCategoryName;
  String? createdDate;
  num? thresholdValue = 0;

  //Double? thresholdValue;
  bool? isSensor;
  bool? isActive;
  String? uomName;
  String? tenantId;
  String? tenantName;

  DeviceData(
      {this.deviceId,
      this.deviceCategoryId,
      this.deviceName,
      this.deviceSerialNumber,
      this.deviceHardwareId,
      this.uomid,
      required this.upperLimit,
      required this.lowerLimit,
      this.deviceLifeCycleId,
      this.deviceLifeCycleName,
      this.deviceCategoryName,
      this.thresholdValue,
      this.isSensor,
      this.isActive,
      this.uomName,
      this.tenantId,
      this.tenantName,
      this.createdDate});

  DeviceData.fromJson(Map<String, dynamic> json) {
    deviceId = json['deviceId'];
    deviceCategoryId = json['deviceCategoryId'];
    deviceName = json['deviceName'];
    deviceSerialNumber = json['deviceSerialNumber'];
    deviceHardwareId = json['deviceHardwareId'];
    uomid = json['uomid'];
    upperLimit = json['upperLimit'];
    lowerLimit = json['lowerLimit'];
    deviceLifeCycleId = json['deviceLifeCycleId'];
    deviceLifeCycleName = json['deviceLifeCycleName'];
    deviceCategoryName = json['deviceCategoryName'];
    thresholdValue = json['thresholdValue'];
    isSensor = json['isSensor'];
    isActive = json['isActive'];
    uomName = json['uomName'];
    tenantId = json['tenantId'];
    tenantName = json['tenantName'];
    createdDate = json['createdDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['deviceId'] = this.deviceId;
    data['deviceCategoryId'] = this.deviceCategoryId;
    data['deviceName'] = this.deviceName;
    data['deviceSerialNumber'] = this.deviceSerialNumber;
    data['deviceHardwareId'] = this.deviceHardwareId;
    data['uomid'] = this.uomid;
    data['upperLimit'] = this.upperLimit;
    data['lowerLimit'] = this.lowerLimit;
    data['deviceLifeCycleId'] = this.deviceLifeCycleId;
    data['deviceLifeCycleName'] = this.deviceLifeCycleName;
    data['deviceCategoryName'] = this.deviceCategoryName;
    data['thresholdValue'] = this.thresholdValue;
    data['isSensor'] = this.isSensor;
    data['isActive'] = this.isActive;
    data['uomName'] = this.uomName;
    data['tenantId'] = this.tenantId;
    data['tenantName'] = this.tenantName;
    data['createdDate'] = this.createdDate;
    return data;
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
