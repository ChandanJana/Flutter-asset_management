import 'dart:developer';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mindteck_iot/models/allocation/allocation_data.dart';
import 'package:mindteck_iot/models/site/site_data.dart';
import 'package:mindteck_iot/models/site_level/site_level_data.dart';

import '../models/device/device_data.dart';
import '../provider/api_data_provider.dart';
import '../provider/app_theme_provider.dart';
import 'loading_screen.dart';

/// Created by Chandan Jana on 12-02-2024.
/// Company name: Mindteck
/// Email: chandan.jana@mindteck.com
///

class EditDeviceAllocationScreen extends ConsumerStatefulWidget {
  const EditDeviceAllocationScreen({super.key, required this.allocationData});

  final AllocationData allocationData;

  @override
  ConsumerState<EditDeviceAllocationScreen> createState() =>
      _EditDeviceAllocationState();
}

class _EditDeviceAllocationState
    extends ConsumerState<EditDeviceAllocationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Keys for each form field
  final Map<String, GlobalKey<FormFieldState<String>>> _fieldKeys = {
    'deviceName': GlobalKey(),
    'serialNo': GlobalKey(),
    'hardwareId': GlobalKey(),
    'status': GlobalKey(),
    'tenant': GlobalKey(),
    'category': GlobalKey(),
    'unitOfMeasurement': GlobalKey(),
    'threshold': GlobalKey(),
    'save': GlobalKey(),
    'min_value': GlobalKey(),
    'max_value': GlobalKey(),
  };

  bool isLoading = false;
  DeviceData? _deviceData;
  DeviceData? _parentDeviceData;
  SiteData? _siteData;
  SiteLevelData? _siteLevelData;
  Map<String, dynamic> sendData = Map();

  void _updateDevice() async {
    print('Device: $_deviceData');
    print('Site: $_siteData');
    print('Site Level: $_siteLevelData');
    print('Parent device: $_parentDeviceData');
    final isValid = _formKey.currentState!.validate();
    print('Form isValid: $isValid');
    if (!isValid) {
      return;
    }

    _formKey.currentState!.save();
    sendData['deviceId'] = _deviceData?.deviceId;
    sendData['siteId'] = _siteData?.siteId;
    sendData['levelId'] = _siteLevelData?.levelId;
    sendData['parentDeviceId'] = _parentDeviceData?.deviceId;
    sendData['tenantId'] = _deviceData?.tenantId;
    //ref.read(editDeviceAllocationProvider(sendData));
    // Simulate loading data
    setState(() {
      isLoading = true;
    });
  }

  @override
  void initState() {
    //_refresh();
    super.initState();
    final deviceAllocationList = ref.read(deviceAllocationListProvider);
    final siteDataList = ref.read(siteListProvider);
    var deviceList = deviceAllocationList.asData?.value;
    var siteList = siteDataList.asData?.value;
    log('allocationData ${widget.allocationData}');
    log('deviceList $deviceList');
    log('siteList $siteList');
    if (deviceList != null) {
      _deviceData = deviceList
              .where((element) =>
                  element.deviceId == widget.allocationData.deviceId)
              .isNotEmpty
          ? deviceList
              .where((element) =>
                  element.deviceId == widget.allocationData.deviceId)
              .first
          : null;
    }
    if (siteList != null) {
      _siteData = siteList
              .where(
                  (element) => element.siteId == widget.allocationData.siteId)
              .isNotEmpty
          ? siteList
              .where(
                  (element) => element.siteId == widget.allocationData.siteId)
              .first
          : null;
    }
    final parentDeviceDataList = ref.read(parentDeviceProvider(_deviceData));
    final siteLevelDataList = ref.read(siteLevelProvider(_siteData));
    var parentDeviceList = parentDeviceDataList.asData?.value;
    var siteLevelList = siteLevelDataList.asData?.value;
    if (parentDeviceList != null) {
      _parentDeviceData = parentDeviceList
              .where((element) =>
                  element.deviceId == widget.allocationData.parentDeviceId)
              .isNotEmpty
          ? parentDeviceList
              .where((element) =>
                  element.deviceId == widget.allocationData.parentDeviceId)
              .first
          : null;
    }
    if (siteLevelList != null) {
      _siteLevelData = siteLevelList
              .where(
                  (element) => element.levelId == widget.allocationData.levelId)
              .isNotEmpty
          ? siteLevelList
              .where(
                  (element) => element.levelId == widget.allocationData.levelId)
              .first
          : null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = ref.watch(appThemeProvider).getTheme();
    final deviceAllocationList = ref.watch(deviceAllocationListProvider);
    final siteDataList = ref.watch(siteListProvider);
    final parentDeviceDataList = ref.watch(parentDeviceProvider(_deviceData));
    final siteLevelDataList = ref.watch(siteLevelProvider(_siteData));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Device Allocation',
          style: GoogleFonts.latoTextTheme().titleLarge!.copyWith(
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
            key: _fieldKeys['update'],
            onPressed: () {
              //_addDevice(ref);
              _updateDevice();

              ref
                  .read(editDeviceAllocationProvider(sendData).future)
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
                            ? 'Allocation Updated successfully'
                            : 'Allocation Updated Error',
                        style: GoogleFonts.latoTextTheme().titleLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: isDarkMode ? Colors.white : Colors.black,
                              fontSize: 18,
                            ),
                      ),
                      content: Text(
                        //data.responseCode == 200 ? data.data! : data.responseMessage!,
                        'Allocation updated successfully',
                        style: GoogleFonts.latoTextTheme().titleLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: isDarkMode ? Colors.white : Colors.black,
                              fontSize: 15,
                            ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            sendData.clear();
                            _siteLevelData = null;
                            _deviceData = null;
                            _siteData = null;
                            _parentDeviceData = null;
                            ref.read(deviceDataStateProvider.notifier).state =
                                null;
                            ref.read(siteDataStateProvider.notifier).state =
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
                          'Allocation updated error',
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
                  );
                },
              );
            },
            icon: const Icon(
              Icons.save,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Stack(
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
                        deviceAllocationList.when(
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
                              initialItem: _deviceData,
                              excludeSelected: true,
                              onChanged: (value) {
                                log('changing value to: ${value.deviceName}');
                                setState(() {
                                  _deviceData = value;
                                });
                                /*ref
                                    .read(
                                    deviceDataStateProvider.notifier)
                                    .state = value;*/
                              },
                              headerBuilder: (context, selectedItem) {
                                return Text(selectedItem.deviceName!);
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
                        if (_deviceData != null)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Name: ${_deviceData?.deviceName}',
                                style: GoogleFonts.latoTextTheme()
                                    .titleLarge!
                                    .copyWith(
                                      fontWeight: FontWeight.normal,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground,
                                      fontSize: 15.0,
                                    ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Category: ${_deviceData?.deviceCategoryName}',
                                style: GoogleFonts.latoTextTheme()
                                    .titleLarge!
                                    .copyWith(
                                      fontWeight: FontWeight.normal,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground,
                                      fontSize: 15.0,
                                    ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Serial No: ${_deviceData?.deviceSerialNumber}',
                                style: GoogleFonts.latoTextTheme()
                                    .titleLarge!
                                    .copyWith(
                                      fontWeight: FontWeight.normal,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground,
                                      fontSize: 15.0,
                                    ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Hardware Id: ${_deviceData?.deviceHardwareId}',
                                style: GoogleFonts.latoTextTheme()
                                    .titleLarge!
                                    .copyWith(
                                      fontWeight: FontWeight.normal,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground,
                                      fontSize: 15.0,
                                    ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Status: ${_deviceData?.deviceLifeCycleName}',
                                style: GoogleFonts.latoTextTheme()
                                    .titleLarge!
                                    .copyWith(
                                      fontWeight: FontWeight.normal,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground,
                                      fontSize: 15.0,
                                    ),
                              ),
                            ],
                          ),
                        const SizedBox(height: 20),
                        if (_deviceData != null)
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
                                excludeSelected: true,
                                initialItem: _parentDeviceData,
                                onChanged: (value) {
                                  log('changing value to: ${value.deviceName}');
                                  _parentDeviceData = value;
                                },
                                headerBuilder: (context, selectedItem) {
                                  return Text(selectedItem.deviceName!);
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
                        if (_deviceData != null) const SizedBox(height: 20),
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
                              excludeSelected: true,
                              initialItem: _siteData,
                              onChanged: (value) {
                                log('changing value to: ${value.siteName}');
                                setState(() {
                                  _siteData = value;
                                });
                                /*ref
                                          .read(siteDataStateProvider.notifier)
                                          .state = value;*/
                              },
                              headerBuilder: (context, selectedItem) {
                                return Text(selectedItem.siteName!);
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
                        if (_siteData != null) const SizedBox(height: 20),
                        if (_siteData != null)
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
                                initialItem: _siteLevelData,
                                excludeSelected: true,
                                onChanged: (value) {
                                  log('changing value to: ${value.levelName}');
                                  _siteLevelData = value;
                                },
                                headerBuilder: (context, selectedItem) {
                                  return Text(selectedItem.levelName!);
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
                                  return Text(item.levelName!);
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
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (sendData.isNotEmpty) LoadingOverlay(isLoading: isLoading)
          /*if (sendData.isNotEmpty)
            Consumer(
              builder: (context, ref, child) {
                var editData = ref.watch(editDeviceAllocationProvider(sendData));
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
                            ? 'Allocation Updated successfully'
                            : 'Allocation Updated Error',
                        style: GoogleFonts.latoTextTheme().titleLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: isDarkMode ? Colors.white : Colors.black,
                              fontSize: 18,
                            ),
                      ),
                      content: Text(
                        //data.responseCode == 200 ? data.data! : data.responseMessage!,
                        'Allocation updated successfully',
                        style: GoogleFonts.latoTextTheme().titleLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: isDarkMode ? Colors.white : Colors.black,
                              fontSize: 15,
                            ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            sendData.clear();
                            _siteLevelData = null;
                            _deviceData = null;
                            _siteData = null;
                            _parentDeviceData = null;
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
                    //The SchedulerBinding class in Flutter is part of the
                    // rendering system and provides methods for scheduling
                    // tasks to be executed on the Dart runtime's event loop.
                    // It allows you to schedule tasks to be run in the future
                    // or immediately after the current frame is finished
                    // rendering.
                    //SchedulerBinding to schedule tasks to be executed on the
                    // next frame or at a specific time. This is useful for
                    // deferring work until after the current frame is rendered.
                    SchedulerBinding.instance.addPostFrameCallback((_) {
                      setState(() {
                        isLoading = false;
                      });
                    });
                    //Utils().showServerError(this.context, 'Login failed, Incorrect Username or Password');
                    return AlertDialog(
                      title: Text(
                        'Allocation updated error',
                        style: GoogleFonts.latoTextTheme().titleLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: isDarkMode ? Colors.white : Colors.black,
                              fontSize: 18,
                            ),
                      ),
                      content: Text(
                        error.toString(),
                        style: GoogleFonts.latoTextTheme().titleLarge!.copyWith(
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
          // Loading overlay widget
        ],
      ),
    );
  }

  void _resetField() {
    _formKey.currentState!.reset();
    _deviceData = null;
  }

  @override
  void dispose() {
    super.dispose();
  }
}
