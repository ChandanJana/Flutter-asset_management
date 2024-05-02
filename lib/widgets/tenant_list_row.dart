import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mindteck_iot/models/tenant/tenant_data.dart';

import '../provider/app_theme_provider.dart';
import '../resource/app_resource.dart';

/// Created by Chandan Jana on 27-03-2024.
/// Company name: Mindteck
/// Email: chandan.jana@mindteck.com
///

class TenantListRow extends ConsumerWidget {
  const TenantListRow({super.key, required this.tenantData});

  final TenantData tenantData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var isDarkMode = ref.watch(appThemeProvider).getTheme();
    return Card(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20.0),
          bottomRight: Radius.circular(5.0),
          topLeft: Radius.circular(5.0),
          topRight: Radius.circular(5.0),
        ),
      ),
      elevation: 2,
      color: isDarkMode ? const Color.fromARGB(0, 33, 43, 54) : Colors.white,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: ListTile(
          title: Text(
            tenantData.tenantName ?? '',
            style: GoogleFonts.latoTextTheme().titleLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black,
                  fontSize: 15,
                ),
            textAlign: TextAlign.center,
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _buildSubtitleRows(isDarkMode, context),
          ),
          onTap: () {
            // Handle row tap here
          },
        ),
      ),
    );
  }

  List<Widget> _buildSubtitleRows(bool isDarkMode, BuildContext context) {
    final List<Widget> rows = [];

    rows.add(SizedBox(
      height: 20,
    ));
    void addRow(String label, String? value) {
      if (value != null && value.isNotEmpty) {
        rows.add(SizedBox(
          height: 5,
        ));
        rows.add(
          Row(
            children: [
              Text(
                label,
                style: _getTextStyle(isDarkMode, context),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Text(
                  value,
                  style: _getTextStyle(isDarkMode, context),
                ),
              ),
            ],
          ),
        );
      }
    }

    addRow(AppText.contact_name,
        tenantData.firstName! + ' ' + tenantData.lastName!);
    addRow(AppText.contact_no, tenantData.contactNo);
    addRow(AppText.contact_email, tenantData.email);

    return rows;
  }

  TextStyle _getTextStyle(bool isDarkMode, BuildContext context) {
    return TextStyle(
      color: isDarkMode ? Colors.white : Colors.black,
      fontWeight: FontWeight.normal,
    );
  }
}
