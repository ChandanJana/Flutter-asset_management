/// Created by Chandan Jana on 07-03-2024.
/// Company name: Mindteck
/// Email: chandan.jana@mindteck.com
///

class TopTenDeviceId {
  int? timestamp;
  int? machine;
  int? pid;
  int? increment;
  String? creationTime;

  TopTenDeviceId(
      {this.timestamp,
      this.machine,
      this.pid,
      this.increment,
      this.creationTime});

  TopTenDeviceId.fromJson(Map<String, dynamic> json) {
    timestamp = json['timestamp'];
    machine = json['machine'];
    pid = json['pid'];
    increment = json['increment'];
    creationTime = json['creationTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['timestamp'] = this.timestamp;
    data['machine'] = this.machine;
    data['pid'] = this.pid;
    data['increment'] = this.increment;
    data['creationTime'] = this.creationTime;
    return data;
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
