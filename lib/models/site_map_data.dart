/// Created by Chandan Jana on 14-03-2024.
/// Company name: Mindteck
/// Email: chandan.jana@mindteck.com
///

class SiteMapData {
  final double siteLat;
  final double siteLong;
  final String siteName;

  const SiteMapData(
      {required this.siteName, required this.siteLat, required this.siteLong});

  factory SiteMapData.fromJson(Map<String, dynamic> json) => SiteMapData(
      siteName: json['siteName'],
      siteLat: json['siteLat'],
      siteLong: json['siteLong']);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['siteLat'] = this.siteLat;
    data['siteLong'] = this.siteLong;
    data['siteName'] = this.siteName;
    return data;
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
