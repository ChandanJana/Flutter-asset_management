import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mindteck_iot/provider/api_data_provider.dart';

import '../../provider/app_theme_provider.dart';
import '../graph_error.dart';

class UpTimeProgressWidget extends ConsumerStatefulWidget {
  const UpTimeProgressWidget({super.key});

  @override
  ConsumerState<UpTimeProgressWidget> createState() => _CircularProgressState();
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

class _CircularProgressState extends ConsumerState<UpTimeProgressWidget> {
  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = ref.watch(appThemeProvider).getTheme();
    var circularChartData = ref.watch(averageUpTimeProvider);
    // Replace with your actual number
    return SizedBox(
      height: 160,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Average Up Time',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black,
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
                              style: GoogleFonts.latoTextTheme()
                                  .titleLarge!
                                  .copyWith(
                                    fontWeight: FontWeight.normal,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground,
                                    fontSize: 15,
                                  ),
                            ),
                          ),
                        );
                      }
                      return Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              flex:1,
                              child: Text(
                                textAlign: TextAlign.center,
                                '0',
                                style: GoogleFonts.latoTextTheme()
                                    .titleLarge!
                                    .copyWith(
                                      fontWeight: FontWeight.normal,
                                      color: isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: 30,
                                    ),
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.black,
                                ),
                                children: [
                                  WidgetSpan(
                                    alignment: PlaceholderAlignment.middle,
                                    child: Icon(
                                      Icons.arrow_upward_sharp,
                                      size: 20,
                                      color: Colors.green,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '100%',
                                    style: GoogleFonts.latoTextTheme()
                                        .titleLarge!
                                        .copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green,
                                          fontSize: 15,
                                        ),
                                  ),
                                  TextSpan(
                                    text: '    Since last 24 hour',
                                    style: GoogleFonts.latoTextTheme()
                                        .titleLarge!
                                        .copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey,
                                          fontSize: 13,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ],
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
            ),
            Container(
              alignment: Alignment.center,
              width: 60,
              height: 60,
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: Colors.green),
              child: Icon(
                Icons.timer,
                size: 30,
                color: Colors.white,
              ),
            )
          ],
        ),
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
