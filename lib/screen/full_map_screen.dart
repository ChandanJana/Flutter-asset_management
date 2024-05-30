import 'dart:convert';
import 'dart:developer';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mindteck_iot/models/telemetry/telemetry_data.dart';
import 'package:mindteck_iot/utils/map_refresh_listener.dart';
import 'package:mindteck_iot/widgets/mqtt_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/site/site_data.dart';
import '../models/site_map_data.dart';
import '../models/tenant/tenant_data.dart';
import '../provider/api_data_provider.dart';
import '../provider/app_theme_provider.dart';
import '../resource/app_resource.dart';
import '../utils/constants.dart';
//import 'package:location/location.dart';

/// Created by Chandan Jana on 08-03-2024.
/// Company name: Mindteck
/// Email: chandan.jana@mindteck.com
///

class FullMapScreen extends ConsumerStatefulWidget {
  const FullMapScreen({super.key, required this.role});

  final String? role;

  @override
  ConsumerState<FullMapScreen> createState() => _FullMapScreenState();
}

class _FullMapScreenState extends ConsumerState<FullMapScreen>
    implements MapRefreshListener {
  MapController? mapController;
  double newZoomLevel = 15;
  late MqttHandler mqttHandler;

  //LocationData? currentLocation;

  String? role;
  String? loginTenantId;
  List<SiteMapData> siteMapDataList = [];
  List<Marker> markerList = [];
  List<LatLng> polygonList = [];

  Future<void> _getValueFromSecureStorage() async {
    try {
      // Create storage
      SharedPreferences storage = await SharedPreferences.getInstance();
      role = storage.getString(AppDatabase.roleName);
      loginTenantId = storage.getString(AppDatabase.tenantId);
      print('role $role');
      print('loginTenantId $loginTenantId');
    } catch (e) {
      // Handle error
      print('Error reading value: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _getValueFromSecureStorage();
    mapController = MapController();
    mqttHandler = MqttHandler();
  }

  @override
  void dispose() {
    //ref.read(tenantDataStateProvider.notifier).state = null;
    mqttHandler.diconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('widget.role ${widget.role}');
    final bool isDarkMode = ref.watch(appThemeProvider).getTheme();
    var tenantList = ref.watch(tenantListProvider);
    final tenantData = ref.watch(tenantDataStateProvider);
    //final siteDataList = ref.watch(siteByTenantIdProvider(tenantData));
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Full Map',
          style: GoogleFonts.robotoTextTheme().titleLarge!.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 15,
              ),
        ),
        iconTheme: IconThemeData(
          color: Colors.white, // Change the color of the back button
        ),
      ),
      body: WillPopScope(
        onWillPop: () {
          ref.read(tenantDataStateProvider.notifier).state = null;
          return Future.value(true);
        },
        child: Flex(
          crossAxisAlignment: CrossAxisAlignment.center,
          direction: Axis.vertical,
          children: [
            if (widget.role == Constants.system_administrator)
              const SizedBox(
                height: 20,
              ),
            if (widget.role == Constants.system_administrator)
              tenantList.when(
                data: (tenantData) {
                  List<TenantData> tenantsList =
                      tenantData.map((e) => e).toList();
                  if (tenantsList.isEmpty) {
                    return Container(
                      alignment: Alignment.center,
                      child: const Text('No Tenants found'),
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomDropdown<TenantData>.search(
                      //closedHeaderPadding: EdgeInsets.all(5),
                      expandedHeaderPadding: EdgeInsets.all(20),
                      hintText: 'Select tenant',
                      initialItem: ref.read(tenantDataStateProvider),
                      items: tenantsList,
                      excludeSelected: false,
                      onChanged: (value) {
                        log('changing value to: ${value.tenantName}');
                        mqttHandler.connect("", this);
                        ref.read(tenantDataStateProvider.notifier).state =
                            value;
                      },
                      hideSelectedFieldWhenExpanded: false,
                      canCloseOutsideBounds: true,
                      validator: (value) {
                        if (value == null) {
                          return "Please select tenant";
                        } else {
                          return null;
                        }
                      },
                      headerBuilder: (context, selectedItem) {
                        return Text(selectedItem.tenantName!);
                      },
                      decoration: CustomDropdownDecoration(
                        closedBorderRadius: BorderRadius.all(Radius.zero),
                        searchFieldDecoration: SearchFieldDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.primary,
                              width: 1,
                              style: BorderStyle.solid,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.primary.withOpacity(.5),
                              width: 1,
                              style: BorderStyle.solid,
                            ),
                          ),
                        ),
                        //closedFillColor: Colors.green,
                        //closedBorderRadius: BorderRadius.only(topLeft: Radius.circular(10))
                      ),
                      listItemBuilder:
                          (context, item, isSelected, onItemSelect) {
                        return Text(item.tenantName!);
                      },
                    ),
                  );
                },
                error: (error, stackTrace) {
                  return Text(error.toString());
                },
                loading: () {
                  return Center(
                    child: LoadingAnimationWidget.staggeredDotsWave(
                      color: Colors.blueAccent,
                      size: 70,
                    ),
                  );
                },
              ),
            if (widget.role == Constants.system_administrator)
              const SizedBox(
                height: 10,
              ),
            Expanded(
              flex: 1,
              child: Consumer(
                builder: (context, ref, child) {
                  String? tenantId;
                  if (tenantData != null) {
                    tenantId = tenantData.tenantId;
                  } else {
                    tenantId = loginTenantId;
                  }
                  final siteDataList =
                      ref.watch(siteByTenantIdProvider(tenantId));
                  siteDataList.when(
                    data: (data) {
                      siteMapDataList.clear();
                      List<SiteData> siteList =
                          data.where((e) => e.levels.isNotEmpty).toList();
                      print('siteList $siteList');
                      if (siteList.isEmpty) {
                        return Container(
                          alignment: Alignment.center,
                          child: const Text('No site found'),
                        );
                      }

                      siteMapDataList.addAll(siteList
                          .map((element) => SiteMapData.fromJson({
                                'siteName': element.siteName,
                                'siteLat': element.levels.first.geoLatitude
                                    ?.toDouble(),
                                //'siteLat': 22.58,
                                'siteLong': element.levels.first.geoLongitude
                                    ?.toDouble()
                                //'siteLong': 88.43
                              }))
                          .toList());

                      print('siteMapDataList $siteMapDataList');
                      markerList.clear();
                      siteMapDataList.forEach((element) {
                        markerList.add(Marker(
                          width: 50.0,
                          height: 50.0,
                          point: LatLng(element.siteLat, element.siteLong),
                          child: IconButton(
                            icon: const Icon(
                              Icons.location_on,
                              size: 40,
                            ),
                            color: Colors.red,
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text(element.siteName),
                                    content: Text(
                                        'Co-ordinate: ${element.siteLat}, ${element.siteLong}'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('Close'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ));
                      });
                      polygonList.clear();
                      polygonList.addAll(siteList.first.levels.first.shapes
                          .map((element) => LatLng(element.latitude!.toDouble(),
                              element.longitude!.toDouble()))
                          .toList());
                      newZoomLevel = 16;
                      mapController?.move(
                          LatLng(siteMapDataList.first.siteLat.toDouble(),
                              siteMapDataList.first.siteLong.toDouble()),
                          newZoomLevel);
                    },
                    error: (error, stackTrace) {
                      return Text(error.toString());
                    },
                    loading: () {
                      return Center(
                        child: LoadingAnimationWidget.staggeredDotsWave(
                          color: Colors.blueAccent,
                          size: 70,
                        ),
                      );
                    },
                  );
                  return FlutterMap(
                    options: MapOptions(
                      initialCenter: const LatLng(22.58, 88.43),
                      initialZoom: newZoomLevel,
                      interactionOptions: const InteractionOptions(
                        enableMultiFingerGestureRace: true,
                        enableScrollWheel: true,
                        //flags: InteractiveFlag.flingAnimation,
                      ),
                    ),
                    mapController: mapController,
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.mindteck.mindteck_iot',
                        //subdomains: ['a', 'b', 'c'],
                      ),
                      PolygonLayer(
                        drawLabelsLast: true,
                        polygonLabels: false,
                        polygonCulling: false,
                        polygons: [
                          Polygon(
                              points: polygonList,
                              color: Colors.blue.withOpacity(0.3),
                              borderColor: Colors.blue,
                              borderStrokeWidth: 2,
                              isFilled: true),
                        ],
                      ),
                      MarkerLayer(
                        markers: markerList,
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void onGetLocation(String message) {
    final responseBody = json.decode(message);
    TelemetryData telemetryData = TelemetryData.fromJson(responseBody);
    log("FullMap: telemetryData $telemetryData");
    setState(() {
      markerList.clear();
      markerList.add(Marker(
        width: 50.0,
        height: 50.0,
        point: LatLng(telemetryData.latitude!.toDouble(),
            telemetryData.longitude!.toDouble()),
        child: IconButton(
          icon: const Icon(
            Icons.location_on,
            size: 40,
          ),
          color: Colors.red,
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text(telemetryData.hardwareId!),
                  content: Text('Custom marker information goes here.'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Close'),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ));
      mapController?.move(
          LatLng(telemetryData.latitude!.toDouble(),
              telemetryData.longitude!.toDouble()),
          newZoomLevel);
    });

    /*mapController?.move(
        LatLng(telemetryData.latitude!.toDouble(),
            telemetryData.longitude!.toDouble()),
        newZoomLevel);*/
    /*setState(() {
      siteMapDataList.clear();
      siteMapDataList.add(SiteMapData.fromJson({
        'siteName': 'Example',
        'siteLat': telemetryData.latitude!.toDouble(),
        'siteLong': telemetryData.longitude!.toDouble()
      }));
      mapController?.move(
          LatLng(siteMapDataList.first.siteLat.toDouble(),
              siteMapDataList.first.siteLong.toDouble()),
          newZoomLevel);
    });*/

    /*ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );*/
  }
}
