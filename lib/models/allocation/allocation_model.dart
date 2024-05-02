import 'allocation_data.dart';

/// Created by Chandan Jana on 19-02-2024.
/// Company name: Mindteck
/// Email: chandan.jana@mindteck.com
///

class AllocationModel {
  List<AllocationData> data = [];
  String? responseMessage;
  int? responseId;
  int? responseCode;

  AllocationModel(
      {required this.data,
      this.responseMessage,
      this.responseId,
      this.responseCode});

  AllocationModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <AllocationData>[];
      json['data'].forEach((v) {
        data.add(new AllocationData.fromJson(v));
      });
    }
    responseMessage = json['responseMessage'];
    responseId = json['responseId'];
    responseCode = json['responseCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = this.data.map((v) => v.toJson()).toList();
    data['responseMessage'] = this.responseMessage;
    data['responseId'] = this.responseId;
    data['responseCode'] = this.responseCode;
    return data;
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
