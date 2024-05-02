/// Created by Chandan Jana on 14-02-2024.
/// Company name: Mindteck
/// Email: chandan.jana@mindteck.com

class UnitOfMeasurementData {
  String? uomid;
  String? uomcategoryId;
  String? uomcategoryName;
  String? uomname;
  String? uomsymbol;

  UnitOfMeasurementData(
      {this.uomid,
      this.uomcategoryId,
      this.uomcategoryName,
      this.uomname,
      this.uomsymbol});

  UnitOfMeasurementData.fromJson(Map<String, dynamic> json) {
    uomid = json['uomid'];
    uomcategoryId = json['uomcategoryId'];
    uomcategoryName = json['uomcategoryName'];
    uomname = json['uomname'];
    uomsymbol = json['uomsymbol'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uomid'] = this.uomid;
    data['uomcategoryId'] = this.uomcategoryId;
    data['uomcategoryName'] = this.uomcategoryName;
    data['uomname'] = this.uomname;
    data['uomsymbol'] = this.uomsymbol;
    return data;
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
