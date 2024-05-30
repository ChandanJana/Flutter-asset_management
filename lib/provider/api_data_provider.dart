import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindteck_iot/models/deallocation_reason_data.dart';
import 'package:mindteck_iot/models/device/device_data.dart';
import 'package:mindteck_iot/models/environment_monitor_sensor/sensor_list.dart';
import 'package:mindteck_iot/models/locate_asset/data.dart';
import 'package:mindteck_iot/models/site/site_data.dart';
import 'package:mindteck_iot/models/site_level/site_level_data.dart';
import 'package:mindteck_iot/models/tenant/tenant_data.dart';
import 'package:mindteck_iot/provider/api_services.dart';

import '../models/allocation/allocation_data.dart';
import '../models/application/application_data.dart';
import '../models/asset/asset_data.dart';
import '../models/asset_detail_data.dart';
import '../models/category/category_data.dart';
import '../models/level_image_data.dart';
import '../models/notification_data.dart';
import '../models/pieChart/pie_chart_tenant_entities.dart';
import '../models/response_model.dart';
import '../models/status/status_data.dart';
import '../models/top_ten_device_data.dart';
import '../models/trace_history_data.dart';
import '../models/unitMeasurement/unit_measurement_data.dart';

// StateProvider is great for storing simple state objects that can change

final deviceDataStateProvider = StateProvider<DeviceData?>((ref) {
  return ref.read(apiServicesProvider).deviceData;
});

final siteDataStateProvider = StateProvider<SiteData?>((ref) {
  return ref.read(apiServicesProvider).siteData;
});

final tenantDataStateProvider = StateProvider<TenantData?>((ref) {
  return ref.read(apiServicesProvider).tenantData;
});

final assetDataStateProvider = StateProvider<AssetData?>((ref) {
  return ref.read(apiServicesProvider).assetData;
});

// FutureProvider is great for read some async data from network/database

final deviceListProvider = FutureProvider<List<DeviceData>>((ref) async {
  return await ref.watch(apiServicesProvider).loadAllDevice();
});
final sensorListProvider = FutureProvider<List<SensorData>>((ref) async {
  return await ref.watch(apiServicesProvider).loadAllSensor();
});

final deviceAllocationListProvider =
    FutureProvider<List<DeviceData>>((ref) async {
  return await ref.watch(apiServicesProvider).loadDeviceForAllocation();
});

final deallocationReasonListProvider =
    FutureProvider<List<DeallocationReasonData>>((ref) async {
  return await ref.watch(apiServicesProvider).loadDeallocationReason();
});

final applicationListProvider =
    FutureProvider<List<ApplicationData>>((ref) async {
  return await ref.watch(apiServicesProvider).loadAllApplications();
});

final siteListProvider = FutureProvider<List<SiteData>>((ref) async {
  return await ref.watch(apiServicesProvider).loadAllSites();
});

final averageUpTimeProvider = FutureProvider<ResponseModel>((ref) async {
  return await ref.watch(apiServicesProvider).loadAverageUpTime();
});

final notificationCountProvider =
    FutureProvider<List<NotificationData>>((ref) async {
  return await ref.watch(apiServicesProvider).loadNotificationCount();
});
final topTenDevicsProvider =
    FutureProvider<List<TopTenDeviceData>>((ref) async {
  return await ref.watch(apiServicesProvider).loadTopTenDevicesTime();
});

final categoryListProvider = FutureProvider<List<CategoryData>>((ref) async {
  return await ref.watch(apiServicesProvider).loadDeviceCategory();
});

final statusListProvider = FutureProvider<List<StatusData>>((ref) async {
  return await ref.watch(apiServicesProvider).loadDeviceStatus();
});

final tenantListProvider = FutureProvider<List<TenantData>>((ref) async {
  return await ref.watch(apiServicesProvider).loadAllTenant();
});

final uomListProvider =
    FutureProvider<List<UnitOfMeasurementData>>((ref) async {
  return await ref.watch(apiServicesProvider).loadAllUOM();
});

final allocationDataListProvider =
    FutureProvider<List<AllocationData>>((ref) async {
  return await ref.watch(apiServicesProvider).loadAllAllocation();
});

final assetListProvider = FutureProvider<List<AssetData>>((ref) async {
  return ref.watch(apiServicesProvider).loadAllAsset();
});

final pieChartProvider =
    FutureProvider<List<PieChartTenantEntities>>((ref) async {
  return ref.watch(apiServicesProvider).loadPieChartData();
});

// family is a modifier that we can use to pass an argument to a provider.

final addDeviceProvider = FutureProvider.autoDispose
// additional areaId argument of type int
    .family<ResponseModel, DeviceData>((ref, deviceData) async {
  // get the repository
  final areaRepo = ref.watch(apiServicesProvider);
  // call method that returns a Future<ZonePathModel>, passing the areaId as an argument
  return areaRepo.addDevice(deviceData);
});

final sendEmailProvider = FutureProvider.autoDispose
// additional areaId argument of type int
    .family<ResponseModel, String>((ref, email) async {
  // get the repository
  final areaRepo = ref.watch(apiServicesProvider);
  // call method that returns a Future<ZonePathModel>, passing the areaId as an argument
  return areaRepo.sendMail(email);
});

final addDeviceAllocationProvider = FutureProvider.autoDispose
// additional areaId argument of type int
    .family<ResponseModel, Map<String, dynamic>>((ref, data) async {
  // get the repository
  final areaRepo = ref.watch(apiServicesProvider);
  return areaRepo.addDeviceAllocation(data);
});

