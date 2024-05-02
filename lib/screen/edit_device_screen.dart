import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../models/category/category_data.dart';
import '../models/device/device_data.dart';
import '../models/status/status_data.dart';
import '../models/tenant/tenant_data.dart';
import '../models/unitMeasurement/unit_measurement_data.dart';
import '../provider/api_data_provider.dart';
import '../provider/app_theme_provider.dart';
import '../resource/app_resource.dart';
import '../utils/utils.dart';
import 'loading_screen.dart';

/// Created by Chandan Jana on 12-02-2024.
/// Company name: Mindteck
/// Email: chandan.jana@mindteck.com
///

class EditDeviceScreen extends ConsumerStatefulWidget {
  const EditDeviceScreen({super.key, required this.deviceData});

  final DeviceData deviceData;

  @override
  ConsumerState<EditDeviceScreen> createState() => _EditDeviceScreenState();
}

class _EditDeviceScreenState extends ConsumerState<EditDeviceScreen> {
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
  final TextEditingController _deviceNameController = TextEditingController();
  final TextEditingController _hardwareIdController = TextEditingController();
  final TextEditingController _serialNoController = TextEditingController();
  final TextEditingController _thresholdController = TextEditingController();
  final TextEditingController _maxController = TextEditingController();
  final TextEditingController _minController = TextEditingController();
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _hardwareIdFocus = FocusNode();
  final FocusNode _serialNoFocus = FocusNode();
  final FocusNode _thresholdFocus = FocusNode();
  final FocusNode _maxFocus = FocusNode();
  final FocusNode _minFocus = FocusNode();
  String _deviceName = '';
  String _serialNo = '';
  String _hardwareId = '';
  int _threshold = 0;
  int _maxUnit = 0;
  int _minUnit = 0;
  CategoryData? _selectedCategory;
  StatusData? _selectedStatus;
  TenantData? _selectedTenant;
  UnitOfMeasurementData? _selectedUOM;
  bool isLoading = false;
  DeviceData? _deviceData;

  void _updateDevice() async {
    final isValid = _formKey.currentState!.validate();
    print('Form isValid: $isValid');
    if (!isValid) {
      return;
    }

    _formKey.currentState!.save();

    print('Device name: ${_deviceNameController.text}');
    print('Serial no: ${_serialNoController.text}');
    print('Hardware id: ${_hardwareIdController.text}');
    print('Threshold: ${_thresholdController.text}');
    print('Min: ${_minController.text}');
    print('Max: ${_maxController.text}');
    print('Category: $_selectedCategory');
    print('Status: $_selectedStatus');
    print('Tenant: $_selectedTenant');
    print('UOM: $_selectedUOM');

    _deviceData = DeviceData.fromJson({
      "deviceId": widget.deviceData.deviceId,
      "deviceCategoryId": _selectedCategory?.deviceCategoryId!,
      "deviceName": _deviceName,
      "deviceSerialNumber": _serialNo,
      "deviceHardwareId": _hardwareId,
      "uomid": _selectedCategory?.deviceCategoryName == 'Sensor'
          ? _selectedUOM?.uomid!
          : null,
      "uomName": _selectedCategory?.deviceCategoryName == 'Sensor'
          ? _selectedUOM?.uomname!
          : null,
      "upperLimit":
          _selectedCategory?.deviceCategoryName == 'Sensor' ? _maxUnit : 0,
      "lowerLimit":
          _selectedCategory?.deviceCategoryName == 'Sensor' ? _minUnit : 0,
      "deviceLifeCycleId": _selectedStatus?.deviceLifeCycleId,
      "deviceLifeCycleName": _selectedStatus?.deviceLifeCycleName,
      "deviceCategoryName": _selectedCategory?.deviceCategoryName,
      "thresholdValue":
          _selectedCategory?.deviceCategoryName == 'Sensor' ? _threshold : 0,
      "isSensor":
          _selectedCategory?.deviceCategoryName == 'Sensor' ? true : false,
      "isActive": true,
      "tenantId": _selectedTenant?.tenantId,
      "tenantName": _selectedTenant?.tenantName
    });

    print('edit deviceData: $_deviceData');

    //ref.read(editDeviceProvider(_deviceData!));

    //_resetField();
    // Simulate loading data
    setState(() {
      isLoading = true;
    });
    /*await Future.delayed(const Duration(seconds: 2));
    setState(() {
      isLoading = false;
    });
    Navigator.of(context).pop(true);*/
  }

