import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mindteck_iot/provider/api_data_provider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../../provider/app_theme_provider.dart';
import '../graph_error.dart';

class CircularProgressWidget extends ConsumerStatefulWidget {
  const CircularProgressWidget({super.key});

  @override
  ConsumerState<CircularProgressWidget> createState() =>
      _CircularProgressState();
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

class _CircularProgressState extends ConsumerState<CircularProgressWidget> {
  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = ref.watch(appThemeProvider).getTheme();
    var circularChartData = ref.watch(averageUpTimeProvider);
    // Replace with your actual number
    return SizedBox(
      height: 300,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Average Up Time',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          ),
          circularChartData.when(
            data: (data) {
              //List<PieChartTenantEntities> pieList = data.map((e) => e).toList();
              print('Circular data $data');
              if (data == null) {
                return Expanded(
                  child: Container(
                    child: Text(
                      textAlign: TextAlign.center,
                      'No data available',
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
                  child: Column(
                    children: [
                      Expanded(
                        child: SfRadialGauge(
                          animationDuration: 20,
                          enableLoadingAnimation: true,
                          axes: <RadialAxis>[
                            RadialAxis(
                              minimum: 0,
                              maximum: 100,
                              showLabels: true,
                              showTicks: true,
                              canScaleToFit: true,
                              showLastLabel: true,
                              showAxisLine: true,
                              majorTickStyle: const MajorTickStyle(
                                length: 0.1,
                                lengthUnit: GaugeSizeUnit.factor,
                                thickness: 1.5,
                                color: Colors.grey,
                              ),
                              minorTickStyle: const MinorTickStyle(
                                length: 0.05,
                                lengthUnit: GaugeSizeUnit.factor,
                                thickness: 1.5,
                                color: Colors.grey,
                              ),
                              axisLabelStyle: const GaugeTextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                              ),
                              axisLineStyle: const AxisLineStyle(
                                thickness: 22,
                                color: Colors.black26,
                                thicknessUnit: GaugeSizeUnit.logicalPixel,
                                cornerStyle: CornerStyle.bothCurve,
                              ),
                              pointers: const <GaugePointer>[
                                NeedlePointer(
                                  needleLength: 0.5,
                                  needleEndWidth: 5,
                                  needleStartWidth: .5,
                                  value: 70,
                                  enableAnimation: true,
                                  needleColor: Color(0xff3366ff),
                                  lengthUnit: GaugeSizeUnit.factor,
                                  knobStyle: KnobStyle(
                                    knobRadius: 0.08,
                                    sizeUnit: GaugeSizeUnit.factor,
                                    color: Colors.deepOrange,
                                    //borderWidth: 0.20,
                                    //borderColor: Colors.green
                                  ),
                                  tailStyle: TailStyle(
                                    width: 8,
                                    length: 0.15,
                                    color: Color(0xff3366ff),
                                  ),
                                ),
                                RangePointer(
                                  value: 70,
                                  width: 0.21,
                                  sizeUnit: GaugeSizeUnit.factor,
                                  cornerStyle: CornerStyle.bothCurve,
                                  gradient: SweepGradient(
                                    colors: <Color>[
                                      Color(0xff779cfd),
                                      Color(0xff3366ff),
                                    ],
                                    stops: <double>[0.25, 0.75],
                                  ),
                                ),
                                MarkerPointer(
                                  value: 70,
                                  markerType: MarkerType.circle,
                                  color: Color(0xff3366ff),
                                )
                              ],
                              annotations: <GaugeAnnotation>[
                                GaugeAnnotation(
                                  positionFactor: 0.4,
                                  angle: 90,
                                  widget: Text(
                                    '70 %',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Column(
                          children: [
                            _buildLegend(
                              isDarkMode: isDarkMode,
                              color: const Color(0xff3366ff),
                              text: 'Transmission',
                            ),
                            // Add more legends as needed
                          ],
                        ),
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
              color: isDarkMode ? Colors.white : Colors.black),
        ),
      ],
    );
  }
}
