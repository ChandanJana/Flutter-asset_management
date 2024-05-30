class AppApi {
  // Api Name
  static const String _baseApi = 'http://172.16.5.149/api';
  static const String loginApi = '$_baseApi/Authenticate/Login';
  static const String logoutApi = '$_baseApi/Authenticate/Logout/';
  static const String forgotPasswordApi =
      '$_baseApi/Authenticate/ForgotPassword?';

  static const String getPermissionListByRoleIdApi =
      '$_baseApi/RolePermission/GetFeatureWiseRolePermissionByRoleId/';
  static const String getRolePermissionByUserIdApi =
      '$_baseApi/RolePermission/GetRolePermissionByUserId';

  static const String getAllAssetsApi = '$_baseApi/Asset/GetAllAssets';
  static const String getAssetByIdApi = '$_baseApi/Asset/GetAssetById/';
  static const String getLatestAssetLoacationApi =
      '$_baseApi/Asset/GetLatestAssetLoacation?';
  static const String getLostDeviceCountApi =
      '$_baseApi/AssetDashboard/GetLostDeviceCount';
  static const String getLowBatteryCountApi =
      '$_baseApi/AssetDashboard/GetLowBatteryCount';
  static const String getZoneChangesCountApi =
      '$_baseApi/AssetDashboard/GetZoneChangesCount';
  static const String getZoneViolationCountApi =
      '$_baseApi/AssetDashboard/GetZoneViolationCount';
  static const String getAlarmCountApi =
      '$_baseApi/AssetDashboard/GetAlarmCount';
  static const String getAssetTraceHistoryApi =
      '$_baseApi/Asset/GetAssetTraceHistory?';
  static const String getAllZoneBoundaryByLevelIdApi =
      '$_baseApi/ZoneManagement/GetAllZoneBounderyByLevelId?';

  static const String getDeviceListApi = '$_baseApi/DeviceManagement/GetDevice';
  static const String addDeviceApi = '$_baseApi/DeviceManagement/AddDevices';
  static const String updateDeviceApi =
      '$_baseApi/DeviceManagement/UpdateDevice';
  static const String getDeviceCategory =
      '$_baseApi/DeviceManagement/GetCategory';
  static const String getDeviceLifeCycle =
      '$_baseApi/DeviceManagement/GetDeviceLifeCycle';
  static const String getUnitMasterApi =
      '$_baseApi/DeviceManagement/GetUnitMaster';
  static const String getAllocationApi =
      '$_baseApi/DeviceManagement/GetAllocation';
  static const String getDeviceForAllocationApi =
      '$_baseApi/DeviceManagement/GetDeviceForAllocation';
  static const String getParentDeviceApi =
      '$_baseApi/DeviceManagement/GetParentDevice?';
  static const String addAllocationApi =
      '$_baseApi/DeviceManagement/AddAllocation';
  static const String editAllocationApi =
      '$_baseApi/DeviceManagement/EditAllocation';
  static const String getDeviceDeallocationReasonApi =
      '$_baseApi/DeviceManagement/GetDeviceDeallocationReason';
  static const String removeDeviceAllocationApi =
      '$_baseApi/DeviceManagement/RemoveDeviceAllocation';

  static const String getApplicationListApi =
      '$_baseApi/Application/GetApplication';

  static const String getSiteApi = '$_baseApi/Site/GetSite';
  static const String getSiteByIdApi = '$_baseApi/Site/GetSiteById?';
  static const String getImageByLevelIdApi =
      '$_baseApi/Site/GetImageByLevelId?';
  static const String getSiteByTenantIdApi =
      '$_baseApi/Site/GetSiteByTenantId?';

  static const String getUptimeApi = '$_baseApi/Dashboard/GetUptime';
  static const String getNotificationsCountApi =
      '$_baseApi/Dashboard/GetNotificationsCount';
  static const String getTopTenDevicesApi =
      '$_baseApi/Dashboard/GetTopTenDevices';
  static const String getRolesListApi = '$_baseApi/Roles/GetRolesList';
  static const String getTenantDashboardSummaryApi =
      '$_baseApi/Dashboard/GetTenantDashboardSummary';

  static const String changePasswordApi =
      '$_baseApi/Authenticate/ChangePassword';
  static const String getAllTenantsApi = '$_baseApi/Tenant/GetAllTenants';

  static const String getLevelBySiteIdApi =
      '$_baseApi/ZoneManagement/GetLevelBySiteId?';

  //Environmental_Monitoring
  static const String getDeviceForAssetEnvironmentMonitoring =
      '$_baseApi/EnvironmentMonitoring/GetDeviceForAssetEnvironmentMonitoring';
  static const String GetListOfAllocatedDeviceForEnvironment =
      '$_baseApi/EnvironmentMonitoring/GetListOfAllocatedDeviceForEnvironment';
  static const String saveDeviceIds =
      '$_baseApi/EnvironmentMonitoring/SaveDeviceIds';
}
