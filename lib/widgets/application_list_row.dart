import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mindteck_iot/utils/arc_clipper.dart';

class ApplicationManagementListRow extends StatelessWidget {
  const ApplicationManagementListRow({Key? key, required this.applicationlist});

  final applicationlist;

  @override
  Widget build(BuildContext context) {
    if (applicationlist == null) {
      return Container(); // or any other appropriate widget
    }

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
              height: 100,
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
                applicationlist.applicationName ?? '',
                style: GoogleFonts.latoTextTheme().titleLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.background,
                      fontSize: 15,
                    ),
                textAlign: TextAlign.center,
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

  // List<Widget> _buildSubtitleRows(BuildContext context) {
  //   final List<Widget> rows = [];
  //
  //   void addRow(String label, String? value) {
  //     if (value != null && value.isNotEmpty) {
  //       rows.add(
  //         Row(
  //           children: [
  //             Text(
  //               label,
  //               style: _getTextStyle(context),
  //             ),
  //             const SizedBox(width: 20),
  //             Text(
  //               value,
  //               style: _getTextStyle(context),
  //             ),
  //           ],
  //         ),
  //       );
  //     }
  //   }
  //
  //   addRow(AppText.device_Serial_number, applicationlist.deviceSerialNumber);
  //   addRow(AppText.device_Hardware_id, applicationlist.deviceHardwareId);
  //   addRow(AppText.device_category_name, applicationlist.deviceCategoryName);
  //   addRow(AppText.device_lifecycle_name, applicationlist.deviceLifeCycleName);
  //   addRow(AppText.device_tenant_name, applicationlist.tenantName);
  //
  //   const SizedBox(height: 10);
  //
  //   if (applicationlist.isSensor != null) {
  //     final Color sensorColor =
  //     applicationlist.isSensor! ? AppColors.contentColorGreen : AppColors.contentColorRed;
  //
  //     rows.add(
  //       Align(
  //         alignment: Alignment.centerRight,
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.end,
  //           children: [
  //             const SizedBox(height: 20), // Added space before the sensor row
  //             Row(
  //               children: [
  //                 Container(
  //                   width: 20.0,
  //                   height: 20.0,
  //                   decoration: BoxDecoration(
  //                     shape: BoxShape.circle,
  //                     color: sensorColor,
  //                   ),
  //                 ),
  //                 const SizedBox(width: 10),
  //                 const Center(
  //                   child: Text(
  //                     AppText.device_isSensor,
  //                     style: TextStyle(fontWeight: FontWeight.bold),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ],
  //         ),
  //       ),
  //     );
  //   }
  //
  //
  //   return rows;
  // }

  TextStyle _getTextStyle(BuildContext context) {
    return TextStyle(
      color: Theme.of(context).colorScheme.background,
      fontWeight: FontWeight.normal,
    );
  }
}
