import 'package:get/get.dart';
import 'package:recipe_food/Pages/homescreen.dart';
import 'package:recipe_food/Pages/item_detail_screen.dart';
import 'package:recipe_food/Pages/reviews_screen.dart';
import 'package:recipe_food/routes/route_name.dart';

import '../Pages/bottom_navigation_bar.dart';
import '../Pages/login.dart';
import '../Pages/signup.dart';
import '../Pages/splashscreen.dart';

class AppRoutes {
  static appRoutes() => [
        GetPage(
          name: RouteName.splashScreen,
          page: () => const SplashScreen(),
        ),
        GetPage(
          name: RouteName.loginScreen,
          page: () => const LoginScreen(),
        ),
        GetPage(
          name: RouteName.signupScreen,
          page: () => const SignupScreen(),
        ),
        GetPage(
          name: RouteName.homeScreen,
          page: () => const HomeScreen(),
        ),
        GetPage(
          name: RouteName.bottomNavigationBar,
          page: () => const BottomNavigationBar(),
        ),
        GetPage(
          name: RouteName.itemDetailScreen,
          page: () => const ItemDetailScreen(),
        ),
        GetPage(
          name: RouteName.reviewsScreen,
          page: () => const ReviewsScreen(),
        ),
      ];
}
