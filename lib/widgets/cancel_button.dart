import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CancelButton extends StatelessWidget {
  const CancelButton(
      {super.key, required this.cancelText, required this.onCancelClick});

  final String cancelText;
  final void Function() onCancelClick;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        onCancelClick();
      },
      child: Text(
        cancelText,
        style: GoogleFonts.latoTextTheme().titleLarge!.copyWith(
              fontWeight: FontWeight.normal,
              color: Colors.grey,
              fontSize: 14,
            ),
      ),
    );
  }
}
