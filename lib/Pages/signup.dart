import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recipe_food/Pages/homescreen.dart';
import 'package:recipe_food/Pages/login.dart';

import '../AppAssets/app_assets.dart';
import '../CommenWidget/app_text.dart';
import '../CommenWidget/custom_button.dart';
import '../CommenWidget/custom_text_form_field.dart';
import '../CommenWidget/icon_button.dart';
import '../Controllers/signup_controller.dart';
import '../Helpers/colors.dart';
import '../routes/route_name.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final SignUpController loginController = Get.put(SignUpController());
  final _auth = FirebaseAuth.instance;
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final isLoading = false.obs;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final bool isTablet = size.width >= 600;
    return Scaffold(
      body: SafeArea(
        child: Obx(() => isLoading.value
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      AppText(
                        text: 'Create an account',
                        textColor: Colors.black,
                        fontSize: 20,
                      ),
                      SizedBox(height: size.height * 0.015),
                      AppText(
                        text:
                            'Let’s help you set up your account,\nit won’t take long.',
                        textColor: Colors.black,
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                      ),
                      SizedBox(height: size.height * 0.02),
                      CustomTextFormField(
                        controller: _name,
                        label: 'Name',
                        hintText: 'Enter your Name',
                      ),
                      SizedBox(height: size.height * 0.02),
                      CustomTextFormField(
                        controller: _email,
                        label: 'Email',
                        hintText: 'Enter your Email',
                      ),
                      SizedBox(height: size.height * 0.02),
                      CustomTextFormField(
                        controller: _password,
                        label: 'Password',
                        hintText: 'Enter your Password',
                      ),
                      SizedBox(height: size.height * 0.02),
                      Row(
                        children: [
                          Obx(
                            () => GestureDetector(
                              onTap: () {
                                loginController.check();
                              },
                              child: Container(
                                width: isTablet
                                    ? size.width * 0.03
                                    : size.width * 0.036,
                                height: isTablet
                                    ? size.height * 0.027
                                    : size.height * 0.017,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(2),
                                  border:
                                      Border.all(color: AppColors.orangeColor),
                                  color: loginController.isChecked.value
                                      ? AppColors.primaryColor
                                      : Colors.transparent,
                                ),
                                child: loginController.isChecked.value
                                    ? Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: size.height * 0.013,
                                      )
                                    : null,
                              ),
                            ),
                          ),
                          SizedBox(width: 5),
                          AppText(
                            text: 'Accept terms & Condition',
                            textColor: AppColors.orangeColor,
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                          ),
                        ],
                      ),
                      SizedBox(height: size.height * 0.02),
                      CustomButton(
                        onTap: _signup,
                        label: 'Sign Up',
                        height: 55,
                        icon: Icons.arrow_forward,
                      ),
                      SizedBox(height: size.height * 0.02),
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
                      SizedBox(height: size.height * 0.02),
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
                            text: "Already a member? ",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Get.toNamed(RouteName.loginScreen);
                                  },
                                text: 'signin',
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
              )),
      ),
    );
  }

  void goToLogin(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  void goToHome(BuildContext context) {
    Get.toNamed(RouteName.bottomNavigationBar);
  }

  Future<void> saveUserData() async {
    FirestoreService firestoreService = FirestoreService();
    String name = _name.text;
    String email = _email.text;
    String pass = _password.text;

    await firestoreService.addUserToFirestore(name, email, pass);
  }

  Future<void> _signup() async {
    try {
      isLoading(true);
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _email.text, password: _password.text)
          .then((value) async {
        await saveUserData();
        goToHome(context);
        Get.snackbar("SignUp", "Register successfully");
        _password.clear();
        _email.clear();
        _name.clear();
      });
    } catch (error) {
      Get.snackbar("Error", error.toString());
    } finally {
      isLoading(false);
    }
  }
}

class FirestoreService {
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('User');

  Future<void> addUserToFirestore(
      String name, String email, String pass) async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      log("Adding user to Firestore with UID: $userId");

      await usersCollection.doc(userId).set({
        'name': name,
        'email': email,
        'password': pass,
        'imageUrl': '',
        'uid': userId,
      });

      log("User added to Firestore successfully.");
    } catch (e) {
      log('Error adding user to Firestore: $e');
      throw e;
    }
  }
}
