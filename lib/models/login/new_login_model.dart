import 'login_data.dart';

class LoginResponseModel {
  LoginData? data;
  String? responseMessage;
  int? responseId;
  int? responseCode;

  LoginResponseModel(
      {this.data, this.responseMessage, this.responseId, this.responseCode});

  LoginResponseModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? LoginData.fromJson(json['data']) : null;
    responseMessage = json['responseMessage'];
    responseId = json['responseId'];
    responseCode = json['responseCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['responseMessage'] = responseMessage;
    data['responseId'] = responseId;
    data['responseCode'] = responseCode;
    return data;
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