  @override
  void initState() {
    //_refresh();
    super.initState();
    var categoryList = ref.read(categoryListProvider);
    var statusList = ref.read(statusListProvider);
    var tenantList = ref.read(tenantListProvider);
    var uomList = ref.read(uomListProvider);
    var cateList = categoryList.asData?.value;
    var statussList = statusList.asData?.value;
    var tenantsList = tenantList.asData?.value;
    var uomsList = uomList.asData?.value;
    if (cateList != null)
      _selectedCategory = cateList
                  .where((element) =>
                      element.deviceCategoryId ==
                      widget.deviceData.deviceCategoryId)
                  .length >
              0
          ? cateList
              .where((element) =>
                  element.deviceCategoryId ==
                  widget.deviceData.deviceCategoryId)
              .first
          : null;

    if (statussList != null)
      _selectedStatus = statussList
                  .where((element) =>
                      element.deviceLifeCycleId ==
                      widget.deviceData.deviceLifeCycleId)
                  .length >
              0
          ? statussList
              .where((element) =>
                  element.deviceLifeCycleId ==
                  widget.deviceData.deviceLifeCycleId)
              .first
          : null;
    if (tenantsList != null) {
      _selectedTenant = tenantsList
                  .where((element) =>
                      element.tenantId == widget.deviceData.tenantId)
                  .length >
              0
          ? tenantsList
              .where(
                  (element) => element.tenantId == widget.deviceData.tenantId)
              .first
          : null;
    }
    if (uomsList != null)
      _selectedUOM = uomsList
                  .where((element) => element.uomid == widget.deviceData.uomid)
                  .length >
              0
          ? uomsList
              .where((element) => element.uomid == widget.deviceData.uomid)
              .first
          : null;
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = ref.watch(appThemeProvider).getTheme();
    var categoryList = ref.watch(categoryListProvider);
    var statusList = ref.watch(statusListProvider);
    var tenantList = ref.watch(tenantListProvider);
    var uomList = ref.watch(uomListProvider);
    _deviceNameController.text = widget.deviceData.deviceName!;
    _serialNoController.text = widget.deviceData.deviceSerialNumber!;
    _hardwareIdController.text = widget.deviceData.deviceHardwareId!;
    _thresholdController.text = widget.deviceData.thresholdValue != null
        ? widget.deviceData.thresholdValue.toString()
        : "0";
    _minController.text = widget.deviceData.lowerLimit != null
        ? widget.deviceData.lowerLimit.toString()
        : "0";
    _maxController.text = widget.deviceData.upperLimit != null
        ? widget.deviceData.upperLimit.toString()
        : "0";

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Device',
          style: GoogleFonts.latoTextTheme().titleLarge!.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 18,
              ),
        ),
        actions: [
          IconButton(
            key: _fieldKeys['update'],
            onPressed: () {
              _updateDevice();
              ref.read(editDeviceProvider(_deviceData!).future).then((data) {
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
                            ? 'Dedvice Edit Success'
                            : 'Dedvice Edit Error',
                        style: GoogleFonts.latoTextTheme().titleLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: isDarkMode ? Colors.white : Colors.black,
                              fontSize: 18,
                            ),
                      ),
                      content: Text(
                        //data.responseCode == 200 ? data.data! : data.responseMessage!,
                        'Device edited',
                        style: GoogleFonts.latoTextTheme().titleLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: isDarkMode ? Colors.white : Colors.black,
                              fontSize: 15,
                            ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            _resetField();
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
                          'Device Edit Error',
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
          /*IconButton(
            onPressed: () {
              _refresh();
            },
            icon: const Icon(
              Icons.refresh,
              color: Colors.white,
            ),
          )*/
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
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Form(
                    key: _formKey,
                    //autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      children: [
                        TextFormField(
                          key: _fieldKeys['deviceName'],
                          controller: _deviceNameController,
                          //autofocus: true,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            hintText: AppText.name,
                            labelText: AppText.device_name,
                            labelStyle: const TextStyle(fontSize: 18),
                          ),
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          focusNode: _nameFocus,
                          onFieldSubmitted: (value) {
                            Utils().fieldFocusChange(
                                context, _nameFocus, _serialNoFocus);
                          },
                          /*onEditingComplete: () {
                              Utils().fieldFocusChange(context, _currentFocus,
                                  _newFocus);
                            },*/
                          onSaved: (name) {
                            _deviceName = name!;
                          },
                          style: TextStyle(
                              color:
                                  Theme.of(context).colorScheme.onBackground),
                          validator: (currentPassword) {
                            if (currentPassword == null ||
                                currentPassword.isEmpty) {
                              return AppText.input_current_password;
                            } else {
                              return null;
                            }
                          },
                          onTap: () {},
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          key: _fieldKeys['serialNo'],
                          controller: _serialNoController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            hintText: AppText.number,
                            labelText: AppText.device_Serial_number,
                            labelStyle: const TextStyle(fontSize: 18),
                          ),
                          textInputAction: TextInputAction.next,
                          focusNode: _serialNoFocus,
                          onFieldSubmitted: (value) {
                            Utils().fieldFocusChange(
                                context, _serialNoFocus, _hardwareIdFocus);
                          },
                          /*onEditingComplete: () {
                              Utils().fieldFocusChange(context, _newFocus, _confirmFocus);
                            },*/
                          onSaved: (number) {
                            _serialNo = number!;
                          },
                          style: TextStyle(
                              color:
                                  Theme.of(context).colorScheme.onBackground),
                          validator: (newPassword) {
                            if (newPassword == null || newPassword.isEmpty) {
                              return AppText.input_new_passsword;
                            } else {
                              return null;
                            }
                          },
                          onTap: () {},
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          key: _fieldKeys['hardwareId'],
                          controller: _hardwareIdController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            hintText: AppText.id,
                            labelText: AppText.device_Hardware_id,
                            labelStyle: const TextStyle(fontSize: 18),
                          ),
                          textInputAction: TextInputAction.done,
                          focusNode: _hardwareIdFocus,
                          onFieldSubmitted: (value) {
                            _hardwareIdFocus.unfocus();
                          },
                          /*onEditingComplete: () {
                              _confirmFocus.unfocus();
                            },*/
                          onSaved: (id) {
                            _hardwareId = id!;
                          },
                          style: TextStyle(
                              color:
                                  Theme.of(context).colorScheme.onBackground),
                          validator: (confirmPassword) {
                            if (confirmPassword == null ||
                                confirmPassword.isEmpty) {
                              return AppText.input_confirm_password;
                            } else {
                              return null;
                            }
                          },
                          onTap: () {},
                        ),
                        const SizedBox(height: 10),
                        statusList.when(
                          data: (statusdata) {
                            List<StatusData> statussList =
                                statusdata.map((e) => e).toList();
                            if (statussList.isEmpty) {
                              return Container(
                                alignment: Alignment.center,
                                child: const Text('No status found'),
                              );
                            }
                            //_selectedStatus = statussList.where((element) => element.deviceLifeCycleId == widget.deviceData.deviceLifeCycleId).first;
                            return DropdownButtonFormField<StatusData>(
                              //hint: const Text("Select Area"),
                              key: _fieldKeys['status'],
                              isExpanded: true,
                              value: _selectedStatus,
                              decoration: InputDecoration(
                                labelText: 'Select status',
                                hintText: 'Please choose status',
                                labelStyle: const TextStyle(fontSize: 18),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    gapPadding: 5),
                              ),
                              onChanged: (StatusData? value) {
                                //ref.invalidate(assetByGroupIdProvider);
                                //ref.read(assetByGroupIdProvider(value?.id));

                                //ref.read(assetGroupModelStateProvider.notifier).state = value;
                                //ref.read(assetModelStateProvider.notifier).state = null;

                                //_formKey.currentState!.validate();
                                setState(() {
                                  _selectedStatus = value;
                                  //selectedAsset = null;
                                  //_loadedAllAsset = _loadAllAsset();
                                });
                              },
                              validator: (value) {
                                if (value == null) {
                                  return "Please select status";
                                } else {
                                  return null;
                                }
                              },
                              onSaved: (newValue) {},
                              items: statussList
                                  .map(
                                    (StatusData status) =>
                                        DropdownMenuItem<StatusData>(
                                      value: status,
                                      child: Row(
                                        //crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          /*Container(
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
                                          ),*/
                                          Text(status.deviceLifeCycleName!,
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
                        const SizedBox(height: 10),
                        tenantList.when(
                          data: (tenantData) {
                            List<TenantData> tenantsList =
                                tenantData.map((e) => e).toList();
                            if (tenantsList.isEmpty) {
                              return Container(
                                alignment: Alignment.center,
                                child: const Text('No Tenants found'),
                              );
                            }
                            //_selectedTenant = tenantsList.where((element) => element.tenantId == widget.deviceData.tenantId).first;

                            return DropdownButtonFormField<TenantData>(
                              //hint: const Text("Select Area"),
                              key: _fieldKeys['tenant'],
                              isExpanded: true,
                              value: _selectedTenant,
                              decoration: InputDecoration(
                                labelText: 'Select tenant',
                                hintText: 'Please choose tenant',
                                labelStyle: const TextStyle(fontSize: 18),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    gapPadding: 5),
                              ),
                              onChanged: (TenantData? value) {
                                //ref.invalidate(assetByGroupIdProvider);
                                //ref.read(assetByGroupIdProvider(value?.id));

                                //ref.read(assetGroupModelStateProvider.notifier).state = value;
                                //ref.read(assetModelStateProvider.notifier).state = null;

                                //_formKey.currentState!.validate();
                                setState(() {
                                  _selectedTenant = value;
                                });
                              },
                              validator: (value) {
                                if (value == null) {
                                  return "Please select tenant";
                                } else {
                                  return null;
                                }
                              },
                              onSaved: (newValue) {},
                              items: tenantsList
                                  .map(
                                    (TenantData status) =>
                                        DropdownMenuItem<TenantData>(
                                      value: status,
                                      child: Row(
                                        //crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          /*Container(
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
                                          ),*/
                                          Expanded(
                                            child: Text(status.tenantName!,
                                                style:
                                                    GoogleFonts.latoTextTheme()
                                                        .titleLarge!
                                                        .copyWith(
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .onBackground)),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                  .toList(),
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
                        const SizedBox(height: 10),
                        categoryList.when(
                          data: (categorydata) {
                            List<CategoryData> cateList =
                                categorydata.map((e) => e).toList();
                            if (cateList.isEmpty) {
                              return Container(
                                alignment: Alignment.center,
                                child: const Text('No category found'),
                              );
                            }
                            //_selectedCategory = cateList.where((element) => element.deviceCategoryId == widget.deviceData.deviceCategoryId).first;

                            return DropdownButtonFormField<CategoryData>(
                              //hint: const Text("Select Area"),
                              key: _fieldKeys['category'],
                              isExpanded: true,
                              value: _selectedCategory,
                              decoration: InputDecoration(
                                labelText: 'Select category',
                                hintText: 'Please choose category',
                                labelStyle: const TextStyle(fontSize: 18),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    gapPadding: 5),
                              ),
                              onChanged: (CategoryData? value) {
                                //ref.invalidate(assetByGroupIdProvider);
                                //ref.read(assetByGroupIdProvider(value?.id));

                                //ref.read(assetGroupModelStateProvider.notifier).state = value;
                                //ref.read(assetModelStateProvider.notifier).state = null;

                                //_formKey.currentState!.validate();
                                setState(() {
                                  _selectedCategory = value;
                                  //selectedAsset = null;
                                  //_loadedAllAsset = _loadAllAsset();
                                });
                              },
                              validator: (value) {
                                if (value == null) {
                                  return "Please select category";
                                } else {
                                  return null;
                                }
                              },
                              onSaved: (newValue) {},
                              items: cateList
                                  .map(
                                    (CategoryData cate) =>
                                        DropdownMenuItem<CategoryData>(
                                      value: cate,
                                      child: Row(
                                        //crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
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
                                          Text(cate.deviceCategoryName!,
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
                        const SizedBox(height: 10),
                        if (_selectedCategory?.deviceCategoryName == 'Sensor')
                          Column(
                            children: [
                              uomList.when(
                                data: (uomData) {
                                  List<UnitOfMeasurementData> uomsList =
                                      uomData.map((e) => e).toList();
                                  if (uomsList.isEmpty) {
                                    return Container(
                                      alignment: Alignment.center,
                                      child: const Text('No UOM found'),
                                    );
                                  }
                                  //_selectedUOM = uomsList.where((element) => element.uomid == widget.deviceData.uomid).length > 0 ? uomsList.where((element) => element.uomid == widget.deviceData.uomid).first : null;

                                  return DropdownButtonFormField<
                                      UnitOfMeasurementData>(
                                    //hint: const Text("Select Area"),
                                    key: _fieldKeys['unitOfMeasurement'],
                                    isExpanded: true,
                                    value: _selectedUOM,
                                    decoration: InputDecoration(
                                      labelText: 'Select unit',
                                      hintText: 'Please choose unit',
                                      labelStyle: const TextStyle(fontSize: 18),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          gapPadding: 5),
                                    ),
                                    onChanged: (UnitOfMeasurementData? value) {
                                      //ref.invalidate(assetByGroupIdProvider);
                                      //ref.read(assetByGroupIdProvider(value?.id));

                                      //ref.read(assetGroupModelStateProvider.notifier).state = value;
                                      //ref.read(assetModelStateProvider.notifier).state = null;

                                      //_formKey.currentState!.validate();
                                      setState(() {
                                        _selectedUOM = value;
                                        //selectedAsset = null;
                                        //_loadedAllAsset = _loadAllAsset();
                                      });
                                    },
                                    validator: (value) {
                                      if (value == null) {
                                        return "Please select unit";
                                      } else {
                                        return null;
                                      }
                                    },
                                    onSaved: (newValue) {},
                                    items: uomsList
                                        .map(
                                          (UnitOfMeasurementData uom) =>
                                              DropdownMenuItem<
                                                  UnitOfMeasurementData>(
                                            value: uom,
                                            child: Row(
                                              //crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
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
                                                      width:
                                                          2.0, // Border width
                                                    ),
                                                  ),
                                                  child: CircleAvatar(
                                                    radius: 20,
                                                    // Adjust the radius as needed
                                                    //backgroundImage: NetworkImage(cate.image!),
                                                    backgroundColor:
                                                        Theme.of(context)
                                                            .colorScheme
                                                            .secondaryContainer,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Text(uom.uomcategoryName!,
                                                    style: GoogleFonts
                                                            .latoTextTheme()
                                                        .titleLarge!
                                                        .copyWith(
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .onBackground))
                                              ],
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  );
                                },
                                error: (error, stackTrace) {
                                  return Text(error.toString());
                                },
                                loading: () {
                                  return Center(
                                    child: LoadingAnimationWidget
                                        .staggeredDotsWave(
                                      color: Colors.blueAccent,
                                      size: 70,
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                key: _fieldKeys['threshold'],
                                controller: _thresholdController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  hintText: AppText.value,
                                  labelText: AppText.device_threshold,
                                  labelStyle: const TextStyle(fontSize: 18),
                                ),
                                textInputAction: TextInputAction.next,
                                focusNode: _thresholdFocus,
                                onFieldSubmitted: (value) {
                                  Utils().fieldFocusChange(
                                      context, _thresholdFocus, _minFocus);
                                },
                                /*onEditingComplete: () {
                              Utils().fieldFocusChange(context, _newFocus, _confirmFocus);
                            },*/
                                onSaved: (number) {
                                  _threshold = int.parse(number!);
                                },
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground),
                                validator: (newPassword) {
                                  if (newPassword == null ||
                                      newPassword.isEmpty) {
                                    return AppText.input_device_threshold;
                                  } else {
                                    return null;
                                  }
                                },
                                onTap: () {},
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                key: _fieldKeys['min_value'],
                                controller: _minController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  hintText: AppText.value,
                                  labelText: AppText.device_min,
                                  labelStyle: const TextStyle(fontSize: 18),
                                ),
                                textInputAction: TextInputAction.next,
                                focusNode: _minFocus,
                                onFieldSubmitted: (value) {
                                  Utils().fieldFocusChange(
                                      context, _minFocus, _maxFocus);
                                },
                                /*onEditingComplete: () {
                              Utils().fieldFocusChange(context, _newFocus, _confirmFocus);
                            },*/
                                onSaved: (number) {
                                  _minUnit = int.parse(number!);
                                },
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground),
                                validator: (newPassword) {
                                  if (newPassword == null ||
                                      newPassword.isEmpty) {
                                    return AppText.input_device_min;
                                  } else {
                                    return null;
                                  }
                                },
                                onTap: () {},
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                key: _fieldKeys['max_value'],
                                controller: _maxController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  hintText: AppText.value,
                                  labelText: AppText.device_max,
                                  labelStyle: const TextStyle(fontSize: 18),
                                ),
                                textInputAction: TextInputAction.done,
                                focusNode: _maxFocus,
                                onFieldSubmitted: (value) {
                                  _maxFocus.unfocus();
                                },
                                /*onEditingComplete: () {
                              Utils().fieldFocusChange(context, _newFocus, _confirmFocus);
                            },*/
                                onSaved: (number) {
                                  _maxUnit = int.parse(number!);
                                },
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground),
                                validator: (newPassword) {
                                  if (newPassword == null ||
                                      newPassword.isEmpty) {
                                    return AppText.input_device_max;
                                  } else {
                                    return null;
                                  }
                                },
                                onTap: () {},
                              ),
                            ],
                          )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_deviceData != null) LoadingOverlay(isLoading: isLoading)
          /*if (_deviceData != null)
            Consumer(
              builder: (context, ref, child) {
                var editData = ref.watch(editDeviceProvider(_deviceData!));
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
                            ? 'Dedvice Edit Success'
                            : 'Dedvice Edit Error',
                        style: GoogleFonts.latoTextTheme().titleLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: isDarkMode ? Colors.white : Colors.black,
                              fontSize: 18,
                            ),
                      ),
                      content: Text(
                        //data.responseCode == 200 ? data.data! : data.responseMessage!,
                        'Device edted',
                        style: GoogleFonts.latoTextTheme().titleLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: isDarkMode ? Colors.white : Colors.black,
                              fontSize: 15,
                            ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            _resetField();
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
                        'Dedvice Edit Error',
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
    _deviceNameController.clear();
    _serialNoController.clear();
    _hardwareIdController.clear();
    _thresholdController.clear();
    _minController.clear();
    _maxController.clear();
    _formKey.currentState!.reset();
    _selectedCategory = null;
    _selectedStatus = null;
    _selectedTenant = null;
    _selectedUOM = null;
    _deviceData = null;
  }

  @override
  void dispose() {
    super.dispose();
    _deviceNameController.dispose();
    _serialNoController.dispose();
    _hardwareIdController.dispose();
    _thresholdController.dispose();
    _minController.dispose();
    _maxController.dispose();
  }
}
