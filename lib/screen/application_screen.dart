import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mindteck_iot/provider/api_data_provider.dart';
import 'package:mindteck_iot/resource/app_resource.dart';
import 'package:mindteck_iot/widgets/application_list_row.dart';
import 'package:mindteck_iot/widgets/error_screen.dart';
import 'package:mindteck_iot/widgets/no_data_screen.dart';

import '../models/application/application_data.dart';

class ApplicationScreen extends ConsumerStatefulWidget {
  const ApplicationScreen({super.key});

  @override
  ConsumerState<ApplicationScreen> createState() =>
      _ApplicationManagementState();
}

class _ApplicationManagementState extends ConsumerState<ApplicationScreen> {
  void _reload() {
    ref.invalidate(applicationListProvider);
    ref.read(applicationListProvider);
  }

  @override
  Widget build(BuildContext context) {
    final deviceData = ref.watch(applicationListProvider);

    return Scaffold(
      body: CustomScrollView(
        primary: true,
        slivers: <Widget>[
          SliverAppBar(
            forceElevated: true,
            elevation: 4,
            floating: true,
            pinned: true,
            title: Text(
              AppText.application,
              style: GoogleFonts.latoTextTheme().titleLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 18,
                  ),
            ),
            iconTheme: IconThemeData(
              color: Colors.white, // Change the color of the back button
            ),
            actions: [],
          ),
          SliverFillRemaining(
            child: deviceData.when(
              data: (data) {
                List<ApplicationData>? applicationList =
                    data!.map((e) => e).toList();

                if (applicationList == null || applicationList.isEmpty) {
                  return Container(
                    alignment: Alignment.center,
                    child: NoDataScreen(onRetry: _reload),
                  );
                }
                return ListView.builder(
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    return ApplicationManagementListRow(
                      applicationlist: applicationList[index],
                    );
                  },
                  itemCount: applicationList.length,
                );
              },
              error: (error, stackTrace) {
                return Center(
                  child: ErrorScreen(
                    errorMessage: error.toString(),
                    onRetry: _reload,
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
          ),
        ],
      ),
    );
  }
}
