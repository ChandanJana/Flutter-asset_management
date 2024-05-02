import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:connectivity/connectivity.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mindteck_iot/models/login/new_login_model.dart';
import 'package:mindteck_iot/models/login_model.dart';
import 'package:mindteck_iot/resource/app_api.dart';
import 'package:mindteck_iot/resource/app_api_key.dart';
import 'package:mindteck_iot/resource/app_colors.dart';
import 'package:mindteck_iot/resource/app_database.dart';
import 'package:mindteck_iot/resource/app_text.dart';
import 'package:mindteck_iot/screen/forget_password_screen.dart';
import 'package:mindteck_iot/screen/main_screen.dart';
import 'package:mindteck_iot/utils/database_helper.dart';
import 'package:mindteck_iot/utils/utils.dart';
import 'package:mindteck_iot/widgets/error_snackbar.dart';
import 'package:uuid/uuid.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends ConsumerState<LoginPage> {
  // text editing controllers
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final _formKey = GlobalKey<FormState>();

  // Keys for each form field
  final Map<String, GlobalKey<FormFieldState<String>>> _fieldKeys = {
    'login': GlobalKey(),
    'email': GlobalKey(),
    'password': GlobalKey(),
  };
  String _email = '';
  String _password = '';
  var _isAuthenticating = false;
  var _isLogged = false;

  // var isServerAvailable = true;

  // Initially password is obscure
  bool _showPassword = false;
  late LoginModel _loginModel;

  int get timeLimit => 10;

  // Toggles the password show status
  void _toggle() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