final saveDeviceIdsProvider = FutureProvider.autoDispose
// additional areaId argument of type int
    .family<ResponseModel, Map<String, dynamic>>((ref, data) async {
  // get the repository
  final areaRepo = ref.watch(apiServicesProvider);
  return areaRepo.saveDeviceIds(data);
});

// final allotedDeviceIdsProvider = FutureProvider.autoDispose
//     .family<List<String>, Map<String, dynamic>>((ref, data) async {
//   // get the repository
//   final areaRepo = ref.watch(apiServicesProvider);
//   return areaRepo.loadAllAllocatedDeviceforEV();
// });

final allotedDeviceIdsProvider = FutureProvider<List<String>>((ref) async {
  return await ref.watch(apiServicesProvider).loadAllAllocatedDeviceforEV();
});

final editDeviceAllocationProvider = FutureProvider.autoDispose
// additional areaId argument of type int
    .family<ResponseModel, Map<String, dynamic>>((ref, data) async {
  // get the repository
  final areaRepo = ref.watch(apiServicesProvider);
  // call method that returns a Future<ZonePathModel>, passing the areaId as an argument
  return areaRepo.editDeviceAllocation(data);
});

final removeDeviceAllocationProvider = FutureProvider.autoDispose
// additional areaId argument of type int
    .family<ResponseModel, Map<String, dynamic>>((ref, data) async {
  // get the repository
  final areaRepo = ref.watch(apiServicesProvider);
  // call method that returns a Future<ZonePathModel>, passing the areaId as an argument
  return areaRepo.removeDeviceAllocation(data);
});

final editDeviceProvider = FutureProvider.autoDispose
// additional areaId argument of type int
    .family<ResponseModel, DeviceData>((ref, deviceData) async {
  // get the repository
  final areaRepo = ref.watch(apiServicesProvider);
  // call method that returns a Future<ZonePathModel>, passing the areaId as an argument
  return areaRepo.editDevice(deviceData);
});

final parentDeviceProvider = FutureProvider.autoDispose
// additional areaId argument of type int
    .family<List<DeviceData>, DeviceData?>((ref, deviceData) async {
  // get the repository
  final areaRepo = ref.watch(apiServicesProvider);
  // call method that returns a Future<ZonePathModel>, passing the areaId as an argument
  return areaRepo.loadParentDevice(deviceData);
});

final siteLevelProvider = FutureProvider.autoDispose
// additional areaId argument of type int
    .family<List<SiteLevelData>, SiteData?>((ref, siteData) async {
  // get the repository
  final areaRepo = ref.watch(apiServicesProvider);
  // call method that returns a Future<ZonePathModel>, passing the areaId as an argument
  return areaRepo.loadSiteLevel(siteData);
});

final siteByIdProvider = FutureProvider.autoDispose
// additional areaId argument of type int
    .family<List<SiteData>, SiteData?>((ref, siteData) async {
  // get the repository
  final areaRepo = ref.watch(apiServicesProvider);
  // call method that returns a Future<ZonePathModel>, passing the areaId as an argument
  return areaRepo.loadSiteById(siteData);
});

final siteByTenantIdProvider = FutureProvider.autoDispose
// additional areaId argument of type int
    .family<List<SiteData>, String?>((ref, tenantId) async {
  // get the repository
  final areaRepo = ref.watch(apiServicesProvider);
  // call method that returns a Future<ZonePathModel>, passing the areaId as an argument
  return areaRepo.loadSiteByTenantId(tenantId);
});

final levelImageBylevelIdProvider = FutureProvider.autoDispose
// additional areaId argument of type int
    .family<LevelImageData?, String?>((ref, levelId) async {
  // get the repository
  final areaRepo = ref.watch(apiServicesProvider);
  // call method that returns a Future<ZonePathModel>, passing the areaId as an argument
  return areaRepo.loadImageByLevelId(levelId);
});

final getAllZoneBoundaryByLevelIdProvider = FutureProvider.autoDispose
    .family<List<Data>?, String?>((ref, levelId) async {
  // Get the repository
  final areaRepo = ref.watch(apiServicesProvider);
  // Call method that returns a Future<AssetZoneData?>, passing the levelId as an argument
  final assetZoneData = await areaRepo.getAllZoneBoundaryByLevelIdApi(levelId);

  // Convert AssetZoneData to List<Data> if assetZoneData is not null
  return assetZoneData?.data;
});

final assetDataProvider = FutureProvider.autoDispose
// additional areaId argument of type int
    .family<AssetData?, AssetData?>((ref, assetData) async {
  // get the repository
  final areaRepo = ref.watch(apiServicesProvider);
  // call method that returns a Future<ZonePathModel>, passing the areaId as an argument
  return areaRepo.getAssetById(assetData);
});

final assetTraceHistoryProvider = FutureProvider.autoDispose
// additional areaId argument of type int
    .family<List<TraceHistoryData>, AssetData?>((ref, assetData) async {
  // get the repository
  final areaRepo = ref.watch(apiServicesProvider);
  // call method that returns a Future<ZonePathModel>, passing the areaId as an argument
  return areaRepo.getAssetTraceHistory(assetData);
});

final assetDetailProvider = FutureProvider.autoDispose
// additional areaId argument of type int
    .family<AssetDetailData?, String?>((ref, assetData) async {
  // get the repository
  final areaRepo = ref.watch(apiServicesProvider);
  // call method that returns a Future<ZonePathModel>, passing the areaId as an argument
  return areaRepo.getAssetDetail(assetData);
});
