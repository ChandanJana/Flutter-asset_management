import 'package:flutter/material.dart';
import 'package:mindteck_iot/widgets/Charts/bar_graph_widget.dart';
import 'package:mindteck_iot/widgets/Charts/horizontal_bar_graph.dart';
import 'package:mindteck_iot/widgets/Charts/pie_chart_widget.dart';

import '../../widgets/Charts/up_time_progress_bar.dart';

class GuestDashboardScreen extends StatelessWidget {
  const GuestDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            elevation: 2, // Add elevation for a shadow effect
            child: BarGraphWidget(),
          ),
          Card(
            elevation: 2,
            child: PieChartWidget(),
          ),
          Card(
            elevation: 2,
            child: HorizontalBarGraphWidget(),
          ),
          Card(
            elevation: 2,
            child: UpTimeProgressWidget(),
          ),
        ],
      ),
    );
  }
}
