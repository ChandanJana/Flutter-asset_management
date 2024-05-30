import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mindteck_iot/resource/app_resource.dart';

import '../models/asset/asset_data.dart';
import '../utils/arc_clipper.dart';

/// Created by Chandan Jana on 05-03-2024.
/// Company name: Mindteck
/// Email: chandan.jana@mindteck.com

class AssetListRow extends StatelessWidget {
  const AssetListRow({super.key, required this.assetData});

  final AssetData assetData;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(5.0),
          topRight: Radius.circular(5.0),
          bottomLeft: Radius.circular(20.0),
          bottomRight: Radius.circular(5.0),
        ),
      ),
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceVariant,
      // Set the clip behavior of the card
      clipBehavior: Clip.antiAliasWithSaveLayer,
      margin: const EdgeInsets.all(8),
      child: Stack(
        children: [
          Center(
            child: Container(
              width: double.infinity,
              height: 180,
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.only(bottomLeft: Radius.circular(20.0)),
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Theme.of(context).colorScheme.onPrimaryContainer,
                      Theme.of(context)
                          .colorScheme
                          .onPrimaryContainer
                          .withOpacity(.5),
                    ]),
              ),
              child: ClipRect(child: CustomPaint(painter: ArcClipper())),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: ListTile(
              title: Text(
                assetData.assetName!,
                style: GoogleFonts.latoTextTheme().titleLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.background,
                      fontSize: 15,
                    ),
                textAlign: TextAlign.center,
              ),
              subtitle: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: 'Device  ',
                          style: TextStyle(
                            color: AppColors.contentColorWhite.withAlpha(100),
                            fontSize: 15,
                          ),
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          text: 'Zone  ',
                          style: TextStyle(
                            color: AppColors.contentColorWhite.withAlpha(100),
                            fontSize: 15,
                          ),
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          text: 'Level  ',
                          style: TextStyle(
                            color: AppColors.contentColorWhite.withAlpha(100),
                            fontSize: 15,
                          ),
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          text: 'Site  ',
                          style: TextStyle(
                            color: AppColors.contentColorWhite.withAlpha(100),
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 15,
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            WidgetSpan(
                              child: SizedBox(
                                  width: 5), // Add space between text spans
                            ),
                            TextSpan(
                              text: assetData.deviceName,
                              style: TextStyle(
                                color: AppColors.contentColorWhite,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            WidgetSpan(
                              child: SizedBox(
                                  width: 5), // Add space between text spans
                            ),
                            TextSpan(
                              text: assetData.zoneName!,
                              style: TextStyle(
                                color: AppColors.contentColorWhite,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            WidgetSpan(
                              child: SizedBox(
                                  width: 5), // Add space between text spans
                            ),
                            TextSpan(
                              text: assetData.levelName!,
                              style: TextStyle(
                                color: AppColors.contentColorWhite,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            WidgetSpan(
                              child: SizedBox(
                                  width: 5), // Add space between text spans
                            ),
                            TextSpan(
                              text: assetData.siteName!,
                              style: TextStyle(
                                color: AppColors.contentColorWhite,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        DateFormat('MMM d, y - hh:mm a')
                            .format(DateTime.parse(assetData.createdDate!)),
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.background,
                            fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                ],
              ),
              //trailing: Icon(Icons.assessment),
              onTap: () {
                // Handle row tap here
              },
            ),
          )
        ],
      ),
    );
  }
}
