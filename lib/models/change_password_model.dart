class ChangePasswordModel {
  String? data;
  String? responseMessage;
  int? responseId;
  int? responseCode;

  ChangePasswordModel(
      {this.data, this.responseMessage, this.responseId, this.responseCode});

  ChangePasswordModel.fromJson(Map<String, dynamic> json) {
    data = json['data'];
    responseMessage = json['responseMessage'];
    responseId = json['responseId'];
    responseCode = json['responseCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = this.data;
    data['responseMessage'] = this.responseMessage;
    data['responseId'] = this.responseId;
    data['responseCode'] = this.responseCode;
    return data;
  }
}
