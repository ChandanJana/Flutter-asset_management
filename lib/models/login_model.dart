import 'package:mindteck_iot/resource/app_database.dart';

class LoginModel {
  const LoginModel({
    required this.id,
    required this.email,
    required this.token,
    required this.firstName,
    required this.lastName,
    required this.contactNumber,
    required this.registrationDate,
    required this.lastLogin,
    // required this.isActive,
    required this.roleId,
    required this.roleName,
  });

  final String id;
  final String token;
  final String email;
  final String firstName;
  final String lastName;
  final String? contactNumber;
  final String registrationDate;
  final String lastLogin;

  // final bool isActive;
  final String? roleName;
  final String? roleId;

  /// A factory constructor is a constructor that doesn't create a new
  /// instance of the class every time it's called. Instead, it returns an
  /// existing instance of the class or a different instance based on some
  /// logic within the constructor itself. Factory constructors are commonly
  /// used in situations where you want to control the creation of objects or
  /// return cached instances to optimize memory usage.

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
      id: json[AppDatabase.userId],
      token: json[AppDatabase.token],
      email: json[AppDatabase.email],
      firstName: json[AppDatabase.firstName],
      lastName: json[AppDatabase.lastName],
      contactNumber: json[AppDatabase.contactNumber],
      registrationDate: json[AppDatabase.registrationDate],
      lastLogin: json[AppDatabase.lastLogin],
      // isActive: json[AppDatabase.isActive],
      roleName: json[AppDatabase.roleName],
      roleId: json[AppDatabase.roleId]);

  Map<String, dynamic> toJson() => {
        AppDatabase.userId: id,
        AppDatabase.token: token,
        AppDatabase.email: email,
        AppDatabase.firstName: firstName,
        AppDatabase.lastName: lastName,
        AppDatabase.contactNumber: contactNumber,
        AppDatabase.registrationDate: registrationDate,
        AppDatabase.lastLogin: lastLogin,
        // AppDatabase.isActive: isActive,
        AppDatabase.roleName: roleName,
        AppDatabase.roleId: roleId,
      };

  @override
  String toString() {
    return toJson().toString();
  }
}
