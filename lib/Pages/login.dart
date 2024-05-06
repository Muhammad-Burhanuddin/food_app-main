import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipe_food/CommenWidget/app_text.dart';
import 'package:recipe_food/CommenWidget/custom_button.dart';
import '../AppAssets/app_assets.dart';
import '../CommenWidget/custom_text_form_field.dart';
import '../CommenWidget/icon_button.dart';
import '../Helpers/colors.dart';
import '../routes/route_name.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                AppText(
                  text: 'Hello,',
                  textColor: Colors.black,
                  fontSize: 30,
                ),
                SizedBox(height: size.height * 0.04),
                AppText(
                  text: 'Welcome Back!,',
                  textColor: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
                SizedBox(height: size.height * 0.04),
                CustomTextFormField(
                  label: 'Email',
                  hintText: 'Enter your Email',
                ),
                SizedBox(height: size.height * 0.04),
                CustomTextFormField(
                  label: 'Password',
                  hintText: 'Enter your Password',
                ),
                SizedBox(height: size.height * 0.04),
                AppText(
                  text: 'Forgot Password?',
                  textColor: AppColors.orangeColor,
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                ),
                SizedBox(height: size.height * 0.04),
                CustomButton(
                  onTap: () {
                    Get.toNamed(RouteName.bottomNavigationBar);
                  },
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
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: AppText(
                        text: "Or Sign in With",
                        fontSize: isTablet ? 20 : 12,
                        textColor: AppColors.lightGreyColor,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const IconButtons(
                      icon: AppAssets.googleIcon,
                    ),
                    SizedBox(width: 20),
                    const IconButtons(
                      icon: AppAssets.facebookIcon,
                    ),
                  ],
                ),
                SizedBox(height: size.height * 0.04),
                Align(
                  alignment: Alignment.center,
                  child: RichText(
                    text: TextSpan(
                      text: "Don’t have an account? ",
                      style: TextStyle(
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
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
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
    );
  }
}
