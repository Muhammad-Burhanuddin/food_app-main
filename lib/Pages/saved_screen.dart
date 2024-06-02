import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:recipe_food/AppAssets/app_assets.dart';
import 'package:recipe_food/CommenWidget/app_text.dart';
import 'package:recipe_food/Helpers/colors.dart';
import 'package:recipe_food/routes/route_name.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SavedScreen extends StatefulWidget {
  const SavedScreen({Key? key}) : super(key: key);

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  SharedPreferences? _prefs;
  bool _isLoading = true;
  List<String> _savedRecipes = [];

  @override
  void initState() {
    super.initState();
    _initPrefs();
  }

  Future<void> _initPrefs() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      _savedRecipes = _prefs?.getStringList('bookmarks') ?? [];
    } catch (e) {
      print('Error initializing SharedPreferences: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final containerWidth = screenWidth;
    final containerHeight = screenHeight * 0.2;

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primaryColor,
          automaticallyImplyLeading: false,
          title: AppText(
            text: 'Saved Recipes',
            fontSize: 18,
            textColor: Colors.white,
          ),
          centerTitle: true,
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        automaticallyImplyLeading: false,
        title: AppText(
          text: 'Saved Recipes',
          fontSize: 18,
          textColor: Colors.white,
        ),
        centerTitle: true,
      ),
      body: _savedRecipes.isEmpty
          ? Center(
              child: AppText(
                text: 'No saved recipes',
                fontSize: 16,
                textColor: Colors.black,
              ),
            )
          : ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: _savedRecipes.length,
              itemBuilder: (context, index) {
                final String recipeName = _savedRecipes[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GestureDetector(
                    onTap: () {
                      Get.toNamed(RouteName.itemDetailScreen,
                          arguments: {'recipeName': recipeName});
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 5),
                      width: containerWidth,
                      height: containerHeight,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade600,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Opacity(
                            opacity: 0.8,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                AppAssets.saveItem,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            top: containerHeight * 0.07,
                            left: containerWidth * 0.03,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: AppColors.lightOrangeColor,
                                  ),
                                  height: 23,
                                  width: 45,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(AppAssets.starIcon),
                                      SizedBox(
                                        width: 3,
                                      ),
                                      AppText(
                                        text: '4.5',
                                        fontWeight: FontWeight.w200,
                                        fontSize: 11,
                                        textColor: Colors.black,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: containerHeight * 0.35),
                                AppText(
                                  text: recipeName,
                                  fontSize: 14,
                                ),
                                Row(
                                  children: [
                                    AppText(
                                      text: 'By Chef John',
                                      fontSize: 8,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    SizedBox(width: containerWidth * 0.44),
                                    SvgPicture.asset(
                                      AppAssets.timerIcon,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: containerWidth * 0.02),
                                    AppText(
                                      text: '20 mins',
                                      fontSize: 11,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    SizedBox(width: containerWidth * 0.02),
                                    Container(
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(13),
                                        color: Colors.white,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: SvgPicture.asset(
                                            AppAssets.bookMarkIcon),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
