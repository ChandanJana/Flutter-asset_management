/// Created by Chandan Jana on 08-03-2024.
/// Company name: Mindteck
/// Email: chandan.jana@mindteck.com
///

class ShapesData {
  String? shapeId;
  String? levelId;
  String? siteId;
  double? longitude;
  double? latitude;
  int? serialNo;

  ShapesData(
      {this.shapeId,
      this.levelId,
      this.siteId,
      this.longitude,
      this.latitude,
      this.serialNo});

  ShapesData.fromJson(Map<String, dynamic> json) {
    shapeId = json['shapeId'];
    levelId = json['levelId'];
    siteId = json['siteId'];
    longitude = json['longitude'];
    latitude = json['latitude'];
    serialNo = json['serialNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['shapeId'] = this.shapeId;
    data['levelId'] = this.levelId;
    data['siteId'] = this.siteId;
    data['longitude'] = this.longitude;
    data['latitude'] = this.latitude;
    data['serialNo'] = this.serialNo;
    return data;
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