// sign user in method
  Future<void> signUserIn() async {
    final isValid = _formKey.currentState!.validate();
    print('User isValid: $isValid');

    if (!isValid) {
      return;
    }

    _formKey.currentState!.save();
    FocusManager.instance.primaryFocus?.unfocus();
    print('User Email: $_email');
    print('User password: $_password');

    Duration timeoutDuration = const Duration(seconds: 10);

    var isInternetAvailable = await Utils().checkInternetConnectivity();

    if (isInternetAvailable) {
      try {
        setState(() {
          _isAuthenticating = true;
        });
      } catch (error) {}
      const String loginUrl = AppApi.loginApi;
      try {
        print('User login url $loginUrl');

        final Map<String, String> headers = {
          AppApiKey.contentTypeKey: AppApiKey.contentTypeValue,
          AppApiKey.acceptKey: AppApiKey.acceptValue,
          // Add other headers as needed, e.g., 'Authorization'
        };
        final Map<String, dynamic> body = {
          AppApiKey.email: _email,
          AppApiKey.password: _password,
        };

        final response = await http
            .post(
              Uri.parse(AppApi.loginApi),
              headers: headers,
              body: json.encode(body),
            )
            .timeout(timeoutDuration);

        if (response.statusCode == 200) {
          // Login was successful
          final responseBody = json.decode(response.body);
          print('User Login successful. $responseBody');

          LoginResponseModel loginModel =
              LoginResponseModel.fromJson(responseBody);

          if (loginModel.responseMessage == 'Login successful') {
            String tempId = const Uuid().v4();
            int insertId = await DatabaseHelper().insert({
              AppDatabase.userId: loginModel.data!.user!.userId,
              AppDatabase.tenantId: loginModel.data!.tenant!.tenantId,
              AppDatabase.tenantName: loginModel.data!.tenant!.tenantName,
              AppDatabase.email: loginModel.data!.user!.email,
              AppDatabase.token: loginModel.data!.token,
              AppDatabase.firstName: loginModel.data!.user!.firstName,
              AppDatabase.lastName: loginModel.data!.user!.lastName,
              AppDatabase.contactNumber: loginModel.data!.user!.contactNumber,
              AppDatabase.roleId: loginModel.data!.user!.roleId,
              AppDatabase.lastLogin: loginModel.data!.user!.lastLogin,
              AppDatabase.roleName: loginModel.data!.user!.roleName,
              AppDatabase.registrationDate:
                  loginModel.data!.user!.registrationDate,
              // AppDatabase.isActive: loginModel.data!.user!.isActive,
            });

            _loginModel = LoginModel.fromJson({
              AppDatabase.userId: loginModel.data!.user!.userId,
              AppDatabase.tenantId: loginModel.data!.tenant!.tenantId,
              AppDatabase.tenantName: loginModel.data!.tenant!.tenantName,
              AppDatabase.email: loginModel.data!.user!.email,
              AppDatabase.token: loginModel.data!.token,
              AppDatabase.firstName: loginModel.data!.user!.firstName,
              AppDatabase.lastName: loginModel.data!.user!.lastName,
              AppDatabase.contactNumber: loginModel.data!.user!.contactNumber,
              AppDatabase.roleId: loginModel.data!.user!.roleId,
              AppDatabase.roleName: loginModel.data!.user!.roleName,
              AppDatabase.lastLogin: loginModel.data!.user!.lastLogin,
              AppDatabase.registrationDate:
                  loginModel.data!.user!.registrationDate,
              // AppDatabase.isActive: loginModel.data!.user!.isActive,
            });
            print('User insertId: $insertId');
            // Create storage
            const storage = FlutterSecureStorage();
            //Write token value
            await storage.write(
                key: AppDatabase.token, value: loginModel.data!.token);
            //Write userId value
            await storage.write(
                key: AppDatabase.userId, value: loginModel.data!.user!.userId);
            //Write userId value
            await storage.write(
                key: AppDatabase.tenantId,
                value: loginModel.data!.tenant!.tenantId);
            //Write userId value
            await storage.write(
                key: AppDatabase.tenantName,
                value: loginModel.data!.tenant!.tenantName);
            //Write role value
            await storage.write(
                key: AppDatabase.roleName,
                value: loginModel.data!.user!.roleName);

            setState(() {
              _isLogged = true;
            });
          } else {
            // ErrorSnackbar.showError(this.context, 'Login failed');
            Utils().showServerError(
                this.context, 'Login failed, Incorrect Username or Password');
            // Login failed
            print('User Login failed. Status code: ${response.statusCode}');
            setState(() {
              _isLogged = false;
              _isAuthenticating = false;
            });
          }
        } else {
          // ScaffoldMessenger.of(this.context).clearSnackBars();
          // ErrorSnackbar.showError(this.context, 'Login failed, Incorrect Username or Password');
          Utils().showServerError(
              this.context, 'Login failed, Incorrect Username or Password');

          // Login failed
          print('User Login failed. Status code: ${response.statusCode}');
          setState(() {
            _isLogged = false;
            _isAuthenticating = false;
          });
        }
      } catch (e) {
        // Handle different types of exceptions
        print('Error: $e');
        if (e is SocketException) {
          // Handle SocketException (connection timeout, server unreachable, etc.)
          print(AppText.Network_Error_Message);

          Utils().showServerError(this.context, AppText.Network_Error_Message);

          setState(() {
            _isAuthenticating = false;
          });
        } else if (e is TimeoutException) {
          // Handle TimeoutException
          print('Connection timeout. Please try again later.');
          print('Server unreachable. Check your internet connection.');

          Utils().showServerError(this.context, AppText.Network_Error_Message);
          setState(() {
            _isAuthenticating = false;
          });
        } else {
          // Handle other exceptions
          print('An unexpected error occurred: $e');
        }
      }
    } else {
      ErrorSnackbar.showError(
          this.context, 'Please check your internet connection');
      // ServerErrorPopup.showServerError(this.context, 'Unable to connect to Server. Please check your network connection');
    }
  }

  @override
  void dispose() {
    _emailFocus.dispose();
    _passwordFocus.dispose();
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Connectivity _connectivity = Connectivity();

  void _handleConnectivityChange(ConnectivityResult result) {
    setState(() {
      // Handle the connectivity change
      switch (result) {
        case ConnectivityResult.none:
          // No internet connection
          Utils().showNetworkSnackbar(AppText.no_internet, context);
          break;
        case ConnectivityResult.mobile:
          // Mobile data connection
          //Utils().showNetworkSnackbar("Connected to Mobile Data", context);
          break;
        case ConnectivityResult.wifi:
          // WiFi connection
          //Utils().showNetworkSnackbar("Connected to WiFi", context);
          break;
      }
    });
  }

  @override
  void initState() {
    super.initState();

    // Initialize the connectivity package
    _connectivity = Connectivity();

    // Subscribe to the connectivity changes
    _connectivity.onConnectivityChanged.listen((result) {
      // Handle the connectivity change
      _handleConnectivityChange(result);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      body: _isLogged
          ? MainScreen(
              loginModel: _loginModel,
            )
          : Container(
              /*decoration: const BoxDecoration(
                gradient: LinearGradient(
                  tileMode: TileMode.decal,
                  colors: [
                    Colors.white,
                    Colors.white,
                  ], // Your two colors
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),*/
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  colors: [
                    AppColors.contentColorWhite,
                    AppColors.contentColorWhite.withOpacity(.8),
                    AppColors.contentColorWhite.withOpacity(.6),
                  ],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 80,
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.all(0),
                    child: const Image(
                      image: AssetImage("assets/images/mindtecklogo.png"),
                      width: 200,
                      //color: Colors.white,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        FadeInUp(
                            duration: Duration(milliseconds: 1000),
                            child: Text(
                              AppText.login,
                              style: TextStyle(
                                  color: AppColors.primary, fontSize: 40),
                            )),
                        /*SizedBox(
                          height: 0,
                        ),*/
                        /* FadeInUp(
                            duration: Duration(milliseconds: 1300),
                            child: Text(
                              "Welcome Back",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            )),*/
                      ],
                    ),
                  ),
                  //SizedBox(height: 10),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(60),
                              topRight: Radius.circular(60))),
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              SizedBox(
                                height: 30,
                              ),
                              FadeInUp(
                                duration: Duration(milliseconds: 1400),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: AppColors.contentColorWhite,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                            //color: Color(0xFF92b1ab),
                                            color: AppColors.contentColorWhite,
                                            blurRadius: 20,
                                            offset: Offset(0, 10))
                                      ]),
                                  child: Column(
                                    children: [
                                      Container(
                                        constraints: const BoxConstraints(
                                          minHeight: 300,
                                          minWidth: double.infinity,
                                          maxHeight: 430,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(16),
                                          child: Form(
                                            key: _formKey,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                TextFormField(
                                                  key: Key('email'),
                                                  decoration:
                                                      const InputDecoration(
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(40.0),
                                                      ),
                                                      borderSide: BorderSide(
                                                        color:
                                                            AppColors.primary,
                                                        width: 2.0,
                                                      ),
                                                    ),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(40.0),
                                                      ),
                                                      borderSide: BorderSide(
                                                        color: Colors.grey,
                                                        width: 2.0,
                                                      ),
                                                    ),
                                                    label: Text(AppText.email),
                                                    prefixIcon:
                                                        Icon(Icons.email),
                                                    border: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors.red,
                                                          width: 1),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(40.0),
                                                      ),
                                                    ),
                                                  ),
                                                  keyboardType: TextInputType
                                                      .emailAddress,
                                                  autocorrect: false,
                                                  textCapitalization:
                                                      TextCapitalization.none,
                                                  textInputAction:
                                                      TextInputAction.next,
                                                  focusNode: _emailFocus,
                                                  onFieldSubmitted: (value) {
                                                    Utils().fieldFocusChange(
                                                        context,
                                                        _emailFocus,
                                                        _passwordFocus);
                                                  },
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.trim().isEmpty ||
                                                        !EmailValidator
                                                            .validate(value)) {
                                                      return AppText
                                                          .pleaseEnterValidEmailId;
                                                    }
                                                    return null;
                                                  },
                                                  onSaved: (newValue) {
                                                    _email = newValue!;
                                                  },
                                                ),
                                                const SizedBox(
                                                  height: 15,
                                                ),
                                                TextFormField(
                                                  key: Key('password'),
                                                  textInputAction:
                                                      TextInputAction.done,
                                                  focusNode: _passwordFocus,
                                                  onFieldSubmitted: (value) {
                                                    _passwordFocus.unfocus();
                                                  },
                                                  obscureText: !_showPassword,
                                                  decoration: InputDecoration(
                                                    focusedBorder:
                                                        const OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(40.0),
                                                      ),
                                                      borderSide: BorderSide(
                                                        color:
                                                            AppColors.primary,
                                                        width: 2.0,
                                                      ),
                                                    ),
                                                    enabledBorder:
                                                        const OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(40.0),
                                                      ),
                                                      borderSide: BorderSide(
                                                        color: Colors.grey,
                                                        width: 2.0,
                                                      ),
                                                    ),
                                                    label: const Text(
                                                        AppText.password),
                                                    prefixIcon:
                                                        const Icon(Icons.lock),
                                                    suffixIcon: GestureDetector(
                                                      onTap: () {
                                                        _toggle();
                                                      },
                                                      child: Icon(
                                                        _showPassword
                                                            ? Icons.visibility
                                                            : Icons
                                                                .visibility_off,
                                                      ),
                                                    ),
                                                    border:
                                                        const OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors.red),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  40.0)),
                                                    ),
                                                  ),
                                                  keyboardType:
                                                      TextInputType.text,

                                                  /// Hide the password
                                                  //obscureText: _obscureText,
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.trim().isEmpty ||
                                                        value.trim().length <
                                                            6) {
                                                      return 'Password must be at least 6 characters.';
                                                    }
                                                    return null;
                                                  },
                                                  onSaved: (newValue) {
                                                    _password = newValue!;
                                                  },
                                                ),
                                                const SizedBox(
                                                  height: 30,
                                                ),
                                                if (_isAuthenticating)
                                                  LoadingAnimationWidget
                                                      .staggeredDotsWave(
                                                    color: AppColors.primary,
                                                    size: 70,
                                                  ),
                                                if (!_isAuthenticating)
                                                  ElevatedButton(
                                                    key: Key('login'),
                                                    onPressed: signUserIn,
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          AppColors.primary,
                                                      minimumSize:
                                                          const Size(200, 50),
                                                    ),
                                                    child: Text(
                                                      AppText.login,
                                                      style: GoogleFonts
                                                              .latoTextTheme()
                                                          .bodyMedium!
                                                          .copyWith(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                    ),
                                                  ),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                if (!_isAuthenticating)
                                                  TextButton(
                                                    onPressed: () {
                                                      _formKey.currentState
                                                          ?.reset();
                                                      setState(() {});
                                                    },
                                                    child: Text(
                                                      AppText.createNewAccount,
                                                      style: GoogleFonts
                                                              .latoTextTheme()
                                                          .bodyLarge!
                                                          .copyWith(
                                                            color: const Color(
                                                                0xFF064d44),
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                          ),
                                                    ),
                                                  ),
                                                if (!_isAuthenticating)
                                                  TextButton(
                                                    onPressed: () {
                                                      _formKey.currentState
                                                          ?.reset();
                                                      Navigator.of(context)
                                                          .push(
                                                        PageRouteBuilder(
                                                          pageBuilder: (BuildContext
                                                                  context,
                                                              Animation<double>
                                                                  animation,
                                                              Animation<double>
                                                                  secondaryAnimation) {
                                                            return const ForgetPasswordScreen();
                                                          },
                                                          transitionDuration:
                                                              const Duration(
                                                                  milliseconds:
                                                                      500),
                                                          transitionsBuilder:
                                                              (context,
                                                                  animation,
                                                                  secondaryAnimation,
                                                                  child) {
                                                            // Right to left
                                                            const begin =
                                                                Offset(
                                                                    1.0, 0.0);

                                                            /// Left to Right
                                                            //const begin = Offset(-1.0, 0.0);
                                                            /// Top to Bottom
                                                            //const begin = Offset(0.0, -1.0);
                                                            /// Bottom to Top
                                                            //const begin = Offset(0.0, 1.0);
                                                            const end =
                                                                Offset.zero;

                                                            /// Curves to specify the timing of transitions and animations.
                                                            /// Curves are used to define how the animation values change
                                                            /// over time.
                                                            const curve =
                                                                Curves.ease;

                                                            var tween = Tween(
                                                                    begin:
                                                                        begin,
                                                                    end: end)
                                                                .chain(CurveTween(
                                                                    curve:
                                                                        curve));

                                                            return SlideTransition(
                                                              position: animation
                                                                  .drive(tween),
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
                                                    },
                                                    child: Text(
                                                      key: Key(
                                                          'forget_password'),
                                                      AppText.forgotpassword,
                                                      style: GoogleFonts
                                                              .latoTextTheme()
                                                          .bodyLarge!
                                                          .copyWith(
                                                            color: AppColors
                                                                .primary,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        //),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
