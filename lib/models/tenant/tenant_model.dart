import 'package:mindteck_iot/models/tenant/tenant_data.dart';

/// Created by Chandan Jana on 13-02-2024.
/// Company name: Mindteck
/// Email: chandan.jana@mindteck.com
///

class TenantModel {
  List<TenantData> data = [];
  String? responseMessage;
  int? responseId;
  int? responseCode;

  TenantModel(
      {required this.data,
      this.responseMessage,
      this.responseId,
      this.responseCode});

  TenantModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <TenantData>[];
      json['data'].forEach((v) {
        data.add(TenantData.fromJson(v));
      });
    }
    responseMessage = json['responseMessage'];
    responseId = json['responseId'];
    responseCode = json['responseCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['data'] = this.data.map((v) => v.toJson()).toList();
    data['responseMessage'] = responseMessage;
    data['responseId'] = responseId;
    data['responseCode'] = responseCode;
    return data;
  }

  @override
  String toString() {
    // TODO: implement toString
    return toJson().toString();
  }
}
