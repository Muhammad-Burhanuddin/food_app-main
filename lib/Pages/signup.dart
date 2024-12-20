import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const AppText(
                        text: 'Create an account',
                        textColor: Colors.black,
                        fontSize: 20,
                      ),
                      SizedBox(height: size.height * 0.015),
                      const AppText(
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
                          const SizedBox(width: 5),
                          const AppText(
                            text: 'Accept terms & Condition',
                            textColor: AppColors.orangeColor,
                            fontSize: 14,
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
                      SizedBox(height: size.height * 0.02),
                      SizedBox(
                        width: size.width,
                        child: const IconButtons(
                          icon: AppAssets.googleIcon,
                        ),
                      ),
                      SizedBox(height: size.height * 0.04),
                      Align(
                        alignment: Alignment.center,
                        child: RichText(
                          text: TextSpan(
                            text: "Already a member? ",
                            style: const TextStyle(
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
              )),
      ),
    );
  }

  void goToLogin(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  void goToHome(BuildContext context) {
    Get.toNamed(RouteName.bottomNavigationBar);
  }

  Future<void> saveUserData() async {
    String name = _name.text.trim();
    String email = _email.text.trim();
    String pass = _password.text.trim();

    if (name.isEmpty || email.isEmpty || pass.isEmpty) {
      log('Error: Fields cannot be empty');
      Get.snackbar('Error', 'All fields are required.');
      return;
    }

    try {
      await FirestoreService().addUserToFirestore(name, email, pass);
    } catch (e) {
      log('Error saving user data: $e');
      Get.snackbar('Error', 'Failed to save user data.');
    }
  }

  Future<void> _signup() async {
    if (isLoading.value) return; // Prevents multiple triggers
    try {
      isLoading(true);

      // Check if the email is a valid Gmail address
      if (!_email.text.endsWith('@gmail.com')) {
        throw Exception("Please use a valid Gmail address.");
      }

      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _email.text, password: _password.text);

      User? user = userCredential.user;
      await saveUserData();
      if (user != null) {
        await user.sendEmailVerification();
        Get.snackbar("Email Verification",
            "A verification email has been sent to ${_email.text}. Please verify your email before logging in.");

        // Show a dialog box with the email verification message
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Email Verification"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("A verification email has been sent to:"),
                  const SizedBox(height: 8),
                  Text(
                    _email.text,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const CircularProgressIndicator(), // Show loading indicator
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();

                    Get.toNamed(RouteName.loginScreen);
                  },
                  child: const Text("OK"),
                ),
              ],
            );
          },
        );

        // Wait for email verification
        await _checkEmailVerification(user);

        // Save the user data to Firestore only after email is verified
        if (user.emailVerified) {
          goToHome(context);
          Get.snackbar("SignUp", "Register successfully");
        } else {
          Get.snackbar("Email Verification",
              "Please verify your email before logging in.");
        }
      }
    } catch (error) {
      String errorMessage;

      if (error is FirebaseAuthException) {
        switch (error.code) {
          case 'invalid-email':
            errorMessage = "The email address is not valid.";
            break;
          case 'email-already-in-use':
            errorMessage =
                "The email address is already in use by another account.";
            break;
          case 'user-not-found':
            errorMessage = "No user found with this email.";
            break;
          default:
            errorMessage = error.message ?? "An unknown error occurred.";
        }
      } else {
        errorMessage = error.toString();
      }

      Get.snackbar("Error", errorMessage);
    } finally {
      isLoading(false);
    }
  }

  Future<void> _checkEmailVerification(User user) async {
    while (!user.emailVerified) {
      await Future.delayed(const Duration(seconds: 3));
      await user.reload();
      user = FirebaseAuth.instance.currentUser!;
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
