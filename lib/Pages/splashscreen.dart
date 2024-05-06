import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:recipe_food/AppAssets/app_assets.dart';
import 'package:recipe_food/CommenWidget/custom_button.dart';
import 'package:recipe_food/CommenWidget/app_text.dart';
import 'package:recipe_food/Helpers/colors.dart' as RecipeColors;

import '../routes/route_name.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 2), () {
      Get.toNamed(RouteName.loginScreen);
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image container
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AppAssets.splashBgImage),
                fit: BoxFit.cover, // Cover the entire screen
              ),
            ),
          ),
          // Overlay gradient container
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.3), // Adjust opacity as needed
                  Colors.black, // Adjust as needed
                ],
              ),
            ),
          ),

          Center(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  Column(
                    children: [
                      Image.asset(
                        AppAssets.splashIcon,
                        width: 79,
                        height: 79,
                      ),
                      SizedBox(height: 10,),
                      AppText(text: '100K+ Premium Recipe ',fontWeight: FontWeight.w600,fontSize: 16,),

                    ],
                  ),

                  Column(
                    children: [
                      AppText(textAlign: TextAlign.center,text:  'Get \nCooking',fontWeight: FontWeight.w600,fontSize: 50,),
                      AppText(text:'Simple way to find Tasty Recipe',fontWeight: FontWeight.w400,fontSize: 16, ),
                     SizedBox(height: 40,),
                      CustomButton(
                        width: 243,
                        height: 54,
                        label: 'Start Cooking',
                        icon: Icons.arrow_forward,
                      ),

                    ],
                  ),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
