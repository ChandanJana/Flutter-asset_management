import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mindteck_iot/provider/app_theme_provider.dart';

class ErrorScreen extends ConsumerWidget {
  const ErrorScreen(
      {super.key, required this.errorMessage, required this.onRetry});

  final void Function() onRetry;
  final String errorMessage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print('Error ' + errorMessage);
    final bool isDarkTheme = ref.watch(appThemeProvider).getTheme();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        const Icon(
          Icons.error,
          size: 50,
          color: Colors.red,
        ),
        const SizedBox(height: 20),
        Text(
          'An error occurred',
          style: GoogleFonts.latoTextTheme().titleLarge!.copyWith(
                fontWeight: FontWeight.bold,
                color: isDarkTheme ? Colors.white : Colors.black,
                fontSize: 24,
              ),
        ),
        const SizedBox(height: 10),
        Text(
          'Something went wrong while performing the operation. Please try again later!',
          textAlign: TextAlign.center,
          style: GoogleFonts.latoTextTheme().titleLarge!.copyWith(
                fontWeight: FontWeight.normal,
                color: isDarkTheme ? Colors.white : Colors.black,
                fontSize: 16,
              ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            onRetry();
            // You can navigate back or perform some action to retry the operation here.
          },
          child: Text(
            'Retry',
            style: GoogleFonts.latoTextTheme().titleLarge!.copyWith(
                  fontWeight: FontWeight.normal,
                  color: isDarkTheme ? Colors.white : Colors.white,
                  fontSize: 16,
                ),
          ),
        ),
      ],
    );
  }
}
