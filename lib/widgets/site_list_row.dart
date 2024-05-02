import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mindteck_iot/models/site/site_data.dart';
import 'package:mindteck_iot/resource/app_text.dart';
import 'package:mindteck_iot/utils/arc_clipper.dart';

class SiteManagementListRow extends StatelessWidget {
  const SiteManagementListRow({super.key, required this.sitelist});

  final SiteData sitelist;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
      ),
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceVariant,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      margin: const EdgeInsets.all(8),
      child: Stack(
        children: [
          Center(
            child: Container(
              width: double.infinity,
              height: 150,
              decoration: BoxDecoration(
                borderRadius:
                    const BorderRadius.only(bottomLeft: Radius.circular(20.0)),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).colorScheme.onPrimaryContainer,
                    Theme.of(context)
                        .colorScheme
                        .onPrimaryContainer
                        .withOpacity(.5),
                  ],
                ),
              ),
              child: ClipRect(child: CustomPaint(painter: ArcClipper())),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: ListTile(
              title: Text(
                sitelist.siteName ?? '',
                style: GoogleFonts.latoTextTheme().titleLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.background,
                      fontSize: 15,
                    ),
                textAlign: TextAlign.center,
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _buildSubtitleRows(context),
              ),
              onTap: () {
                // Handle row tap here
              },
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildSubtitleRows(BuildContext context) {
    final List<Widget> rows = [];

    void addRow(String label, String? value) {
      if (value != null && value.isNotEmpty) {
        rows.add(
          Row(
            children: [
              Text(
                label,
                style: _getTextStyle(context),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Text(
                  value,
                  style: _getTextStyle(context),
                ),
              ),
            ],
          ),
        );
      }
    }

    addRow(AppText.site_description, sitelist.siteDescription);
    addRow(
        AppText.site_type, (sitelist.siteType == 'O' ? 'Outdoor' : 'Indoor'));
    // addRow(AppText.device_category_name, sitelist.deviceCategoryName);
    // addRow(AppText.device_lifecycle_name, sitelist.deviceLifeCycleName);
    // addRow(AppText.device_tenant_name, sitelist.tenantName);

    // const SizedBox(height: 10);

    // if (sitelist.isActive != null) {
    //   final Color sensorColor =
    //   sitelist.isActive! ? AppColors.contentColorGreen : AppColors.contentColorRed;
    //
    //   rows.add(
    //     Align(
    //       alignment: Alignment.centerRight,
    //       child: Column(
    //         crossAxisAlignment: CrossAxisAlignment.end,
    //         children: [
    //           const SizedBox(height: 20), // Added space before the sensor row
    //           Row(
    //             children: [
    //               Container(
    //                 width: 20.0,
    //                 height: 20.0,
    //                 decoration: BoxDecoration(
    //                   shape: BoxShape.circle,
    //                   color: sensorColor,
    //                 ),
    //               ),
    //               const SizedBox(width: 10),
    //               const Center(
    //                 child: Text(
    //                   AppText.site_isactive,
    //                   style: TextStyle(
    //                     fontWeight: FontWeight.normal,
    //                   ),
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ],
    //       ),
    //     ),
    //   );
    // }

    return rows;
  }

  TextStyle _getTextStyle(BuildContext context) {
    return TextStyle(
      color: Theme.of(context).colorScheme.background,
      fontWeight: FontWeight.normal,
    );
  }
}
