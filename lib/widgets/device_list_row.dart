import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mindteck_iot/utils/constants.dart';

import '../models/device/device_data.dart';
import '../provider/app_theme_provider.dart';
import '../resource/app_resource.dart';

class DeviceManagementListRow extends ConsumerWidget {
  const DeviceManagementListRow(
      {super.key,
      required this.role,
      required this.devicelist,
      required this.onItemClick});

  final DeviceData devicelist;
  final String? role;
  final Function(DeviceData data, String actionType) onItemClick;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print('DeviceManagementListRow role $role');
    var isDarkMode = ref.watch(appThemeProvider).getTheme();
    return InkWell(
      highlightColor: Colors.blue.withOpacity(0.4),
      splashColor: Colors.green.withOpacity(0.5),
      key: ValueKey<String>('device_row'),
      onTap: () {
        onItemClick(devicelist, Constants.item_view);
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        devicelist.deviceName ?? '',
                        style: GoogleFonts.latoTextTheme().titleLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: isDarkMode ? Colors.white : Colors.black,
                              fontSize: 13,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    if (role == Constants.system_administrator)
                      InkWell(
                        key: ValueKey<String>('device_edit'),
                        onTap: () {
                          onItemClick(devicelist, Constants.item_edit);
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          alignment: Alignment.topRight,
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.edit,
                              size: 15,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.developer_board,
                      size: 15,
                      color: Colors.grey,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Text(
                        devicelist.deviceSerialNumber ?? '',
                        style: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.black,
                          fontSize: 13,
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.difference_rounded,
                      size: 15,
                      color: Colors.grey,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Text(
                        devicelist.deviceHardwareId ?? '',
                        style: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.black,
                          fontSize: 13,
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    /*Container(
                      width: 10.0,
                      height: 10.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: devicelist.isSensor!
                            ? AppColors.contentColorGreen
                            : AppColors.contentColorRed,
                      ),
                    ),
                    const SizedBox(width: 10),*/
                    const Icon(
                      Icons.category,
                      size: 15,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 10),
                    Center(
                      child: Text(
                        devicelist.deviceCategoryName!,
                        style: GoogleFonts.robotoFlexTextTheme()
                            .titleLarge!
                            .copyWith(
                              fontWeight: FontWeight.normal,
                              color: isDarkMode ? Colors.white : Colors.black,
                              fontSize: 15,
                            ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(width: 20),
                    addRow(isDarkMode, AppText.device_lifecycle_name,
                        devicelist.deviceLifeCycleName ?? '', context),
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
          /*Text(
            label,
            style: GoogleFonts.robotoFlexTextTheme().titleLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDarkMode
                      ? Colors.white.withOpacity(.15)
                      : Colors.black.withOpacity(.15),
                  fontSize: 14,
                ),
          ),
          const SizedBox(width: 10),*/
          /*Container(
            padding: const EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.white : Colors.black,
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: */
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
