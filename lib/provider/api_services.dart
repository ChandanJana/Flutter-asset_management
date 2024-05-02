import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:mindteck_iot/models/application/application_model.dart';
import 'package:mindteck_iot/models/asset/asset_data.dart';
import 'package:mindteck_iot/models/deallocation_reason_data.dart';
import 'package:mindteck_iot/models/device/device_model.dart';
import 'package:mindteck_iot/models/notification_data.dart';
import 'package:mindteck_iot/models/pieChart/pie_chart_model.dart';
import 'package:mindteck_iot/models/site/site_data.dart';
import 'package:mindteck_iot/models/site/site_model.dart';
import 'package:mindteck_iot/models/site_level/site_level_data.dart';
import 'package:mindteck_iot/models/site_level/site_level_model.dart';
import 'package:mindteck_iot/models/tenant/tenant_data.dart';
import 'package:mindteck_iot/models/tenant/tenant_model.dart';
import 'package:mindteck_iot/models/top_ten_device_data.dart';
import 'package:mindteck_iot/resource/app_api.dart';
import 'package:mindteck_iot/resource/app_api_key.dart';

import '../models/allocation/allocation_data.dart';
import '../models/allocation/allocation_model.dart';
import '../models/application/application_data.dart';
import '../models/asset/asset_model.dart';
import '../models/asset_detail_data.dart';
import '../models/asset_detail_model.dart';
import '../models/category/category_data.dart';
import '../models/category/category_model.dart';
import '../models/deallocation_reason_model.dart';
import '../models/device/device_data.dart';
import '../models/level_image_data.dart';
import '../models/level_image_model.dart';
import '../models/pieChart/pie_chart_tenant_entities.dart';
import '../models/response_model.dart';
import '../models/status/status_data.dart';
import '../models/status/status_model.dart';
import '../models/top_ten_device_model.dart';
import '../models/trace_history_data.dart';
import '../models/trace_history_model.dart';
import '../models/unitMeasurement/unit_measurement_data.dart';
import '../models/unitMeasurement/unit_measurement_model.dart';
import '../models/up_time_model.dart';
import '../resource/app_database.dart';

class ApiServices {
  DeviceData? deviceData;
  SiteData? siteData;
  AssetData? assetData;
  TenantData? tenantData;

  // Future<bool> login({required email, required password}) async {
  //   const String loginUrl = AppApi.loginApi;
  //
  //   if (kDebugMode) {
  //     print('User login url $loginUrl');
  //   }
  //   final Map<String, String> headers = {
  //     AppApiKey.contentTypeKey: AppApiKey.contentTypeValue,
  //     AppApiKey.acceptKey: AppApiKey.acceptValue,
  //     // Add other headers as needed, e.g., 'Authorization'
  //   };
  //   final Map<String, dynamic> body = {
  //     AppApiKey.email: email,
  //     AppApiKey.password: password,
  //   };
  //   final response = await http.post(
  //     Uri.parse(loginUrl),
  //     headers: headers,
  //     body: json.encode(body),
  //   );
  //
  //   if (response.statusCode == 200) {
  //     // Login was successful
  //     final responseBody = json.decode(response.body);
  //     if (kDebugMode) {
  //       print('User Login successful. $responseBody');
  //     }
  //
  //     LoginResponseModel loginModel = LoginResponseModel.fromJson(responseBody);
  //
  //     if (loginModel.responseMessage == 'Login successful') {
  //       String tempId = const Uuid().v4();
  //       // int insertId = await DatabaseHelper().insert({
  //       //   AppDatabase.userId: tempId,
  //       //   AppDatabase.email: email,
  //       //   AppDatabase.token: loginModel.token,
  //       //   AppDatabase.name: loginModel.user!.firstName,
  //       // });
  //
  //       // if (kDebugMode) {
  //       //   print('User insertId: $insertId');
  //       // }
  //       // Create storage
  //       const storage = FlutterSecureStorage();
  //       // Write token value
  //       // await storage.write(key: AppDatabase.token, value: loginModel.token);
  //
  //       return true;
  //     } else {
  //       // Login failed
  //       if (kDebugMode) {
  //         print('User Login failed. Status code: ${response.statusCode}');
  //       }
  //       return false;
  //     }
  //   }
  //   return false;
  // }
  // Future<List<PermissionModel>> getRolePermission({required String userId}) async {
  //   if (userId != null) {
  //     /// Here we getting/fetch data from server
  //     String zoneUrl =
  //         '${AppApi.GetRolePermissionByUserId}${userId}';
  //
  //     // Create storage
  //     const storage = FlutterSecureStorage();
  //     // Read token value
  //     String? authToken = await storage.read(key: AppDatabase.token);
  //
  //     final Map<String, String> headers = {
  //       AppApiKey.contentTypeKey: AppApiKey.contentTypeValue,
  //       AppApiKey.acceptKey: AppApiKey.acceptValue,
  //       AppApiKey.authorizationKey: '${AppApiKey.bearer}$authToken'
  //       // Add other headers as needed, e.g., 'Authorization'
  //     };
  //
  //     final response = await http.get(Uri.parse(zoneUrl), headers: headers);
  //     if (response.statusCode == 200) {
  //       List responseBody = json.decode(response.body);
  //       List<PermissionModel> _permissionModel = responseBody.map((featureIdentifier) =>
  //           PermissionModel.fromJson(featureIdentifier)).toList();
  //
  //       return _permissionModel;
  //
  //     }else {
  //       throw Exception(
  //           'Failed to fetch data. Please try again later! ${response.reasonPhrase}');
  //     }
  //     }
  //   else{
  //     throw Exception('Failed to fetch data. Please try again later!');
  //   }
  // }

