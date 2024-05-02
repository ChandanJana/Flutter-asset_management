import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mindteck_iot/utils/constants.dart';
import 'package:mindteck_iot/utils/utils.dart';
import 'package:mindteck_iot/widgets/device_filter_drawer.dart';
import 'package:mindteck_iot/widgets/device_list_row.dart';
import 'package:mindteck_iot/widgets/error_screen.dart';
import 'package:mindteck_iot/widgets/no_data_screen.dart';

import '../models/device/device_data.dart';
import '../provider/api_data_provider.dart';
import '../provider/app_theme_provider.dart';
import '../resource/app_resource.dart';
import '../widgets/custom_search_delegate.dart';
import 'add_device_screen.dart';
import 'edit_device_screen.dart';

class DeviceScreen extends ConsumerStatefulWidget {
  const DeviceScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<DeviceScreen> createState() => _DeviceManagementState();
}

class _DeviceManagementState extends ConsumerState<DeviceScreen> {
  List<DeviceData>? _filteredDevices;
  Connectivity _connectivity = Connectivity();

  String? role;

  Future<void> _getValueFromSecureStorage() async {
    try {
      FlutterSecureStorage storage = FlutterSecureStorage();
      role = await storage.read(key: AppDatabase.roleName);
    } catch (e) {
      // Handle error
      print('Error reading value: $e');
    }
  }

  void _handleConnectivityChange(ConnectivityResult result) {
    setState(() {
      // Handle the connectivity change
      switch (result) {
        case ConnectivityResult.none:
          // No internet connection
          Utils().showNetworkSnackbar(AppText.no_internet, context);
          break;
        case ConnectivityResult.mobile:
          // Mobile data connection
          //_showNetworkSnackbar("Connected to Mobile Data");
          break;
        case ConnectivityResult.wifi:
          // WiFi connection
          //_showNetworkSnackbar("Connected to WiFi");
          break;
      }
    });
  }

  void _reload() async {
    if (await Utils().checkInternetConnectivity()) {
      ref.invalidate(deviceListProvider);
      ref.read(deviceListProvider);
    } else {
      Utils().showNetworkSnackbar(AppText.no_internet, context);
    }
  }

