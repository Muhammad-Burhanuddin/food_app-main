import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:recipe_food/AppAssets/app_assets.dart';
import 'package:recipe_food/CommenWidget/app_text.dart';
import 'package:recipe_food/Helpers/colors.dart';
import 'package:recipe_food/Pages/auth_service.dart';
import 'package:recipe_food/Pages/recentsearch.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:translator/translator.dart';
import 'package:flutter_langdetect/flutter_langdetect.dart' as langdetect;
import '../Controllers/home_screen_controller.dart';
import '../model/user_model.dart';
import 'item_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeScreenController controller = Get.put(HomeScreenController());
  final TextEditingController _searchController = TextEditingController();
  UserModel? _user;
  final AuthService _authService = AuthService();

  bool _isSearchFocused = false;

  late stt.SpeechToText _speech;
  bool _isListening = false;
  final translator = GoogleTranslator();
  SharedPreferences? _prefs;
  List<String> _recentSearches = [];

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    _speech = stt.SpeechToText();
    _initializeLangDetect();
    _initPrefs();
    _loadRecentSearches();
  }

  Future<void> _fetchUserData() async {
    final User? currentUser = _authService.getCurrentUser();
    if (currentUser != null) {
      final UserModel? user =
          await _authService.fetchUserDetails(currentUser.uid);
      if (user != null) {
        setState(() {
          _user = user;
        });
      }
    }
  }

  void _loadRecentSearches() async {
    _recentSearches = await fetchRecentSearches();
    _searchRecipes(_recentSearches.join(' '));
    setState(() {});
  }

  void _onSearch(String query) {
    if (query.isEmpty) {
      controller.filteredRecipes.value = controller.recipes;
    } else {
      saveSearchQuery(query);
      _searchRecipes(query);
    }
    setState(() {});
  }

  void _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<List<String>> fetchRecentSearches() async {
    List<String> recentSearches = [];
    final firestore = FirebaseFirestore.instance;

    var querySnapshot = await firestore.collection('recentSearches').get();
    for (var doc in querySnapshot.docs) {
      recentSearches.add(doc['searchQuery']);
    }

    return recentSearches;
  }

  void saveSearchQuery(String query) async {
    final firestore = FirebaseFirestore.instance;
    try {
      await firestore.collection('recentSearches').add({'searchQuery': query});
      print('Search query saved: $query');
    } catch (e) {
      print('Error saving search query: $e');
    }
  }

  void _saveRecipeToBookmarks(String recipeName, String recipeImage,
      String recipetime, double reciperating, String recipeprocedure) {
    List<Map<String, String>> bookmarks = _prefs
            ?.getStringList('savedRecipes')
            ?.map((e) => Map<String, String>.from(json.decode(e)))
            .toList() ??
        [];

    final recipeIndex =
        bookmarks.indexWhere((recipe) => recipe['name'] == recipeName);

    if (recipeIndex != -1) {
      bookmarks.removeAt(recipeIndex);
      print('$recipeName removed from saved recipes');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$recipeName removed from saved recipes')),
      );
    } else {
      bookmarks.add({
        'name': recipeName,
        'image': recipeImage,
        'time': recipetime,
        'rating': reciperating.toString(),
        'procedure': recipeprocedure
      });
      print('$recipeName added to saved recipes');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$recipeName added to saved recipes')),
      );
    }

    _prefs?.setStringList(
        'savedRecipes', bookmarks.map((e) => json.encode(e)).toList());
  }

  bool _isRecipeBookmarked(String recipeName) {
    List<Map<String, String>> bookmarks = _prefs
            ?.getStringList('savedRecipes')
            ?.map((e) => Map<String, String>.from(json.decode(e)))
            .toList() ??
        [];
    return bookmarks.any((recipe) => recipe['name'] == recipeName);
  }

  void _initializeLangDetect() async {
    await langdetect.initLangDetect();
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) async {
            String recognizedText = val.recognizedWords;
            String translatedText = await _translateText(recognizedText);
            _searchController.text = translatedText;
            _searchRecipes(translatedText);
            setState(() => _isListening = false);
            _speech.stop();
          },
          localeId: 'ur-PK',
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  Future<String> _translateText(String text) async {
    String language = langdetect.detect(text);
    if (language != 'en') {
      final translation =
          await translator.translate(text, from: language, to: 'en');
      return translation.text;
    }
    return text;
  }

  void _searchRecipes(String query) {
    // final selectedIngredientsList = controller.ingredients
    //     .where((ingredient) => controller
    //         .selectedIngredients[controller.ingredients.indexOf(ingredient)]
    //         .value)
    //     .toList();

    final filteredRecipes = controller.recipes.where((recipe) {
      final matchesQuery =
          (recipe.name?.toLowerCase().contains(query.toLowerCase()) ?? false);

      return matchesQuery;
    }).toList();

    controller.filteredRecipes.value = filteredRecipes;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 7),
                    child: ListTile(
                      title: AppText(
                        text: 'Welcome, ${_user!.name ?? 'Guest'}',
                        textColor: Colors.black,
                        fontSize: 20,
                      ),
                      subtitle: const AppText(
                        text: 'What are you cooking today?',
                        textColor: Colors.black,
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                      ),
                      trailing: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: AppColors.orangeColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            _user!.imageUrl ?? AppAssets.profileIcon,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                AppAssets.profileIcon,
                                fit: BoxFit.cover,
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _isSearchFocused = true;
                              });
                            },
                            child: Container(
                              height: 45,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.search,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: TextFormField(
                                      cursorColor: Colors.grey,
                                      controller: _searchController,
                                      decoration: const InputDecoration(
                                        hintText: 'Search',
                                        border: InputBorder.none,
                                      ),
                                      onTap: () {
                                        setState(() {
                                          _isSearchFocused = true;
                                        });
                                      },
                                      onChanged: (value) {
                                        _onSearch(value);
                                      },
                                      onSaved: (value) {
                                        _onSearch(value!);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        GestureDetector(
                          onTap: _listen,
                          child: Container(
                              height: 45,
                              width: 45,
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                  _isListening ? Icons.mic : Icons.mic_none)),
                        )
                      ],
                    ),
                  ),
                  if (_isSearchFocused)
                    Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          height: 40,
                          child: Row(
                            children: [
                              const Expanded(
                                child: Text(
                                  'Recent Searches',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  setState(() {
                                    _isSearchFocused = false;
                                    _searchController.clear();
                                    _onSearch('');
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 150,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: _recentSearches.length,
                            itemBuilder: (context, index) {
                              return RecentSearchContainer(
                                searchQuery: _recentSearches[index],
                                onSearchSelected: (query) {
                                  _searchController.text = query;
                                  _onSearch(query);
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_searchController.text.isNotEmpty)
                          SizedBox(
                            height: 231,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: controller.filteredRecipes.length,
                              itemBuilder: (context, index) {
                                final recipe =
                                    controller.filteredRecipes[index];
                                return Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ItemDetailScreen(recipe: recipe),
                                        ),
                                      );
                                    },
                                    child: Stack(children: [
                                      Container(
                                        color: Colors.white,
                                        width: 150,
                                        height: 231,
                                      ),
                                      Positioned(
                                        right: 0,
                                        bottom: 0,
                                        child: Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            color: Colors.grey.shade200,
                                          ),
                                          height: 176,
                                          width: 150,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Center(
                                                  child: AppText(
                                                textAlign: TextAlign.center,
                                                text: recipe.name ??
                                                    'Recipe Name',
                                                fontSize: 16,
                                                textColor: Colors.black,
                                              )),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              const AppText(
                                                text: 'Time',
                                                textColor: AppColors.blackColor,
                                                fontSize: 11,
                                                fontWeight: FontWeight.w400,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  AppText(
                                                      text: recipe.time ??
                                                          'Recipe Name',
                                                      textColor:
                                                          AppColors.blackColor,
                                                      fontSize: 11),
                                                  GestureDetector(
                                                    onTap: () {
                                                      _saveRecipeToBookmarks(
                                                        recipe.name!,
                                                        recipe.image!,
                                                        recipe.time!,
                                                        recipe.rating!,
                                                        recipe.procedure!,
                                                      );
                                                    },
                                                    child: Container(
                                                      width: 30,
                                                      height: 30,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(13),
                                                        color: Colors.white,
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(5.0),
                                                        child: SvgPicture.asset(
                                                            AppAssets
                                                                .bookMarkIcon),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        right: 30,
                                        top: 0,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          child: CachedNetworkImage(
                                            width: 100,
                                            height: 100,
                                            fit: BoxFit.cover,
                                            imageUrl: recipe.image!,
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(Icons.error),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 30,
                                        right: 0,
                                        child: Container(
                                          padding: const EdgeInsets.all(3),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: AppColors.lightOrangeColor,
                                          ),
                                          height: 23,
                                          width: 45,
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              SvgPicture.asset(
                                                  AppAssets.starIcon),
                                              const SizedBox(
                                                width: 3,
                                              ),
                                              AppText(
                                                text: recipe.rating.toString(),
                                                fontWeight: FontWeight.w200,
                                                fontSize: 11,
                                                textColor: Colors.black,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ]),
                                  ),
                                );
                              },
                            ),
                          ),
                        const AppText(
                          text: 'All Recipes',
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          textColor: Colors.black,
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 231,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: controller.recipes.length,
                            itemBuilder: (context, index) {
                              final recipe = controller.recipes[index];
                              return Padding(
                                padding: const EdgeInsets.all(10),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ItemDetailScreen(recipe: recipe),
                                      ),
                                    );
                                  },
                                  child: Stack(children: [
                                    Container(
                                      color: Colors.white,
                                      width: 150,
                                      height: 231,
                                    ),
                                    Positioned(
                                      right: 0,
                                      bottom: 0,
                                      child: Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          color: Colors.grey.shade200,
                                        ),
                                        height: 176,
                                        width: 150,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Center(
                                                child: AppText(
                                              textAlign: TextAlign.center,
                                              text:
                                                  recipe.name ?? 'Recipe Name',
                                              fontSize: 16,
                                              textColor: Colors.black,
                                            )),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            const AppText(
                                              text: 'Time',
                                              textColor: AppColors.blackColor,
                                              fontSize: 11,
                                              fontWeight: FontWeight.w400,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                AppText(
                                                    text: recipe.time ??
                                                        'Recipe Name',
                                                    textColor:
                                                        AppColors.blackColor,
                                                    fontSize: 11),
                                                GestureDetector(
                                                  onTap: () {
                                                    _saveRecipeToBookmarks(
                                                      recipe.name!,
                                                      recipe.image!,
                                                      recipe.time!,
                                                      recipe.rating!,
                                                      recipe.procedure!,
                                                    );
                                                  },
                                                  child: Container(
                                                    width: 30,
                                                    height: 30,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              13),
                                                      color: Colors.white,
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5.0),
                                                      child: SvgPicture.asset(
                                                          AppAssets
                                                              .bookMarkIcon),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      right: 30,
                                      top: 0,
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        child: CachedNetworkImage(
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.cover,
                                          imageUrl: recipe.image!,
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 30,
                                      right: 0,
                                      child: Container(
                                        padding: const EdgeInsets.all(3),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: AppColors.lightOrangeColor,
                                        ),
                                        height: 23,
                                        width: 45,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset(
                                                AppAssets.starIcon),
                                            const SizedBox(
                                              width: 3,
                                            ),
                                            AppText(
                                              text: recipe.rating
                                                      ?.toStringAsFixed(1) ??
                                                  '0.0',
                                              fontWeight: FontWeight.w200,
                                              fontSize: 12,
                                              textColor: Colors.black,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ]),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        const AppText(
                          text: 'New Recipes',
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          textColor: Colors.black,
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                            height: 130,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: controller.recipes.length,
                                itemBuilder: (context, index) {
                                  final recipe = controller.recipes[index];
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: Stack(children: [
                                      Container(
                                          color: Colors.white,
                                          width: 251,
                                          height: 127),
                                      Positioned(
                                        right: 0,
                                        bottom: 0,
                                        child: Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            color: Colors.grey.shade100,
                                          ),
                                          height: 95,
                                          width: 251,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              SizedBox(
                                                width: 150,
                                                child: AppText(
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  textAlign: TextAlign.center,
                                                  text: recipe.name ??
                                                      'Recipe Name',
                                                  fontSize: 14,
                                                  textColor: Colors.black,
                                                ),
                                              ),
                                              RatingBar.builder(
                                                initialRating: 4.5,
                                                minRating: 1,
                                                direction: Axis.horizontal,
                                                allowHalfRating: true,
                                                itemCount: 5,
                                                itemSize: 12,
                                                itemBuilder: (context, _) =>
                                                    const Icon(Icons.star,
                                                        color: Colors.amber),
                                                onRatingUpdate:
                                                    (double value) {},
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    width: 25,
                                                    height: 25,
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              13),
                                                      child: Image.asset(
                                                          AppAssets
                                                              .personImage),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 5),
                                                  const AppText(
                                                    text: 'By Unknown}',
                                                    textColor:
                                                        AppColors.blackColor,
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                  const SizedBox(width: 50),
                                                  AppText(
                                                    text: recipe.time ??
                                                        'Unknown',
                                                    textColor:
                                                        AppColors.blackColor,
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                  const SizedBox(width: 5),
                                                  SvgPicture.asset(
                                                      AppAssets.timerIcon),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        right: 0,
                                        top: 0,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          child: CachedNetworkImage(
                                            width: 80,
                                            height: 80,
                                            fit: BoxFit.cover,
                                            imageUrl: recipe.image!,
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(Icons.error),
                                          ),
                                        ),
                                      ),
                                    ]),
                                  );
                                }))
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
