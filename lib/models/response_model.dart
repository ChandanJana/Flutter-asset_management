/// Created by Chandan Jana on 13-02-2024.
/// Company name: Mindteck
/// Email: chandan.jana@mindteck.com

class ResponseModel {
  String? responseMessage;
  String? data;
  int? responseId;
  int? responseCode;

  ResponseModel({this.responseMessage, this.responseId, this.responseCode});

  ResponseModel.fromJson(Map<String, dynamic> json) {
    responseMessage = json['responseMessage'];
    responseId = json['responseId'];
    responseCode = json['responseCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['responseMessage'] = this.responseMessage;
    data['responseId'] = this.responseId;
    data['responseCode'] = this.responseCode;
    return data;
  }

  @override
  String toString() {
    // TODO: implement toString
    return toJson().toString();
  }
}
