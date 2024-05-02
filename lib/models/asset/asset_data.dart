/// Created by Chandan Jana on 05-03-2024.
/// Company name: Mindteck
/// Email: chandan.jana@mindteck.com
///

class AssetData {
  String? assetId;
  String? assetName;
  String? siteId;
  String? siteName;
  String? levelId;
  String? levelName;
  String? zoneId;
  String? zoneName;
  String? deviceId;
  String? deviceName;
  String? createdDate;
  String? assetStatusId;
  String? assetTypeId;

  AssetData(
      {this.assetId,
      this.assetName,
      this.siteId,
      this.siteName,
      this.levelId,
      this.levelName,
      this.zoneId,
      this.zoneName,
      this.deviceId,
      this.deviceName,
      this.createdDate,
      this.assetStatusId,
      this.assetTypeId});

  AssetData.fromJson(Map<String, dynamic> json) {
    assetId = json['assetId'];
    assetName = json['assetName'];
    siteId = json['siteId'];
    siteName = json['siteName'];
    levelId = json['levelId'];
    levelName = json['levelName'];
    zoneId = json['zoneId'];
    zoneName = json['zoneName'];
    deviceId = json['deviceId'];
    deviceName = json['deviceName'];
    createdDate = json['createdDate'];
    assetStatusId = json['assetStatusId'];
    assetTypeId = json['assetTypeId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['assetId'] = this.assetId;
    data['assetName'] = this.assetName;
    data['siteId'] = this.siteId;
    data['siteName'] = this.siteName;
    data['levelId'] = this.levelId;
    data['levelName'] = this.levelName;
    data['zoneId'] = this.zoneId;
    data['zoneName'] = this.zoneName;
    data['deviceId'] = this.deviceId;
    data['deviceName'] = this.deviceName;
    data['createdDate'] = this.createdDate;
    data['assetStatusId'] = this.assetStatusId;
    data['assetTypeId'] = this.assetTypeId;
    return data;
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
