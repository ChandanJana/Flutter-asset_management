/// Created by Chandan Jana on 27-02-2024.
/// Company name: Mindteck
/// Email: chandan.jana@mindteck.com
///

class PermissionData {
  String? featureIdentifier;
  bool? read;
  bool? write;
  String? componentId;
  String? componentName;
  String? subComponentId;
  String? subComponentName;
  String? featureID;
  String? featureName;
  String? permissionId;
  String? permissionName;
  String? roleId;
  String? roleName;

  PermissionData(
      {this.featureIdentifier,
      this.read,
      this.write,
      this.componentId,
      this.componentName,
      this.subComponentId,
      this.subComponentName,
      this.featureID,
      this.featureName,
      this.permissionId,
      this.permissionName,
      this.roleId,
      this.roleName});

  PermissionData.fromJson(Map<String, dynamic> json) {
    featureIdentifier = json['featureIdentifier'];
    read = json['read'];
    write = json['write'];
    componentId = json['componentId'];
    componentName = json['componentName'];
    subComponentId = json['subComponentId'];
    subComponentName = json['subComponentName'];
    featureID = json['featureID'];
    featureName = json['featureName'];
    permissionId = json['permissionId'];
    permissionName = json['permissionName'];
    roleId = json['roleId'];
    roleName = json['roleName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['featureIdentifier'] = this.featureIdentifier;
    data['read'] = this.read;
    data['write'] = this.write;
    data['componentId'] = this.componentId;
    data['componentName'] = this.componentName;
    data['subComponentId'] = this.subComponentId;
    data['subComponentName'] = this.subComponentName;
    data['featureID'] = this.featureID;
    data['featureName'] = this.featureName;
    data['permissionId'] = this.permissionId;
    data['permissionName'] = this.permissionName;
    data['roleId'] = this.roleId;
    data['roleName'] = this.roleName;
    return data;
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
