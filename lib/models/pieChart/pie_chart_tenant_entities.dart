/// Created by Chandan Jana on 05-03-2024.
/// Company name: Mindteck
/// Email: chandan.jana@mindteck.com
///

class PieChartTenantEntities {
  String? name;
  int? count;

  PieChartTenantEntities({this.name, this.count});

  PieChartTenantEntities.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['count'] = this.count;
    return data;
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
