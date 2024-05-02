import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindteck_iot/utils/constants.dart';
import 'package:mindteck_iot/widgets/menu_items.dart';

import '../provider/app_theme_provider.dart';
import '../resource/app_resource.dart';

class MainDrawer extends ConsumerWidget {
  const MainDrawer({
    super.key,
    required this.userName,
    required this.userEmail,
    required this.userRole,
    required this.userContactNumber,
    required this.onSelect,
  });

  final void Function(String identifier) onSelect;
  final String userName;
  final String userEmail;
  final String? userRole;
  final String? userContactNumber;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isDarkMode = ref.watch(appThemeProvider).getTheme();
    return Drawer(
      key: Key('drawer_element'),
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 100,
            color: Theme.of(context).colorScheme.secondaryContainer,
            // Background color for the header
            alignment: Alignment.center,
            padding: const EdgeInsets.only(top: 20),
            child: Text(
              AppText.mindteck_iot_management,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onBackground,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                MenuItems(
                  textSize: 15,
                  iconSize: 18,
                  menuName: AppText.dashBoard,
                  menuImg: Icons.home,
                  onMenuItemClick: onSelect,
                ),
                if (userRole == Constants.system_administrator ||
                    userRole == Constants.business_administrator ||
                    userRole == Constants.data_analyst ||
                    userRole == Constants.operator)
                  // ExpansionTile(
                  // leading: const Icon(
                  //   Icons.important_devices,
                  //   size: 20,
                  // ),
                  // title: Text(
                  //   AppTexts.deviceManagement,
                  //   style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  //     color: Theme.of(context).colorScheme.onBackground,
                  //     fontSize: 18,
                  //   ),
                  // ),
                  // children: [
                  MenuItems(
                    textSize: 15,
                    iconSize: 18,
                    menuName: AppText.device,
                    menuImg: Icons.space_dashboard_sharp,
                    onMenuItemClick: onSelect,
                  ),
                if (userRole == Constants.system_administrator ||
                    userRole == Constants.business_administrator ||
                    userRole == Constants.operator)
                  MenuItems(
                    textSize: 15,
                    iconSize: 18,
                    menuName: AppText.deviceallocation,
                    menuImg: Icons.home_repair_service_rounded,
                    onMenuItemClick: onSelect,
                  ),
                // ],
                // /),
                /*if (userRole == Constants.system_administrator ||
                    userRole == Constants.business_administrator ||
                    userRole == Constants.operator )
                  MenuItems(
                    textSize: 15,
                    iconSize: 18,
                    menuName: AppText.application,
                    menuImg: Icons.devices_other,
                    onMenuItemClick: onSelect,
                  ),
                if (userRole == Constants.system_administrator ||
                    userRole == Constants.business_administrator )
                  MenuItems(
                    textSize: 15,
                    iconSize: 18,
                    menuName: AppText.sites,
                    menuImg: Icons.location_on_outlined,
                    onMenuItemClick: onSelect,
                  ),
                if (userRole == Constants.system_administrator ||
                    userRole == Constants.business_administrator)
                  MenuItems(
                    textSize: 15,
                    iconSize: 18,
                    menuName: AppText.users,
                    menuImg: Icons.manage_accounts,
                    onMenuItemClick: onSelect,
                  ),*/
                if (userRole == Constants.system_administrator)
                  MenuItems(
                    textSize: 15,
                    iconSize: 18,
                    menuName: AppText.tenants,
                    menuImg: Icons.people_alt,
                    onMenuItemClick: onSelect,
                  ),

                if (userRole == Constants.business_administrator ||
                    userRole == Constants.system_administrator)
                  ExpansionTile(
                    shape: Border(),
                    leading: const Icon(
                      Icons.dashboard_sharp,
                      size: 20,
                    ),
                    title: Text(
                      AppText.assetTrack,
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            color: Theme.of(context).colorScheme.onBackground,
                            fontSize: 15,
                          ),
                    ),
                    children: [
                      MenuItems(
                          textSize: 15,
                          iconSize: 18,
                          menuName: AppText.assetDashBoard,
                          menuImg: Icons.home,
                          onMenuItemClick: onSelect),
                      /*MenuItems(
                        textSize: 15,
                        iconSize: 18,
                        menuName: AppText.allAssets,
                        menuImg: Icons.devices_other,
                        onMenuItemClick: onSelect,
                      ),*/
                      MenuItems(
                        textSize: 15,
                        iconSize: 18,
                        menuName: AppText.locateAsset,
                        menuImg: Icons.location_on_sharp,
                        onMenuItemClick: onSelect,
                      ),
                    ],
                  ),

                // MenuItems(
                //   textSize: 18,
                //   iconSize: 20,
                //   menuName: AppTexts.roleManagement,
                //   menuImg: Icons.shield_outlined,
                //   onMenuItemClick: onSelect,
                // ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
