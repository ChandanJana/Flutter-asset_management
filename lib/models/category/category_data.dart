/// Created by Chandan Jana on 05-02-2024.
/// Company name: Mindteck
/// Email: chandan.jana@mindteck.com

class CategoryData {
  String? deviceCategoryId;
  String? deviceCategoryName;

  CategoryData({this.deviceCategoryId, this.deviceCategoryName});

  CategoryData.fromJson(Map<String, dynamic> json) {
    deviceCategoryId = json['deviceCategoryId'];
    deviceCategoryName = json['deviceCategoryName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['deviceCategoryId'] = this.deviceCategoryId;
    data['deviceCategoryName'] = this.deviceCategoryName;
    return data;
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
