/// Created by Chandan Jana on 18-03-2024.
/// Company name: Mindteck
/// Email: chandan.jana@mindteck.com
///

class TraceHistoryData {
  int? orderId;
  String? message;
  String? dateTime;
  String? trackerName;
  String? trackerId;
  String? lifeCycleName;
  String? zoneName;

  TraceHistoryData(
      {this.orderId,
      this.message,
      this.dateTime,
      this.trackerName,
      this.trackerId,
      this.lifeCycleName,
      this.zoneName});

  TraceHistoryData.fromJson(Map<String, dynamic> json) {
    orderId = json['orderId'];
    message = json['message'];
    dateTime = json['dateTime'];
    trackerName = json['trackerName'];
    trackerId = json['trackerId'];
    lifeCycleName = json['lifeCycleName'];
    zoneName = json['zoneName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderId'] = this.orderId;
    data['message'] = this.message;
    data['dateTime'] = this.dateTime;
    data['trackerName'] = this.trackerName;
    data['trackerId'] = this.trackerId;
    data['lifeCycleName'] = this.lifeCycleName;
    data['zoneName'] = this.zoneName;
    return data;
  }

  @override
  String toString() {
    // TODO: implement toString
    return toJson().toString();
  }
}
