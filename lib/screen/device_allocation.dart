import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mindteck_iot/models/allocation/allocation_data.dart';
import 'package:mindteck_iot/models/deallocation_reason_data.dart';
import 'package:mindteck_iot/provider/api_data_provider.dart';
import 'package:mindteck_iot/provider/app_theme_provider.dart';
import 'package:mindteck_iot/widgets/allocation_list_row.dart';

import '../resource/app_resource.dart';
import '../utils/constants.dart';
import '../utils/utils.dart';
import '../widgets/cancel_button.dart';
import '../widgets/custom_search_delegate.dart';
import '../widgets/error_screen.dart';
import '../widgets/no_data_screen.dart';
import '../widgets/submit_button.dart';
import 'add_device_allocation_screen.dart';
import 'edit_device_allocation_screen.dart';
import 'loading_screen.dart';

class DeviceAllocation extends ConsumerStatefulWidget {
  const DeviceAllocation({super.key});

  @override
  ConsumerState<DeviceAllocation> createState() => _UserManagementState();
}

class _UserManagementState extends ConsumerState<DeviceAllocation> {
  String? role;
  DeallocationReasonData? deallocationReasonDataSelected;

  Future<void> _getValueFromSecureStorage() async {
    try {
      FlutterSecureStorage storage = FlutterSecureStorage();
      role = await storage.read(key: AppDatabase.roleName);
    } catch (e) {
      // Handle error
      print('Error reading value: $e');
    }
  }

  void _reload() async {
    if (await Utils().checkInternetConnectivity()) {
      ref.invalidate(allocationDataListProvider);
      ref.read(allocationDataListProvider);
    } else {
      Utils().showNetworkSnackbar(AppText.no_internet, context);
    }
  }

  void _addDeviceAllocation() async {
    final isAdded = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) {
          return const AddDeviceAllocationScreen();
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
          'Device Allocation successfully',
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

  void onItemClick(AllocationData data, String actionType) {
    switch (actionType) {
      case Constants.item_view:
        _showDeviceAllocationDetailDialog(context, data: data);
        break;
      case Constants.item_edit:
        _editDeviceAllocation(context, data: data);
        break;
      case Constants.item_remove:
        _showDeallocationReasonDialog(context, data: data);
        break;
    }
  }

  Future<void> _showDeallocationReasonDialog(BuildContext context,
      {required AllocationData data}) {
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      shape: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.0),
        borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
      ),
      title: Text(
        AppText.device_deallocation,
        textAlign: TextAlign.center,
        style: GoogleFonts.latoTextTheme().titleLarge!.copyWith(
              fontWeight: FontWeight.normal,
              color: Theme.of(context).colorScheme.onBackground,
              fontSize: 25.0,
            ),
      ),

      /// In Flutter, the StatefulBuilder widget is often used when you need to
      /// rebuild a part of the UI tree in response to user interactions without
      /// rebuilding the entire widget tree. This can be useful when working with dialogs,

      content: Consumer(
        builder: (context, ref, child) {
          final deallocationReasonData =
              ref.watch(deallocationReasonListProvider);
          return Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
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
                  'Parent Device: ${data.parentDeviceName}',
                  style: GoogleFonts.latoTextTheme().titleLarge!.copyWith(
                        fontWeight: FontWeight.normal,
                        color: Theme.of(context).colorScheme.onBackground,
                        fontSize: 15.0,
                      ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Site: ${data.siteName}',
                  style: GoogleFonts.latoTextTheme().titleLarge!.copyWith(
                        fontWeight: FontWeight.normal,
                        color: Theme.of(context).colorScheme.onBackground,
                        fontSize: 15.0,
                      ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Allocation Id: ${data.allocationId}',
                  style: GoogleFonts.latoTextTheme().titleLarge!.copyWith(
                        fontWeight: FontWeight.normal,
                        color: Theme.of(context).colorScheme.onBackground,
                        fontSize: 15.0,
                      ),
                ),
                const SizedBox(height: 20),
                deallocationReasonData.when(
                  data: (data) {
                    List<DeallocationReasonData> reasonList =
                        data.map((e) => e).toList();
                    if (reasonList.isEmpty) {
                      return Container(
                        alignment: Alignment.center,
                        child: const Text('No reason found'),
                      );
                    }
                    return Consumer(
                      builder: (context, ref, child) {
                        return DropdownButtonFormField<DeallocationReasonData>(
                          //hint: const Text("Select Area"),
                          //key: _fieldKeys['category'],
                          isExpanded: true,
                          value: deallocationReasonDataSelected,
                          decoration: InputDecoration(
                            labelText: 'Select Reason',
                            hintText: 'Please choose reason',
                            labelStyle: const TextStyle(fontSize: 18),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                gapPadding: 5),
                          ),
                          onChanged: (DeallocationReasonData? value) {
                            //setState(() {
                            deallocationReasonDataSelected = value;
                            //});
                          },
                          validator: (value) {
                            if (value == null) {
                              return "Please select reason";
                            } else {
                              return null;
                            }
                          },
                          onSaved: (newValue) {},
                          items: reasonList
                              .map(
                                (DeallocationReasonData cate) =>
                                    DropdownMenuItem<DeallocationReasonData>(
                                  value: cate,
                                  child: Row(
                                    //crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondaryContainer,
                                            // Border color
                                            width: 2.0, // Border width
                                          ),
                                        ),
                                        child: CircleAvatar(
                                          radius: 20,
                                          // Adjust the radius as needed
                                          //backgroundImage: NetworkImage(cate.image!),
                                          backgroundColor: Theme.of(context)
                                              .colorScheme
                                              .secondaryContainer,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(cate.deviceLifeCycleName!,
                                          style: GoogleFonts.latoTextTheme()
                                              .titleLarge!
                                              .copyWith(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onBackground))
                                    ],
                                  ),
                                ),
                              )
                              .toList(),
                        );
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
          );
        },
      ),
      actions: [
        CancelButton(
          cancelText: AppText.cancel,
          onCancelClick: _onCancelClick,
        ),
        SubmitButton(
          submitText: AppText.submit,
          onSubmitClick: () {
            _onSubmitClick(data.deviceId!);
          },
        ),
      ],
    );

