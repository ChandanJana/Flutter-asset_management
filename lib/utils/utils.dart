import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart';

import '../resource/app_resource.dart';

// Singleton class
class Utils {
  // Private constructor
  Utils._();

  // Singleton instance
  // The one and only instance of this singleton
  // In Dart, all global variables are lazy-loaded naturally. This implies
  // that they are possibly initialized when they are first utilized.
  static final Utils _instance = Utils._();

  // Factory constructor to get the instance
  factory Utils() {
    return _instance;
  }

  final Logger logger = Logger(AppText.appName);

  Future<String> get _localPath async {
    var directory = await getExternalStorageDirectory();
    directory ??= await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/mindteck_iot.txt');
  }

  void setupLogging() async {
    File file = await _localFile;
    Logger.root.level = Level.ALL; // Set the logging level
    Logger.root.onRecord.listen((record) {
      // Print log messages to the console
      print('${record.level.name}: ${record.time}: ${record.message}');

      // Write log messages to a file
      file.writeAsStringSync(
        '${record.level.name}: ${record.time}: ${record.message}\n',
        mode: FileMode.append,
      );
    });
  }

  Future<void> downloadFile(String fileUrl) async {
    print('fileUrl $fileUrl');
    //You can download a single file
    FileDownloader.downloadFile(
      url: fileUrl,
      //name: 'alarm_mindteck', //THE FILE NAME AFTER DOWNLOADING,
      onProgress: (String? fileName, double progress) {
        print('FILE fileName HAS PROGRESS $progress');
      },
      onDownloadCompleted: (String path) {
        print('FILE DOWNLOADED TO PATH: $path');
        final File file = File(path);
        //This will be the path of the downloaded file
        print('FILE DOWNLOADED TO file: $file');
      },
      onDownloadError: (String error) {
        print('FILE DOWNLOAD ERROR: $error');
      },
      notificationType: NotificationType.all,
      downloadDestination: DownloadDestinations.publicDownloads,
    );
  }

  void fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  void showLoaderDialog(BuildContext context, bool isDarkMode) {
    AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          LoadingAnimationWidget.staggeredDotsWave(
            color: Colors.blueAccent,
            size: 70,
          ),
          Container(
              margin: const EdgeInsets.only(left: 7),
              child: Text(
                "Please wait...",
                style:
                    TextStyle(color: isDarkMode ? Colors.white : Colors.black),
              )),
        ],
      ),
    );
    showGeneralDialog(
      context: context,
      pageBuilder: (context, animation, secondaryAnimation) {
        return Container(
          height: 300,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(40),
          ),
          child: const SizedBox.expand(child: FlutterLogo()),
        );
      },
      transitionBuilder: (ctx, anim, a2, child) {
        var curve = Curves.easeInOut.transform(anim.value);
        return Transform.scale(
          scale: curve,
          filterQuality: FilterQuality.medium,
          child: alert,
        );
      },
      transitionDuration: const Duration(milliseconds: 250),
      barrierDismissible: false,
      barrierLabel: "Barrier",
      barrierColor: Colors.black.withOpacity(0.5),
    );
  }

  void downloadFileDialog(BuildContext context, String downloadUrl) {
    showModalBottomSheet(
      useRootNavigator: true,
      //isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      context: context,
      clipBehavior: Clip.antiAliasWithSaveLayer,

      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      useSafeArea: true,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(10),
          //color: Theme.of(context).colorScheme.background,
          //height: 180,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              InkWell(
                splashColor: Colors.black26, // Change the splash color
                //radius: 60, // Change the highlight shape
                borderRadius: BorderRadius.circular(20),
                child: const Icon(
                  Icons.cancel_outlined,
                  color: Colors.grey,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: ImageIcon(
                  const AssetImage("assets/images/csv.png"),
                  color: Theme.of(context).colorScheme.onBackground,
                  size: 20,
                ),
                title: Text(
                  AppText.csv,
                  style: GoogleFonts.latoTextTheme().titleLarge!.copyWith(
                        fontWeight: FontWeight.normal,
                        color: Theme.of(context).colorScheme.onBackground,
                        fontSize: 15,
                      ),
                ),
                onTap: () {
                  // Handle the selection of Item 1.
                  print('CSV 1 selected');
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.picture_as_pdf,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
                title: Text(
                  AppText.pdf,
                  style: GoogleFonts.latoTextTheme().titleLarge!.copyWith(
                        fontWeight: FontWeight.normal,
                        color: Theme.of(context).colorScheme.onBackground,
                        fontSize: 15,
                      ),
                ),
                onTap: () {
                  // Handle the selection of Item 2.
                  Utils().downloadFile(downloadUrl);
                  print('PDF 2 selected');
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<bool> checkInternetConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }

  void showNetworkSnackbar(String message, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<bool> checkUserConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        //setState(() {
        return true;
        // ActiveConnection = true;
        // T = "Turn off the data and repress again";
        //});
      }
    } on SocketException catch (_) {
      return false;
      /*setState(() {
        ActiveConnection = false;
        T = "Turn On the data and repress again";
      });*/
    }
    return false;
  }

  void showServerError(BuildContext context, String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;

        return AlertDialog(
          title: Column(
            children: [
              Icon(
                Icons.error,
                color: isDarkTheme ? Colors.white : Colors.red,
              ),
              const SizedBox(width: 8.0),
              Text(
                AppText.server_error,
                style: TextStyle(
                  color: isDarkTheme ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  errorMessage,
                  style: TextStyle(
                    color: isDarkTheme ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: isDarkTheme
                    ? AppColors.contentColorPurpleDark
                    : AppColors.contentColorPurple,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                AppText.close,
                style: GoogleFonts.latoTextTheme().bodyMedium!.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ],
        );
      },
    );
  }
}
