import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mindteck_iot/models/pieChart/pie_chart_tenant_entities.dart';

import '../../provider/api_data_provider.dart';
import '../../provider/app_theme_provider.dart';
import '../graph_error.dart';

class PieChartWidget extends ConsumerStatefulWidget {
  const PieChartWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _PieChartWidget();
  }
}

class _PieChartWidget extends ConsumerState<PieChartWidget> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = ref.watch(appThemeProvider).getTheme();
    var pieChartData = ref.watch(pieChartProvider);
    return SizedBox(
      height: 300,
      width: double.infinity,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'System',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black),
            ),
          ),
          /*Container(
            height: 260,
            child: */
          pieChartData.when(
            data: (data) {
              List<PieChartTenantEntities> pieList =
                  data.map((e) => e).toList();
              if (pieList.isEmpty) {
                return Expanded(
                  child: Container(
                    child: Text(
                      'No data available',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.latoTextTheme().titleLarge!.copyWith(
                            fontWeight: FontWeight.normal,
                            color: Theme.of(context).colorScheme.onBackground,
                            fontSize: 15,
                          ),
                    ),
                  ),
                );
              }
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: PieChart(
                          PieChartData(
                            sections: pieList.map((data) {
                              final isTouched =
                                  pieList.indexOf(data) == touchedIndex;
                              final double fontSize = isTouched ? 18 : 16;
                              final double radius = isTouched ? 100 : 90;
                              return PieChartSectionData(
                                value: data.count?.toDouble(),
                                title: data.count.toString(),
                                color: getRandomColor(data.name!),
                                radius: radius,
                                titleStyle: GoogleFonts.latoTextTheme()
                                    .titleSmall!
                                    .copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: fontSize,
                                    ),
                              );
                            }).toList(),
                            sectionsSpace: 3,
                            centerSpaceRadius: 0,
                            //centerSpaceColor: Colors.white,
                            borderData: FlBorderData(
                              show: true,
                            ),
                            pieTouchData: PieTouchData(
                              touchCallback: (FlTouchEvent event,
                                  PieTouchResponse? touchResponse) {
                                setState(() {
                                  if (!event.isInterestedForInteractions ||
                                      touchResponse == null ||
                                      touchResponse.touchedSection == null) {
                                    touchedIndex = -1;
                                    return;
                                  }
                                  touchedIndex = touchResponse
                                      .touchedSection!.touchedSectionIndex;
                                  //startDegree = 270.0;
                                });
                              },
                              enabled: true,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      // Add legends on the right side
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: pieList.map((data) {
                          return _buildLegend(
                              isDarkMode: isDarkMode,
                              color: getRandomColor(data.name!),
                              text: data.name!);
                        }).toList(),
                        /* children: [
                          _buildLegend(
                              isDarkMode: isDarkMode,
                              color: Colors.green,
                              text: 'In Stock'),
                          _buildLegend(
                              isDarkMode: isDarkMode,
                              color: Colors.indigo,
                              text: 'Assigned'),
                          _buildLegend(
                              isDarkMode: isDarkMode,
                              color: Colors.blueAccent,
                              text: 'Stolen'),
                          _buildLegend(
                              isDarkMode: isDarkMode,
                              color: Colors.purpleAccent,
                              text: 'Registered'),
                          _buildLegend(
                              isDarkMode: isDarkMode,
                              color: Colors.yellow,
                              text: 'De-Registered'),
                          _buildLegend(
                              isDarkMode: isDarkMode,
                              color: Colors.orange,
                              text: 'Damaged'),
                          _buildLegend(
                              isDarkMode: isDarkMode,
                              color: Colors.red,
                              text: 'De-commissioned'),
                          _buildLegend(
                              isDarkMode: isDarkMode,
                              color: Colors.cyan,
                              text: 'Lost'),
                          // Add more legends as needed
                        ],*/
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
          //),
        ],
      ),
    );
  }

  // Generate random color for each section of the pie chart
  Color getRandomColor(String name) {
    /*switch (name) {
      case 'Lost':
        return Colors.cyan;
      case 'De-commissioned':
        return Colors.red;
      case 'Damaged':
        return Colors.orange;
      case 'De-Registered':
        return Colors.yellow;
      case 'Registered':
        return Colors.purpleAccent;
      case 'Stolen':
        return Colors.blueAccent;
      case 'Assigned':
        return Colors.indigo;
      case 'In Stock':
        return Colors.green;
    }*/
    switch (name) {
      case 'Device':
        return Colors.green;
      case 'Site':
        return Colors.orange;
      case 'Users':
        return Colors.indigo;
    }
    return Colors.white;
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
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            text,
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.normal,
                color: isDarkMode ? Colors.white : Colors.black),
          ),
        ),
      ],
    );
  }
}
