import 'package:mindteck_iot/models/site_level/shape_data.dart';

/// Created by Chandan Jana on 21-02-2024.
/// Company name: Mindteck
/// Email: chandan.jana@mindteck.com
///

class SiteLevelData {
  String? levelId;
  String? levelName;
  String? levelDescription;
  num? altitude;
  String? siteId;
  int? serialNo;
  num? geoLatitude;
  num? geoLongitude;
  num? length;
  num? breadth;
  String? image;
  String? imageByteArray;
  List<ShapesData> shapes = [];

  SiteLevelData(
      {this.levelId,
      this.levelName,
      this.levelDescription,
      this.altitude,
      this.siteId,
      this.serialNo,
      this.geoLatitude,
      this.geoLongitude,
      this.length,
      this.breadth,
      this.image,
      this.imageByteArray,
      required this.shapes});

  SiteLevelData.fromJson(Map<String, dynamic> json) {
    levelId = json['levelId'];
    levelName = json['levelName'];
    levelDescription = json['levelDescription'];
    altitude = json['altitude'];
    siteId = json['siteId'];
    serialNo = json['serialNo'];
    geoLatitude = json['geoLatitude'];
    geoLongitude = json['geoLongitude'];
    length = json['length'];
    breadth = json['breadth'];
    image = json['image'];
    imageByteArray = json['imageByteArray'];
    if (json['shapes'] != null) {
      shapes = <ShapesData>[];
      json['shapes'].forEach((v) {
        shapes.add(new ShapesData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['levelId'] = this.levelId;
    data['levelName'] = this.levelName;
    data['levelDescription'] = this.levelDescription;
    data['altitude'] = this.altitude;
    data['siteId'] = this.siteId;
    data['serialNo'] = this.serialNo;
    data['geoLatitude'] = this.geoLatitude;
    data['geoLongitude'] = this.geoLongitude;
    data['length'] = this.length;
    data['breadth'] = this.breadth;
    data['image'] = this.image;
    data['imageByteArray'] = this.imageByteArray;
    data['shapes'] = this.shapes.map((v) => v.toJson()).toList();
    //data['shapes'] = this.shapes;
    return data;
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
