/// Created by Chandan Jana on 27-02-2024.
/// Company name: Mindteck
/// Email: chandan.jana@mindteck.com
///
import 'dart:ui';

import 'package:flutter_driver/driver_extension.dart';
import 'package:mindteck_iot/main.dart' as app;

void main() {
  handler(_) async {
    final language = window.locale.languageCode;
    return Future.value(language);
  }

  // This line enables the extension
  enableFlutterDriverExtension(handler: handler);
  app.main();
}
