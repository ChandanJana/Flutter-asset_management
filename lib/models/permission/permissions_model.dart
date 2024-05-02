import 'package:mindteck_iot/models/permission/permission_data.dart';

class PermissionModel {
  List<PermissionData>? data;
  String? responseMessage;
  int? responseId;
  int? responseCode;

  PermissionModel(
      {this.data, this.responseMessage, this.responseId, this.responseCode});

  PermissionModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <PermissionData>[];
      json['data'].forEach((v) {
        data!.add(new PermissionData.fromJson(v));
      });
    }
    responseMessage = json['responseMessage'];
    responseId = json['responseId'];
    responseCode = json['responseCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['responseMessage'] = this.responseMessage;
    data['responseId'] = this.responseId;
    data['responseCode'] = this.responseCode;
    return data;
  }
}
