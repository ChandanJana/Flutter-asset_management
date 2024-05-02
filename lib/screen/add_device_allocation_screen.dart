import 'dart:developer';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mindteck_iot/models/device/device_data.dart';
import 'package:mindteck_iot/models/site/site_data.dart';
import 'package:mindteck_iot/models/site_level/site_level_data.dart';
import 'package:mindteck_iot/provider/api_data_provider.dart';

import '../provider/app_theme_provider.dart';
import 'loading_screen.dart';

/// Created by Chandan Jana on 19-02-2024.
/// Company name: Mindteck
/// Email: chandan.jana@mindteck.com
///

class AddDeviceAllocationScreen extends ConsumerStatefulWidget {
  const AddDeviceAllocationScreen({super.key});

  @override
  ConsumerState<AddDeviceAllocationScreen> createState() {
    return _AddDeviceAllocationState();
  }
}

class _AddDeviceAllocationState
    extends ConsumerState<AddDeviceAllocationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late List<DeviceData?>? parentDevice;
  DeviceData? parentDeviceSelected;
  SiteLevelData? siteLevelDataSelected;

  void _refresh() {
    ref.invalidate(deviceAllocationListProvider);
    ref.read(deviceAllocationListProvider);
    ref.invalidate(siteListProvider);
    ref.read(siteListProvider);
    //ref.read(parentDeviceSelected);
  }

  @override
  void initState() {
    super.initState();
    ref.read(deviceAllocationListProvider);
    ref.read(siteListProvider);
    //ref.read(apiServicesProvider).deviceData = null;
    //ref.read(deviceDataStateProvider.notifier).state = null;
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = ref.watch(appThemeProvider).getTheme();

    final deviceAllocationDataList = ref.watch(deviceAllocationListProvider);
    final siteDataList = ref.watch(siteListProvider);
    final deviceData = ref.watch(deviceDataStateProvider);
    final parentDeviceDataList = ref.watch(parentDeviceProvider(deviceData));
    final siteData = ref.watch(siteDataStateProvider);
    final siteLevelDataList = ref.watch(siteLevelProvider(siteData));
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Allocation',
          style: GoogleFonts
              .latoTextTheme()
              .titleLarge!
              .copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 18,
          ),
        ),
        iconTheme: IconThemeData(
          color: Colors.white, // Change the color of the back button
        ),
        actions: [
          IconButton(
            //key: _fieldKeys['save'],
            onPressed: () {
              /*setState(() {
                isLoading = true;
              });*/
              _addAllocation(ref);
              ref
                  .read(addDeviceAllocationProvider(sendData).future)
                  .then((data) {
                SchedulerBinding.instance.addPostFrameCallback((_) {
                  setState(() {
                    isLoading = false;
                  });
                });
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(
                        data.responseCode == 200
                            ? 'Device Allocation Success'
                            : 'Device Allocation Error',
                        style: GoogleFonts
                            .latoTextTheme()
                            .titleLarge!
                            .copyWith(
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.black,
                          fontSize: 18,
                        ),
                      ),
                      content: Text(
                        //data.responseCode == 200 ? data.data! : data.responseMessage!,
                        'Device allocated successfully',
                        style: GoogleFonts
                            .latoTextTheme()
                            .titleLarge!
                            .copyWith(
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.black,
                          fontSize: 15,
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            sendData.clear();
                            parentDeviceSelected = null;
                            siteLevelDataSelected = null;
                            ref
                                .read(deviceDataStateProvider.notifier)
                                .state =
                            null;
                            ref
                                .read(siteDataStateProvider.notifier)
                                .state =
                            null;
                            Navigator.of(context).pop();
                            Navigator.of(context)
                                .pop(true); // Close the alert dialog
                          },
                          child: Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              }).catchError(
                    (error) {
                  SchedulerBinding.instance.addPostFrameCallback((_) {
                    setState(() {
                      isLoading = false;
                    });
                  });
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(
                          'Device Allocation Error',
                          style: GoogleFonts
                              .latoTextTheme()
                              .titleLarge!
                              .copyWith(
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? Colors.white : Colors.black,
                            fontSize: 18,
                          ),
                        ),
                        content: Text(
                          error.toString(),
                          style: GoogleFonts
                              .latoTextTheme()
                              .titleLarge!
                              .copyWith(
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? Colors.white : Colors.black,
                            fontSize: 15,
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              sendData.clear();
                              Navigator.of(context)
                                  .pop(); // Close the alert dialog
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                },
              );
            },
            icon: const Icon(
              Icons.save,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: () {
              _refresh();
            },
            icon: const Icon(
              Icons.refresh,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: WillPopScope(
        onWillPop: () {
          sendData.clear();
          parentDeviceSelected = null;
          siteLevelDataSelected = null;
          ref
              .read(deviceDataStateProvider.notifier)
              .state = null;
          ref
              .read(siteDataStateProvider.notifier)
              .state = null;
          return Future.value(true);
        },
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: SingleChildScrollView(
                padding: EdgeInsets.only(top: 5),
                child: Column(
                  //mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Form(
                      key: _formKey,
                      //autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        children: [
                          deviceAllocationDataList.when(
                            data: (data) {
                              List<DeviceData> deviceList =
                              data.map((e) => e).toList();
                              if (deviceList.isEmpty) {
                                return Container(
                                  alignment: Alignment.center,
                                  child: const Text('No deivce found'),
                                );
                              }
                              return CustomDropdown<DeviceData>.search(
                                hintText: 'Select device',
                                items: deviceList,
                                excludeSelected: false,
                                onChanged: (value) {
                                  log('changing value to: ${value.deviceName}');
                                  ref
                                      .read(deviceDataStateProvider.notifier)
                                      .state = value;
                                },
                                headerBuilder: (context, selectedItem) {
                                  return Text(selectedItem.deviceName!);
                                },
                                validator: (value) {
                                  if (value == null) {
                                    return "Please select device";
                                  } else {
                                    return null;
                                  }
                                },
                                decoration: const CustomDropdownDecoration(
                                  searchFieldDecoration: SearchFieldDecoration(
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.black,
                                        width: 1,
                                        style: BorderStyle.solid,
                                      ),
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.grey,
                                        width: 1,
                                        style: BorderStyle.none,
                                      ),
                                    ),
                                  ),

                                  //closedFillColor: Colors.green,
                                  //closedBorderRadius: BorderRadius.only(topLeft: Radius.circular(10))
                                ),
                                listItemBuilder:
                                    (context, item, isSelected, onItemSelect) {
                                  return Text(item.deviceName!);
                                },
                              );
                            },
                            error: (error, stackTrace) {
                              return Text(error.toString());
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
                          const SizedBox(height: 20),
                          if (deviceData != null)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Name: ${deviceData.deviceName}',
                                  style: GoogleFonts
                                      .latoTextTheme()
                                      .titleLarge!
                                      .copyWith(
                                    fontWeight: FontWeight.normal,
                                    color: Theme
                                        .of(context)
                                        .colorScheme
                                        .onBackground,
                                    fontSize: 15.0,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Category: ${deviceData.deviceCategoryName}',
                                  style: GoogleFonts
                                      .latoTextTheme()
                                      .titleLarge!
                                      .copyWith(
                                    fontWeight: FontWeight.normal,
                                    color: Theme
                                        .of(context)
                                        .colorScheme
                                        .onBackground,
                                    fontSize: 15.0,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Serial No: ${deviceData.deviceSerialNumber}',
                                  style: GoogleFonts
                                      .latoTextTheme()
                                      .titleLarge!
                                      .copyWith(
                                    fontWeight: FontWeight.normal,
                                    color: Theme
                                        .of(context)
                                        .colorScheme
                                        .onBackground,
                                    fontSize: 15.0,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Hardware Id: ${deviceData.deviceHardwareId}',
                                  style: GoogleFonts
                                      .latoTextTheme()
                                      .titleLarge!
                                      .copyWith(
                                    fontWeight: FontWeight.normal,
                                    color: Theme
                                        .of(context)
                                        .colorScheme
                                        .onBackground,
                                    fontSize: 15.0,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Status: ${deviceData.deviceLifeCycleName}',
                                  style: GoogleFonts
                                      .latoTextTheme()
                                      .titleLarge!
                                      .copyWith(
                                    fontWeight: FontWeight.normal,
                                    color: Theme
                                        .of(context)
                                        .colorScheme
                                        .onBackground,
                                    fontSize: 15.0,
                                  ),
                                ),
                              ],
                            ),
                          const SizedBox(height: 20),
                          if (deviceData != null)
                            parentDeviceDataList.when(
                              data: (data) {
                                List<DeviceData> deviceList =
                                data.map((e) => e).toList();
                                if (deviceList.isEmpty) {
                                  return Container(
                                    alignment: Alignment.center,
                                    child: const Text('No parent deivce found'),
                                  );
                                }
                                return CustomDropdown<DeviceData>.search(
                                  hintText: 'Select parent device',
                                  items: deviceList,
                                  excludeSelected: false,
                                  onChanged: (value) {
                                    log('changing value to: ${value
                                        .deviceName}');
                                    parentDeviceSelected = value;
                                  },
                                  validator: (value) {
                                    if (value == null) {
                                      return "Please select parent device";
                                    } else {
                                      return null;
                                    }
                                  },
                                  headerBuilder: (context, selectedItem) {
                                    return Text(selectedItem.deviceName!);
                                  },
                                  decoration: const CustomDropdownDecoration(
                                    searchFieldDecoration:
                                    SearchFieldDecoration(
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.black,
                                          width: 1,
                                          style: BorderStyle.solid,
                                        ),
                                      ),
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey,
                                          width: 1,
                                          style: BorderStyle.none,
                                        ),
                                      ),
                                    ),

                                    //closedFillColor: Colors.green,
                                    //closedBorderRadius: BorderRadius.only(topLeft: Radius.circular(10))
                                  ),
                                  listItemBuilder: (context, item, isSelected,
                                      onItemSelect) {
                                    return Text(item.deviceName!);
                                  },
                                );
                              },
                              error: (error, stackTrace) {
                                return Text(error.toString());
                              },
                              loading: () {
                                return Center(
                                  child:
                                  LoadingAnimationWidget.staggeredDotsWave(
                                    color: Colors.blueAccent,
                                    size: 70,
                                  ),
                                );
                              },
                            ),
                          if (deviceData != null) const SizedBox(height: 20),
                          siteDataList.when(
                            data: (data) {
                              List<SiteData> siteList =
                              data.map((e) => e).toList();
                              if (siteList.isEmpty) {
                                return Container(
                                  alignment: Alignment.center,
                                  child: const Text('No site found'),
                                );
                              }
                              return CustomDropdown<SiteData>.search(
                                hintText: 'Select site',
                                items: siteList,
                                excludeSelected: false,
                                onChanged: (value) {
                                  log('changing value to: ${value.siteName}');
                                  log('changing value to: ${value.siteId}');
                                  //siteDataSelected = value;
                                  ref
                                      .read(siteDataStateProvider.notifier)
                                      .state = value;
                                },
                                headerBuilder: (context, selectedItem) {
                                  return Text(selectedItem.siteName!);
                                },
                                validator: (value) {
                                  if (value == null) {
                                    return "Please select site";
                                  } else {
                                    return null;
                                  }
                                },
                                decoration: const CustomDropdownDecoration(
                                  searchFieldDecoration: SearchFieldDecoration(
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.black,
                                        width: 1,
                                        style: BorderStyle.solid,
                                      ),
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.grey,
                                        width: 1,
                                        style: BorderStyle.none,
                                      ),
                                    ),
                                  ),

                                  //closedFillColor: Colors.green,
                                  //closedBorderRadius: BorderRadius.only(topLeft: Radius.circular(10))
                                ),
                                listItemBuilder:
                                    (context, item, isSelected, onItemSelect) {
                                  return Text(item.siteName!);
                                },
                              );
                            },
                            error: (error, stackTrace) {
                              return Text(error.toString());
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
                          if (siteData != null) const SizedBox(height: 20),
                          if (siteData != null)
                            siteLevelDataList.when(
                              data: (data) {
                                List<SiteLevelData> siteLevelList =
                                data.map((e) => e).toList();
                                if (siteLevelList.isEmpty) {
                                  return Container(
                                    alignment: Alignment.center,
                                    child: const Text('No Level found'),
                                  );
                                }
                                return CustomDropdown<SiteLevelData>.search(
                                  hintText: 'Select level',
                                  items: siteLevelList,
                                  excludeSelected: false,
                                  onChanged: (value) {
                                    log('changing value to: ${value
                                        .levelName}');
                                    siteLevelDataSelected = value;
                                  },
                                  headerBuilder: (context, selectedItem) {
                                    return Text(selectedItem.levelName!);
                                  },
                                  validator: (value) {
                                    if (value == null) {
                                      return "Please select site level";
                                    } else {
                                      return null;
                                    }
                                  },
                                  decoration: const CustomDropdownDecoration(
                                    searchFieldDecoration:
                                    SearchFieldDecoration(
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.black,
                                          width: 1,
                                          style: BorderStyle.solid,
                                        ),
                                      ),
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey,
                                          width: 1,
                                          style: BorderStyle.none,
                                        ),
                                      ),
                                    ),

                                    //closedFillColor: Colors.green,
                                    //closedBorderRadius: BorderRadius.only(topLeft: Radius.circular(10))
                                  ),
                                  listItemBuilder: (context, item, isSelected,
                                      onItemSelect) {
                                    return Text(item.levelName!);
                                  },
                                );
                              },
                              error: (error, stackTrace) {
                                return Text(error.toString());
                              },
                              loading: () {
                                return Center(
                                  child:
                                  LoadingAnimationWidget.staggeredDotsWave(
                                    color: Colors.blueAccent,
                                    size: 70,
                                  ),
                                );
                              },
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (sendData.isNotEmpty) LoadingOverlay(isLoading: isLoading)
            // Loading overlay widget
            /*if (sendData.isNotEmpty)
              Consumer(
                builder: (context, ref, child) {
                  var editData =
                      ref.watch(addDeviceAllocationProvider(sendData));
                  return editData.when(
                    data: (data) {
                      SchedulerBinding.instance.addPostFrameCallback((_) {
                        setState(() {
                          isLoading = false;
                        });
                      });

                      //Navigator.of(context).pop(true);
                      return AlertDialog(
                        title: Text(
                          data.responseCode == 200
                              ? 'Device Allocation Success'
                              : 'Device Allocation Error',
                          style: GoogleFonts.latoTextTheme()
                              .titleLarge!
                              .copyWith(
                                fontWeight: FontWeight.bold,
                                color: isDarkMode ? Colors.white : Colors.black,
                                fontSize: 18,
                              ),
                        ),
                        content: Text(
                          //data.responseCode == 200 ? data.data! : data.responseMessage!,
                          'Device allocated successfully',
                          style: GoogleFonts.latoTextTheme()
                              .titleLarge!
                              .copyWith(
                                fontWeight: FontWeight.bold,
                                color: isDarkMode ? Colors.white : Colors.black,
                                fontSize: 15,
                              ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              sendData.clear();
                              parentDeviceSelected = null;
                              siteLevelDataSelected = null;
                              ref.read(deviceDataStateProvider.notifier).state =
                                  null;
                              ref.read(siteDataStateProvider.notifier).state =
                                  null;
                              Navigator.of(context)
                                  .pop(true); // Close the alert dialog
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                    error: (error, stackTrace) {
                      SchedulerBinding.instance.addPostFrameCallback((_) {
                        setState(() {
                          isLoading = false;
                        });
                      });
                      //Utils().showServerError(this.context, 'Login failed, Incorrect Username or Password');
                      return AlertDialog(
                        title: Text(
                          'Device Allocation Error',
                          style: GoogleFonts.latoTextTheme()
                              .titleLarge!
                              .copyWith(
                                fontWeight: FontWeight.bold,
                                color: isDarkMode ? Colors.white : Colors.black,
                                fontSize: 18,
                              ),
                        ),
                        content: Text(
                          error.toString(),
                          style: GoogleFonts.latoTextTheme()
                              .titleLarge!
                              .copyWith(
                                fontWeight: FontWeight.bold,
                                color: isDarkMode ? Colors.white : Colors.black,
                                fontSize: 15,
                              ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              sendData.clear();
                              Navigator.of(context)
                                  .pop(); // Close the alert dialog
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                    loading: () {
                      return LoadingOverlay(isLoading: isLoading);
                    },
                  );
                },
              )*/
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    parentDeviceSelected = null;
    siteLevelDataSelected = null;
    //ref.read(deviceDataStateProvider.notifier).state = null;
    //ref.read(siteDataStateProvider.notifier).state = null;
    super.dispose();
  }

  Map<String, dynamic> sendData = {};
  bool isLoading = false;

  void _addAllocation(WidgetRef ref) {
    var device = ref.read(deviceDataStateProvider);
    var siteData = ref.read(siteDataStateProvider);
    print('Device: $device');
    print('Site: $siteData');
    print('Site Level: $siteLevelDataSelected');
    print('Parent device: $parentDeviceSelected');
    final isValid = _formKey.currentState!.validate();
    print('Form isValid: $isValid');
    if (!isValid) {
      return;
    }

    _formKey.currentState!.save();
    sendData['deviceId'] = device?.deviceId;
    sendData['siteId'] = siteData?.siteId;
    sendData['levelId'] = siteLevelDataSelected?.levelId;
    sendData['parentDeviceId'] = parentDeviceSelected?.deviceId;
    sendData['tenantId'] = device?.tenantId;
    //ref.read(addDeviceAllocationProvider(sendData));
    // Simulate loading data
    setState(() {
      isLoading = true;
    });
  }
}
