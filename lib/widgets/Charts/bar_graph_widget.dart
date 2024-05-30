import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../models/notification_data.dart';
import '../../provider/api_data_provider.dart';
import '../../provider/app_theme_provider.dart';
import '../../resource/app_colors.dart';
import '../graph_error.dart';

class BarGraphWidget extends ConsumerStatefulWidget {
  const BarGraphWidget({super.key});

  @override
  ConsumerState<BarGraphWidget> createState() => _BarGraphWidget();
}

// Define data structure for a bar group
class DataItem {
  int x;
  double y1;
  double y2;
  double y3;

  DataItem(
      {required this.x, required this.y1, required this.y2, required this.y3});
}

class _BarGraphWidget extends ConsumerState<BarGraphWidget> {
  SideTitles get _bottomTitles => SideTitles(
        showTitles: true,
        getTitlesWidget: (value, meta) {
          String text = '';
          switch (value.toInt()) {
            case 0:
              text = '0';
              break;
            case 2:
              text = '2';
              break;
            case 4:
              text = '4';
              break;
            case 6:
              text = '6';
              break;
            case 8:
              text = '8';
              break;
            case 10:
              text = '10';
              break;
          }

          return Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.normal,
              color: Colors.grey,
            ),
          );
        },
      );
  final maxX = 50.0;
  final maxY = 50.0;
  final radius = 8.0;

  bool showFlutter = false;
  final blue1 = AppColors.contentColorBlue.withOpacity(0.5);
  final blue2 = AppColors.contentColorBlue;

  List<ScatterSpot> flutterLogoData() {
    return [
      /// section 1
      ScatterSpot(
        20,
        14.5,
        radius: radius,
        color: blue1,
      ),
      ScatterSpot(
        20,
        14.5,
        radius: radius,
        color: blue1,
      ),
      ScatterSpot(
        22,
        16.5,
        radius: radius,
        color: blue1,
      ),
      ScatterSpot(
        24,
        18.5,
        radius: radius,
        color: blue1,
      ),

      ScatterSpot(
        22,
        12.5,
        radius: radius,
        color: blue1,
      ),
      ScatterSpot(
        24,
        14.5,
        radius: radius,
        color: blue1,
      ),
      ScatterSpot(
        26,
        16.5,
        radius: radius,
        color: blue1,
      ),

      ScatterSpot(
        24,
        10.5,
        radius: radius,
        color: blue1,
      ),
      ScatterSpot(
        26,
        12.5,
        radius: radius,
        color: blue1,
      ),
      ScatterSpot(
        28,
        14.5,
        radius: radius,
        color: blue1,
      ),

      ScatterSpot(
        26,
        8.5,
        radius: radius,
        color: blue1,
      ),
      ScatterSpot(
        28,
        10.5,
        radius: radius,
        color: blue1,
      ),
      ScatterSpot(
        30,
        12.5,
        radius: radius,
        color: blue1,
      ),

      ScatterSpot(
        28,
        6.5,
        radius: radius,
        color: blue1,
      ),
      ScatterSpot(
        30,
        8.5,
        radius: radius,
        color: blue1,
      ),
      ScatterSpot(
        32,
        10.5,
        radius: radius,
        color: blue1,
      ),

      ScatterSpot(
        30,
        4.5,
        radius: radius,
        color: blue1,
      ),
      ScatterSpot(
        32,
        6.5,
        radius: radius,
        color: blue1,
      ),
      ScatterSpot(
        34,
        8.5,
        radius: radius,
        color: blue1,
      ),

      ScatterSpot(
        34,
        4.5,
        radius: radius,
        color: blue1,
      ),
      ScatterSpot(
        36,
        6.5,
        radius: radius,
        color: blue1,
      ),

      ScatterSpot(
        38,
        4.5,
        radius: radius,
        color: blue1,
      ),

      /// section 2
      ScatterSpot(
        20,
        14.5,
        radius: radius,
        color: blue2,
      ),
      ScatterSpot(
        22,
        12.5,
        radius: radius,
        color: blue2,
      ),
      ScatterSpot(
        24,
        10.5,
        radius: radius,
        color: blue2,
      ),

      ScatterSpot(
        22,
        16.5,
        radius: radius,
        color: blue2,
      ),
      ScatterSpot(
        24,
        14.5,
        radius: radius,
        color: blue2,
      ),
      ScatterSpot(
        26,
        12.5,
        radius: radius,
        color: blue2,
      ),

      ScatterSpot(
        24,
        18.5,
        radius: radius,
        color: blue2,
      ),
      ScatterSpot(
        26,
        16.5,
        radius: radius,
        color: blue2,
      ),
      ScatterSpot(
        28,
        14.5,
        radius: radius,
        color: blue2,
      ),

      ScatterSpot(
        26,
        20.5,
        radius: radius,
        color: blue2,
      ),
      ScatterSpot(
        28,
        18.5,
        radius: radius,
        color: blue2,
      ),
      ScatterSpot(
        30,
        16.5,
        radius: radius,
        color: blue2,
      ),

      ScatterSpot(
        28,
        22.5,
        radius: radius,
        color: blue2,
      ),
      ScatterSpot(
        30,
        20.5,
        radius: radius,
        color: blue2,
      ),
      ScatterSpot(
        32,
        18.5,
        radius: radius,
        color: blue2,
      ),

      ScatterSpot(
        30,
        24.5,
        radius: radius,
        color: blue2,
      ),
      ScatterSpot(
        32,
        22.5,
        radius: radius,
        color: blue2,
      ),
      ScatterSpot(
        34,
        20.5,
        radius: radius,
        color: blue2,
      ),

      ScatterSpot(
        34,
        24.5,
        radius: radius,
        color: blue2,
      ),
      ScatterSpot(
        36,
        22.5,
        radius: radius,
        color: blue2,
      ),

      ScatterSpot(
        38,
        24.5,
        radius: radius,
        color: blue2,
      ),

      /// section 3
      ScatterSpot(
        10,
        25,
        radius: radius,
        color: blue2,
      ),
      ScatterSpot(
        12,
        23,
        radius: radius,
        color: blue2,
      ),
      ScatterSpot(
        14,
        21,
        radius: radius,
        color: blue2,
      ),

      ScatterSpot(
        12,
        27,
        radius: radius,
        color: blue2,
      ),
      ScatterSpot(
        14,
        25,
        radius: radius,
        color: blue2,
      ),
      ScatterSpot(
        16,
        23,
        radius: radius,
        color: blue2,
      ),

      ScatterSpot(
        14,
        29,
        radius: radius,
        color: blue2,
      ),
      ScatterSpot(
        16,
        27,
        radius: radius,
        color: blue2,
      ),
      ScatterSpot(
        18,
        25,
        radius: radius,
        color: blue2,
      ),

      ScatterSpot(
        16,
        31,
        radius: radius,
        color: blue2,
      ),
      ScatterSpot(
        18,
        29,
        radius: radius,
        color: blue2,
      ),
      ScatterSpot(
        20,
        27,
        radius: radius,
        color: blue2,
      ),

      ScatterSpot(
        18,
        33,
        radius: radius,
        color: blue2,
      ),
      ScatterSpot(
        20,
        31,
        radius: radius,
        color: blue2,
      ),
      ScatterSpot(
        22,
        29,
        radius: radius,
        color: blue2,
      ),

      ScatterSpot(
        20,
        35,
        radius: radius,
        color: blue2,
      ),
      ScatterSpot(
        22,
        33,
        radius: radius,
        color: blue2,
      ),
      ScatterSpot(
        24,
        31,
        radius: radius,
        color: blue2,
      ),

      ScatterSpot(
        22,
        37,
        radius: radius,
        color: blue2,
      ),
      ScatterSpot(
        24,
        35,
        radius: radius,
        color: blue2,
      ),
      ScatterSpot(
        26,
        33,
        radius: radius,
        color: blue2,
      ),

      ScatterSpot(
        24,
        39,
        radius: radius,
        color: blue2,
      ),
      ScatterSpot(
        26,
        37,
        radius: radius,
        color: blue2,
      ),
      ScatterSpot(
        28,
        35,
        radius: radius,
        color: blue2,
      ),

      ScatterSpot(
        26,
        41,
        radius: radius,
        color: blue2,
      ),
      ScatterSpot(
        28,
        39,
        radius: radius,
        color: blue2,
      ),
      ScatterSpot(
        30,
        37,
        radius: radius,
        color: blue2,
      ),

      ScatterSpot(
        28,
        43,
        radius: radius,
        color: blue2,
      ),
      ScatterSpot(
        30,
        41,
        radius: radius,
        color: blue2,
      ),
      ScatterSpot(
        32,
        39,
        radius: radius,
        color: blue2,
      ),

      ScatterSpot(
        30,
        45,
        radius: radius,
        color: blue2,
      ),
      ScatterSpot(
        32,
        43,
        radius: radius,
        color: blue2,
      ),
      ScatterSpot(
        34,
        41,
        radius: radius,
        color: blue2,
      ),

      ScatterSpot(
        34,
        45,
        radius: radius,
        color: blue2,
      ),
      ScatterSpot(
        36,
        43,
        radius: radius,
        color: blue2,
      ),

      ScatterSpot(
        38,
        45,
        radius: radius,
        color: blue2,
      ),
    ];
  }

  List<ScatterSpot> randomData() {
    const blue1Count = 20;
    const blue2Count = 27;
    return List.generate(blue1Count + blue2Count, (i) {
      Color color;
      if (i < blue1Count) {
        color = blue1;
      } else {
        color = blue2;
      }

      return ScatterSpot(
        (Random().nextDouble() * (maxX - 8)) + 4,
        (Random().nextDouble() * (maxY - 8)) + 4,
        show: true,
        radius: (Random().nextDouble() * 2) + 4,
        color: color,
      );
    });
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      fontSize: 10,
    );
    String text = '';
    switch (value.toInt()) {
      case 1:
        text = '1';
        break;
      case 6:
        text = '2';
        break;
      case 12:
        text = '4';
        break;
      case 18:
        text = '6';
        break;
      case 24:
        text = '8';
        break;
    }

    return Text(
      text,
      style: const TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.normal,
        color: Colors.grey,
      ),
    );
  }

  Widget leftTitles(double value, TitleMeta meta) {
    if (value == meta.max) {
      return Container();
    }
    const style = TextStyle(
      fontSize: 10,
    );
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
        meta.formattedValue,
        style: style,
      ),
    );
  }

  //List<int> notifications = [10, 5, 8, 12, 15, 20, 25, 30, 35, 40, 38, 32, 28, 25, 22, 20, 18, 15, 12, 10, 8, 5, 3, 2];
  List<NotificationData> notifications = [
    NotificationData(hour: 1, count: 10),
    NotificationData(hour: 2, count: 35),
    NotificationData(hour: 3, count: 14),
    NotificationData(hour: 4, count: 25),
    NotificationData(hour: 5, count: 15),
    NotificationData(hour: 6, count: 10),
    NotificationData(hour: 7, count: 25),
    NotificationData(hour: 8, count: 30),
    NotificationData(hour: 9, count: 29),
    NotificationData(hour: 10, count: 21),
    NotificationData(hour: 11, count: 38),
    NotificationData(hour: 12, count: 32),
    NotificationData(hour: 13, count: 28),
    NotificationData(hour: 14, count: 25),
    NotificationData(hour: 15, count: 22),
    NotificationData(hour: 16, count: 20),
    NotificationData(hour: 17, count: 18),
    NotificationData(hour: 18, count: 15),
    NotificationData(hour: 19, count: 12),
    NotificationData(hour: 20, count: 10),
    NotificationData(hour: 21, count: 8),
    NotificationData(hour: 22, count: 5),
    NotificationData(hour: 23, count: 3),
    NotificationData(hour: 24, count: 2),
    // Add more data points for the remaining hours
  ];

  List<ScatterSpot> _generateScatterSpots(
      List<NotificationData> notifications) {
    List<ScatterSpot> spots = [];
    for (var point in notifications) {
      Color color;
      if (point.count <= 10) {
        color = Colors.blue.withOpacity(.5);
      } else if (point.count <= 20) {
        color = Colors.blue.withOpacity(.7);
      } else {
        color = Colors.blue;
      }
      spots.add(
        ScatterSpot(
          point.hour.toDouble(),
          point.count.toDouble(), // Number of notifications
          color: color,
          radius: 5,
        ),
      );
    }
    return spots;
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = ref.watch(appThemeProvider).getTheme();
    var notificationData = ref.watch(notificationCountProvider);
    return SizedBox(
      height: 300,
      width: double.infinity,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Last 24 Hours Alarms',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          ),
          notificationData.when(
            data: (data) {
              List<NotificationData> notificationList =
                  data.map((e) => e).toList();
              if (notificationList.isEmpty) {
                return Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      'No data available',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.latoTextTheme().titleLarge!.copyWith(
                            fontWeight: FontWeight.normal,
                            color: isDarkMode ? Colors.white : Colors.black,
                            fontSize: 15,
                          ),
                    ),
                  ),
                );
              }
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Expanded(
                        child: AspectRatio(
                          aspectRatio: 1.5,
                          child: ScatterChart(
                            ScatterChartData(
                              //scatterSpots: showFlutter ? flutterLogoData() : randomData(),
                              scatterSpots:
                                  _generateScatterSpots(notificationList),
                              minX: 1,
                              maxX: 24,
                              minY: 0,
                              maxY: notificationList
                                      .reduce((value, element) =>
                                          (value.count > element.count
                                              ? value
                                              : element))
                                      .count
                                      .toDouble() +
                                  5,
                              borderData: FlBorderData(
                                show: false,
                              ),
                              gridData: const FlGridData(
                                show: true,
                              ),
                              titlesData: FlTitlesData(
                                show: true,
                                bottomTitles: AxisTitles(
                                  drawBelowEverything: true,
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 30,
                                    getTitlesWidget: bottomTitles,
                                    /*getTitlesWidget: (value, meta) {
                                        // Convert the x-axis values to strings
                                        String text = '';
                                        switch (value.toInt()) {
                                          case 1:
                                            text = '1h';
                                            break;
                                          case 6:
                                            text = '6h';
                                            break;
                                          case 12:
                                            text = '12h';
                                            break;
                                          case 18:
                                            text = '18h';
                                            break;
                                          case 24:
                                            text = '24h';
                                            break;
                                            */ /*return SideTitleWidget(
                                              axisSide: meta.axisSide,
                                              child: Text(
                                                '24h',
                                                style: TextStyle(
                                                  fontSize: 10,
                                                ),
                                              ),
                                            );*/ /*
                                        }
                                        return Text(
                                          text,
                                          style: const TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.normal,
                                            color: Colors.grey,
                                          ),
                                        );
                                      },*/
                                  ),
                                ),
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 30,
                                    getTitlesWidget: leftTitles,
                                  ),
                                ),
                                topTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                rightTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                              ),
                              scatterTouchData: ScatterTouchData(
                                enabled: true,
                              ),
                              clipData: FlClipData.all(),
                            ),
                            swapAnimationDuration:
                                const Duration(milliseconds: 600),
                            swapAnimationCurve: Curves.bounceOut,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      // Add legend on the right side
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLegend(
                              isDarkMode: isDarkMode,
                              color: Colors.blue,
                              text: 'Alarms'),
                          // Add more legends as needed
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
            error: (error, stackTrace) {
              return Center(
                child: GraphError(
                  errorMessage: error.toString(),
                  onRetry: () {},
                ),
              );
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
        ],
      ),
    );
  }

  Widget _buildLegend(
      {required bool isDarkMode, required Color color, required String text}) {
    return Row(
      children: [
        Container(
          width: 7,
          height: 7,
          color: color,
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.normal,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
      ],
    );
  }
}
