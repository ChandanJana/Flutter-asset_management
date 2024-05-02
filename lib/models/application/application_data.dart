/// Created by Chandan Jana on 27-02-2024.
/// Company name: Mindteck
/// Email: chandan.jana@mindteck.com
///

class ApplicationData {
  String? applicationId;
  String? applicationName;
  bool? isActive;
  String? createdDate;

  ApplicationData(
      {this.applicationId,
      this.applicationName,
      this.isActive,
      this.createdDate});

  ApplicationData.fromJson(Map<String, dynamic> json) {
    applicationId = json['applicationId'];
    applicationName = json['applicationName'];
    isActive = json['isActive'];
    createdDate = json['createdDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['applicationId'] = this.applicationId;
    data['applicationName'] = this.applicationName;
    data['isActive'] = this.isActive;
    data['createdDate'] = this.createdDate;
    return data;
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
