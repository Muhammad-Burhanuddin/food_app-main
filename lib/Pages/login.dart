import 'dart:developer';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:recipe_food/CommenWidget/app_text.dart';
import 'package:recipe_food/CommenWidget/custom_button.dart';
import 'package:recipe_food/Pages/auth_service.dart';
import '../AppAssets/app_assets.dart';
import '../CommenWidget/custom_text_form_field.dart';
import '../CommenWidget/icon_button.dart';
import '../Helpers/colors.dart';
import '../Helpers/googlsignin.dart';
import '../model/user_model.dart';
import '../routes/route_name.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = AuthService();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    _email.dispose();
    _password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final bool isTablet = size.width >= 600;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const AppText(
                    text: 'Hello,',
                    textColor: Colors.black,
                    fontSize: 30,
                  ),
                  SizedBox(height: size.height * 0.04),
                  const AppText(
                    text: 'Welcome Back!,',
                    textColor: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
                  SizedBox(height: size.height * 0.04),
                  CustomTextFormField(
                    controller: _email,
                    label: 'Email',
                    hintText: 'Enter your Email',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                          .hasMatch(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: size.height * 0.04),
                  CustomTextFormField(
                    label: 'Password',
                    hintText: 'Enter your Password',
                    controller: _password,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      } else if (value.length < 6) {
                        return 'Password must be at least 6 characters long';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: size.height * 0.04),
                  GestureDetector(
                    onTap: () => _showForgotPasswordDialog(context),
                    child: const AppText(
                      text: 'Forgot Password?',
                      textColor: AppColors.orangeColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: size.height * 0.04),
                  CustomButton(
                    onTap: _login,
                    icon: Icons.arrow_forward,
                    label: 'Signin',
                    height: 55,
                  ),
                  SizedBox(height: size.height * 0.04),
                  Row(
                    children: <Widget>[
                      Expanded(
                          child: Divider(
                        thickness: isTablet ? 2 : 1,
                        color: AppColors.lightGreyColor,
                      )),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: AppText(
                          text: "Or Sign in With",
                          fontSize: isTablet ? 20 : 12,
                          textColor: AppColors.primaryColor,
                        ),
                      ),
                      Expanded(
                          child: Divider(
                        thickness: isTablet ? 2 : 1,
                        color: AppColors.lightGreyColor,
                      )),
                    ],
                  ),
                  SizedBox(height: size.height * 0.04),
                  GestureDetector(
                    onTap: () async {
                      final googleSignInProvider =
                          Provider.of<GoogleSignInProvider>(context,
                              listen: false);
                      await googleSignInProvider.googleLogin();
                    },
                    child: SizedBox(
                      width: size.width,
                      child: IconButtons(
                        icon: AppAssets.googleIcon,
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * 0.04),
                  Align(
                    alignment: Alignment.center,
                    child: RichText(
                      text: TextSpan(
                        text: "Don’t have an account? ",
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Get.toNamed(RouteName.signupScreen);
                              },
                            text: 'sign up',
                            style: const TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: AppColors.orangeColor,
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
        ),
      ),
    );
  }

  void goToHome(BuildContext context, UserModel user) {
    Get.toNamed(RouteName.bottomNavigationBar, arguments: {'user': user});
  }

  _login() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        final user = await _auth.loginUserWithEmailAndPassword(
            _email.text, _password.text);
        if (user != null) {
          log("User Logged In");

          // Check if the email is verified
          if (!user.emailVerified) {
            Get.snackbar("Email Verification",
                "Please verify your email. A verification link has been sent to your email.");
            await user.sendEmailVerification(); // Resend the verification email
            return;
          }

          // Fetch user details using email instead of uid
          final userDetails = await _auth.fetchUserDetailsByEmail(_email.text);
          if (userDetails != null) {
            goToHome(context, userDetails);
          } else {
            _showErrorDialog('User details not found');
          }
        } else {
          _showErrorDialog('Invalid email or password');
        }
      } catch (e) {
        _showErrorDialog('An error occurred. Please try again later.');
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  void _showForgotPasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Forgot Password"),
        content: TextField(
          controller: _email,
          decoration: const InputDecoration(hintText: "Enter your email"),
        ),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text("Send"),
            onPressed: () async {
              if (_email.text.isNotEmpty) {
                await _auth.sendPasswordResetEmail(_email.text);
                Get.snackbar("Password Reset",
                    "Password reset link sent to your email.");
                Navigator.of(context).pop();
              } else {
                Get.snackbar("Error", "Please enter your email.");
              }
            },
          ),
        ],
      ),
    );
  }
}
