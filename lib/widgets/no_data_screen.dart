import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mindteck_iot/provider/app_theme_provider.dart';
import 'package:mindteck_iot/resource/app_text.dart';

class NoDataScreen extends ConsumerWidget {
  const NoDataScreen({super.key, required this.onRetry});

  final void Function() onRetry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isDarkMode = ref.watch(appThemeProvider).getTheme();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Icon(
          Icons.info,
          size: 100,
          color: Colors.blue,
        ),
        const SizedBox(height: 20),
        Text(
          'No data available',
          style: GoogleFonts.latoTextTheme().titleLarge!.copyWith(
                fontWeight: FontWeight.normal,
                color: isDarkMode ? Colors.white : Colors.black,
                fontSize: 25,
              ),
        ),
        const SizedBox(height: 10),
        Text(
          'There is no data to display at the moment. Press Refresh to load data.',
          textAlign: TextAlign.center,
          style: GoogleFonts.latoTextTheme().titleLarge!.copyWith(
                fontWeight: FontWeight.normal,
                color: isDarkMode ? Colors.white : Colors.black,
                fontSize: 16,
              ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            onRetry();
          },
          style: ElevatedButton.styleFrom(
            textStyle: const TextStyle(fontSize: 20, color: Colors.white),
          ),
          child: Text(
            AppText.refresh,
            style: GoogleFonts.latoTextTheme().titleLarge!.copyWith(
                  fontWeight: FontWeight.normal,
                  color: isDarkMode ? Colors.white : Colors.white,
                  fontSize: 16,
                ),
          ),
        ),
      ],
    );
  }
}
