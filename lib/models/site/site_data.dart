import 'package:mindteck_iot/models/site_level/site_level_data.dart';

/// Created by Chandan Jana on 20-02-2024.
/// Company name: Mindteck
/// Email: chandan.jana@mindteck.com
///

class SiteData {
  String? siteId;
  String? siteName;
  String? siteDescription;
  bool? isActive;
  String? siteType;
  int? siteLevelCount;
  String? tenantId;
  String? tenantName;
  bool? isSystem;
  String? createdDate;
  List<SiteLevelData> levels = [];

  SiteData(
      {this.siteId,
      this.siteName,
      this.siteDescription,
      this.isActive,
      this.siteType,
      this.siteLevelCount,
      this.tenantId,
      this.tenantName,
      this.isSystem,
      this.createdDate,
      required this.levels});

  SiteData.fromJson(Map<String, dynamic> json) {
    siteId = json['siteId'];
    siteName = json['siteName'];
    siteDescription = json['siteDescription'];
    isActive = json['isActive'];
    siteType = json['siteType'];
    siteLevelCount = json['siteLevelCount'];
    tenantId = json['tenantId'];
    tenantName = json['tenantName'];
    isSystem = json['isSystem'];
    createdDate = json['createdDate'];
    if (json['levels'] != null) {
      levels = <SiteLevelData>[];
      json['levels'].forEach((v) {
        levels.add(new SiteLevelData.fromJson(v));
      });
    }
    //levels = json['levels'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['siteId'] = this.siteId;
    data['siteName'] = this.siteName;
    data['siteDescription'] = this.siteDescription;
    data['isActive'] = this.isActive;
    data['siteType'] = this.siteType;
    data['siteLevelCount'] = this.siteLevelCount;
    data['tenantId'] = this.tenantId;
    data['tenantName'] = this.tenantName;
    data['isSystem'] = this.isSystem;
    data['createdDate'] = this.createdDate;
    data['levels'] = this.levels.map((v) => v.toJson()).toList();
    return data;
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
