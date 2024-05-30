import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindteck_iot/resource/app_resource.dart';
import 'package:mindteck_iot/screen/osm_map_screen.dart';
import 'package:mindteck_iot/widgets/Charts/bar_graph_widget.dart';
import 'package:mindteck_iot/widgets/Charts/horizontal_bar_graph.dart';
import 'package:mindteck_iot/widgets/Charts/pie_chart_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../widgets/Charts/up_time_progress_bar.dart';

class SystemAdminDashboardScreen extends ConsumerStatefulWidget {
  const SystemAdminDashboardScreen({super.key});

  @override
  ConsumerState<SystemAdminDashboardScreen> createState() =>
      _SystemAdminDashboardScreenState();
}

class _SystemAdminDashboardScreenState
    extends ConsumerState<SystemAdminDashboardScreen> {
  String? role;

  Future<void> _getValueFromSecureStorage() async {
    try {
      // Create storage
      SharedPreferences storage = await SharedPreferences.getInstance();

      role = storage.getString(AppDatabase.roleName);
      print('role $role');
    } catch (e) {
      // Handle error
      print('Error reading value: $e');
    }
  }

  int _firstCurrentIndex = 0;
  int _secondCurrentIndex = 0;
  CarouselController buttonCarouselController = CarouselController();

  @override
  void initState() {
    _getValueFromSecureStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      key: Key('system_screen'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            elevation: 2,
            child: UpTimeProgressWidget(),
          ),
          Column(
            children: [
              CarouselSlider(
                items: [
                  const Card(
                    elevation: 2,
                    child: PieChartWidget(),
                  ),
                  const Card(
                    elevation: 2,
                    child: HorizontalBarGraphWidget(),
                  ),
                  const Card(
                    elevation: 2,
                    child: BarGraphWidget(),
                  ),
                ],
                carouselController: buttonCarouselController,
                options: CarouselOptions(
                  height: 300.0,
                  enlargeCenterPage: true,
                  autoPlay: false,
                  aspectRatio: 2.0,
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enableInfiniteScroll: true,
                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                  viewportFraction: 1,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _firstCurrentIndex = index;
                    });
                  },
                ),
              ),
              //SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (index) {
                  return Container(
                    width: 8.0,
                    height: 8.0,
                    margin:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _firstCurrentIndex == index
                          ? Colors.blueAccent
                          : Colors.grey,
                    ),
                  );
                }),
              )
            ],
          ),
          Card(
            elevation: 2,
            child: OSMMapScreen(role: role),
          ),
        ],
      ),
    );
  }
}
