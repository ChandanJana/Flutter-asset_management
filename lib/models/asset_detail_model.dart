import 'asset_detail_data.dart';

/// Created by Chandan Jana on 04-04-2024.
/// Company name: Mindteck
/// Email: chandan.jana@mindteck.com
///

class AssetDetailModel {
  AssetDetailData data = Map() as AssetDetailData;
  String? responseMessage;
  int? responseId;
  int? responseCode;
  int? errorCode;

  AssetDetailModel(
      {required this.data,
        this.responseMessage,
        this.responseId,
        this.responseCode,
        this.errorCode});

  AssetDetailModel.fromJson(Map<String, dynamic> json) {
    data = (json['data'] != null ? new AssetDetailData.fromJson(json['data']) : null)!;
    responseMessage = json['responseMessage'];
    responseId = json['responseId'];
    responseCode = json['responseCode'];
    errorCode = json['errorCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['responseMessage'] = this.responseMessage;
    data['responseId'] = this.responseId;
    data['responseCode'] = this.responseCode;
    data['errorCode'] = this.errorCode;
    return data;
  }

  @override
  String toString() {
    // TODO: implement toString
    return toJson().toString();
  }
}