    // show the dialog
    return showGeneralDialog(
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
          child: StatefulBuilder(
            builder: (context, setState) {
              return alert;
            },
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 250),
      barrierDismissible: false,
      barrierLabel: "Barrier",
      barrierColor: Colors.black.withOpacity(0.5),
    );
  }

  void _onCancelClick() {
    _formKey.currentState?.reset();
    deallocationReasonDataSelected = null;
    Navigator.of(context).pop();
  }

  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Map<String, dynamic> sendData = Map();
  bool isLoading = false;
  bool isDarkMode = false;

  void _onSubmitClick(String deviceId) {
    final isValid = _formKey.currentState!.validate();
    print('Form isValid: $isValid');
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();
    log('data: $deallocationReasonDataSelected');

    sendData['deviceId'] = deviceId;
    sendData['reasonId'] = deallocationReasonDataSelected?.deviceLifeCycleId!;
    log('sendData $sendData');
    Navigator.of(context).pop();
    //ref.read(removeDeviceAllocationProvider(sendData));
    setState(() {
      isLoading = true;
    });
  }

  void _showDeviceAllocationDetailDialog(BuildContext context,
      {required AllocationData data}) {
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
            'Name:  ${data.deviceName}',
            style: GoogleFonts.latoTextTheme().titleLarge!.copyWith(
                  fontWeight: FontWeight.normal,
                  color: Theme.of(context).colorScheme.onBackground,
                  fontSize: 15.0,
                ),
          ),
          const SizedBox(height: 10),
          Text(
            'Parent Device:  ${data.parentDeviceName}',
            style: GoogleFonts.latoTextTheme().titleLarge!.copyWith(
                  fontWeight: FontWeight.normal,
                  color: Theme.of(context).colorScheme.onBackground,
                  fontSize: 15.0,
                ),
          ),
          const SizedBox(height: 10),
          Text(
            'Site:  ${data.siteName}',
            style: GoogleFonts.latoTextTheme().titleLarge!.copyWith(
                  fontWeight: FontWeight.normal,
                  color: Theme.of(context).colorScheme.onBackground,
                  fontSize: 15.0,
                ),
          ),
          const SizedBox(height: 10),
          Text(
            'Allocation Id:  ${data.allocationId}',
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

  void _editDeviceAllocation(BuildContext context,
      {required AllocationData data}) async {
    final isAdded = await Navigator.of(context).push<bool>(MaterialPageRoute(
      builder: (context) {
        return EditDeviceAllocationScreen(allocationData: data);
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

  @override
  void initState() {
    super.initState();
    _getValueFromSecureStorage();
    //_reload();
  }

  @override
  Widget build(BuildContext context) {
    isDarkMode = ref.watch(appThemeProvider).getTheme();
    final allocationData = ref.watch(allocationDataListProvider);
    return Scaffold(
      /// WillPopScope is a widget in the Flutter framework, which is used for
      /// controlling the behavior of the back button or the system navigation
      /// gestures on Android devices. It allows you to intercept and handle
      /// the back button press event to perform custom actions
      ///
      /// Inside the CustomScrollView, we add several Sliver widgets:
      //
      // SliverAppBar: A flexible app bar with a title.
      // SliverList: A scrollable list of items.
      // SliverGrid: A scrollable grid with cards.
      // SliverToBoxAdapter: A custom container with non-sliver content.
      // SliverFillRemaining: A custom container with fills all remaining space in a
      // scroll view, and lays a box widget out inside that space.

      body: Stack(
        children: [
          CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                forceElevated: true,
                elevation: 4,
                floating: true,
                snap: true,
                title: Text(
                  AppText.deviceallocation,
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
                    icon: const Icon(
                      Icons.search,
                    ),
                    onPressed: () {
                      allocationData.when(
                        data: (data) {
                          List<AllocationData> allocationList =
                              data.map((e) => e).toList();
                          return showSearch(
                            context: context,
                            delegate: CustomSearchDelegate<AllocationData>(
                              optionName: 'Allocation',
                              searchList: allocationList,
                              role: null,
                            ),
                          );
                        },
                        error: (error, stackTrace) {},
                        loading: () {},
                      );
                    },
                  ),
                  IconButton(
                    onPressed: _addDeviceAllocation,
                    icon: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    onPressed: _reload,
                    icon: const Icon(
                      Icons.refresh,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              SliverFillRemaining(
                child: allocationData.when(
                  data: (data) {
                    List<AllocationData> allocationList =
                        data.map((e) => e).toList();
                    if (allocationList.isEmpty) {
                      return Container(
                        alignment: Alignment.center,
                        child: NoDataScreen(onRetry: _reload),
                      );
                    }
                    return GridView.custom(
                      padding: const EdgeInsets.only(top: 0),
                      physics: const AlwaysScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 1,
                              mainAxisSpacing: 0.0, // Spacing between rows
                              crossAxisSpacing: 0.0, // Spacing between columns
                              childAspectRatio: 2.0 // Number of columns
                              ),
                      childrenDelegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          return AllocationListRow(
                            role: role,
                            allocationData: allocationList[index],
                            onItemClick: (allocationData, actionType) {
                              onItemClick(allocationData, actionType);
                            },
                          );
                        },
                        childCount:
                            allocationList.length, // Total number of items
                      ),
                    );
                  },
                  error: (error, stackTrace) {
                    return Center(
                      child: ErrorScreen(
                          errorMessage: error.toString(), onRetry: _reload),
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
              /*SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                return FutureBuilder(
                  future: _loadedItems,
                  builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: LoadingAnimationWidget.staggeredDotsWave(
                      color: Colors.blueAccent,
                      size: 70,
                    ),
                    );
                  }
                  if (snapshot.hasError) {
                    return Container(
                      alignment: Alignment.center,
                      child: Text(snapshot.error.toString()),
                    );
                  }

                  if (snapshot.data!.isEmpty) {
                    return Container(
                      alignment: Alignment.center,
                      child: const Text('No Users available'),
                    );
                  }
                  return const Card(
                    child: Text(Constants.DeviceAllocation),
                  );
                },);
              },
            ),
          )*/
            ],
          ),
          if (sendData.isNotEmpty)
            Positioned(
              child: Center(
                child: Consumer(
                  builder: (context, ref, child) {
                    var removeData =
                        ref.watch(removeDeviceAllocationProvider(sendData));
                    return removeData.when(
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
                            style: GoogleFonts.latoTextTheme()
                                .titleLarge!
                                .copyWith(
                                  fontWeight: FontWeight.bold,
                                  color:
                                      isDarkMode ? Colors.white : Colors.black,
                                  fontSize: 18,
                                ),
                          ),
                          content: Text(
                            //data.responseCode == 200 ? data.data! : data.responseMessage!,
                            'Allocation updated successfully',
                            style: GoogleFonts.latoTextTheme()
                                .titleLarge!
                                .copyWith(
                                  fontWeight: FontWeight.bold,
                                  color:
                                      isDarkMode ? Colors.white : Colors.black,
                                  fontSize: 15,
                                ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  sendData.clear();
                                  deallocationReasonDataSelected = null;
                                });

                                //_reload();
                                //Navigator.of(context).pop(); // Close the alert dialog
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
                            style: GoogleFonts.latoTextTheme()
                                .titleLarge!
                                .copyWith(
                                  fontWeight: FontWeight.bold,
                                  color:
                                      isDarkMode ? Colors.white : Colors.black,
                                  fontSize: 18,
                                ),
                          ),
                          content: Text(
                            error.toString(),
                            style: GoogleFonts.latoTextTheme()
                                .titleLarge!
                                .copyWith(
                                  fontWeight: FontWeight.bold,
                                  color:
                                      isDarkMode ? Colors.white : Colors.black,
                                  fontSize: 15,
                                ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  sendData.clear();
                                });
                                //Navigator.of(context).pop(); // Close the alert dialog
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
                ),
              ),
            ),
        ],
      ),
    );
  }
}
