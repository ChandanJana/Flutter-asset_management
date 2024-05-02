/// Created by Chandan Jana on 28-03-2024.
/// Company name: Mindteck
/// Email: chandan.jana@mindteck.com
///

class ValueData {
  String? valueType;
  String? value;
  String? uOM;

  ValueData({this.valueType, this.value, this.uOM});

  ValueData.fromJson(Map<String, dynamic> json) {
    valueType = json['ValueType'];
    value = json['Value'];
    uOM = json['UOM'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['ValueType'] = this.valueType;
    data['Value'] = this.value;
    data['UOM'] = this.uOM;
    return data;
  }

  @override
  String toString() {
    // TODO: implement toString
    return toJson().toString();
  }
}
