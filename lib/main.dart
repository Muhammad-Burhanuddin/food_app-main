import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipe_food/routes/routes.dart';
import 'Helpers/googlsignin.dart';
import 'Pages/splashscreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => GoogleSignInProvider(),
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Raleway',
          useMaterial3: true,
        ),
        getPages: AppRoutes.appRoutes(),
        home: const SplashScreen(),
      ),
    );
  }
}
