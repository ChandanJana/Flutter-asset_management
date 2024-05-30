import 'dart:io';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mindteck_iot/models/login_model.dart';
import 'package:mindteck_iot/provider/app_theme_provider.dart';
import 'package:mindteck_iot/resource/app_resource.dart';
import 'package:mindteck_iot/screen/main_screen.dart';
import 'package:mindteck_iot/screen/splash_screen.dart';
import 'package:mindteck_iot/utils/database_helper.dart';
import 'package:mindteck_iot/utils/utils.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'screen/login_screen.dart';

var kColorScheme = ColorScheme.fromSeed(
  seedColor: AppColors.primary,
);

var kDarkColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: AppColors.primary.withOpacity(.5),
);

class AssetHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  if (Platform.isWindows || Platform.isLinux) {
    // Initialize FFI
    sqfliteFfiInit();
  }
  // Change the default factory. On iOS/Android, if not using `sqlite_flutter_lib` you can forget
  // this step, it will use the sqlite version available on the system.
  databaseFactory = databaseFactoryFfi;
  WidgetsFlutterBinding.ensureInitialized();
  // enableFlutterDriverExtension();
  HttpOverrides.global = AssetHttpOverrides();
  // initialization SharedPreferences
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  //Utils().setupLogging();
  runApp(ProviderScope(
    // override SharedPreferences provider with correct value
    overrides: [
      sharedPreferencesProvider.overrideWithValue(prefs),
    ],
    child: const IOTManagementApp(),
  ));
}

class IOTManagementApp extends ConsumerStatefulWidget {
  const IOTManagementApp({super.key});

  @override
  ConsumerState<IOTManagementApp> createState() => _IOTManagementAppState();
}

class _IOTManagementAppState extends ConsumerState<IOTManagementApp> {
  late List<LoginModel> data;

  Future<bool> checkLoginState() async {
    data = await DatabaseHelper().queryAll();

    print('User LoginModel data: $data');
    if (data.isNotEmpty) {
      //Navigator.pushReplacementNamed(context, '/home');
      return true;
    }
    return false;
  }

// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // final ThemeMode themeMode =
    // MediaQuery.of(context).platformBrightness == Brightness.dark
    //     ? ThemeMode.dark
    //     : ThemeMode.light;
    //
    // final bool isDarkMode = themeMode == ThemeMode.dark;

    final bool isDarkMode = ref.watch(appThemeProvider).getTheme();

    return MaterialApp(
      title: AppText.appName,
      debugShowCheckedModeBanner: false,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData.light().copyWith(
        useMaterial3: true,
        colorScheme: kColorScheme,
        appBarTheme: const AppBarTheme().copyWith(
          backgroundColor: kColorScheme.onPrimaryContainer,
          foregroundColor: kColorScheme.primaryContainer,
        ),
        popupMenuTheme: const PopupMenuThemeData(
          shape: Border(),
          elevation: 10,
          enableFeedback: true,
        ),
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 1.5,
              color: AppColors.primary.withOpacity(.5),
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 2,
              color: AppColors.primary,
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.contentColorRed, width: 1),
            borderRadius: BorderRadius.all(
              Radius.circular(40.0),
            ),
          ),
        ),
        cardTheme: const CardTheme().copyWith(
          color: kColorScheme.secondaryContainer,
          margin: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 16,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kColorScheme.onPrimaryContainer,
            textStyle: TextStyle(
              fontWeight: FontWeight.normal,
              color: kColorScheme.primary,
              fontSize: 18,
            ),
          ),
        ),
        textTheme: GoogleFonts.latoTextTheme().copyWith(
          titleLarge: TextStyle(
            fontWeight: FontWeight.normal,
            color: kColorScheme.onSecondaryContainer,
            fontSize: 14,
          ),
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        useMaterial3: true,
        colorScheme: kDarkColorScheme,
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 1.5,
              color: Theme.of(context)
                  .colorScheme
                  .primaryContainer
                  .withOpacity(.5),
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(20.0),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 2,
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(20.0),
            ),
          ),
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.contentColorRed, width: 1),
            borderRadius: BorderRadius.all(
              Radius.circular(40.0),
            ),
          ),
        ),
        cardTheme: const CardTheme().copyWith(
          color: kDarkColorScheme.secondaryContainer,
          margin: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 16,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kDarkColorScheme.primaryContainer,
            //foregroundColor: kDarkColorScheme.onPrimaryContainer,
            //backgroundColor: kColorScheme.onPrimaryContainer,
            textStyle: TextStyle(
              fontWeight: FontWeight.normal,
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ),
        textTheme: GoogleFonts.latoTextTheme().copyWith(
          titleLarge: TextStyle(
            fontWeight: FontWeight.normal,
            color: kColorScheme.onSecondaryContainer,
            fontSize: 14,
          ),
        ),
      ),
      home: AnimatedSplashScreen.withScreenFunction(
        splash: const SplashScreen(),
        screenFunction: () async {
          // Your code here
          var dataExist = await checkLoginState();

          if (dataExist) {
            return MainScreen(
              loginModel: data[0],
            );
          } else {
            return const LoginPage();
          } // loginScreen
        },
        //nextScreen: content,
        splashTransition: SplashTransition.scaleTransition,
        pageTransitionType: PageTransitionType.rightToLeft,
        backgroundColor: AppColors.primary,
      ),
    );
  }
}