  Future<List<AssetData>> loadAllAsset() async {
    /// Here we getting/fetch data from server
    const String zoneUrl = AppApi.getAllAssetsApi;

    // Create storage
    const storage = FlutterSecureStorage();
    // Read token value
    String? authToken = await storage.read(key: AppDatabase.token);
    if (kDebugMode) {
      print('authToken $authToken');
    }

    final Map<String, String> headers = {
      AppApiKey.contentTypeKey: AppApiKey.contentTypeValue,
      AppApiKey.acceptKey: AppApiKey.acceptValue,
      AppApiKey.authorizationKey: '${AppApiKey.bearer}$authToken'
      // Add other headers as needed, e.g., 'Authorization'
    };
    if (kDebugMode) {
      print('zoneUrl $zoneUrl');
      print('headers $headers');
    }

    final response = await http.get(Uri.parse(zoneUrl), headers: headers);
    if (kDebugMode) {
      print('response.statusCode ${response.statusCode}');
    }
    if (response.statusCode == 200) {
      Map<String, dynamic> responseBody = json.decode(response.body);
      print("GetDeviceResponseBody. $responseBody");
      AssetModel assetModel = AssetModel.fromJson(responseBody);
      List<AssetData> assetList = [];
      try {
        assetList = assetModel.data;
      } catch (e) {}
      if (kDebugMode) {
        print('Zone fetch. $responseBody');
      }
      return assetList;
    } else {
      throw Exception(
          'Failed to fetch data. Please try again later! ${response.reasonPhrase}');
    }
  }

  Future<List<PieChartTenantEntities>> loadPieChartData() async {
    /// Here we getting/fetch data from server
    const String pieChartUrl = AppApi.getTenantDashboardSummaryApi;

    // Create storage
    const storage = FlutterSecureStorage();
    // Read token value
    String? authToken = await storage.read(key: AppDatabase.token);
    if (kDebugMode) {
      print('authToken $authToken');
    }

    final Map<String, String> headers = {
      AppApiKey.contentTypeKey: AppApiKey.contentTypeValue,
      AppApiKey.acceptKey: AppApiKey.acceptValue,
      AppApiKey.authorizationKey: '${AppApiKey.bearer}$authToken'
      // Add other headers as needed, e.g., 'Authorization'
    };
    if (kDebugMode) {
      print('pieChartUrl $pieChartUrl');
      print('headers $headers');
    }

    final response = await http.get(Uri.parse(pieChartUrl), headers: headers);
    if (kDebugMode) {
      print('response.statusCode ${response.statusCode}');
    }
    if (response.statusCode == 200) {
      Map<String, dynamic> responseBody = json.decode(response.body);
      print("GetDeviceResponseBody. $responseBody");
      PieChartModel pieChartModel = PieChartModel.fromJson(responseBody);
      List<PieChartTenantEntities> tenantEntitiesList = [];
      try {
        tenantEntitiesList = pieChartModel.data!.tenantEntities;
      } catch (e) {}

      if (kDebugMode) {
        print('Zone fetch. $responseBody');
      }
      return tenantEntitiesList;
    } else {
      throw Exception(
          'Failed to fetch pie chart data. Please try again later! ${response.reasonPhrase}');
    }
  }

  Future<List<DeviceData>> loadAllDevice() async {
    const String devicelistUrl = AppApi.getDeviceListApi;

    // Create storage
    const storage = FlutterSecureStorage();

    // Read token value
    String? authToken = await storage.read(key: AppDatabase.token);
    if (kDebugMode) {
      print('authToken $authToken');
    }

    final Map<String, String> headers = {
      AppApiKey.contentTypeKey: AppApiKey.contentTypeValue,
      AppApiKey.acceptKey: AppApiKey.acceptValue,
      AppApiKey.authorizationKey: '${AppApiKey.bearer}$authToken',
      // Add other headers as needed, e.g., 'Authorization'
    };

    if (kDebugMode) {
      print('deviceListurl $devicelistUrl');
      print('headers $headers');
    }

    final response = await http.get(Uri.parse(devicelistUrl), headers: headers);
    if (kDebugMode) {
      print('response.statusCode ${response.statusCode}');
    }

    if (response.statusCode == 200) {
      Map<String, dynamic> responseBody = json.decode(response.body);
      print("GetDeviceResponseBody. $responseBody");
      DeviceModel getDeviceModel = DeviceModel.fromJson(responseBody);
      List<DeviceData> deviceList = getDeviceModel.data;

      if (kDebugMode) {
        print('Device fetch. $responseBody');
      }

      return deviceList;
    } else {
      throw Exception(
          'Failed to fetch data. Please try again later! ${response.reasonPhrase}');
    }
  }

