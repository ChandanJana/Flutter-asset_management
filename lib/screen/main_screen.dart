import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:mindteck_iot/models/change_password_model.dart';
import 'package:mindteck_iot/models/login_model.dart';
import 'package:mindteck_iot/provider/app_theme_provider.dart';
import 'package:mindteck_iot/resource/app_resource.dart';
import 'package:mindteck_iot/screen/Dashboard/data_analyst_dashboard_screen.dart';
import 'package:mindteck_iot/screen/Dashboard/field_device_dashboard_screen.dart';
import 'package:mindteck_iot/screen/Dashboard/guest_dashboard_screen.dart';
import 'package:mindteck_iot/screen/Dashboard/operator_dashboard_screen.dart';
import 'package:mindteck_iot/screen/Dashboard/system_admin_dashboard_screen.dart';
import 'package:mindteck_iot/screen/application_screen.dart';
import 'package:mindteck_iot/screen/asset_screen.dart';
import 'package:mindteck_iot/screen/asset_track_dashboard_screen.dart';
import 'package:mindteck_iot/screen/dashboard/business_admin_dashboard_screen.dart';
import 'package:mindteck_iot/screen/device_screen.dart';
import 'package:mindteck_iot/screen/login_screen.dart';
import 'package:mindteck_iot/screen/sites_screen.dart';
import 'package:mindteck_iot/screen/tenant_screen.dart';
import 'package:mindteck_iot/screen/user_screen.dart';
import 'package:mindteck_iot/utils/constants.dart';
import 'package:mindteck_iot/utils/database_helper.dart';
import 'package:mindteck_iot/utils/utils.dart';
import 'package:mindteck_iot/widgets/cancel_button.dart';
import 'package:mindteck_iot/widgets/error_snackbar.dart';
import 'package:mindteck_iot/widgets/main_drawer.dart';
import 'package:mindteck_iot/widgets/submit_button.dart';

