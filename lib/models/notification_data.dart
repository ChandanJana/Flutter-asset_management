/// Created by Chandan Jana on 07-03-2024.
/// Company name: Mindteck
/// Email: chandan.jana@mindteck.com
///

class NotificationData {
  int hour = 0;
  int count = 0;

  NotificationData({required this.hour, required this.count});

  NotificationData.fromJson(Map<String, dynamic> json) {
    hour = json['hour'];
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['hour'] = this.hour;
    data['count'] = this.count;
    return data;
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
