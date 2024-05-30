import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindteck_iot/widgets/Charts/bar_graph_widget.dart';
import 'package:mindteck_iot/widgets/Charts/horizontal_bar_graph.dart';
import 'package:mindteck_iot/widgets/Charts/pie_chart_widget.dart';

import '../../provider/app_theme_provider.dart';
import '../../widgets/Charts/up_time_progress_bar.dart';

class DataAnalystDashboardScreen extends ConsumerStatefulWidget {
  const DataAnalystDashboardScreen({super.key});

  @override
  ConsumerState<DataAnalystDashboardScreen> createState() {
    return _DataAnalystDashboardState();
  }
}

class _DataAnalystDashboardState
    extends ConsumerState<DataAnalystDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    var isDarkMode = ref.watch(appThemeProvider).getTheme();
    /*return ListView(
      scrollDirection: Axis.vertical,
      children: <Widget>[
        Container(
          height: 300,
          child: ListView(
            scrollDirection: Axis.vertical,
            children: [
              Card(
                color: isDarkMode ? Color.fromARGB(0, 33, 43, 54) : Colors.white,
                elevation: 2, // Add elevation for a shadow effect
                child: BarGraphWidget(),
              ),
              Card(
                color: isDarkMode ? Color.fromARGB(0, 33, 43, 54) : Colors.white,
                elevation: 2,
                child: HorizontalBarGraphWidget(),
              ),
            ],
          ),
        ),
        Container(
          height: 300,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              Card(
                color: isDarkMode ? Color.fromARGB(0, 33, 43, 54) : Colors.white,
                elevation: 2,
                child: PieChartWidget(),
              ),
              Card(
                color: isDarkMode ? Color.fromARGB(0, 33, 43, 54) : Colors.white,
                elevation: 2,
                child: CircularProgressWidget(),
              ),
            ],
          ),
        )
      ],
    );*/
    /*return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Expanded(
                child: Card(
                  color:
                      isDarkMode ? Color.fromARGB(0, 33, 43, 54) : Colors.white,
                  elevation: 2, // Add elevation for a shadow effect
                  child: BarGraphWidget(),
                ),
              ),
              Expanded(
                child: Card(
                  color:
                      isDarkMode ? Color.fromARGB(0, 33, 43, 54) : Colors.white,
                  elevation: 2,
                  child: HorizontalBarGraphWidget(),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Card(
                  color:
                      isDarkMode ? Color.fromARGB(0, 33, 43, 54) : Colors.white,
                  elevation: 2,
                  child: PieChartWidget(),
                ),
              ),
              Expanded(
                child: Card(
                  color:
                      isDarkMode ? Color.fromARGB(0, 33, 43, 54) : Colors.white,
                  elevation: 2,
                  child: CircularProgressWidget(),
                ),
              ),
            ],
          ),
          Container(
            height: 300,
            width: double.infinity,
            padding: EdgeInsets.all(10),
            child: Card(
              color: isDarkMode ? Color.fromARGB(0, 33, 43, 54) : Colors.white,
              elevation: 2,
              child: IotMapWidget(),
            ),
          )
        ],
      ),
    );*/
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Card(
            color:
                isDarkMode ? const Color.fromARGB(0, 33, 43, 54) : Colors.white,
            elevation: 2, // Add elevation for a shadow effect
            child: BarGraphWidget(),
          ),
          Card(
            color:
                isDarkMode ? const Color.fromARGB(0, 33, 43, 54) : Colors.white,
            elevation: 2,
            child: const PieChartWidget(),
          ),
          Card(
            color:
                isDarkMode ? const Color.fromARGB(0, 33, 43, 54) : Colors.white,
            elevation: 2,
            child: HorizontalBarGraphWidget(),
          ),
          Card(
            color:
                isDarkMode ? const Color.fromARGB(0, 33, 43, 54) : Colors.white,
            elevation: 2,
            child: const UpTimeProgressWidget(),
          ),
        ],
      ),
    );
  }
}