import 'device_allocation.dart';
import 'locate_asset_screen.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key, required this.loginModel});

  final LoginModel loginModel;

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  int _selectedIndex = 0;
  late PageController _pageController;
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _currentController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();
  final TextEditingController _newController = TextEditingController();
  final FocusNode _currentFocus = FocusNode();
  final FocusNode _confirmFocus = FocusNode();
  final FocusNode _newFocus = FocusNode();
  String _currentPassword = '';
  String _newPassword = '';
  bool isDarkMode = false;

  void _setScreen(String identifier) async {
    // Close the drawer
    Navigator.pop(context);

    if (identifier == AppText.dashBoard) {
      /// pushReplacement will replace the previous/active screen in stack and
      /// push will add the screen on top of previous/active screen
      /// in stack and back button will come automatically
      /// when user back it will return Map<Filter, bool> value and store to result
      // Close the drawer
      // Navigator.pop(context);
    } else if (identifier == AppText.device) {
      // By default Category page showing that why If we are choose the food then close the drawer
      //Navigator.pop(context);
      Navigator.of(context).push(
        PageRouteBuilder(
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return const DeviceScreen();
          },
          transitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // Right to left
            const begin = Offset(1.0, 0.0);

            /// Left to Right
            //const begin = Offset(-1.0, 0.0);
            /// Top to Bottom
            //const begin = Offset(0.0, -1.0);
            /// Bottom to Top
            //const begin = Offset(0.0, 1.0);
            const end = Offset.zero;

            /// Curves to specify the timing of transitions and animations.
            /// Curves are used to define how the animation values change
            /// over time.
            const curve = Curves.ease;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );

            /*var begin = 0.0;
            var end = 1.0;
            var curve = Curves.ease;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            return ScaleTransition(
              scale: animation.drive(tween),
              child: child,
            );*/
          },
        ),
      );
    } else if (identifier == AppText.deviceallocation) {
      // By default Category page showing that why If we are choose the food then close the drawer
      //Navigator.pop(context);
      Navigator.of(context).push(
        PageRouteBuilder(
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return const DeviceAllocation();
          },
          transitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // Right to left
            const begin = Offset(1.0, 0.0);

            /// Left to Right
            //const begin = Offset(-1.0, 0.0);
            /// Top to Bottom
            //const begin = Offset(0.0, -1.0);
            /// Bottom to Top
            //const begin = Offset(0.0, 1.0);
            const end = Offset.zero;

            /// Curves to specify the timing of transitions and animations.
            /// Curves are used to define how the animation values change
            /// over time.
            const curve = Curves.ease;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );

            /*var begin = 0.0;
            var end = 1.0;
            var curve = Curves.ease;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            return ScaleTransition(
              scale: animation.drive(tween),
              child: child,
            );*/
          },
        ),
      );
    } else if (identifier == AppText.application) {
      // By default Category page showing that why If we are choose the food then close the drawer
      //Navigator.pop(context);
      Navigator.of(context).push(
        PageRouteBuilder(
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return const ApplicationScreen();
          },
          transitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // Right to left
            const begin = Offset(1.0, 0.0);

            /// Left to Right
            //const begin = Offset(-1.0, 0.0);
            /// Top to Bottom
            //const begin = Offset(0.0, -1.0);
            /// Bottom to Top
            //const begin = Offset(0.0, 1.0);
            const end = Offset.zero;

            /// Curves to specify the timing of transitions and animations.
            /// Curves are used to define how the animation values change
            /// over time.
            const curve = Curves.ease;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );

            /*var begin = 0.0;
            var end = 1.0;
            var curve = Curves.ease;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            return ScaleTransition(
              scale: animation.drive(tween),
              child: child,
            );*/
          },
        ),
      );
    } else if (identifier == AppText.sites) {
      // By default Category page showing that why If we are choose the food then close the drawer
      //Navigator.pop(context);
      Navigator.of(context).push(
        PageRouteBuilder(
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return const SiteScreen();
          },
          transitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // Right to left
            const begin = Offset(1.0, 0.0);

            /// Left to Right
            //const begin = Offset(-1.0, 0.0);
            /// Top to Bottom
            //const begin = Offset(0.0, -1.0);
            /// Bottom to Top
            //const begin = Offset(0.0, 1.0);
            const end = Offset.zero;

            /// Curves to specify the timing of transitions and animations.
            /// Curves are used to define how the animation values change
            /// over time.
            const curve = Curves.ease;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );

            /*var begin = 0.0;
            var end = 1.0;
            var curve = Curves.ease;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            return ScaleTransition(
              scale: animation.drive(tween),
              child: child,
            );*/
          },
        ),
      );
    } else if (identifier == AppText.userManagement) {
      // By default Category page showing that why If we are choose the food then close the drawer
      //Navigator.pop(context);
      Navigator.of(context).push(
        PageRouteBuilder(
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return const UserScreen();
          },
          transitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // Right to left
            const begin = Offset(1.0, 0.0);

            /// Left to Right
            //const begin = Offset(-1.0, 0.0);
            /// Top to Bottom
            //const begin = Offset(0.0, -1.0);
            /// Bottom to Top
            //const begin = Offset(0.0, 1.0);
            const end = Offset.zero;

            /// Curves to specify the timing of transitions and animations.
            /// Curves are used to define how the animation values change
            /// over time.
            const curve = Curves.ease;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );

            /*var begin = 0.0;
            var end = 1.0;
            var curve = Curves.ease;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            return ScaleTransition(
              scale: animation.drive(tween),
              child: child,
            );*/
          },
        ),
      );
    } else if (identifier == AppText.tenants) {
      // By default Category page showing that why If we are choose the food then close the drawer
      //Navigator.pop(context);
      Navigator.of(context).push(
        PageRouteBuilder(
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return const TenantScreen();
          },
          transitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // Right to left
            const begin = Offset(1.0, 0.0);

            /// Left to Right
            //const begin = Offset(-1.0, 0.0);
            /// Top to Bottom
            //const begin = Offset(0.0, -1.0);
            /// Bottom to Top
            //const begin = Offset(0.0, 1.0);
            const end = Offset.zero;

            /// Curves to specify the timing of transitions and animations.
            /// Curves are used to define how the animation values change
            /// over time.
            const curve = Curves.ease;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );

            /*var begin = 0.0;
            var end = 1.0;
            var curve = Curves.ease;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            return ScaleTransition(
              scale: animation.drive(tween),
              child: child,
            );*/
          },
        ),
      );
    } else if (identifier == Constants.allAssets) {
      // By default Category page showing that why If we are choose the food then close the drawer
      //Navigator.pop(context);
      Navigator.of(context).push(
        PageRouteBuilder(
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return const AssetScreen();
          },
          transitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // Right to left
            const begin = Offset(1.0, 0.0);

            /// Left to Right
            //const begin = Offset(-1.0, 0.0);
            /// Top to Bottom
            //const begin = Offset(0.0, -1.0);
            /// Bottom to Top
            //const begin = Offset(0.0, 1.0);
            const end = Offset.zero;

            /// Curves to specify the timing of transitions and animations.
            /// Curves are used to define how the animation values change
            /// over time.
            const curve = Curves.ease;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );

            /*var begin = 0.0;
            var end = 1.0;
            var curve = Curves.ease;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            return ScaleTransition(
              scale: animation.drive(tween),
              child: child,
            );*/
          },
        ),
      );
    } else if (identifier == Constants.locateAsset) {
      // By default Category page showing that why If we are choose the food then close the drawer
      //Navigator.pop(context);
      Navigator.of(context).push(
        PageRouteBuilder(
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return const LocateAssetScreen();
          },
          transitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // Right to left
            const begin = Offset(1.0, 0.0);

            /// Left to Right
            //const begin = Offset(-1.0, 0.0);
            /// Top to Bottom
            //const begin = Offset(0.0, -1.0);
            /// Bottom to Top
            //const begin = Offset(0.0, 1.0);
            const end = Offset.zero;

            /// Curves to specify the timing of transitions and animations.
            /// Curves are used to define how the animation values change
            /// over time.
            const curve = Curves.ease;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );

            /*var begin = 0.0;
            var end = 1.0;
            var curve = Curves.ease;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            return ScaleTransition(
              scale: animation.drive(tween),
              child: child,
            );*/
          },
        ),
      );
    } else if (identifier == Constants.assetDashBoard) {
      // By default Category page showing that why If we are choose the food then close the drawer
      //Navigator.pop(context);
      Navigator.of(context).push(
        PageRouteBuilder(
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return const AssetTrackDashboardScreen();
          },
          transitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // Right to left
            const begin = Offset(1.0, 0.0);

            /// Left to Right
            //const begin = Offset(-1.0, 0.0);
            /// Top to Bottom
            //const begin = Offset(0.0, -1.0);
            /// Bottom to Top
            //const begin = Offset(0.0, 1.0);
            const end = Offset.zero;

            /// Curves to specify the timing of transitions and animations.
            /// Curves are used to define how the animation values change
            /// over time.
            const curve = Curves.ease;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );

            /*var begin = 0.0;
            var end = 1.0;
            var curve = Curves.ease;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            return ScaleTransition(
              scale: animation.drive(tween),
              child: child,
            );*/
          },
        ),
      );
    }
  }

  Future<bool> _logout(String userId) async {
    /// Here we getting/fetch data from server
    String logoutUrl = '${AppApi.logoutApi}$userId';
    // Create storage
    const storage = FlutterSecureStorage();
    // Read token value
    String? authToken = await storage.read(key: AppDatabase.token);

    print('authToken $authToken');
    final Map<String, String> headers = {
      AppApiKey.contentTypeKey: AppApiKey.contentTypeValue,
      AppApiKey.acceptKey: AppApiKey.acceptValue,
      AppApiKey.authorizationKey: '${AppApiKey.bearer}$authToken'
    };
    print('logoutUrl $logoutUrl');
    print('headers $headers');
    final response = await http.post(Uri.parse(logoutUrl), headers: headers);
    print('response.statusCode ${response.statusCode}');
    if (response.statusCode == 200) {
      var responseBody = json.decode(response.body);
      print('Logout fetch. $responseBody');
      // Delete all
      await storage.deleteAll();
      return true;
    } else {
      // ServerErrorPopup.showServerError(this.context, 'Server unreachable. Check your internet source');
      Navigator.of(context).pop();
      Utils().showServerError(context, AppText.try_again);
    }
    return true;
  }

  void _onLogoutClick() async {
    var isInternetAvailable = await Utils().checkInternetConnectivity();

    if (isInternetAvailable) {
      Navigator.of(context).pop();
      //LoadingOverlay(isLoading: true);
      Utils().showLoaderDialog(context, isDarkMode);
      bool isLogout = await _logout(widget.loginModel.id);
      //bool isLogout = true;
      Navigator.pop(context);
      //LoadingOverlay(isLoading: false);
      if (isLogout) {
        DatabaseHelper().deleteAll();
        //Navigator.of(context).pop();
        setState(() {
          ref.read(appThemeProvider.notifier).setTheme(false);
        });
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) {
              return const LoginPage();
            },
          ),
        );
      } else {
        //Navigator.of(context).pop();
        ScaffoldMessenger.of(context).clearSnackBars();
        ErrorSnackbar.showError(context, AppText.login_failed);
      }
    } else {
      Navigator.of(context).pop();
      ErrorSnackbar.showError(
          this.context, 'Please check your internet connection');
      // ServerErrorPopup.showServerError(this.context, 'Unable to connect to Server. Please check your network connection');
    }
  }

  void _logoutAccountDialog(BuildContext context) {
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      shape: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.0),
        borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
      ),
      title: Text(
        AppText.logoutAlert,
        style: GoogleFonts.latoTextTheme().titleLarge!.copyWith(
              fontWeight: FontWeight.normal,
              color: Theme.of(context).colorScheme.onBackground,
              fontSize: 25,
            ),
      ),
      content: Text(
        AppText.logoutMessage,
        style: GoogleFonts.latoTextTheme().titleLarge!.copyWith(
              fontWeight: FontWeight.normal,
              color: Theme.of(context).colorScheme.onBackground,
              fontSize: 15,
            ),
      ),
      actions: [
        CancelButton(
          cancelText: AppText.cancel,
          onCancelClick: () {
            Navigator.of(context).pop();
          },
        ),
        SubmitButton(
          submitText: AppText.logout,
          onSubmitClick: _onLogoutClick,
        ),
      ],
    );

    // show the dialog
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
          child: alert,
        );
      },
      transitionDuration: const Duration(milliseconds: 250),
      barrierDismissible: true,
      barrierLabel: "Barrier",
      barrierColor: Colors.black.withOpacity(0.5),
    );
  }

  void _showProfileDialog(BuildContext context,
      {required String userName,
      required String userEmail,
      String? userRole,
      String? userContactNumber}) {
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      shape: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.0),
        borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
      ),
      title: Text(
        AppText.user_profile,
        textAlign: TextAlign.center,
        style: GoogleFonts.latoTextTheme().titleLarge!.copyWith(
              fontWeight: FontWeight.normal,
              color: Theme.of(context).colorScheme.onBackground,
              fontSize: 25.0,
            ),
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Name:  $userName',
            style: GoogleFonts.latoTextTheme().titleLarge!.copyWith(
                  fontWeight: FontWeight.normal,
                  color: Theme.of(context).colorScheme.onBackground,
                  fontSize: 15.0,
                ),
          ),
          const SizedBox(height: 10),
          Text(
            'Email:  $userEmail',
            style: GoogleFonts.latoTextTheme().titleLarge!.copyWith(
                  fontWeight: FontWeight.normal,
                  color: Theme.of(context).colorScheme.onBackground,
                  fontSize: 15.0,
                ),
          ),
          const SizedBox(height: 10),
          Text(
            'Role:  $userRole',
            style: GoogleFonts.latoTextTheme().titleLarge!.copyWith(
                  fontWeight: FontWeight.normal,
                  color: Theme.of(context).colorScheme.onBackground,
                  fontSize: 15.0,
                ),
          ),
          const SizedBox(height: 10),
          Text(
            'Contact:  $userContactNumber',
            style: GoogleFonts.latoTextTheme().titleLarge!.copyWith(
                  fontWeight: FontWeight.normal,
                  color: Theme.of(context).colorScheme.onBackground,
                  fontSize: 15.0,
                ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            AppText.close,
            style: GoogleFonts.latoTextTheme().titleLarge!.copyWith(
                  fontWeight: FontWeight.normal,
                  color: Theme.of(context).colorScheme.onBackground,
                  fontSize: 15.0,
                ),
          ),
        ),
      ],
    );

    // show the dialog
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
          child: alert,
        );
      },
      transitionDuration: const Duration(milliseconds: 250),
      barrierDismissible: true,
      barrierLabel: "Barrier",
      barrierColor: Colors.black.withOpacity(0.5),
    );
  }

  Future<void> _changePasswordDialog(BuildContext context) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(
        AppText.change_password,
        style: GoogleFonts.latoTextTheme().titleLarge!.copyWith(
            color: Theme.of(context).colorScheme.onBackground, fontSize: 20),
      ),

      /// In Flutter, the StatefulBuilder widget is often used when you need to
      /// rebuild a part of the UI tree in response to user interactions without
      /// rebuilding the entire widget tree. This can be useful when working with dialogs,
      content: StatefulBuilder(
        builder: (context, setState) {
          return SingleChildScrollView(
            padding: const EdgeInsets.only(top: 5),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Form(
                  key: _formKey,
                  //autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _currentController,
                        autofocus: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          hintText: AppText.password,
                          labelText: AppText.current_password,
                          labelStyle: const TextStyle(fontSize: 18),
                        ),
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        focusNode: _currentFocus,
                        onFieldSubmitted: (value) {
                          Utils().fieldFocusChange(
                              context, _currentFocus, _newFocus);
                        },
                        /*onEditingComplete: () {
                            Utils().fieldFocusChange(context, _currentFocus,
                                _newFocus);
                          },*/
                        onSaved: (currentPassword) {
                          this._currentPassword = currentPassword!;
                        },
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onBackground),
                        validator: (currentPassword) {
                          if (currentPassword == null ||
                              currentPassword.isEmpty) {
                            return AppText.input_current_password;
                          } else {
                            return null;
                          }
                        },
                        onTap: () {},
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _newController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          hintText: AppText.password,
                          labelText: AppText.new_password,
                          labelStyle: const TextStyle(fontSize: 18),
                        ),
                        textInputAction: TextInputAction.next,
                        focusNode: _newFocus,
                        onFieldSubmitted: (value) {
                          Utils().fieldFocusChange(
                              context, _newFocus, _confirmFocus);
                        },
                        /*onEditingComplete: () {
                            Utils().fieldFocusChange(context, _newFocus, _confirmFocus);
                          },*/
                        onSaved: (newPassword) {
                          this._newPassword = newPassword!;
                        },
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onBackground),
                        validator: (newPassword) {
                          if (newPassword == null || newPassword.isEmpty) {
                            return AppText.input_new_passsword;
                          } else {
                            return null;
                          }
                        },
                        onTap: () {},
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _confirmController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          hintText: AppText.password,
                          labelText: AppText.confirm_password,
                          labelStyle: const TextStyle(fontSize: 18),
                        ),
                        textInputAction: TextInputAction.done,
                        focusNode: _confirmFocus,
                        onFieldSubmitted: (value) {
                          _confirmFocus.unfocus();
                        },
                        /*onEditingComplete: () {
                            _confirmFocus.unfocus();
                          },*/
                        onSaved: (confirmPassword) {},
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onBackground),
                        validator: (confirmPassword) {
                          if (confirmPassword == null ||
                              confirmPassword.isEmpty) {
                            return AppText.input_confirm_password;
                          } else if (_newController.text != confirmPassword) {
                            return AppText.new_and_confirm_password_not_matched;
                          } else {
                            return null;
                          }
                        },
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      actions: [
        CancelButton(
          cancelText: AppText.cancel,
          onCancelClick: _onCancelClick,
        ),
        SubmitButton(
          submitText: AppText.change,
          onSubmitClick: _onSubmitClick,
        ),
      ],
    );
    // show the dialog
    return showGeneralDialog(
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
          child: alertDialog,
        );
      },
      transitionDuration: const Duration(milliseconds: 350),
      barrierDismissible: false,
      barrierLabel: "Barrier",
      barrierColor: Colors.black.withOpacity(0.5),
    );
  }

  void _passwordChangedSuccessDialog() {
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
          child: WillPopScope(
            child: AlertDialog(
              title: Text(
                AppText.password_changed_successfully,
                style: GoogleFonts.latoTextTheme().titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontSize: 20),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppText.password_changed_successfully_msg,
                    style: GoogleFonts.latoTextTheme().titleLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 14,
                        ),
                  )
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () async {
                    DatabaseHelper().deleteAll();
                    Navigator.of(context).pop();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) {
                          return const LoginPage();
                        },
                      ),
                    );
                  },
                  child: Text(
                    AppText.ok,
                    style: GoogleFonts.latoTextTheme().titleLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 14,
                        ),
                  ),
                ),
              ],
            ),
            onWillPop: () async {
              return false;
            },
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 350),
      barrierDismissible: false,
      barrierLabel: "Barrier",
      barrierColor: Colors.black.withOpacity(0.5),
    );
  }

  void _changePassword(BuildContext context) async {
    Navigator.pop(context);
    Utils().showLoaderDialog(context, isDarkMode);

    /// Here we getting/fetch data from server
    const String changePasswordUrl = AppApi.changePasswordApi;
    // Create storage
    const storage = FlutterSecureStorage();
    // Read userId value
    String? userId = await storage.read(key: AppDatabase.userId);

    print('userId $userId');

    final Map<String, String> headers = {
      AppApiKey.contentTypeKey: AppApiKey.contentTypeValue,
    };
    final Map<String, dynamic> body = {
      AppApiKey.userId: '$userId',
      AppApiKey.previousPassword: _currentPassword,
      AppApiKey.newPassword: _newPassword,
    };
    print('changePasswordUrl $changePasswordUrl');
    print('headers $headers');
    print('body $body');
    final response = await http.post(
      Uri.parse(changePasswordUrl),
      headers: headers,
      body: json.encode(body),
    );
    print('response.statusCode ${response.statusCode}');
    if (response.statusCode == 200) {
      // Decode the JSON response into a Map<String, dynamic>
      Map<String, dynamic> decodedBody = json.decode(response.body);

      // Create an instance of ChangePasswordModel using the decoded map
      ChangePasswordModel responseBody =
          ChangePasswordModel.fromJson(decodedBody);
      print('Change Password fetch. $responseBody.responseMessage');
      if (responseBody.responseCode == 200) {
        // Delete all
        await storage.deleteAll();
        _currentController.clear();
        _newController.clear();
        _confirmController.clear();
        Navigator.pop(context);
        _passwordChangedSuccessDialog();
      } else {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppText.try_again,
              style: GoogleFonts.latoTextTheme().titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.primaryContainer,
                  ),
            ),
            backgroundColor: Theme.of(context).colorScheme.onBackground,
          ),
        );
      }
    } else {
      Navigator.of(context).pop();
      Utils().showServerError(this.context, AppText.try_again);
    }
  }

  void _onCancelClick() {
    _formKey.currentState?.reset();
    _currentController.clear();
    _newController.clear();
    _confirmController.clear();
    Navigator.of(context).pop();
  }

  void _onSubmitClick() {
    final isValid = _formKey.currentState!.validate();
    print('Form isValid: $isValid');
    if (!isValid) {
      return;
    }

    _formKey.currentState!.save();

    print('Current password: ${_currentController.text}');
    print('New password: ${_newController.text}');
    print('Confirm password: ${_confirmController.text}');

    _changePassword(context);
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _currentController.dispose();
    _confirmController.dispose();
    _newController.dispose();
    _currentFocus.dispose();
    _newFocus.dispose();
    _confirmFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    isDarkMode = ref.watch(appThemeProvider).getTheme();

    //Widget activePage = const AssetsChartScreen();
    String activeText = AppText.dashBoard;

    if (_selectedIndex == 1) {
      //final favoriteFoods = ref.watch(favoriteFood);
      //activePage = const AllAssetsScreen();
      activeText = AppText.allAssets;
    }

    String? roleName = widget.loginModel.roleName;
    Widget dashboard = const DataAnalystDashboardScreen();
    print('roleName $roleName');
    switch (roleName) {
      /*case Constants.data_analyst:
        dashboard = const DataAnalystDashboardScreen();
        break;*/
      case Constants.system_administrator:
        dashboard = SystemAdminDashboardScreen();
        break;
      case Constants.business_administrator:
        dashboard = BusinessAdminDashboardScreen();
        break;
      case Constants.operator:
        dashboard = OperatorDashboardScreen();
        break;
      case Constants.guest:
        dashboard = GuestDashboardScreen();
        break;
      case Constants.field_device:
        dashboard = FieldDeviceDashboardScreen();
        break;
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        // Set the preferred height of the AppBar
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(15), // Adjust border radius as needed
            bottomRight: Radius.circular(15),
          ),
          child: AppBar(
            //backgroundColor: Theme.of(context).colorScheme.primary,
            leading: Builder(
              builder: (BuildContext context) {
                return IconButton(
                  key: Key('main_menu'),
                  icon: Icon(
                    Icons.menu,
                    color: AppColors.contentColorWhite,
                  ),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  tooltip:
                      MaterialLocalizations.of(context).openAppDrawerTooltip,
                );
              },
            ),
            // hides default back button
            automaticallyImplyLeading: false,
            title: Text(
              activeText,
              style: GoogleFonts.latoTextTheme().titleLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 18,
                  ),
            ),
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.topRight,
                    colors: <Color>[Colors.black, Colors.blue]),
              ),
            ),
            actions: [
              /*if (_selectedIndex == 1)
                IconButton(onPressed: () {}, icon: const Icon(Icons.refresh)),*/
              Switch(
                key: Key('theme_change'),
                value: isDarkMode,
                onChanged: (value) async {
                  var data = await DatabaseHelper().queryAll();
                  if (data.isNotEmpty) {
                    setState(() {
                      ref.read(appThemeProvider.notifier).setTheme(!isDarkMode);
                    });
                  }
                },
                inactiveThumbColor: Colors.white,
                activeColor: Colors.white,
                activeTrackColor: AppColors.switchThemeColor,
                //inactiveThumbColor: Colors.white,
              ),
              PopupMenuButton<String>(
                //iconColor: Theme.of(context).colorScheme.secondaryContainer,
                iconColor: AppColors.contentColorWhite,
                key: Key('more_option'),
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'profile',
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.account_circle_outlined,
                          // Assuming you want to use the default profile icon
                          color: AppColors.contentColorBlue,
                          size: 20,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(AppText.profile),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'change_password',
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.lock_reset,
                          color: AppColors.contentColorBlue,
                          size: 20,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(AppText.change_password),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'logout',
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.exit_to_app,
                          color: AppColors.contentColorBlue,
                          size: 20,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(AppText.logout),
                      ],
                    ),
                  ),
                ],
                onSelected: (value) {
                  // Handle menu item selection
                  if (value == 'profile') {
                    // Handle profile selection
                    _showProfileDialog(
                      context,
                      userName:
                          "${widget.loginModel.firstName} ${widget.loginModel.lastName}",
                      userEmail: widget.loginModel.email,
                      userRole: widget.loginModel.roleName,
                      userContactNumber: widget.loginModel.contactNumber,
                    );
                  } else if (value == 'logout') {
                    // Handle logout selection
                    _logoutAccountDialog(context);
                  } else if (value == 'change_password') {
                    // Handle change password selection
                    _changePasswordDialog(context);
                  }
                },
              )
            ],
            systemOverlayStyle: SystemUiOverlayStyle.light,
          ),
        ),
      ),
      drawer: MainDrawer(
        userName:
            "${widget.loginModel.firstName} ${widget.loginModel.lastName}",
        userEmail: widget.loginModel.email,
        userRole: widget.loginModel.roleName,
        userContactNumber: widget.loginModel.contactNumber,
        onSelect: _setScreen,
      ),
      body: SizedBox.expand(
        child: dashboard,
      ),
    );
  }
}
