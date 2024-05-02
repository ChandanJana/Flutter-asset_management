import 'package:flutter/material.dart';

class ErrorSnackbar {
  static void showError(BuildContext context, String errorMessage) {
    final ThemeData theme = Theme.of(context);
    final snackBar = SnackBar(
      content: Row(
        children: [
          Expanded(
            child: Text(
              errorMessage,
              style: TextStyle(color: theme.primaryColor),
            ),
          ),
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
            child: const Text(
              'Dismiss',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
      duration: const Duration(seconds: 5),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
