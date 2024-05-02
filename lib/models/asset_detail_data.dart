/// Created by Chandan Jana on 04-04-2024.
/// Company name: Mindteck
/// Email: chandan.jana@mindteck.com
///

class AssetDetailData {
  String? nId;
  String? timestamp;
  String? assetId;
  String? zoneId;
  String? latitude;
  String? longitude;
  String? assetName;
  String? zoneName;
  String? trackerDeviceName;
  String? hardwareID;
  String? locationName;
  String? siteName;
  String? siteId;
  String? levelID;
  String? levelName;
  bool? isLevelOutDoor;

  AssetDetailData(
      {this.nId,
        this.timestamp,
        this.assetId,
        this.zoneId,
        this.latitude,
        this.longitude,
        this.assetName,
        this.zoneName,
        this.trackerDeviceName,
        this.hardwareID,
        this.locationName,
        this.siteName,
        this.siteId,
        this.levelID,
        this.levelName,
        this.isLevelOutDoor});

  AssetDetailData.fromJson(Map<String, dynamic> json) {
    nId = json['_id'];
    timestamp = json['timestamp'];
    assetId = json['assetId'];
    zoneId = json['zoneId'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    assetName = json['assetName'];
    zoneName = json['zoneName'];
    trackerDeviceName = json['trackerDeviceName'];
    hardwareID = json['hardwareID'];
    locationName = json['locationName'];
    siteName = json['siteName'];
    siteId = json['siteId'];
    levelID = json['levelID'];
    levelName = json['levelName'];
    isLevelOutDoor = json['isLevelOutDoor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.nId;
    data['timestamp'] = this.timestamp;
    data['assetId'] = this.assetId;
    data['zoneId'] = this.zoneId;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['assetName'] = this.assetName;
    data['zoneName'] = this.zoneName;
    data['trackerDeviceName'] = this.trackerDeviceName;
    data['hardwareID'] = this.hardwareID;
    data['locationName'] = this.locationName;
    data['siteName'] = this.siteName;
    data['siteId'] = this.siteId;
    data['levelID'] = this.levelID;
    data['levelName'] = this.levelName;
    data['isLevelOutDoor'] = this.isLevelOutDoor;
    return data;
  }

  @override
  String toString() {
    // TODO: implement toString
    return toJson().toString();
  }
}