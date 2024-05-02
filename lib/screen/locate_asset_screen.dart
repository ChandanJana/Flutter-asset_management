import 'dart:convert';
import 'dart:developer';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mindteck_iot/models/asset/asset_data.dart';
import 'package:mindteck_iot/models/trace_history_data.dart';
import 'package:mindteck_iot/utils/map_refresh_listener.dart';

import '../provider/api_data_provider.dart';
import '../provider/app_theme_provider.dart';
import '../resource/app_resource.dart';
import '../utils/track_status_painter.dart';
import '../widgets/error_screen.dart';
import '../widgets/mqtt_handler.dart';
import '../widgets/no_data_screen.dart';
import 'full_screen_image.dart';

/// Created by Chandan Jana on 06-03-2024.
/// Company name: Mindteck
/// Email: chandan.jana@mindteck.com
///

class LocateAssetScreen extends ConsumerStatefulWidget {
  const LocateAssetScreen({super.key});

  @override
  ConsumerState<LocateAssetScreen> createState() => _LocateAssetScreenState();
}

class _LocateAssetScreenState extends ConsumerState<LocateAssetScreen>
    implements MapRefreshListener {
  MqttHandler? mqttHandler;
  final GlobalKey<CarouselSliderState> _carouselKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    mqttHandler = MqttHandler();
    //mqttHandler?.connect(this);
    //ref.read(assetListProvider);
  }

  @override
  void dispose() {
    super.dispose();
    //mqttHandler?.diconnect();
    //ref.read(assetDataStateProvider.notifier).state = null;
  }

  CarouselController buttonCarouselController = CarouselController();

  //int _firstCurrentIndex = 1;
  ///
  /// ValueListenableBuilder is used to create responsive and performant user
  /// interfaces. When used in conjunction with the Flutter valuelistenable
  /// feature, it can simplify code, reduce unnecessary widget rebuilds, and
  /// create dynamic UIs
  final ValueNotifier<int> _firstCurrentIndex = ValueNotifier<int>(1);

  void _onPageChanged(int index) {
    //setState(() {
    _firstCurrentIndex.value = index;
    //});
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = ref.watch(appThemeProvider).getTheme();
    final double height = MediaQuery.of(context).size.height;
    final assetData = ref.watch(assetListProvider);
    AssetData? selectedValue = ref.watch(assetDataStateProvider);
    final assetDetail = ref.watch(assetDetailProvider(selectedValue?.assetId));
    final levelImageByLevelId =
        ref.watch(levelImageBylevelIdProvider(selectedValue?.levelId));
    final assetTraceHistory =
        ref.watch(assetTraceHistoryProvider(selectedValue));
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
      appBar: AppBar(
          title: Text(
            AppText.locateAsset,
            style: GoogleFonts.latoTextTheme().titleLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 18,
                ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                ref.read(assetListProvider);
              },
              icon: const Icon(
                Icons.refresh,
                color: Colors.white,
              ),
            ),
          ]),
      resizeToAvoidBottomInset: false,
      body: WillPopScope(
        onWillPop: () {
          mqttHandler?.diconnect();
          ref.read(assetDataStateProvider.notifier).state = null;
          return Future.value(true);
        },
        child: assetData.when(
          data: (data) {
            List<AssetData> assetList = data.map((e) => e).toList();
            if (assetList.isEmpty) {
              return Container(
                alignment: Alignment.center,
                child: NoDataScreen(onRetry: () {}),
              );
            }

            return Container(
              padding: const EdgeInsets.all(5),
              height: double.infinity,
              child: Column(
                children: [
                  Card(
                    elevation: 0,
                    color: Colors.white,
                    child: CustomDropdown<AssetData>.search(
                      hintText: 'Select asset',
                      initialItem: selectedValue,
                      items: assetList,
                      excludeSelected: false,
                      onChanged: (value) {
                        log('changing value to: ${value.assetName}');
                        if (selectedValue == null ||
                            (selectedValue.assetName != value.assetName))
                          mqttHandler?.connect(this);

                        //mqttHandler?.publishMessage('Hello From FLutter App');
                        ref.read(assetDataStateProvider.notifier).state = value;
                        _firstCurrentIndex.value = 1;
                        buttonCarouselController.jumpToPage(1);
                      },
                      hideSelectedFieldWhenExpanded: false,
                      canCloseOutsideBounds: true,
                      validator: (value) {
                        if (value == null) {
                          return "Please select asset";
                        } else {
                          return null;
                        }
                      },
                      headerBuilder: (context, selectedItem) {
                        return Text(
                          selectedItem.assetName!,
                          style:
                              GoogleFonts.latoTextTheme().titleLarge!.copyWith(
                                    fontWeight: FontWeight.normal,
                                    //color: Colors.white,
                                    fontSize: 15,
                                  ),
                        );
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
                        //closedBorderRadius: BorderRadius.all(Radius.circular(50)),
                        //closedBorder: Border.fromBorderSide(BorderSide.none),
                      ),
                      listItemBuilder:
                          (context, item, isSelected, onItemSelect) {
                        return Text(item.assetName!,
                            style: GoogleFonts.latoTextTheme()
                                .titleLarge!
                                .copyWith(
                                  fontWeight: FontWeight.normal,
                                  //color: Colors.white,
                                  fontSize: 14,
                                ));
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  if (selectedValue != null)
                    Expanded(
                      child: Column(
                        children: [
                          Expanded(
                            child: CarouselSlider(
                              key: _carouselKey,
                              items: [
                                Card(
                                  elevation: 2,
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: SingleChildScrollView(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              height: 40,
                                              width: double.infinity,
                                              alignment: Alignment.center,
                                              child: Text(
                                                'Asset Details',
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts
                                                        .robotoTextTheme()
                                                    .titleLarge!
                                                    .copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: isDarkMode
                                                          ? Colors.white
                                                          : Colors.black,
                                                      fontSize: 18,
                                                    ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                              width: double.infinity,
                                              // Width of the line
                                              height: 2,
                                              // Height of the line
                                              color: Colors
                                                  .grey, // Color of the line
                                            ),
                                            SizedBox(
                                              height: 30,
                                            ),
                                            RichText(
                                              text: TextSpan(
                                                text: 'Asset Name:  ',
                                                style: GoogleFonts
                                                        .robotoTextTheme()
                                                    .titleLarge!
                                                    .copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: isDarkMode
                                                          ? Colors.grey
                                                          : Colors.grey,
                                                      fontSize: 14,
                                                    ),
                                                children: <TextSpan>[
                                                  TextSpan(
                                                    text: selectedValue
                                                        .assetName!,
                                                    style: GoogleFonts
                                                            .robotoTextTheme()
                                                        .titleLarge!
                                                        .copyWith(
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          color: isDarkMode
                                                              ? Colors.white
                                                              : Colors.black,
                                                          fontSize: 15,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            RichText(
                                              text: TextSpan(
                                                text: 'Device Name:  ',
                                                style: GoogleFonts
                                                        .robotoTextTheme()
                                                    .titleLarge!
                                                    .copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: isDarkMode
                                                          ? Colors.grey
                                                          : Colors.grey,
                                                      fontSize: 14,
                                                    ),
                                                children: <TextSpan>[
                                                  TextSpan(
                                                    text: selectedValue
                                                        .deviceName!,
                                                    style: GoogleFonts
                                                            .robotoTextTheme()
                                                        .titleLarge!
                                                        .copyWith(
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          color: isDarkMode
                                                              ? Colors.white
                                                              : Colors.black,
                                                          fontSize: 15,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            RichText(
                                              text: TextSpan(
                                                text: 'Site:  ',
                                                style: GoogleFonts
                                                        .robotoTextTheme()
                                                    .titleLarge!
                                                    .copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: isDarkMode
                                                          ? Colors.grey
                                                          : Colors.grey,
                                                      fontSize: 14,
                                                    ),
                                                children: <TextSpan>[
                                                  TextSpan(
                                                    text:
                                                        selectedValue.siteName!,
                                                    style: GoogleFonts
                                                            .robotoTextTheme()
                                                        .titleLarge!
                                                        .copyWith(
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          color: isDarkMode
                                                              ? Colors.white
                                                              : Colors.black,
                                                          fontSize: 15,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            RichText(
                                              text: TextSpan(
                                                text: 'Level:  ',
                                                style: GoogleFonts
                                                        .robotoTextTheme()
                                                    .titleLarge!
                                                    .copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: isDarkMode
                                                          ? Colors.grey
                                                          : Colors.grey,
                                                      fontSize: 14,
                                                    ),
                                                children: <TextSpan>[
                                                  TextSpan(
                                                    text: selectedValue
                                                            .levelName ??
                                                        "",
                                                    style: GoogleFonts
                                                            .robotoTextTheme()
                                                        .titleLarge!
                                                        .copyWith(
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          color: isDarkMode
                                                              ? Colors.white
                                                              : Colors.black,
                                                          fontSize: 15,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            RichText(
                                              text: TextSpan(
                                                text: 'Zone:  ',
                                                style: GoogleFonts
                                                        .robotoTextTheme()
                                                    .titleLarge!
                                                    .copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: isDarkMode
                                                          ? Colors.grey
                                                          : Colors.grey,
                                                      fontSize: 14,
                                                    ),
                                                children: <TextSpan>[
                                                  TextSpan(
                                                    text: selectedValue
                                                            .zoneName ??
                                                        '',
                                                    style: GoogleFonts
                                                            .robotoTextTheme()
                                                        .titleLarge!
                                                        .copyWith(
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          color: isDarkMode
                                                              ? Colors.white
                                                              : Colors.black,
                                                          fontSize: 15,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Card(
                                  elevation: 2,
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: levelImageByLevelId.when(
                                      data: (data) {
                                        if (data == null) {
                                          return Container(
                                            alignment: Alignment.center,
                                            child: NoDataScreen(onRetry: () {}),
                                          );
                                        }
                                        return Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8.0),
                                              child: Container(
                                                height: 40,
                                                width: double.infinity,
                                                alignment: Alignment.center,
                                                child: Text(
                                                  'Map/Layout',
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts
                                                          .robotoTextTheme()
                                                      .titleLarge!
                                                      .copyWith(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: isDarkMode
                                                            ? Colors.white
                                                            : Colors.black,
                                                        fontSize: 18,
                                                      ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0, right: 8.0),
                                              child: Container(
                                                width: double.infinity,
                                                // Width of the line
                                                height: 2,
                                                // Height of the line
                                                color: Colors
                                                    .grey, // Color of the line
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              data.levelName!,
                                              style: GoogleFonts.latoTextTheme()
                                                  .titleLarge!
                                                  .copyWith(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onBackground),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            if (data.imageByteArray != null)
                                              Expanded(
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      PageRouteBuilder(
                                                        pageBuilder: (BuildContext
                                                                context,
                                                            Animation<double>
                                                                animation,
                                                            Animation<double>
                                                                secondaryAnimation) {
                                                          print(data
                                                              .imageByteArray!);
                                                          if (data.imageByteArray!
                                                                  .isEmpty ||
                                                              data.imageByteArray ==
                                                                  null) {
                                                            return FullScreenPage(
                                                              dark: true,
                                                              child: Image.asset(
                                                                  'assets/images/no-image-icon-23504.png'),
                                                            );
                                                          }
                                                          return FullScreenPage(
                                                            dark: true,
                                                            child: Image.memory(
                                                              base64.decode(data
                                                                  .imageByteArray!),
                                                            ),
                                                          );
                                                        },
                                                        transitionDuration:
                                                            const Duration(
                                                                milliseconds:
                                                                    500),
                                                        transitionsBuilder:
                                                            (context,
                                                                animation,
                                                                secondaryAnimation,
                                                                child) {
                                                          var begin = 0.0;
                                                          var end = 1.0;
                                                          var curve =
                                                              Curves.ease;

                                                          var tween = Tween(
                                                                  begin: begin,
                                                                  end: end)
                                                              .chain(CurveTween(
                                                                  curve:
                                                                      curve));
                                                          return ScaleTransition(
                                                            scale: animation
                                                                .drive(tween),
                                                            child: child,
                                                          );
                                                        },
                                                      ),
                                                    );
                                                  },
                                                  child: Image.memory(
                                                    base64.decode(
                                                        data.imageByteArray!),
                                                    fit: BoxFit.fill,
                                                  ),
                                                ),
                                              )
                                            else
                                              Expanded(
                                                child: Center(
                                                  child: Text(
                                                    'No image available.',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleSmall!
                                                        .copyWith(
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .onBackground,
                                                          fontSize: 15,
                                                        ),
                                                  ),
                                                ),
                                              )
                                          ],
                                        );
                                      },
                                      error: (error, stackTrace) {
                                        return Center(
                                          child: ErrorScreen(
                                              errorMessage: error.toString(),
                                              onRetry: () {}),
                                        );
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
                                  ),
                                ),
                                Card(
                                  elevation: 2,
                                  child: SingleChildScrollView(
                                    padding: EdgeInsets.all(10.0),
                                    child: Column(
                                      children: [
                                        Container(
                                          height: 40,
                                          width: double.infinity,
                                          alignment: Alignment.center,
                                          child: Text(
                                            'Trace History',
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.robotoTextTheme()
                                                .titleLarge!
                                                .copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: isDarkMode
                                                      ? Colors.white
                                                      : Colors.black,
                                                  fontSize: 18,
                                                ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          width: double.infinity,
                                          // Width of the line
                                          height: 2,
                                          // Height of the line
                                          color:
                                              Colors.grey, // Color of the line
                                        ),
                                        SingleChildScrollView(
                                          child: Container(
                                            height: double.maxFinite,
                                            child: assetTraceHistory.when(
                                              data: (data) {
                                                List<TraceHistoryData>
                                                    historyList =
                                                    data.map((e) => e).toList();
                                                if (historyList.isEmpty) {
                                                  return Container(
                                                    alignment: Alignment.center,
                                                    child: NoDataScreen(
                                                        onRetry: () {}),
                                                  );
                                                }
                                                return Padding(
                                                  padding: EdgeInsets.all(10),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      CustomPaint(
                                                        painter:
                                                            TrackStatusPainter(
                                                                historyList),
                                                        child: Container(),
                                                        //size: Size(250, 100),
                                                      )
                                                      // Prevent drawing line after the last circle
                                                    ],
                                                  ),
                                                );
                                              },
                                              error: (error, stackTrace) {
                                                return Center(
                                                  child: ErrorScreen(
                                                      errorMessage:
                                                          error.toString(),
                                                      onRetry: () {}),
                                                );
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
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                              carouselController: buttonCarouselController,
                              options: CarouselOptions(
                                height: double.infinity,
                                enlargeCenterPage: true,
                                autoPlay: false,
                                //aspectRatio:1.0,
                                initialPage: _firstCurrentIndex.value,
                                autoPlayCurve: Curves.fastOutSlowIn,
                                enableInfiniteScroll: true,
                                autoPlayAnimationDuration:
                                    Duration(milliseconds: 800),
                                viewportFraction: 1,
                                onPageChanged: (index, reason) {
                                  _onPageChanged(index);
                                },
                              ),
                            ),
                          ),
                          //SizedBox(height: 5),
                          ValueListenableBuilder<int>(
                            valueListenable: _firstCurrentIndex,
                            builder: (context, value, child) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                  3,
                                  (index) => GestureDetector(
                                    onTap: () => buttonCarouselController
                                        .animateToPage(index),
                                    child: Container(
                                      width: 12.0,
                                      height: 12.0,
                                      margin: EdgeInsets.symmetric(
                                          vertical: 8.0, horizontal: 4.0),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color:
                                            (_firstCurrentIndex.value == index
                                                    ? Colors.blue
                                                    : Colors.grey)
                                                .withOpacity(
                                          _firstCurrentIndex.value == index
                                              ? 0.9
                                              : 0.4,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          )
                        ],
                      ),
                    ),
                ],
              ),
            );
          },
          error: (error, stackTrace) {
            return Center(
              child:
                  ErrorScreen(errorMessage: error.toString(), onRetry: () {}),
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
    );
  }

  @override
  void onGetLocation(String message) {
    log("Locate Asset: " + message);
    /*ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );*/
  }
}