  Future<List<ApplicationData>> loadAllApplications() async {
    const String applicationlistUrl = AppApi.getApplicationListApi;

    // Create storage
    const storage = FlutterSecureStorage();

    // Read token value
    String? authToken = await storage.read(key: AppDatabase.token);
    if (kDebugMode) {
      print('authToken $authToken');
    }

    final Map<String, String> headers = {
      AppApiKey.contentTypeKey: AppApiKey.contentTypeValue,
      AppApiKey.acceptKey: AppApiKey.acceptValue,
      AppApiKey.authorizationKey: '${AppApiKey.bearer}$authToken',
      // Add other headers as needed, e.g., 'Authorization'
    };

    if (kDebugMode) {
      print('applicationUrl $applicationlistUrl');
      print('headers $headers');
    }

    final response =
        await http.get(Uri.parse(applicationlistUrl), headers: headers);
    if (kDebugMode) {
      print('response.statusCode ${response.statusCode}');
    }

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      print("GetApplicationResponseBody. $responseBody");
      ApplicationModel getApplicationModel =
          ApplicationModel.fromJson(responseBody);

      List<ApplicationData> applicationList = getApplicationModel.data;

      if (kDebugMode) {
        print('Application fetch. $responseBody');
      }

      return applicationList;
    } else {
      throw Exception(
          'Failed to fetch data. Please try again later! ${response.reasonPhrase}');
    }
  }

  Future<List<SiteData>> loadAllSites() async {
    const String sitelistUrl = AppApi.getSiteApi;

    // Create storage
    const storage = FlutterSecureStorage();

    // Read token value
    String? authToken = await storage.read(key: AppDatabase.token);
    if (kDebugMode) {
      print('authToken $authToken');
    }

    final Map<String, String> headers = {
      AppApiKey.contentTypeKey: AppApiKey.contentTypeValue,
      AppApiKey.acceptKey: AppApiKey.acceptValue,
      AppApiKey.authorizationKey: '${AppApiKey.bearer}$authToken',
      // Add other headers as needed, e.g., 'Authorization'
    };

    if (kDebugMode) {
      print('sitelistUrl $sitelistUrl');
      print('headers $headers');
    }

    final response = await http.get(Uri.parse(sitelistUrl), headers: headers);
    if (kDebugMode) {
      print('response.statusCode ${response.statusCode}');
    }

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      print("GetSiteResponseBody. $responseBody");
      SiteModel getSiteModel = SiteModel.fromJson(responseBody);

      List<SiteData> siteList = getSiteModel.data;

      if (kDebugMode) {
        print('Site fetch. $responseBody');
      }

      return siteList;
    } else {
      throw Exception(
          'Failed to fetch Site data. Please try again later! ${response.reasonPhrase}');
    }
  }

  Future<ResponseModel> loadAverageUpTime() async {
    const String upTimeUrl = AppApi.getUptimeApi;

    // Create storage
    const storage = FlutterSecureStorage();

    // Read token value
    String? authToken = await storage.read(key: AppDatabase.token);
    if (kDebugMode) {
      print('authToken $authToken');
    }

    final Map<String, String> headers = {
      AppApiKey.contentTypeKey: AppApiKey.contentTypeValue,
      AppApiKey.acceptKey: AppApiKey.acceptValue,
      AppApiKey.authorizationKey: '${AppApiKey.bearer}$authToken',
      // Add other headers as needed, e.g., 'Authorization'
    };

    if (kDebugMode) {
      print('upTimeUrl $upTimeUrl');
      print('headers $headers');
    }

    final response = await http.get(Uri.parse(upTimeUrl), headers: headers);
    if (kDebugMode) {
      print('response.statusCode ${response.statusCode}');
    }

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      print("Average Up Time ResponseBody. $responseBody");
      ResponseModel responseModel = ResponseModel.fromJson(responseBody);

      if (kDebugMode) {
        print('Up Time. $responseModel');
      }

      return responseModel;
      /* SiteModel getSiteModel = SiteModel.fromJson(responseBody);

      List<SiteData> siteList = getSiteModel.data;

      if (kDebugMode) {
        print('Site fetch. $responseBody');
      }

      return siteList;*/
    } else {
      throw Exception(
          'Failed to fetch Up Time data. Please try again later! ${response.reasonPhrase}');
    }
  }

  Future<List<NotificationData>> loadNotificationCount() async {
    const String notificationsCountUrl = AppApi.getNotificationsCountApi;

    // Create storage
    const storage = FlutterSecureStorage();

    // Read token value
    String? authToken = await storage.read(key: AppDatabase.token);
    if (kDebugMode) {
      print('authToken $authToken');
    }

    final Map<String, String> headers = {
      AppApiKey.contentTypeKey: AppApiKey.contentTypeValue,
      AppApiKey.acceptKey: AppApiKey.acceptValue,
      AppApiKey.authorizationKey: '${AppApiKey.bearer}$authToken',
      // Add other headers as needed, e.g., 'Authorization'
    };

    if (kDebugMode) {
      print('notificationsCountUrl $notificationsCountUrl');
      print('headers $headers');
    }

    final response =
        await http.get(Uri.parse(notificationsCountUrl), headers: headers);
    if (kDebugMode) {
      print('response.statusCode ${response.statusCode}');
    }

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      print("Average Up Time ResponseBody. $responseBody");
      UpTimeModel upTimeModel = UpTimeModel.fromJson(responseBody);
      List<NotificationData> notificationList = upTimeModel.data;
      if (kDebugMode) {
        print('Up Time. $notificationList');
      }

      return notificationList;
    } else {
      throw Exception(
          'Failed to fetch notification data. Please try again later! ${response.reasonPhrase}');
    }
  }

  Future<List<TopTenDeviceData>> loadTopTenDevicesTime() async {
    const String topTenDevicesUrl = AppApi.getTopTenDevicesApi;

    // Create storage
    const storage = FlutterSecureStorage();

    // Read token value
    String? authToken = await storage.read(key: AppDatabase.token);
    if (kDebugMode) {
      print('authToken $authToken');
    }

    final Map<String, String> headers = {
      AppApiKey.contentTypeKey: AppApiKey.contentTypeValue,
      AppApiKey.acceptKey: AppApiKey.acceptValue,
      AppApiKey.authorizationKey: '${AppApiKey.bearer}$authToken',
      // Add other headers as needed, e.g., 'Authorization'
    };

    if (kDebugMode) {
      print('topTenDevicesUrl $topTenDevicesUrl');
      print('headers $headers');
    }

    final response =
        await http.get(Uri.parse(topTenDevicesUrl), headers: headers);
    if (kDebugMode) {
      print('response.statusCode ${response.statusCode}');
    }

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      print("Average Up Time ResponseBody. $responseBody");
      TopTenDeviceModel topTenDeviceModel =
          TopTenDeviceModel.fromJson(responseBody);

      List<TopTenDeviceData> topTenDeviceDataList = topTenDeviceModel.data;

      if (kDebugMode) {
        print('topTenDeviceDataList fetch. $topTenDeviceDataList');
      }

      return topTenDeviceDataList;
    } else {
      throw Exception(
          'Failed to fetch Top Ten Device. Please try again later! ${response.reasonPhrase}');
    }
  }

  Future<List<CategoryData>> loadDeviceCategory() async {
    const String deviceCategoryListUrl = AppApi.getDeviceCategory;

    // Create storage
    const storage = FlutterSecureStorage();

    // Read token value
    String? authToken = await storage.read(key: AppDatabase.token);
    if (kDebugMode) {
      print('authToken $authToken');
    }

    final Map<String, String> headers = {
      AppApiKey.contentTypeKey: AppApiKey.contentTypeValue,
      AppApiKey.acceptKey: AppApiKey.acceptValue,
      AppApiKey.authorizationKey: '${AppApiKey.bearer}$authToken',
    };

    if (kDebugMode) {
      print('deviceCategoryListurl $deviceCategoryListUrl');
      print('headers $headers');
    }

    final response =
        await http.get(Uri.parse(deviceCategoryListUrl), headers: headers);
    if (kDebugMode) {
      print('response.statusCode ${response.statusCode}');
    }

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      print("Device Category. $responseBody");
      CategoryModel getCategoryModel = CategoryModel.fromJson(responseBody);

      List<CategoryData> deviceCategoryList = getCategoryModel.data;

      if (kDebugMode) {
        print('Device categories fetched. $deviceCategoryList');
      }

      return deviceCategoryList;
    } else {
      throw Exception(
          'Failed to fetch device categories. Please try again later! ${response.reasonPhrase}');
    }
  }

  Future<List<StatusData>> loadDeviceStatus() async {
    //try {
    const String devicestatusListUrl = AppApi.getDeviceLifeCycle;

    // Create storage
    const storage = FlutterSecureStorage();

    // Read token value
    String? authToken = await storage.read(key: AppDatabase.token);
    if (kDebugMode) {
      print('authToken $authToken');
    }

    final Map<String, String> headers = {
      AppApiKey.contentTypeKey: AppApiKey.contentTypeValue,
      AppApiKey.acceptKey: AppApiKey.acceptValue,
      AppApiKey.authorizationKey: '${AppApiKey.bearer}$authToken',
    };

    if (kDebugMode) {
      print('deviceStatusListurl $devicestatusListUrl');
      print('headers $headers');
    }

    final response =
        await http.get(Uri.parse(devicestatusListUrl), headers: headers);
    if (kDebugMode) {
      print('response.statusCode ${response.statusCode}');
    }

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      print("Status body. $responseBody");
      StatusModel getStatusModel = StatusModel.fromJson(responseBody);

      List<StatusData> deviceStatusList = getStatusModel.data;

      if (kDebugMode) {
        print('Device categories fetched. $deviceStatusList');
      }

      return deviceStatusList;
    } else {
      throw Exception(
          'Failed to fetch device categories. Please try again later! ${response.reasonPhrase}');
    }
    /*} catch (e) {
      ServerErrorPopup.showServerError(this.context, '$e');
      print('Error: $e');
      return null;
    }*/
  }

  Future<List<TenantData>> loadAllTenant() async {
    //try {
    const String tenantUrl = AppApi.getAllTenantsApi;

    // Create storage
    const storage = FlutterSecureStorage();

    // Read token value
    String? authToken = await storage.read(key: AppDatabase.token);
    if (kDebugMode) {
      print('authToken $authToken');
    }

    final Map<String, String> headers = {
      AppApiKey.contentTypeKey: AppApiKey.contentTypeValue,
      AppApiKey.acceptKey: AppApiKey.acceptValue,
      AppApiKey.authorizationKey: '${AppApiKey.bearer}$authToken',
    };

    if (kDebugMode) {
      print('tenantUrl $tenantUrl');
      print('headers $headers');
    }

    final response = await http.get(Uri.parse(tenantUrl), headers: headers);
    if (kDebugMode) {
      print('Tenant response statusCode ${response.statusCode}');
    }

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      print("Tenant ResponseBody. $responseBody");
      TenantModel tenantModel = TenantModel.fromJson(responseBody);

      List<TenantData> tenantList = tenantModel.data;

      if (kDebugMode) {
        print('Tenant fetched. $tenantList');
      }

      return tenantList;
    } else {
      throw Exception(
          'Failed to fetch tenant. Please try again later! ${response.reasonPhrase}');
    }
    /*} catch (e) {
      ServerErrorPopup.showServerError(this.context, '$e');
      print('Error: $e');
      return null;
    }*/
  }

  Future<ResponseModel> addDevice(DeviceData data) async {
    const String addDeviceUrl = AppApi.addDeviceApi;

    // Create storage
    const storage = FlutterSecureStorage();

    // Read token value
    String? authToken = await storage.read(key: AppDatabase.token);
    if (kDebugMode) {
      print('authToken $authToken');
    }

    final Map<String, String> headers = {
      AppApiKey.contentTypeKey: AppApiKey.contentTypeValue,
      AppApiKey.acceptKey: AppApiKey.acceptValue,
      AppApiKey.authorizationKey: '${AppApiKey.bearer}$authToken',
    };

    final Map<String, dynamic> body = {
      AppApiKey.deviceCategoryId: data.deviceCategoryId,
      AppApiKey.deviceName: data.deviceName,
      AppApiKey.deviceSerialNumber: data.deviceSerialNumber,
      AppApiKey.deviceHardwareId: data.deviceHardwareId,
      AppApiKey.uomid: data.uomid,
      AppApiKey.upperLimit: data.upperLimit,
      AppApiKey.lowerLimit: data.lowerLimit,
      AppApiKey.deviceLifeCycleId: data.deviceLifeCycleId,
      AppApiKey.deviceLifeCycleName: data.deviceLifeCycleName,
      AppApiKey.thresholdValue: data.thresholdValue,
      AppApiKey.isSensor: data.isSensor,
      AppApiKey.isActive: data.isActive,
      AppApiKey.tenantId: data.tenantId,
    };
    final response = await http.post(
      Uri.parse(addDeviceUrl),
      headers: headers,
      body: json.encode(body),
    );

    if (kDebugMode) {
      print('response.statusCode ${response.statusCode}');
    }

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      print("Add Device ResponseBody. $responseBody");
      ResponseModel responseModel = ResponseModel.fromJson(responseBody);

      if (kDebugMode) {
        print('Device added. $responseModel');
      }

      return responseModel;
    } else {
      throw Exception(
          'Failed to add device. Please try again later! ${response.reasonPhrase}');
    }
  }

  Future<ResponseModel> sendMail(String email) async {
    String forgetPasswordUrl =
        '${AppApi.forgotPasswordApi}${AppApiKey.userEmail}=$email';
    if (kDebugMode) {
      print('forgetPasswordUrl $forgetPasswordUrl');
    }
    final response = await http.post(Uri.parse(forgetPasswordUrl));

    if (kDebugMode) {
      print('response.statusCode ${response.statusCode}');
    }

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      print("Send Email ResponseBody. $responseBody");
      ResponseModel responseModel = ResponseModel.fromJson(responseBody);

      if (kDebugMode) {
        print('Send Email. $responseModel');
      }

      return responseModel;
    } else {
      throw Exception(
          'Failed to Send Email. Please try again later! ${response.reasonPhrase}');
    }
  }

  Future<ResponseModel> editDevice(DeviceData data) async {
    const String editDeviceUrl = AppApi.updateDeviceApi;

    // Create storage
    const storage = FlutterSecureStorage();

    // Read token value
    String? authToken = await storage.read(key: AppDatabase.token);
    if (kDebugMode) {
      print('editDeviceUrl $editDeviceUrl');
      print('authToken $authToken');
    }

    final Map<String, String> headers = {
      AppApiKey.contentTypeKey: AppApiKey.contentTypeValue,
      AppApiKey.acceptKey: AppApiKey.acceptValue,
      AppApiKey.authorizationKey: '${AppApiKey.bearer}$authToken',
    };

    final Map<String, dynamic> body = {
      AppApiKey.deviceId: data.deviceId,
      AppApiKey.deviceCategoryId: data.deviceCategoryId,
      AppApiKey.deviceName: data.deviceName,
      AppApiKey.deviceSerialNumber: data.deviceSerialNumber,
      AppApiKey.deviceHardwareId: data.deviceHardwareId,
      AppApiKey.uomid: data.uomid,
      AppApiKey.upperLimit: data.upperLimit,
      AppApiKey.lowerLimit: data.lowerLimit,
      AppApiKey.deviceLifeCycleId: data.deviceLifeCycleId,
      AppApiKey.deviceLifeCycleName: data.deviceLifeCycleName,
      AppApiKey.deviceCategoryName: data.deviceCategoryName,
      AppApiKey.thresholdValue: data.thresholdValue,
      AppApiKey.isSensor: data.isSensor,
      AppApiKey.isActive: data.isActive,
      AppApiKey.uomName: data.uomName,
      AppApiKey.tenantId: data.tenantId,
      AppApiKey.tenantName: data.tenantName,
    };
    print('request body $body');
    final response = await http.post(
      Uri.parse(editDeviceUrl),
      headers: headers,
      body: json.encode(body),
    );

    if (kDebugMode) {
      print('response.statusCode ${response.statusCode}');
    }

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      print("Edit Device ResponseBody. $responseBody");
      ResponseModel responseModel = ResponseModel.fromJson(responseBody);

      if (kDebugMode) {
        print('Device edited. $responseModel');
      }

      return responseModel;
    } else {
      throw Exception(
          'Failed to edit device. Please try again later! ${response.reasonPhrase}');
    }
  }

  Future<ResponseModel> addDeviceAllocation(Map<String, dynamic> data) async {
    const String addDeviceAllocationUrl = AppApi.addAllocationApi;

    // Create storage
    const storage = FlutterSecureStorage();

    // Read token value
    String? authToken = await storage.read(key: AppDatabase.token);
    if (kDebugMode) {
      print('authToken $authToken');
      print('addDeviceAllocationUrl $addDeviceAllocationUrl');
    }

    final Map<String, String> headers = {
      AppApiKey.contentTypeKey: AppApiKey.contentTypeValue,
      AppApiKey.acceptKey: AppApiKey.acceptValue,
      AppApiKey.authorizationKey: '${AppApiKey.bearer}$authToken',
    };

    final response = await http.post(
      Uri.parse(addDeviceAllocationUrl),
      headers: headers,
      body: json.encode(data),
    );

    if (kDebugMode) {
      print('response.statusCode ${response.statusCode}');
    }

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      print("Add Allocation ResponseBody. $responseBody");
      ResponseModel responseModel = ResponseModel.fromJson(responseBody);

      if (kDebugMode) {
        print('Device allocated. $responseModel');
      }

      return responseModel;
    } else {
      throw Exception(
          'Failed to allocate. Please try again later! ${response.reasonPhrase}');
    }
  }

  Future<ResponseModel> editDeviceAllocation(Map<String, dynamic> data) async {
    const String editAllocationUrl = AppApi.editAllocationApi;

    // Create storage
    const storage = FlutterSecureStorage();

    // Read token value
    String? authToken = await storage.read(key: AppDatabase.token);
    if (kDebugMode) {
      print('authToken $authToken');
      print('editAllocationUrl $editAllocationUrl');
    }

    final Map<String, String> headers = {
      AppApiKey.contentTypeKey: AppApiKey.contentTypeValue,
      AppApiKey.acceptKey: AppApiKey.acceptValue,
      AppApiKey.authorizationKey: '${AppApiKey.bearer}$authToken',
    };

    final response = await http.post(
      Uri.parse(editAllocationUrl),
      headers: headers,
      body: json.encode(data),
    );

    if (kDebugMode) {
      print('response.statusCode ${response.statusCode}');
    }

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      print("Edit Allocation ResponseBody. $responseBody");
      ResponseModel responseModel = ResponseModel.fromJson(responseBody);

      if (kDebugMode) {
        print('Device allocated. $responseModel');
      }

      return responseModel;
    } else {
      throw Exception(
          'Failed to edit allocation. Please try again later! ${response.reasonPhrase}');
    }
  }

  Future<ResponseModel> removeDeviceAllocation(
      Map<String, dynamic> data) async {
    const String removeDeviceAllocationUrl = AppApi.removeDeviceAllocationApi;

    // Create storage
    const storage = FlutterSecureStorage();

    // Read token value
    String? authToken = await storage.read(key: AppDatabase.token);
    if (kDebugMode) {
      print('authToken $authToken');
      print('removeDeviceAllocationUrl $removeDeviceAllocationUrl');
    }

    final Map<String, String> headers = {
      AppApiKey.contentTypeKey: AppApiKey.contentTypeValue,
      AppApiKey.acceptKey: AppApiKey.acceptValue,
      AppApiKey.authorizationKey: '${AppApiKey.bearer}$authToken',
    };

    final response = await http.post(
      Uri.parse(removeDeviceAllocationUrl),
      headers: headers,
      body: json.encode(data),
    );

    if (kDebugMode) {
      print('remove response.statusCode ${response.statusCode}');
    }

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      print("Remove Allocation ResponseBody. $responseBody");
      ResponseModel responseModel = ResponseModel.fromJson(responseBody);

      if (kDebugMode) {
        print('Device deallocated. $responseModel');
      }

      return responseModel;
    } else {
      throw Exception(
          'Failed to remove allocation. Please try again later! ${response.reasonPhrase}');
    }
  }

  Future<List<UnitOfMeasurementData>> loadAllUOM() async {
    //try {
    const String uomUrl = AppApi.getUnitMasterApi;

    // Create storage
    const storage = FlutterSecureStorage();

    // Read token value
    String? authToken = await storage.read(key: AppDatabase.token);
    if (kDebugMode) {
      print('authToken $authToken');
    }

    final Map<String, String> headers = {
      AppApiKey.contentTypeKey: AppApiKey.contentTypeValue,
      AppApiKey.acceptKey: AppApiKey.acceptValue,
      AppApiKey.authorizationKey: '${AppApiKey.bearer}$authToken',
    };

    if (kDebugMode) {
      print('uomUrl $uomUrl');
      print('headers $headers');
    }

    final response = await http.get(Uri.parse(uomUrl), headers: headers);
    if (kDebugMode) {
      print('UOM response statusCode ${response.statusCode}');
    }

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      print("UOM ResponseBody. $responseBody");
      UnitOfMeasurementModel unitOfMeasurementModel =
          UnitOfMeasurementModel.fromJson(responseBody);

      List<UnitOfMeasurementData> uomList = unitOfMeasurementModel.data;

      if (kDebugMode) {
        print('UOM fetched. $uomList');
      }

      return uomList;
    } else {
      throw Exception(
          'Failed to fetch UOM. Please try again later! ${response.reasonPhrase}');
    }
    /*} catch (e) {
      ServerErrorPopup.showServerError(this.context, '$e');
      print('Error: $e');
      return null;
    }*/
  }

  Future<List<AllocationData>> loadAllAllocation() async {
    //try {
    const String allocationUrl = AppApi.getAllocationApi;

    // Create storage
    const storage = FlutterSecureStorage();

    // Read token value
    String? authToken = await storage.read(key: AppDatabase.token);
    if (kDebugMode) {
      print('authToken $authToken');
    }

    final Map<String, String> headers = {
      AppApiKey.contentTypeKey: AppApiKey.contentTypeValue,
      AppApiKey.acceptKey: AppApiKey.acceptValue,
      AppApiKey.authorizationKey: '${AppApiKey.bearer}$authToken',
    };

    if (kDebugMode) {
      print('allocationUrl $allocationUrl');
      print('headers $headers');
    }

    final response = await http.get(Uri.parse(allocationUrl), headers: headers);
    if (kDebugMode) {
      print('Allocation response statusCode ${response.statusCode}');
    }

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      print("Allocation ResponseBody. $responseBody");
      AllocationModel allocationModel = AllocationModel.fromJson(responseBody);

      List<AllocationData> allocationList = allocationModel.data;

      if (kDebugMode) {
        print('Allocation fetched. $allocationList');
      }

      return allocationList;
    } else {
      throw Exception(
          'Failed to fetch Allocation. Please try again later! ${response.reasonPhrase}');
    }
    /*} catch (e) {
      ServerErrorPopup.showServerError(this.context, '$e');
      print('Error: $e');
      return null;
    }*/
  }

  Future<List<DeviceData>> loadDeviceForAllocation() async {
    //try {
    const String getDeviceForAllocationUrl = AppApi.getDeviceForAllocationApi;

    // Create storage
    const storage = FlutterSecureStorage();

    // Read token value
    String? authToken = await storage.read(key: AppDatabase.token);
    if (kDebugMode) {
      print('authToken $authToken');
    }

    final Map<String, String> headers = {
      AppApiKey.contentTypeKey: AppApiKey.contentTypeValue,
      AppApiKey.acceptKey: AppApiKey.acceptValue,
      AppApiKey.authorizationKey: '${AppApiKey.bearer}$authToken',
    };

    if (kDebugMode) {
      print('getDeviceForAllocationUrl $getDeviceForAllocationUrl');
      print('headers $headers');
    }

    final response =
        await http.get(Uri.parse(getDeviceForAllocationUrl), headers: headers);
    if (kDebugMode) {
      print('Allocation response statusCode ${response.statusCode}');
    }

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      print("Allocation ResponseBody. $responseBody");
      DeviceModel deviceModel = DeviceModel.fromJson(responseBody);

      List<DeviceData> deviceList = deviceModel.data;

      if (kDebugMode) {
        print('Allocation fetched. $deviceList');
      }

      return deviceList;
    } else {
      throw Exception(
          'Failed to fetch Allocation. Please try again later! ${response.reasonPhrase}');
    }
    /*} catch (e) {
      ServerErrorPopup.showServerError(this.context, '$e');
      print('Error: $e');
      return null;
    }*/
  }

  Future<List<DeallocationReasonData>> loadDeallocationReason() async {
    //try {
    const String getDeviceDeallocationReasonUrl =
        AppApi.getDeviceDeallocationReasonApi;

    // Create storage
    const storage = FlutterSecureStorage();

    // Read token value
    String? authToken = await storage.read(key: AppDatabase.token);
    if (kDebugMode) {
      print('authToken $authToken');
    }

    final Map<String, String> headers = {
      AppApiKey.contentTypeKey: AppApiKey.contentTypeValue,
      AppApiKey.acceptKey: AppApiKey.acceptValue,
      AppApiKey.authorizationKey: '${AppApiKey.bearer}$authToken',
    };

    if (kDebugMode) {
      print('getDeviceDeallocationReasonUrl $getDeviceDeallocationReasonUrl');
      print('headers $headers');
    }

    final response = await http.get(Uri.parse(getDeviceDeallocationReasonUrl),
        headers: headers);
    if (kDebugMode) {
      print('Deallocation Reason response statusCode ${response.statusCode}');
    }

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      print("Deallocation Reason ResponseBody. $responseBody");
      DeallocationReasonModel deallocationReasonModel =
          DeallocationReasonModel.fromJson(responseBody);

      List<DeallocationReasonData> reasonList = deallocationReasonModel.data;

      if (kDebugMode) {
        print('Deallocation Reason fetched. $reasonList');
      }

      return reasonList;
    } else {
      throw Exception(
          'Failed to fetch Deallocation Reason. Please try again later! ${response.reasonPhrase}');
    }
    /*} catch (e) {
      ServerErrorPopup.showServerError(this.context, '$e');
      print('Error: $e');
      return null;
    }*/
  }

  Future<List<DeviceData>> loadParentDevice(DeviceData? deviceData) async {
    //try {
    if (deviceData != null) {
      String getDeviceParentUrl =
          "${AppApi.getParentDeviceApi}${AppApiKey.deviceId}=${deviceData.deviceId}";

      // Create storage
      const storage = FlutterSecureStorage();

      // Read token value
      String? authToken = await storage.read(key: AppDatabase.token);
      if (kDebugMode) {
        print('authToken $authToken');
      }

      final Map<String, String> headers = {
        AppApiKey.contentTypeKey: AppApiKey.contentTypeValue,
        AppApiKey.acceptKey: AppApiKey.acceptValue,
        AppApiKey.authorizationKey: '${AppApiKey.bearer}$authToken',
      };

      if (kDebugMode) {
        print('getDeviceParentUrl $getDeviceParentUrl');
        print('headers $headers');
      }

      final response =
          await http.get(Uri.parse(getDeviceParentUrl), headers: headers);
      if (kDebugMode) {
        print('Parent device response statusCode ${response.statusCode}');
      }

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        print("Parent device ResponseBody. $responseBody");
        DeviceModel deviceModel = DeviceModel.fromJson(responseBody);

        List<DeviceData> deviceList = deviceModel.data;

        if (kDebugMode) {
          print('Parent device fetched. $deviceList');
        }

        return deviceList;
      } else {
        throw Exception(
            'Failed to fetch Device. Please try again later! ${response.reasonPhrase}');
      }
    } else {
      return [];
    }

    /*} catch (e) {
      ServerErrorPopup.showServerError(this.context, '$e');
      print('Error: $e');
      return null;
    }*/
  }

  Future<List<SiteLevelData>> loadSiteLevel(SiteData? siteData) async {
    //try {
    if (siteData != null) {
      String getLevelBySiteIdUrl =
          "${AppApi.getLevelBySiteIdApi}${AppApiKey.siteId}=${siteData?.siteId}";

      // Create storage
      const storage = FlutterSecureStorage();

      // Read token value
      String? authToken = await storage.read(key: AppDatabase.token);
      if (kDebugMode) {
        print('authToken $authToken');
      }

      final Map<String, String> headers = {
        AppApiKey.contentTypeKey: AppApiKey.contentTypeValue,
        AppApiKey.acceptKey: AppApiKey.acceptValue,
        AppApiKey.authorizationKey: '${AppApiKey.bearer}$authToken',
      };

      if (kDebugMode) {
        print('getLevelBySiteIdUrl $getLevelBySiteIdUrl');
        print('headers $headers');
      }

      final response =
          await http.get(Uri.parse(getLevelBySiteIdUrl), headers: headers);
      if (kDebugMode) {
        print('Site Level response statusCode ${response.statusCode}');
      }

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        print("Site Level ResponseBody. $responseBody");
        SiteLevelModel siteLevelModel = SiteLevelModel.fromJson(responseBody);

        List<SiteLevelData> levelList = siteLevelModel.data;

        if (kDebugMode) {
          print('Site Level fetched. $levelList');
        }

        return levelList;
      } else {
        throw Exception(
            'Failed to fetch Level. Please try again later! ${response.reasonPhrase}');
      }
    } else {
      return [];
    }

    /*} catch (e) {
      ServerErrorPopup.showServerError(this.context, '$e');
      print('Error: $e');
      return null;
    }*/
  }

  Future<List<SiteData>> loadSiteById(SiteData? siteData) async {
    if (siteData != null) {
      String getSiteByIdUrl =
          "${AppApi.getSiteByIdApi}${AppApiKey.id}=${siteData.siteId}";

      // Create storage
      const storage = FlutterSecureStorage();

      // Read token value
      String? authToken = await storage.read(key: AppDatabase.token);
      if (kDebugMode) {
        print('authToken $authToken');
      }

      final Map<String, String> headers = {
        AppApiKey.contentTypeKey: AppApiKey.contentTypeValue,
        AppApiKey.acceptKey: AppApiKey.acceptValue,
        AppApiKey.authorizationKey: '${AppApiKey.bearer}$authToken',
      };

      if (kDebugMode) {
        print('getSiteByIdUrl $getSiteByIdUrl');
        print('headers $headers');
      }

      final response =
          await http.get(Uri.parse(getSiteByIdUrl), headers: headers);
      if (kDebugMode) {
        print('Site response statusCode ${response.statusCode}');
      }

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        print("Site ResponseBody. $responseBody");
        SiteModel siteModel = SiteModel.fromJson(responseBody);

        List<SiteData> levelList = siteModel.data;

        if (kDebugMode) {
          print('Site fetched. $levelList');
        }

        return levelList;
      } else {
        throw Exception(
            'Failed to fetch Site. Please try again later! ${response.reasonPhrase}');
      }
    } else {
      return [];
    }
  }

  Future<LevelImageData?> loadImageByLevelId(String? levelId) async {
    if (levelId != null) {
      String getImageByLevelIdUrl =
          "${AppApi.getImageByLevelIdApi}${AppApiKey.id}=$levelId";

      // Create storage
      const storage = FlutterSecureStorage();

      // Read token value
      String? authToken = await storage.read(key: AppDatabase.token);
      if (kDebugMode) {
        print('authToken $authToken');
      }

      final Map<String, String> headers = {
        AppApiKey.contentTypeKey: AppApiKey.contentTypeValue,
        AppApiKey.acceptKey: AppApiKey.acceptValue,
        AppApiKey.authorizationKey: '${AppApiKey.bearer}$authToken',
      };

      if (kDebugMode) {
        print('getImageByLevelIdUrl $getImageByLevelIdUrl');
        print('headers $headers');
      }

      final response =
          await http.get(Uri.parse(getImageByLevelIdUrl), headers: headers);
      if (kDebugMode) {
        print('Level Image response statusCode ${response.statusCode}');
      }

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        print("Level Image ResponseBody. $responseBody");
        LevelImageModel levelImageModel =
            LevelImageModel.fromJson(responseBody);

        LevelImageData? levelImageData = levelImageModel.data;

        if (kDebugMode) {
          print('Level Image fetched. $levelImageData');
        }

        return levelImageData;
      } else {
        throw Exception(
            'Failed to fetch Level Image. Please try again later! ${response.reasonPhrase}');
      }
    }
  }

  Future<List<SiteData>> loadSiteByTenantId(String? tenantId) async {
    //try {
    if (tenantId != null) {
      String getSiteByTenantIdUrl =
          "${AppApi.getSiteByTenantIdApi}${AppApiKey.tenantId}=$tenantId";

      // Create storage
      const storage = FlutterSecureStorage();

      // Read token value
      String? authToken = await storage.read(key: AppDatabase.token);
      if (kDebugMode) {
        print('authToken $authToken');
      }

      final Map<String, String> headers = {
        AppApiKey.contentTypeKey: AppApiKey.contentTypeValue,
        AppApiKey.acceptKey: AppApiKey.acceptValue,
        AppApiKey.authorizationKey: '${AppApiKey.bearer}$authToken',
      };

      if (kDebugMode) {
        print('getSiteByTenantIdUrl $getSiteByTenantIdUrl');
        print('headers $headers');
      }

      final response =
          await http.get(Uri.parse(getSiteByTenantIdUrl), headers: headers);
      if (kDebugMode) {
        print('Site Tenant response statusCode ${response.statusCode}');
      }

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        print("Site Tenant ResponseBody. $responseBody");
        SiteModel siteModel = SiteModel.fromJson(responseBody);

        List<SiteData> levelList = siteModel.data;

        if (kDebugMode) {
          print('Site Tenant fetched. $levelList');
        }

        return levelList;
      } else {
        throw Exception(
            'Failed to fetch Site. Please try again later! ${response.reasonPhrase}');
      }
    } else {
      return [];
    }

    /*} catch (e) {
      ServerErrorPopup.showServerError(this.context, '$e');
      print('Error: $e');
      return null;
    }*/
  }

  Future<AssetData?> getAssetById(AssetData? assetData) async {
    //try {
    if (assetData != null) {
      String getAssetByIdUrl = "${AppApi.getAssetByIdApi}${assetData.assetId}";

      // Create storage
      const storage = FlutterSecureStorage();

      // Read token value
      String? authToken = await storage.read(key: AppDatabase.token);
      if (kDebugMode) {
        print('authToken $authToken');
      }

      final Map<String, String> headers = {
        AppApiKey.contentTypeKey: AppApiKey.contentTypeValue,
        AppApiKey.acceptKey: AppApiKey.acceptValue,
        AppApiKey.authorizationKey: '${AppApiKey.bearer}$authToken',
      };

      if (kDebugMode) {
        print('getAssetByIdUrl $getAssetByIdUrl');
        print('headers $headers');
      }

      final response =
          await http.get(Uri.parse(getAssetByIdUrl), headers: headers);
      if (kDebugMode) {
        print('Asset response statusCode ${response.statusCode}');
      }

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        print("Asset ResponseBody. $responseBody");

        AssetData data = AssetData.fromJson(responseBody['data']);

        if (kDebugMode) {
          print('Asset fetched. $data');
        }

        return data;
      } else {
        throw Exception(
            'Failed to fetch Level. Please try again later! ${response.reasonPhrase}');
      }
    }

    return null;
    /*} catch (e) {
      ServerErrorPopup.showServerError(this.context, '$e');
      print('Error: $e');
      return null;
    }*/
  }

  Future<List<TraceHistoryData>> getAssetTraceHistory(
      AssetData? assetData) async {
    //try {
    if (assetData != null) {
      String getAssetTraceHistoryUrl =
          "${AppApi.getAssetTraceHistoryApi}${AppApiKey.assetId}=${assetData.assetId}";

      // Create storage
      const storage = FlutterSecureStorage();

      // Read token value
      String? authToken = await storage.read(key: AppDatabase.token);
      if (kDebugMode) {
        print('authToken $authToken');
      }

      final Map<String, String> headers = {
        AppApiKey.contentTypeKey: AppApiKey.contentTypeValue,
        AppApiKey.acceptKey: AppApiKey.acceptValue,
        AppApiKey.authorizationKey: '${AppApiKey.bearer}$authToken',
      };

      if (kDebugMode) {
        print('getAssetTraceHistoryUrl $getAssetTraceHistoryUrl');
        print('headers $headers');
      }

      final response =
          await http.get(Uri.parse(getAssetTraceHistoryUrl), headers: headers);
      if (kDebugMode) {
        print('History response statusCode ${response.statusCode}');
      }

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        print("History ResponseBody. $responseBody");
        TraceHistoryModel traceHistoryModel =
            TraceHistoryModel.fromJson(responseBody);
        List<TraceHistoryData> historyList = traceHistoryModel.data;

        if (kDebugMode) {
          print('History fetched. $historyList');
        }

        return historyList;
      } else {
        throw Exception(
            'Failed to fetch History. Please try again later! ${response.reasonPhrase}');
      }
    }

    return [];
    /*} catch (e) {
      ServerErrorPopup.showServerError(this.context, '$e');
      print('Error: $e');
      return null;
    }*/
  }

  Future<AssetDetailData> getAssetDetail(
      String? assetId) async {
    //try {
    if (assetId != null) {
      String getAssetDetailUrl =
          "${AppApi.getLatestAssetLoacationApi}${AppApiKey.assetId}=${assetId}";

      // Create storage
      const storage = FlutterSecureStorage();

      // Read token value
      String? authToken = await storage.read(key: AppDatabase.token);
      if (kDebugMode) {
        print('authToken $authToken');
      }

      final Map<String, String> headers = {
        AppApiKey.contentTypeKey: AppApiKey.contentTypeValue,
        AppApiKey.acceptKey: AppApiKey.acceptValue,
        AppApiKey.authorizationKey: '${AppApiKey.bearer}$authToken',
      };

      if (kDebugMode) {
        print('getAssetDetailUrl $getAssetDetailUrl');
        print('headers $headers');
      }

      final response =
          await http.get(Uri.parse(getAssetDetailUrl), headers: headers);
      if (kDebugMode) {
        print('Asset Detail response statusCode ${response.statusCode}');
      }

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        print("Asset Detail ResponseBody. $responseBody");
        AssetDetailModel assetDetailModel = AssetDetailModel.fromJson(responseBody);
        AssetDetailData assetDetailData = assetDetailModel.data;

        if (kDebugMode) {
          print('Asset Detail fetched. $assetDetailData');
        }

        return assetDetailData;
      } else {
        throw Exception(
            'Failed to fetch Asset Detail. Please try again later! ${response.reasonPhrase}');
      }
    }

    return Map() as AssetDetailData;
    /*} catch (e) {
      ServerErrorPopup.showServerError(this.context, '$e');
      print('Error: $e');
      return null;
    }*/
  }
}

// Provider is great for accessing dependencies and objects that don’t change

final apiServicesProvider = Provider<ApiServices>((ref) => ApiServices());
