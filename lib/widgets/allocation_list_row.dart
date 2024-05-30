import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mindteck_iot/models/allocation/allocation_data.dart';
import 'package:mindteck_iot/utils/constants.dart';

import '../provider/app_theme_provider.dart';
import '../resource/app_resource.dart';

class AllocationListRow extends ConsumerWidget {
  const AllocationListRow(
      {super.key,
      required this.role,
      required this.allocationData,
      required this.onItemClick});

  final AllocationData allocationData;
  final String? role;
  final Function(AllocationData allocationData, String actionType) onItemClick;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var isDarkMode = ref.watch(appThemeProvider).getTheme();
    return InkWell(
      highlightColor: Colors.blue.withOpacity(0.4),
      splashColor: Colors.green.withOpacity(0.5),
      key: ValueKey<String>('device_row'),
      onTap: () {
        onItemClick(allocationData, Constants.item_view);
        /*Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (BuildContext context,
                        Animation<double> animation,
                        Animation<double> secondaryAnimation) {

                      return Container();
                    },
                    transitionDuration: const Duration(milliseconds: 500),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      var begin = 0.0;
                      var end = 1.0;
                      var curve = Curves.ease;

                      var tween = Tween(begin: begin, end: end)
                          .chain(CurveTween(curve: curve));
                      return ScaleTransition(
                        scale: animation.drive(tween),
                        child: child,
                      );
                    },
                  ),
                );*/
      },
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: Card(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20.0),
              bottomRight: Radius.circular(5.0),
              topLeft: Radius.circular(5.0),
              topRight: Radius.circular(5.0),
            ),
          ),
          elevation: 2,
          color:
              isDarkMode ? const Color.fromARGB(0, 33, 43, 54) : Colors.white,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          //margin: const EdgeInsets.all(8),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              //crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Text(
                        allocationData.deviceName ?? '',
                        style: GoogleFonts.latoTextTheme().titleLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: isDarkMode ? Colors.white : Colors.black,
                              fontSize: 13,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    if (role == Constants.system_administrator)
                      PopupMenuButton<String>(
                        //color: isDarkMode ? Colors.white : Colors.black,
                        tooltip: 'More',
                        elevation: 10,
                        iconSize: 18,
                        iconColor: isDarkMode ? Colors.white : Colors.black,
                        enableFeedback: true,
                        enabled: true,
                        icon: Icon(
                          Icons.more_vert,
                          color: isDarkMode ? Colors.white : Colors.black,
                          size: 20,
                        ),
                        itemBuilder: (context) => [
                          PopupMenuItem<String>(
                            value: 'Edit',
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.edit,
                                  color: AppColors.contentColorGreen,
                                  size: 20,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  AppText.edit,
                                  style: TextStyle(
                                    color: isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          PopupMenuItem<String>(
                            value: 'Remove',
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.delete,
                                  color: AppColors.contentColorRed,
                                  size: 20,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  AppText.remove,
                                  style: TextStyle(
                                    color: isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        onSelected: (value) {
                          if (value == 'Edit') {
                            onItemClick(allocationData, Constants.item_edit);
                          } else if (value == 'Remove') {
                            onItemClick(allocationData, Constants.item_remove);
                          }
                        },
                      ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Expanded(
                      child: addRow(isDarkMode, AppText.device_name,
                          allocationData.deviceName ?? '', context),
                    )
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Expanded(
                      child: addRow(isDarkMode, AppText.allocation_id,
                          allocationData.allocationId ?? '', context),
                    )
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    addRow(isDarkMode, AppText.parent_device,
                        allocationData.parentDeviceName ?? '', context),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget addRow(
      bool isDarkMode, String label, String value, BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 5),
      child: Row(
        children: [
          Text(
            label + ':',
            style: GoogleFonts.robotoFlexTextTheme().titleLarge!.copyWith(
                  fontWeight: FontWeight.normal,
                  color: isDarkMode ? Colors.white : Colors.black,
                  fontSize: 14,
                ),
          ),
          const SizedBox(width: 10),
          /*Container(
            padding: const EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.white : Colors.black,
              borderRadius: BorderRadius.circular(15.0),
            ),
            child:*/
          Text(
            value,
            style: GoogleFonts.robotoFlexTextTheme().titleLarge!.copyWith(
                  fontWeight: FontWeight.normal,
                  color: isDarkMode ? Colors.white : Colors.black,
                  fontSize: 13,
                ),
          ),
          //),
        ],
      ),
    );
  }
}
