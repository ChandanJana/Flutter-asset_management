import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mindteck_iot/models/category/category_model.dart';
import 'package:mindteck_iot/models/status/status_model.dart';
import 'package:mindteck_iot/provider/api_data_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/category/category_data.dart';
import '../models/status/status_data.dart';
import '../provider/app_theme_provider.dart';
import '../resource/app_resource.dart';

class FilterDrawer extends ConsumerStatefulWidget {
  final Function(bool, List<String>, List<String>) onApplyFilters;

  const FilterDrawer({
    Key? key,
    required this.onApplyFilters,
  }) : super(key: key);

  @override
  ConsumerState<FilterDrawer> createState() => _FilterDrawerState();
}

class _FilterDrawerState extends ConsumerState<FilterDrawer> {
  bool isSensorChecked = false;
  List<String> selectedCategories = [];
  List<String> selectedStatus = [];

  @override
  void initState() {
    super.initState();
    ref.read(categoryListProvider);
    ref.read(statusListProvider);
    _loadFilters(); // Load previous filters when the widget is initialized
  }

  // Load previous filters from SharedPreferences
  void _loadFilters() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      isSensorChecked = prefs.getBool('isSensorChecked') ?? false;
      selectedCategories = prefs.getStringList('selectedCategories') ?? [];
      selectedStatus = prefs.getStringList('selectedStatus') ?? [];
    });
  }

  // Save current filters to SharedPreferences
  void _saveFilters() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setBool('isSensorChecked', isSensorChecked);
    prefs.setStringList('selectedCategories', selectedCategories);
    prefs.setStringList('selectedStatus', selectedStatus);
  }

  Future<List<CategoryData>> loadDeviceCategory() async {
    //try {
    const String deviceCategoryListUrl = AppApi.getDeviceCategory;

    // Create storage
    SharedPreferences storage = await SharedPreferences.getInstance();

    // Read token value
    String? authToken = storage.getString(AppDatabase.token);
    if (kDebugMode) {
      print('authToken $authToken');
    }

    final Map<String, String> headers = {
      AppApiKey.contentTypeKey: AppApiKey.contentTypeValue,
      AppApiKey.acceptKey: AppApiKey.acceptValue,
      AppApiKey.authorizationKey: '${AppApiKey.bearer}$authToken',
    };

    if (kDebugMode) {
      print('deviceCategoryListurl $deviceCategoryListUrl');
      print('headers $headers');
    }

    final response =
        await http.get(Uri.parse(deviceCategoryListUrl), headers: headers);
    if (kDebugMode) {
      print('response.statusCode ${response.statusCode}');
    }

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      print("GetDeviceCategoryResponseBody. $responseBody");
      CategoryModel getCategoryModel = CategoryModel.fromJson(responseBody);

      List<CategoryData> deviceCategoryList = getCategoryModel.data;

      if (kDebugMode) {
        print('Device categories fetched. $deviceCategoryList');
      }

      return deviceCategoryList;
    } else {
      throw Exception(
          'Failed to fetch device categories. Please try again later! ${response.reasonPhrase}');
    }
    /*} catch (e) {
      ServerErrorPopup.showServerError(this.context, '$e');
      print('Error: $e');
      return null;
    }*/
  }

  Future<List<StatusData>> loadDeviceStatus() async {
    //try {
    const String devicestatusListUrl = AppApi.getDeviceLifeCycle;

    // Create storage
    SharedPreferences storage = await SharedPreferences.getInstance();

    // Read token value
    String? authToken = storage.getString(AppDatabase.token);
    if (kDebugMode) {
      print('authToken $authToken');
    }

    final Map<String, String> headers = {
      AppApiKey.contentTypeKey: AppApiKey.contentTypeValue,
      AppApiKey.acceptKey: AppApiKey.acceptValue,
      AppApiKey.authorizationKey: '${AppApiKey.bearer}$authToken',
    };

    if (kDebugMode) {
      print('deviceStatusListurl $devicestatusListUrl');
      print('headers $headers');
    }

    final response =
        await http.get(Uri.parse(devicestatusListUrl), headers: headers);
    if (kDebugMode) {
      print('response.statusCode ${response.statusCode}');
    }

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      print("GetDeviceCategoryResponseBody. $responseBody");
      StatusModel getStatusModel = StatusModel.fromJson(responseBody);

      List<StatusData> deviceStatusList = getStatusModel.data;

      if (kDebugMode) {
        print('Device categories fetched. $deviceStatusList');
      }

      return deviceStatusList;
    } else {
      throw Exception(
          'Failed to fetch device categories. Please try again later! ${response.reasonPhrase}');
    }
    /*} catch (e) {
      ServerErrorPopup.showServerError(this.context, '$e');
      print('Error: $e');
      return null;
    }*/
  }

  @override
  Widget build(BuildContext context) {
    var categoryList = ref.watch(categoryListProvider);
    var statusList = ref.watch(statusListProvider);
    var isDarkMode = ref.watch(appThemeProvider).getTheme();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'Apply Filters',
          textAlign: TextAlign.center,
          style: GoogleFonts.latoTextTheme()
              .titleLarge!
              .copyWith(fontSize: 20.0, color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            key: ValueKey<String>('device_filter_close'),
            icon: const Icon(
              Icons.clear,
              color: Colors.white,
            ),
            onPressed: _cancelFilters,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            /*ListTile(
              title: Text(
                'Sensors',
                style: GoogleFonts.latoTextTheme().titleLarge!.copyWith(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black,
                    ),
              ),
              trailing: GestureDetector(
                onTap: () {
                  setState(() {
                    isSensorChecked = !isSensorChecked;
                  });
                },
                child: Container(
                  width: 20.0,
                  height: 20.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    border: Border.all(
                      color: isSensorChecked ? Colors.green : Colors.blue,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(4.0),
                    color: isSensorChecked ? Colors.green : Colors.white,
                  ),
                  child: isSensorChecked
                      ? const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 15,
                        )
                      : null,
                ),
              ),
            ),*/
            Text(
              'Device Category',
              textAlign: TextAlign.start,
              style: GoogleFonts.latoTextTheme().titleLarge!.copyWith(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                  ),
            ),
            categoryList.when(
              data: (categoryData) {
                //List<CategoryData> deviceCategories = categoryData.data!;
                return ListTile(
                  title: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(5),
                    child: Wrap(
                      spacing: 5.0,
                      children: categoryData.map((category) {
                        return FilterChip(
                          label: Text(
                            category.deviceCategoryName!,
                            style: GoogleFonts.latoTextTheme()
                                .titleLarge!
                                .copyWith(
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize: 15,
                                ),
                          ),
                          //shape: StadiumBorder(side: BorderSide()),
                          shape: RoundedRectangleBorder(
                            /*side: BorderSide(
                              color: Colors.blue, // Set your desired border color
                              width: 1.0, // Set your desired border width
                            ),*/
                            borderRadius: BorderRadius.circular(
                                20.0), // Set your desired border radius
                          ),
                          selected: selectedCategories
                              .contains(category.deviceCategoryName),
                          onSelected: (selected) {
                            setState(() {
                              selectedCategories
                                      .contains(category.deviceCategoryName)
                                  ? selectedCategories
                                      .remove(category.deviceCategoryName)
                                  : selectedCategories
                                      .add(category.deviceCategoryName!);
                              _saveFilters(); // Save filters when changed
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ),
                );
              },
              error: (error, stackTrace) {
                return Text('Error loading categories: ${error.toString()}');
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
            Text(
              'Device Status',
              textAlign: TextAlign.start,
              style: GoogleFonts.latoTextTheme().titleLarge!.copyWith(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                  ),
            ),
            statusList.when(
              data: (statusData) {
                //List<CategoryData> deviceCategories = categoryData.data!;
                return ListTile(
                  title: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Wrap(
                      spacing: 8.0,
                      children: statusData.map((status) {
                        return ChoiceChip(
                          key: ValueKey<String>(
                              status.deviceLifeCycleId.toString()),
                          label: Text(
                            status.deviceLifeCycleName ?? '',
                            style: GoogleFonts.latoTextTheme()
                                .titleLarge!
                                .copyWith(
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize: 15,
                                ),
                          ),
                          shape: RoundedRectangleBorder(
                            /*side: BorderSide(
                              color: Colors.blue, // Set your desired border color
                              width: 1.0, // Set your desired border width
                            ),*/
                            borderRadius: BorderRadius.circular(
                                20.0), // Set your desired border radius
                          ),
                          selected: selectedStatus
                              .contains(status.deviceLifeCycleName),
                          onSelected: (selected) {
                            setState(() {
                              selectedStatus
                                      .contains(status.deviceLifeCycleName)
                                  ? selectedStatus
                                      .remove(status.deviceLifeCycleName)
                                  : selectedStatus
                                      .add(status.deviceLifeCycleName ?? '');
                              _saveFilters(); // Save filters when changed
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ),
                );
              },
              error: (error, stackTrace) {
                return Text('Error loading statuses: ${error.toString()}');
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
            Container(
              padding: const EdgeInsets.only(right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    key: ValueKey<String>('device_filter_submit'),
                    onPressed: () {
                      _applyFilters();
                      _saveFilters(); // Save filters when applying
                    },
                    child: Text(
                      'Apply',
                      style: GoogleFonts.latoTextTheme().titleLarge!.copyWith(
                          fontSize: 15.0,
                          fontWeight: FontWeight.normal,
                          color: isDarkMode ? Colors.white : Colors.white),
                    ),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    key: ValueKey<String>('device_filter_cancel'),
                    onPressed: () {
                      _resetFilters();
                      _loadFilters(); // Reload filters when canceling
                    },
                    child: Text(
                      'Reset',
                      style: GoogleFonts.latoTextTheme().titleLarge!.copyWith(
                          fontSize: 15.0,
                          fontWeight: FontWeight.normal,
                          color: isDarkMode ? Colors.white : Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _applyFilters() {
    widget.onApplyFilters(isSensorChecked, selectedCategories, selectedStatus);
  }

  void _cancelFilters() {
    setState(() {
      isSensorChecked = false;
      selectedCategories.clear();
      selectedStatus.clear();
    });
    Navigator.pop(context);
  }

  void _resetFilters() {
    SharedPreferences.getInstance().then((prefs) {
      prefs.clear();
      _loadFilters();
    });
  }
}