  void _addDevice() async {
    final isAdded = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) {
          return const AddDeviceScreen();
        },
      ),
    ).then((value) {
      setState(() {
        _reload();
      });
    });

    if (isAdded!) {
      //DeviceData deviceData = ref.watch(deviceDataStateProvider as ProviderListenable<DeviceData>);
      //ResponseModel responseModel = ref.watch(addDeviceProvider(deviceData) as ProviderListenable<ResponseModel>);
      //print('deviceData $deviceData');
      //print('responseModel $responseModel');
      //if (responseModel != null) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'Device Added successfully',
          style: TextStyle(color: Colors.white),
        ),
        duration: Duration(
          seconds: 5,
        ),
        backgroundColor: Colors.black,
      ));
      //}
    }
  }

  void _editDevice(BuildContext context, {required DeviceData data}) async {
    final isAdded = await Navigator.of(context).push<bool>(MaterialPageRoute(
      builder: (context) {
        return EditDeviceScreen(deviceData: data);
      },
    ));

    if (isAdded!) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          'Zone edit feature available soon!',
          style: TextStyle(color: Colors.white),
        ),
        duration: Duration(
          seconds: 5,
        ),
        backgroundColor: Colors.black,
      ));
    }
  }

  void _openFilterDrawer() {
    showModalBottomSheet(
      useRootNavigator: true,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: true,
      context: context,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      useSafeArea: true,
      builder: (context) => SizedBox(
        height: MediaQuery.of(context).size.height *
            0.57, // Adjust the height as needed
        child: FilterDrawer(
          onApplyFilters: _applyFilters,
        ),
      ),
    );
  }

  void _applyFilters(bool isSensorChecked, List<String> selectedCategories,
      List<String> selectedStatus) {
    final deviceData = ref.read(deviceListProvider);

    _filteredDevices = deviceData.when(
      data: (data) {
        return data.where((device) {
              bool categoryFilter = selectedCategories.isEmpty ||
                  selectedCategories.contains(device.deviceCategoryName);
              bool sensorFilter = !isSensorChecked || device.isSensor == true;
              bool statusFilter = selectedStatus.isEmpty ||
                  selectedStatus.contains(device.deviceLifeCycleName);

              return categoryFilter && sensorFilter && statusFilter;
            }).toList() ??
            [];
      },
      error: (error, stackTrace) {
        return [];
      },
      loading: () {
        // Handle loading state if needed
        return [];
      },
    );

    setState(() {});

    Navigator.pop(context);
  }

  void _showDeviceDetailDialog(BuildContext context,
      {required DeviceData data}) {
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      shape: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.0),
        borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
      ),
      title: Text(
        AppText.device_details,
        textAlign: TextAlign.center,
        style: GoogleFonts.latoTextTheme().titleLarge!.copyWith(
              fontWeight: FontWeight.normal,
              color: Theme.of(context).colorScheme.onBackground,
              fontSize: 25.0,
            ),
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Name: ${data.deviceName}',
            style: GoogleFonts.latoTextTheme().titleLarge!.copyWith(
                  fontWeight: FontWeight.normal,
                  color: Theme.of(context).colorScheme.onBackground,
                  fontSize: 15.0,
                ),
          ),
          const SizedBox(height: 10),
          Text(
            'Category: ${data.deviceCategoryName}',
            style: GoogleFonts.latoTextTheme().titleLarge!.copyWith(
                  fontWeight: FontWeight.normal,
                  color: Theme.of(context).colorScheme.onBackground,
                  fontSize: 15.0,
                ),
          ),
          const SizedBox(height: 10),
          Text(
            'Serial No: ${data.deviceSerialNumber}',
            style: GoogleFonts.latoTextTheme().titleLarge!.copyWith(
                  fontWeight: FontWeight.normal,
                  color: Theme.of(context).colorScheme.onBackground,
                  fontSize: 15.0,
                ),
          ),
          const SizedBox(height: 10),
          Text(
            'Hardware Id: ${data.deviceHardwareId}',
            style: GoogleFonts.latoTextTheme().titleLarge!.copyWith(
                  fontWeight: FontWeight.normal,
                  color: Theme.of(context).colorScheme.onBackground,
                  fontSize: 15.0,
                ),
          ),
          const SizedBox(height: 10),
          Text(
            'Status: ${data.deviceLifeCycleName}',
            style: GoogleFonts.latoTextTheme().titleLarge!.copyWith(
                  fontWeight: FontWeight.normal,
                  color: Theme.of(context).colorScheme.onBackground,
                  fontSize: 15.0,
                ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            AppText.close,
            style: GoogleFonts.latoTextTheme().titleLarge!.copyWith(
                  fontWeight: FontWeight.normal,
                  color: Theme.of(context).colorScheme.onBackground,
                  fontSize: 15.0,
                ),
          ),
        ),
      ],
    );

    // show the dialog
    showGeneralDialog(
      context: context,
      pageBuilder: (context, animation, secondaryAnimation) {
        return Container(
          height: 300,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(40),
          ),
          child: const SizedBox.expand(child: FlutterLogo()),
        );
      },
      transitionBuilder: (ctx, anim, a2, child) {
        var curve = Curves.easeInOut.transform(anim.value);
        return Transform.scale(
          scale: curve,
          child: alert,
        );
      },
      transitionDuration: const Duration(milliseconds: 250),
      barrierDismissible: true,
      barrierLabel: "Barrier",
      barrierColor: Colors.black.withOpacity(0.5),
    );
  }

  void onItemClick(DeviceData data, String actionType) {
    switch (actionType) {
      case Constants.item_view:
        _showDeviceDetailDialog(context, data: data);
        break;
      case Constants.item_edit:
        _editDevice(context, data: data);
        break;
    }
  }

  @override
  void initState() {
    // Initialize the connectivity package
    //_connectivity = Connectivity();

    // Subscribe to the connectivity changes
    /*_connectivity.onConnectivityChanged.listen((result) {
      // Handle the connectivity change
      _handleConnectivityChange(result);
    });*/
    _getValueFromSecureStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final deviceData = ref.watch(deviceListProvider);
    final isDarkMode = ref.watch(appThemeProvider).getTheme();
    return Scaffold(
      body: CustomScrollView(
        primary: true,
        slivers: <Widget>[
          SliverAppBar(
            forceElevated: true,
            elevation: 4,
            floating: true,
            pinned: true,
            iconTheme: IconThemeData(
              color: Colors.white, // Change the color of the back button
            ),
            title: Text(
              AppText.device,
              style: GoogleFonts.latoTextTheme().titleLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 18,
                  ),
            ),
            actions: [
              IconButton(
                key: ValueKey<String>('device_search'),
                onPressed: () {
                  deviceData.when(
                    data: (data) {
                      List<DeviceData> deviceList = data.map((e) => e).toList();
                      return showSearch(
                        context: context,
                        delegate: CustomSearchDelegate<DeviceData>(
                            optionName: 'Devices',
                            searchList: deviceList,
                            role: role),
                      );
                    },
                    error: (error, stackTrace) {},
                    loading: () {},
                  );
                },
                icon: const Icon(
                  Icons.search,
                  color: Colors.white,
                ),
              ),
              if (role == Constants.system_administrator)
                IconButton(
                  key: ValueKey<String>('device_add'),
                  onPressed: _addDevice,
                  icon: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
              IconButton(
                key: ValueKey<String>('device_filter'),
                onPressed: _openFilterDrawer,
                icon: const Icon(
                  Icons.filter_list_alt,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SliverFillRemaining(
            child: deviceData.when(
              data: (data) {
                List<DeviceData>? deviceList =
                    _filteredDevices ?? data.where((e) => e != null).toList();
                if (deviceList.isEmpty) {
                  return Container(
                    alignment: Alignment.center,
                    child: NoDataScreen(onRetry: _reload),
                  );
                }

                return GridView.custom(
                  padding: const EdgeInsets.only(top: 0),
                  physics: const AlwaysScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      mainAxisSpacing: 0.0, // Spacing between rows
                      crossAxisSpacing: 0.0, // Spacing between columns
                      childAspectRatio: 2.0 // Number of columns
                      ),
                  childrenDelegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return DeviceManagementListRow(
                        role: role,
                        devicelist: deviceList[index],
                        onItemClick: onItemClick,
                      );
                    },
                    childCount: deviceList.length, // Total number of items
                  ),
                );

                /*return GridView.count(
                  crossAxisCount: 2,
                  primary: true,
                  padding: const EdgeInsets.all(5),
                  crossAxisSpacing: 0.0,
                  mainAxisSpacing: 0,
                  childAspectRatio: 1,
                  // Number of columns
                  children: List.generate(deviceList.length, (index) {
                    return DeviceManagementListRow(
                      devicelist: deviceList[index],
                      onItemClick: onItemClick,
                    );
                  }),
                );*/

                /*return ListView.builder(
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    return DeviceManagementListRow(
                      devicelist: deviceList[index],
                    );
                  },
                  itemCount: deviceList.length,
                );*/
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

  @override
  void dispose() {
    super.dispose();
  }
}
