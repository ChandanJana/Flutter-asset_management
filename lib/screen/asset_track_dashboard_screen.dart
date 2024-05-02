import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mindteck_iot/resource/app_resource.dart';

/// Created by Chandan Jana on 01-04-2024.
/// Company name: Mindteck
/// Email: chandan.jana@mindteck.com
///

class AssetTrackDashboardScreen extends ConsumerStatefulWidget {
  const AssetTrackDashboardScreen({super.key});

  @override
  ConsumerState<AssetTrackDashboardScreen> createState() =>
      _AssetTrackDashboardScreenState();
}

class _AssetTrackDashboardScreenState
    extends ConsumerState<AssetTrackDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppText.assetDashBoard,
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
            onPressed: () {
              //_refresh();
            },
            icon: const Icon(
              Icons.refresh,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  width: screenWidth * 0.5,
                  child: Card(
                    color: Colors.white,
                    clipBehavior: Clip.hardEdge,
                    semanticContainer: true,
                    elevation: 2,
                    child: Container(
                      height: 150,
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Lost',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.latoTextTheme()
                                      .titleLarge!
                                      .copyWith(
                                        fontWeight: FontWeight.normal,
                                        color: Colors.grey,
                                        fontSize: 18,
                                      ),
                                ),
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.center,
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.green),
                                    child: Icon(
                                      Icons.call,
                                      size: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Expanded(
                              child: Center(
                                child: Text(
                                  '0',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.latoTextTheme()
                                      .titleLarge!
                                      .copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: 18,
                                      ),
                                ),
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.black,
                                ),
                                children: [
                                  WidgetSpan(
                                    alignment: PlaceholderAlignment.middle,
                                    child: Icon(
                                      Icons.arrow_upward_sharp,
                                      size: 20,
                                      color: Colors.green,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '100%',
                                    style: GoogleFonts.latoTextTheme()
                                        .titleLarge!
                                        .copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green,
                                          fontSize: 15,
                                        ),
                                  ),
                                  TextSpan(
                                    text: ' RichText',
                                    style: GoogleFonts.latoTextTheme()
                                        .titleLarge!
                                        .copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey,
                                          fontSize: 13,
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
                Container(
                  width: screenWidth * 0.5,
                  child: Card(
                    elevation: 5,
                    color: Colors.white,
                    clipBehavior: Clip.hardEdge,
                    semanticContainer: true,
                    child: Container(
                      height: 150,
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Low Battery',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.latoTextTheme()
                                      .titleLarge!
                                      .copyWith(
                                        fontWeight: FontWeight.normal,
                                        color: Colors.grey,
                                        fontSize: 18,
                                      ),
                                ),
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.center,
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.green),
                                    child: Icon(
                                      Icons.battery_3_bar_outlined,
                                      size: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Expanded(
                              child: Center(
                                child: Text(
                                  '0',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.latoTextTheme()
                                      .titleLarge!
                                      .copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: 18,
                                      ),
                                ),
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.black,
                                ),
                                children: [
                                  WidgetSpan(
                                    alignment: PlaceholderAlignment.middle,
                                    child: Icon(
                                      Icons.arrow_upward_sharp,
                                      size: 20,
                                      color: Colors.green,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '100%',
                                    style: GoogleFonts.latoTextTheme()
                                        .titleLarge!
                                        .copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green,
                                          fontSize: 15,
                                        ),
                                  ),
                                  TextSpan(
                                    text: ' RichText',
                                    style: GoogleFonts.latoTextTheme()
                                        .titleLarge!
                                        .copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey,
                                          fontSize: 13,
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
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Card(
                    color: Colors.white,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    elevation: 2,
                    child: Container(
                      height: 150,
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Zone Changes',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.latoTextTheme()
                                      .titleLarge!
                                      .copyWith(
                                        fontWeight: FontWeight.normal,
                                        color: Colors.grey,
                                        fontSize: 18,
                                      ),
                                ),
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.center,
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.green),
                                    child: Center(
                                      child: Icon(
                                        Icons.change_history_sharp,
                                        size: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Expanded(
                              child: Center(
                                child: Text(
                                  '0',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.latoTextTheme()
                                      .titleLarge!
                                      .copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: 18,
                                      ),
                                ),
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.black,
                                ),
                                children: [
                                  WidgetSpan(
                                    alignment: PlaceholderAlignment.middle,
                                    child: Icon(
                                      Icons.arrow_upward_sharp,
                                      size: 20,
                                      color: Colors.green,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '100%',
                                    style: GoogleFonts.latoTextTheme()
                                        .titleLarge!
                                        .copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green,
                                          fontSize: 15,
                                        ),
                                  ),
                                  TextSpan(
                                    text: ' RichText',
                                    style: GoogleFonts.latoTextTheme()
                                        .titleLarge!
                                        .copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey,
                                          fontSize: 13,
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
                VerticalDivider(width: 0),
                Expanded(
                  child: Card(
                    color: Colors.white,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    elevation: 2,
                    child: Container(
                      height: 150,
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Zone Violation',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.latoTextTheme()
                                      .titleLarge!
                                      .copyWith(
                                        fontWeight: FontWeight.normal,
                                        color: Colors.grey,
                                        fontSize: 18,
                                      ),
                                ),
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.center,
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.green),
                                    child: Center(
                                      child: Icon(
                                        Icons.info,
                                        size: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Expanded(
                              child: Center(
                                child: Text(
                                  '0',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.latoTextTheme()
                                      .titleLarge!
                                      .copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: 18,
                                      ),
                                ),
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.black,
                                ),
                                children: [
                                  WidgetSpan(
                                    alignment: PlaceholderAlignment.middle,
                                    child: Icon(
                                      Icons.arrow_upward_sharp,
                                      size: 20,
                                      color: Colors.green,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '100%',
                                    style: GoogleFonts.latoTextTheme()
                                        .titleLarge!
                                        .copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green,
                                          fontSize: 15,
                                        ),
                                  ),
                                  TextSpan(
                                    text: ' RichText',
                                    style: GoogleFonts.latoTextTheme()
                                        .titleLarge!
                                        .copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey,
                                          fontSize: 13,
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
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
