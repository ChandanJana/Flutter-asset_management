import 'asset_data.dart';

/// Created by Chandan Jana on 05-03-2024.
/// Company name: Mindteck
/// Email: chandan.jana@mindteck.com
///

class AssetModel {
  List<AssetData> data = [];
  String? responseMessage;
  int? responseId;
  int? responseCode;
  int? errorCode;

  AssetModel(
      {required this.data,
      this.responseMessage,
      this.responseId,
      this.responseCode,
      this.errorCode});

  AssetModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <AssetData>[];
      json['data'].forEach((v) {
        data.add(new AssetData.fromJson(v));
      });
    }
    responseMessage = json['responseMessage'];
    responseId = json['responseId'];
    responseCode = json['responseCode'];
    errorCode = json['errorCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = this.data.map((v) => v.toJson()).toList();
    data['responseMessage'] = this.responseMessage;
    data['responseId'] = this.responseId;
    data['responseCode'] = this.responseCode;
    data['errorCode'] = this.errorCode;
    return data;
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
