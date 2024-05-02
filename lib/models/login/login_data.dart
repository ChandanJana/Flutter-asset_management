import 'package:mindteck_iot/models/user.dart';

/// Created by Chandan Jana on 27-02-2024.
/// Company name: Mindteck
/// Email: chandan.jana@mindteck.com
///

class LoginData {
  String? token;
  User? user;
  Tenant? tenant;
  String? responseMessage;
  String? responseId;
  String? responseCode;

  LoginData(
      {this.token,
      this.user,
      this.tenant,
      this.responseMessage,
      this.responseId,
      this.responseCode});

  LoginData.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    tenant = json['tenant'] != null ? Tenant.fromJson(json['tenant']) : null;
    responseMessage = json['responseMessage'];
    responseId = json['responseId'];
    responseCode = json['responseCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (this.tenant != null) {
      data['tenant'] = this.tenant!.toJson();
    }
    data['responseMessage'] = responseMessage;
    data['responseId'] = responseId;
    data['responseCode'] = responseCode;
    return data;
  }
}

class Tenant {
  String? tenantId;
  String? tenantName;
  String? tenantDescription;
  String? firstName;
  String? lastName;
  String? email;
  String? contactNo;
  String? createdDate;
  String? address;
  String? address1;
  bool? isSystem;
  String? systemLabel;
  String? systemLogoDark;
  String? systemLogoLight;
  String? address2;
  String? country;
  String? state;
  String? city;
  String? pincode;
  String? deviceAllocationApplicatioIds;
  String? deviceAllocationApplicatioNames;
  String? user;

  Tenant(
      {this.tenantId,
      this.tenantName,
      this.tenantDescription,
      this.firstName,
      this.lastName,
      this.email,
      this.contactNo,
      this.createdDate,
      this.address,
      this.address1,
      this.isSystem,
      this.systemLabel,
      this.systemLogoDark,
      this.systemLogoLight,
      this.address2,
      this.country,
      this.state,
      this.city,
      this.pincode,
      this.deviceAllocationApplicatioIds,
      this.deviceAllocationApplicatioNames,
      this.user});

  Tenant.fromJson(Map<String, dynamic> json) {
    tenantId = json['tenantId'];
    tenantName = json['tenantName'];
    tenantDescription = json['tenantDescription'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    contactNo = json['contactNo'];
    createdDate = json['createdDate'];
    address = json['address'];
    address1 = json['address1'];
    isSystem = json['isSystem'];
    systemLabel = json['systemLabel'];
    systemLogoDark = json['systemLogoDark'];
    systemLogoLight = json['systemLogoLight'];
    address2 = json['address2'];
    country = json['country'];
    state = json['state'];
    city = json['city'];
    pincode = json['pincode'];
    deviceAllocationApplicatioIds = json['deviceAllocationApplicatioIds'];
    deviceAllocationApplicatioNames = json['deviceAllocationApplicatioNames'];
    user = json['user'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tenantId'] = this.tenantId;
    data['tenantName'] = this.tenantName;
    data['tenantDescription'] = this.tenantDescription;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['email'] = this.email;
    data['contactNo'] = this.contactNo;
    data['createdDate'] = this.createdDate;
    data['address'] = this.address;
    data['address1'] = this.address1;
    data['isSystem'] = this.isSystem;
    data['systemLabel'] = this.systemLabel;
    data['systemLogoDark'] = this.systemLogoDark;
    data['systemLogoLight'] = this.systemLogoLight;
    data['address2'] = this.address2;
    data['country'] = this.country;
    data['state'] = this.state;
    data['city'] = this.city;
    data['pincode'] = this.pincode;
    data['deviceAllocationApplicatioIds'] = this.deviceAllocationApplicatioIds;
    data['deviceAllocationApplicatioNames'] =
        this.deviceAllocationApplicatioNames;
    data['user'] = this.user;
    return data;
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
