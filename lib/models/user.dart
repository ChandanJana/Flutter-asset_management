/// Created by Chandan Jana on 13-02-2024.
/// Company name: Mindteck
/// Email: chandan.jana@mindteck.com

class User {
  String? userId;
  String? password;
  String? email;
  String? firstName;
  String? lastName;
  String? contactNumber;
  String? registrationDate;
  String? lastLogin;
  bool? isActive;
  String? roleName;
  String? roleId;
  String? tenantId;
  bool? isSystem;

  User(
      {this.userId,
      this.password,
      this.email,
      this.firstName,
      this.lastName,
      this.contactNumber,
      this.registrationDate,
      this.lastLogin,
      this.isActive,
      this.roleName,
      this.roleId,
      this.tenantId,
      this.isSystem});

  User.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    password = json['password'];
    email = json['email'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    contactNumber = json['contactNumber'];
    registrationDate = json['registrationDate'];
    lastLogin = json['lastLogin'];
    isActive = json['isActive'];
    roleName = json['roleName'];
    roleId = json['roleId'];
    tenantId = json['tenantId'];
    isSystem = json['isSystem'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['password'] = this.password;
    data['email'] = this.email;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['contactNumber'] = this.contactNumber;
    data['registrationDate'] = this.registrationDate;
    data['lastLogin'] = this.lastLogin;
    data['isActive'] = this.isActive;
    data['roleName'] = this.roleName;
    data['roleId'] = this.roleId;
    data['tenantId'] = this.tenantId;
    data['isSystem'] = this.isSystem;
    return data;
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
