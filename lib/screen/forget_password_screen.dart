import 'package:animate_do/animate_do.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mindteck_iot/provider/api_data_provider.dart';
import 'package:mindteck_iot/resource/app_resource.dart';

/// Created by Chandan Jana on 04-03-2024.
/// Company name: Mindteck
/// Email: chandan.jana@mindteck.com
///

class ForgetPasswordScreen extends ConsumerStatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  ConsumerState<ForgetPasswordScreen> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends ConsumerState<ForgetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final FocusNode _emailFocus = FocusNode();
  var _isAuthenticating = false;
  String _email = '';

  @override
  void dispose() {
    _emailFocus.dispose();
    usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Forget Password',
          style: GoogleFonts
              .latoTextTheme()
              .titleLarge!
              .copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: AppColors.contentColorWhite,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 50,
              ),
              Container(
                padding: const EdgeInsets.all(10),
                child: const Image(
                  image: AssetImage("assets/images/mindtecklogo.png"),
                  width: 200,
                  //color: Colors.white,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    FadeInUp(
                      duration: const Duration(milliseconds: 800),
                      child: const Text(
                        textAlign: TextAlign.center,
                        AppText.forgotpassword,
                        style:
                        TextStyle(color: AppColors.primary, fontSize: 25),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    FadeInUp(
                      duration: const Duration(milliseconds: 800),
                      child: const Text(
                        textAlign: TextAlign.center,
                        AppText.forgetMessage,
                        style:
                        TextStyle(color: AppColors.primary, fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
              //SizedBox(height: 10),
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(60),
                    topRight: Radius.circular(60),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      FadeInUp(
                        duration: const Duration(milliseconds: 800),
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
                            ],
                          ),
                          child: Column(
                            children: [
                              Container(
                                constraints: const BoxConstraints(
                                  minHeight: 300,
                                  minWidth: double.infinity,
                                  maxHeight: 430,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Form(
                                    key: _formKey,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextFormField(
                                          key: Key('email'),
                                          decoration: const InputDecoration(
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(40.0),
                                              ),
                                              borderSide: BorderSide(
                                                color: AppColors.primary,
                                                width: 2.0,
                                              ),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(40.0),
                                              ),
                                              borderSide: BorderSide(
                                                color: Colors.grey,
                                                width: 2.0,
                                              ),
                                            ),
                                            label: Text(AppText.email),
                                            prefixIcon: Icon(Icons.email),
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.red, width: 1),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(40.0),
                                              ),
                                            ),
                                          ),
                                          keyboardType:
                                          TextInputType.emailAddress,
                                          autocorrect: false,
                                          textCapitalization:
                                          TextCapitalization.none,
                                          textInputAction: TextInputAction.done,
                                          focusNode: _emailFocus,
                                          validator: (value) {
                                            if (value == null ||
                                                value
                                                    .trim()
                                                    .isEmpty ||
                                                !EmailValidator.validate(
                                                    value)) {
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
                                          height: 25,
                                        ),
                                        if (_isAuthenticating)
                                          LoadingAnimationWidget
                                              .staggeredDotsWave(
                                            color: AppColors.primary,
                                            size: 70,
                                          ),
                                        if (!_isAuthenticating)
                                          ElevatedButton(
                                            key: Key('send'),
                                            onPressed: () {
                                              final isValid = _formKey
                                                  .currentState!
                                                  .validate();
                                              print('User isValid: $isValid');

                                              if (!isValid) {
                                                return;
                                              }

                                              _formKey.currentState!.save();
                                              FocusManager.instance.primaryFocus
                                                  ?.unfocus();
                                              print('User Email: $_email');

                                              setState(() {
                                                _isAuthenticating = true;
                                              });

                                              ref
                                                  .read(
                                                  sendEmailProvider(_email)
                                                      .future)
                                                  .then((data) {
                                                SchedulerBinding.instance
                                                    .addPostFrameCallback((_) {
                                                  setState(() {
                                                    _isAuthenticating = false;
                                                  });
                                                });
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: Text(
                                                        data.responseCode == 200
                                                            ? 'Email Send Success'
                                                            : 'Email Send Error',
                                                        style: GoogleFonts
                                                            .latoTextTheme()
                                                            .titleLarge!
                                                            .copyWith(
                                                          fontWeight:
                                                          FontWeight
                                                              .bold,
                                                          color:
                                                          Colors.black,
                                                          fontSize: 18,
                                                        ),
                                                      ),
                                                      content: Text(
                                                        data.responseCode == 200
                                                            ? AppText
                                                            .emailSendSuccessfuly
                                                            : 'Unable to send reset email. Please try again later.',
                                                        style: GoogleFonts
                                                            .latoTextTheme()
                                                            .titleLarge!
                                                            .copyWith(
                                                          fontWeight:
                                                          FontWeight
                                                              .bold,
                                                          color:
                                                          Colors.black,
                                                          fontSize: 15,
                                                        ),
                                                      ),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () {
                                                            _email = '';
                                                            Navigator.of(
                                                                context)
                                                                .pop();
                                                            Navigator.of(
                                                                context)
                                                                .pop(); // Close the alert dialog
                                                          },
                                                          child: Text('OK'),
                                                        ),
                                                      ],
                                                    );
                                                    ;
                                                  },
                                                );
                                              }).catchError(
                                                    (error) {
                                                  SchedulerBinding.instance
                                                      .addPostFrameCallback(
                                                          (_) {
                                                        setState(() {
                                                          _isAuthenticating =
                                                          false;
                                                        });
                                                      });
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        title: Text(
                                                          'Email Send Error',
                                                          style: GoogleFonts
                                                              .latoTextTheme()
                                                              .titleLarge!
                                                              .copyWith(
                                                            fontWeight:
                                                            FontWeight
                                                                .bold,
                                                            color: Colors
                                                                .black,
                                                            fontSize: 18,
                                                          ),
                                                        ),
                                                        content: Text(
                                                          'Unable to send reset email. Please try again later.',
                                                          style: GoogleFonts
                                                              .latoTextTheme()
                                                              .titleLarge!
                                                              .copyWith(
                                                            fontWeight:
                                                            FontWeight
                                                                .bold,
                                                            color: Colors
                                                                .black,
                                                            fontSize: 15,
                                                          ),
                                                        ),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                  context)
                                                                  .pop(); // Close the alert dialog
                                                            },
                                                            child: Text('OK'),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                },
                                              );
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                              AppColors.primary,
                                              minimumSize: const Size(200, 50),
                                            ),
                                            child: Text(
                                              AppText.send,
                                              style: GoogleFonts
                                                  .latoTextTheme()
                                                  .bodyMedium!
                                                  .copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
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
            ],
          ),
        ),
      ),
    );
  }
}
