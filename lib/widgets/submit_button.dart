import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SubmitButton extends StatelessWidget {
  const SubmitButton(
      {super.key, required this.submitText, required this.onSubmitClick});

  final String submitText;
  final void Function() onSubmitClick;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        onSubmitClick();
      },
      style: ButtonStyle(
        elevation: MaterialStatePropertyAll(4),
      ),
      child: Text(
        submitText,
        style: GoogleFonts.latoTextTheme().titleLarge!.copyWith(
              fontWeight: FontWeight.normal,
              color: Colors.white,
              fontSize: 14,
            ),
      ),
    );
  }
}
