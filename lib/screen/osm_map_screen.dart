import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:mindteck_iot/screen/full_map_screen.dart';

import '../models/tenant/tenant_data.dart';
import '../provider/api_data_provider.dart';
import '../provider/app_theme_provider.dart';
import '../resource/app_resource.dart';

/// Created by Chandan Jana on 06-03-2024.
/// Company name: Mindteck
/// Email: chandan.jana@mindteck.com

class OSMMapScreen extends ConsumerStatefulWidget {
  const OSMMapScreen({super.key, required this.role});

  final String? role;

  @override
  ConsumerState<OSMMapScreen> createState() => _OSMMapScreenState();
}

class _OSMMapScreenState extends ConsumerState<OSMMapScreen> {
  TenantData? _selectedTenant;
  MapController? mapController;
  double newZoomLevel = 12;
  String? role;

  Future<void> _getValueFromSecureStorage() async {
    try {
      FlutterSecureStorage storage = const FlutterSecureStorage();
      role = await storage.read(key: AppDatabase.roleName);
      print('OSM role $role');
    } catch (e) {
      // Handle error
      print('Error reading value: $e');
    }
  }

  @override
  void initState() {
    _getValueFromSecureStorage();
    super.initState();
    mapController = MapController();
    // Move the map to a new position
    //mapController?.move(LatLng(40.758480, -111.888140), newZoomLevel);

    // Zoom in
    //mapController.zoomIn();

    // Zoom out
    //mapController.zoomOut();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = ref.watch(appThemeProvider).getTheme();
    var tenantList = ref.watch(tenantListProvider);

    return Container(
      height: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Flex(
        crossAxisAlignment: CrossAxisAlignment.end,
        direction: Axis.vertical,
        children: [
          Container(
            width: 100,
            height: 40,
            child: TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  PageRouteBuilder(
                    pageBuilder: (BuildContext context,
                        Animation<double> animation,
                        Animation<double> secondaryAnimation) {
                      return FullMapScreen(role: role);
                    },
                    transitionDuration: const Duration(milliseconds: 500),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      // Right to left
                      const begin = Offset(1.0, 0.0);

                      /// Left to Right
                      //const begin = Offset(-1.0, 0.0);
                      /// Top to Bottom
                      //const begin = Offset(0.0, -1.0);
                      /// Bottom to Top
                      //const begin = Offset(0.0, 1.0);
                      const end = Offset.zero;

                      /// Curves to specify the timing of transitions and animations.
                      /// Curves are used to define how the animation values change
                      /// over time.
                      const curve = Curves.ease;

                      var tween = Tween(begin: begin, end: end)
                          .chain(CurveTween(curve: curve));

                      return SlideTransition(
                        position: animation.drive(tween),
                        child: child,
                      );

                      /*var begin = 0.0;
            var end = 1.0;
            var curve = Curves.ease;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            return ScaleTransition(
              scale: animation.drive(tween),
              child: child,
            );*/
                    },
                  ),
                );
              },
              style: ButtonStyle(),
              child: Text(
                AppText.explore,
                style: GoogleFonts.robotoTextTheme().titleLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black,
                      fontSize: 14,
                    ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: FlutterMap(
              options: MapOptions(
                  initialCenter: const LatLng(22.58, 88.43),
                  initialZoom: newZoomLevel,
                  interactionOptions: const InteractionOptions(
                    flags: InteractiveFlag.none,
                  )),
              mapController: mapController,
              children: [
                // {x}: x axis coordinate
                // {y}: y axis coordinate
                // {z}: zoom level
                // {s}: subdomains
                // {r}: ratina mode
                TileLayer(
                  urlTemplate:
                      //'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                      'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.mindteck.mindteck_iot',
                  //subdomains: ['a', 'b', 'c'],
                ),
                const MarkerLayer(
                  markers: [
                    Marker(
                      width: 50.0,
                      height: 50.0,
                      point: LatLng(22.58, 88.43),
                      child:
                          Icon(Icons.location_on, size: 40, color: Colors.red),
                    ),
                  ],
                ),
                PolygonLayer(
                  polygons: [
                    Polygon(
                      points: [
                        LatLng(22.68123456, 88.43123456),
                        LatLng(22.68123789, 88.43123789),
                        LatLng(22.68123123, 88.43123123),
                      ],
                      color: Colors.blue.withOpacity(0.3),
                      borderColor: Colors.blue,
                      borderStrokeWidth: 2,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
    /*return Scaffold(
      body: OSMFlutter(
        controller:mapController,
        //currentLocation: false,
        osmOption: OSMOption(),
      ),
    );*/
  }
}
