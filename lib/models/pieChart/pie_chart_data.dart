import 'package:mindteck_iot/models/pieChart/pie_chart_tenant_entities.dart';

/// Created by Chandan Jana on 05-03-2024.
/// Company name: Mindteck
/// Email: chandan.jana@mindteck.com
///

class PieChartData {
  int? totalCount;
  List<PieChartTenantEntities> tenantEntities = [];

  PieChartData({this.totalCount, required this.tenantEntities});

  PieChartData.fromJson(Map<String, dynamic> json) {
    totalCount = json['totalCount'];
    if (json['tenantEntities'] != null) {
      tenantEntities = <PieChartTenantEntities>[];
      json['tenantEntities'].forEach((v) {
        tenantEntities.add(new PieChartTenantEntities.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalCount'] = this.totalCount;
    data['tenantEntities'] =
        this.tenantEntities.map((v) => v.toJson()).toList();
    return data;
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
