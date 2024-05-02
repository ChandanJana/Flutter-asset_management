import '../user.dart';

/// Created by Chandan Jana on 13-02-2024.
/// Company name: Mindteck
/// Email: chandan.jana@mindteck.com
///

class TenantData {
  String? tenantId;
  String? tenantName;
  String? tenantDescription;
  String? firstName;
  String? lastName;
  String? email;
  String? contactNo;
  String? createdDate;
  String? address;
  bool? isSystem;

  //List<String>? deviceAllocationApplicatioIds;
  //List<String>? deviceAllocationApplicatioNames;
  User? user;
  String? logo;

  TenantData(
      {this.tenantId,
      this.tenantName,
      this.tenantDescription,
      this.firstName,
      this.lastName,
      this.email,
      this.contactNo,
      this.createdDate,
      this.address,
      this.isSystem,
      //this.deviceAllocationApplicatioIds,
      //this.deviceAllocationApplicatioNames,
      this.user});

  TenantData.fromJson(Map<String, dynamic> json) {
    tenantId = json['tenantId'];
    tenantName = json['tenantName'];
    tenantDescription = json['tenantDescription'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    contactNo = json['contactNo'];
    createdDate = json['createdDate'];
    address = json['address'];
    isSystem = json['isSystem'];
    //deviceAllocationApplicatioIds = json['deviceAllocationApplicatioIds'].cast<String>();
    //deviceAllocationApplicatioNames = json['deviceAllocationApplicatioNames'].cast<String>();
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    logo = json['logo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['tenantId'] = this.tenantId;
    data['tenantName'] = this.tenantName;
    data['tenantDescription'] = this.tenantDescription;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['email'] = this.email;
    data['contactNo'] = this.contactNo;
    data['createdDate'] = this.createdDate;
    data['address'] = this.address;
    data['isSystem'] = this.isSystem;
    //data['deviceAllocationApplicatioIds'] = this.deviceAllocationApplicatioIds;
    //data['deviceAllocationApplicatioNames'] = this.deviceAllocationApplicatioNames;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['logo'] = this.logo;
    return data;
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
