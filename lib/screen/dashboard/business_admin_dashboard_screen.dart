import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:mindteck_iot/widgets/Charts/bar_graph_widget.dart';
import 'package:mindteck_iot/widgets/Charts/horizontal_bar_graph.dart';
import 'package:mindteck_iot/widgets/Charts/pie_chart_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../resource/app_resource.dart';
import '../../widgets/Charts/up_time_progress_bar.dart';
import '../osm_map_screen.dart';

class BusinessAdminDashboardScreen extends StatefulWidget {
  @override
  State<BusinessAdminDashboardScreen> createState() =>
      _BusinessAdminDashboardScreenState();
}

class _BusinessAdminDashboardScreenState
    extends State<BusinessAdminDashboardScreen> {
  String? role;

  Future<void> _getValueFromSecureStorage() async {
    try {
      // Create storage
      SharedPreferences storage = await SharedPreferences.getInstance();

      role = storage.getString(AppDatabase.roleName);
    } catch (e) {
      // Handle error
      print('Error reading value: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _getValueFromSecureStorage();
  }

  int _firstCurrentIndex = 0;
  int _secondCurrentIndex = 0;
  CarouselController buttonCarouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              CarouselSlider(
                items: [
                  const Card(
                    elevation: 2,
                    child: HorizontalBarGraphWidget(),
                  ),
                  const Card(
                    elevation: 2,
                    child: BarGraphWidget(),
                  ),
                  const Card(
                    elevation: 2,
                    child: PieChartWidget(),
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
          const Card(
            elevation: 2,
            child: UpTimeProgressWidget(),
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
