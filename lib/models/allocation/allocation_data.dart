/// Created by Chandan Jana on 19-02-2024.
/// Company name: Mindteck
/// Email: chandan.jana@mindteck.com
///

class AllocationData {
  String? allocationId;
  String? deviceName;
  String? deviceId;
  String? siteName;
  String? siteId;
  String? levelId;
  String? levelName;
  String? parentDeviceName;
  String? parentDeviceId;
  int? deviceCategoryId;
  int? parentDeviceCategoryId;

  AllocationData(
      {this.allocationId,
      this.deviceName,
      this.deviceId,
      this.siteName,
      this.siteId,
      this.levelId,
      this.levelName,
      this.parentDeviceName,
      this.parentDeviceId,
      this.deviceCategoryId,
      this.parentDeviceCategoryId});

  AllocationData.fromJson(Map<String, dynamic> json) {
    allocationId = json['allocationId'];
    deviceName = json['deviceName'];
    deviceId = json['deviceId'];
    siteName = json['siteName'];
    siteId = json['siteId'];
    levelId = json['levelId'];
    levelName = json['levelName'];
    parentDeviceName = json['parentDeviceName'];
    parentDeviceId = json['parentDeviceId'];
    deviceCategoryId = json['deviceCategoryId'];
    parentDeviceCategoryId = json['parentDeviceCategoryId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['allocationId'] = this.allocationId;
    data['deviceName'] = this.deviceName;
    data['deviceId'] = this.deviceId;
    data['siteName'] = this.siteName;
    data['siteId'] = this.siteId;
    data['levelId'] = this.levelId;
    data['levelName'] = this.levelName;
    data['parentDeviceName'] = this.parentDeviceName;
    data['parentDeviceId'] = this.parentDeviceId;
    data['deviceCategoryId'] = this.deviceCategoryId;
    data['parentDeviceCategoryId'] = this.parentDeviceCategoryId;
    return data;
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
