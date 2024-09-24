// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';
// import 'package:recipe_food/AppAssets/app_assets.dart';
// import 'package:recipe_food/CommenWidget/app_text.dart';
// import 'package:recipe_food/CommenWidget/recent_search_container.dart';
// import 'package:speech_to_text/speech_to_text.dart' as stt;
// import 'package:translator/translator.dart';
// import '../Controllers/home_screen_controller.dart';
// import '../Helpers/colors.dart';
// import '../model/recepiemodel.dart';
// import 'item_detail_screen.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   final List<String> dishType = [
//     "All",
//     "Breakfast",
//     "Lunch",
//     'Dinner',
//     "Desserts"
//   ];
//   final HomeScreenController controller = Get.put(HomeScreenController());
//   final TextEditingController _searchController = TextEditingController();
//   bool _isSearchFocused = false;
//   double _rating = 0;
//   late stt.SpeechToText _speech;
//   bool _isListening = false;
//   final translator = GoogleTranslator();

//   @override
//   void initState() {
//     super.initState();
//     _speech = stt.SpeechToText();
//   }

//   void _listen() async {
//     if (!_isListening) {
//       bool available = await _speech.initialize(
//         onStatus: (val) => print('onStatus: $val'),
//         onError: (val) => print('onError: $val'),
//       );
//       if (available) {
//         setState(() => _isListening = true);
//         _speech.listen(
//           onResult: (val) async {
//             String translatedText = await _translateText(val.recognizedWords);
//             _searchController.text = translatedText;
//             _searchRecipes(translatedText);
//             setState(() => _isListening = false);
//             _speech.stop();
//           },
//         );
//       }
//     } else {
//       setState(() => _isListening = false);
//       _speech.stop();
//     }
//   }

//   Future<String> _translateText(String text) async {
//     final translation = await translator.translate(text, from: 'ur', to: 'en');
//     return translation.text;
//   }

//   void _searchRecipes(String query) {
//     final filteredRecipes = controller.recipes.where((recipe) {
//       return recipe.name!.toLowerCase().contains(query.toLowerCase()) ||
//           recipe.ingredients!.any((ingredient) =>
//               ingredient.name!.toLowerCase().contains(query.toLowerCase()));
//     }).toList();
//     controller.filteredRecipes.value = filteredRecipes;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final Size size = MediaQuery.of(context).size;
//     final bool isTabletScreen = size.width >= 600;
//     return DefaultTabController(
//       length: 5,
//       child: Scaffold(
//         resizeToAvoidBottomInset: false,
//         backgroundColor: Colors.white,
//         body: SafeArea(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(vertical: 20),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(left: 7),
//                   child: ListTile(
//                     title: AppText(
//                       text: 'Hello Fola',
//                       textColor: Colors.black,
//                       fontSize: 20,
//                     ),
//                     subtitle: AppText(
//                       text: 'What are you cooking today?',
//                       textColor: Colors.black,
//                       fontSize: 11,
//                       fontWeight: FontWeight.w400,
//                     ),
//                     trailing: Container(
//                       width: 45,
//                       height: 45,
//                       decoration: BoxDecoration(
//                         color: AppColors.orangeColor,
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: Image.asset(AppAssets.profileIcon),
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 20,
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 20),
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.end,
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Expanded(
//                         child: GestureDetector(
//                           onTap: () {
//                             setState(() {
//                               _isSearchFocused = true;
//                             });
//                           },
//                           child: Container(
//                             height: 45,
//                             padding: const EdgeInsets.symmetric(horizontal: 10),
//                             decoration: BoxDecoration(
//                               color: Colors.grey.shade100,
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             child: Row(
//                               children: [
//                                 Icon(
//                                   Icons.search,
//                                   color: Colors.grey,
//                                 ),
//                                 SizedBox(width: 10),
//                                 Expanded(
//                                   child: TextFormField(
//                                     cursorColor: Colors.grey,
//                                     controller: _searchController,
//                                     decoration: InputDecoration(
//                                       hintText: 'Search',
//                                       border: InputBorder.none,
//                                     ),
//                                     onTap: () {
//                                       setState(() {
//                                         _isSearchFocused = true;
//                                       });
//                                     },
//                                     onChanged: (value) {
//                                       _searchRecipes(value);
//                                     },
//                                     onSaved: (value) {
//                                       _searchRecipes(value!);
//                                     },
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         width: 20,
//                       ),
//                       GestureDetector(
//                         onTap: _listen,
//                         child: Container(
//                             height: 45,
//                             width: 45,
//                             decoration: BoxDecoration(
//                               color: AppColors.primaryColor,
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             child: Icon(
//                                 _isListening ? Icons.mic : Icons.mic_none)),
//                       )
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: 30),
//                 Obx(() {
//                   return Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         SizedBox(height: 10),
//                         SizedBox(
//                           height: 231,
//                           child: ListView.builder(
//                             scrollDirection: Axis.horizontal,
//                             itemCount: controller.filteredRecipes.length,
//                             itemBuilder: (context, index) {
//                               final recipe = controller.filteredRecipes[index];
//                               return Padding(
//                                 padding: const EdgeInsets.all(10),
//                                 child: InkWell(
//                                   onTap: () {
//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (context) =>
//                                             ItemDetailScreen(recipe: recipe),
//                                       ),
//                                     );
//                                   },
//                                   child: Stack(children: [
//                                     Container(
//                                       color: Colors.white,
//                                       width: 150,
//                                       height: 231,
//                                     ),
//                                     Positioned(
//                                       right: 0,
//                                       bottom: 0,
//                                       child: Container(
//                                         padding: const EdgeInsets.all(10),
//                                         decoration: BoxDecoration(
//                                           borderRadius:
//                                               BorderRadius.circular(12),
//                                           color: Colors.grey.shade200,
//                                         ),
//                                         height: 176,
//                                         width: 150,
//                                         child: Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.end,
//                                           children: [
//                                             Center(
//                                                 child: AppText(
//                                               textAlign: TextAlign.center,
//                                               text:
//                                                   recipe.name ?? 'Recipe Name',
//                                               fontSize: 16,
//                                               textColor: Colors.black,
//                                             )),
//                                             SizedBox(
//                                               height: 5,
//                                             ),
//                                             AppText(
//                                               text: 'Time',
//                                               textColor: AppColors.blackColor,
//                                               fontSize: 11,
//                                               fontWeight: FontWeight.w400,
//                                             ),
//                                             Row(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment
//                                                       .spaceBetween,
//                                               children: [
//                                                 AppText(
//                                                     text: recipe.time ??
//                                                         'Recipe Name',
//                                                     textColor:
//                                                         AppColors.blackColor,
//                                                     fontSize: 11),
//                                                 Container(
//                                                   width: 20,
//                                                   height: 20,
//                                                   decoration: BoxDecoration(
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                             13),
//                                                     color: Colors.white,
//                                                   ),
//                                                   child: Padding(
//                                                     padding:
//                                                         const EdgeInsets.all(
//                                                             2.0),
//                                                     child: SvgPicture.asset(
//                                                         AppAssets.bookMarkIcon),
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                     Positioned(
//                                       right: 30,
//                                       top: 0,
//                                       child: ClipRRect(
//                                         borderRadius:
//                                             BorderRadius.circular(100),
//                                         child: CachedNetworkImage(
//                                           width: 100,
//                                           height: 100,
//                                           fit: BoxFit.cover,
//                                           imageUrl: recipe.image!,
//                                           errorWidget: (context, url, error) =>
//                                               Icon(Icons.error),
//                                         ),
//                                       ),
//                                     ),
//                                     Positioned(
//                                       top: 30,
//                                       right: 0,
//                                       child: Container(
//                                         padding: EdgeInsets.all(3),
//                                         decoration: BoxDecoration(
//                                           borderRadius:
//                                               BorderRadius.circular(20),
//                                           color: AppColors.lightOrangeColor,
//                                         ),
//                                         height: 23,
//                                         width: 45,
//                                         child: Row(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.center,
//                                           children: [
//                                             SvgPicture.asset(
//                                                 AppAssets.starIcon),
//                                             SizedBox(
//                                               width: 3,
//                                             ),
//                                             AppText(
//                                               text: '4.5',
//                                               fontWeight: FontWeight.w200,
//                                               fontSize: 11,
//                                               textColor: Colors.black,
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                   ]),
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 }),
//                 SizedBox(height: 20),
// AnimatedSwitcher(
//   duration: Duration(milliseconds: 300),
//   child: _isSearchFocused
//       ? Column(
//           children: [
//             Container(
//               padding: EdgeInsets.symmetric(horizontal: 20),
//               height: 40,
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: Text(
//                       'Recent Searches',
//                       style: TextStyle(
//                           fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                   IconButton(
//                     icon: Icon(Icons.clear),
//                     onPressed: () {
//                       setState(() {
//                         _isSearchFocused = false;
//                         _searchController.clear();
//                       });
//                     },
//                   )
//                 ],
//               ),
//             ),
//             ListView.builder(
//                 shrinkWrap: true,
//                 itemCount: 2,
//                 itemBuilder: (index, context) {
//                   return RecentSearchContainer();
//                 }),
//           ],
//         )
//       : Obx(
//           () => Container(
//             padding: EdgeInsets.symmetric(horizontal: 10),
//             height: 40,
//             child: TabBar(
//               // isScrollable: true,
//               dividerColor: Colors.transparent,
//               indicator: BoxDecoration(
//                 borderRadius: BorderRadius.circular(50),
//                 color: Colors.transparent,
//               ),
//               labelPadding: EdgeInsets.symmetric(horizontal: 0),
//               onTap: (index) {
//                 controller.changeTabIndex(index);
//               },
//               tabs: dishType.map<Widget>((type) {
//                 return Tab(
//                   child: Material(
//                     color: Colors.transparent,
//                     child: InkWell(
//                       splashColor: Colors.transparent,
//                       highlightColor: Colors.transparent,
//                       onTap: () {
//                         controller.changeTabIndex(
//                             dishType.indexOf(type));
//                       },
//                       child: Container(
//                         height: 35,
//                         padding: const EdgeInsets.all(2),
//                         width: isTabletScreen
//                             ? MediaQuery.of(context).size.width
//                             : 60,
//                         decoration: BoxDecoration(
//                           color: controller.selectedIndex ==
//                                   dishType.indexOf(type)
//                               ? AppColors.primaryColor
//                               : Colors.white,
//                           borderRadius:
//                               BorderRadius.circular(10),
//                         ),
//                         child: Align(
//                           alignment: Alignment.center,
//                           child: Text(
//                             type,
//                             style: Theme.of(context)
//                                 .textTheme
//                                 .titleLarge!
//                                 .merge(
//                                   TextStyle(
//                                     color: controller
//                                                 .selectedIndex ==
//                                             dishType
//                                                 .indexOf(type)
//                                         ? Colors.white
//                                         : AppColors
//                                             .primaryColor,
//                                     fontWeight: FontWeight.w600,
//                                     fontSize: isTabletScreen
//                                         ? 20
//                                         : 12,
//                                   ),
//                                 ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 );
//               }).toList(),
//             ),
//           ),
//         ),
// ),
//                 StreamBuilder<QuerySnapshot>(
//                   stream: FirebaseFirestore.instance
//                       .collection('recipes')
//                       .snapshots(),
//                   builder: (BuildContext context,
//                       AsyncSnapshot<QuerySnapshot> snapshot) {
//                     if (snapshot.hasError) {
//                       return Text('Error: ${snapshot.error}');
//                     }
//                     switch (snapshot.connectionState) {
//                       case ConnectionState.waiting:
//                         return CircularProgressIndicator();
//                       default:
//                         return Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               SizedBox(height: 10),
//                               SizedBox(
//                                   height: 231,
//                                   child: ListView.builder(
//                                       scrollDirection: Axis.horizontal,
//                                       itemCount: snapshot.data!.docs.length,
//                                       itemBuilder: (context, index) {
//                                         DocumentSnapshot doc =
//                                             snapshot.data!.docs[index];
//                                         final data =
//                                             doc.data() as Map<String, dynamic>;
//                                         Recipe recipe = Recipe(
//                                           image: data['image'] as String?,
//                                           name: data['name'] as String?,
//                                           procedure:
//                                               data['procedure'] as String?,
//                                           ingredients: (data['ringredient']
//                                                   as List<dynamic>?)
//                                               ?.map((item) =>
//                                                   Ingredient.fromMap(item
//                                                       as Map<String, dynamic>))
//                                               .toList(),
//                                           time: data['time'] as String?,
//                                         );
//                                         return Padding(
//                                           padding: const EdgeInsets.all(10),
//                                           child: InkWell(
//                                             onTap: () {
//                                               Navigator.push(
//                                                 context,
//                                                 MaterialPageRoute(
//                                                     builder: (context) =>
//                                                         ItemDetailScreen(
//                                                             recipe: recipe)),
//                                               );
//                                             },
//                                             child: Stack(children: [
//                                               Container(
//                                                 color: Colors.white,
//                                                 width: 150,
//                                                 height: 231,
//                                               ),
//                                               Positioned(
//                                                 right: 0,
//                                                 bottom: 0,
//                                                 child: Container(
//                                                   padding:
//                                                       const EdgeInsets.all(10),
//                                                   decoration: BoxDecoration(
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                             12),
//                                                     color: Colors.grey.shade200,
//                                                   ),
//                                                   height: 176,
//                                                   width: 150,
//                                                   child: Column(
//                                                     crossAxisAlignment:
//                                                         CrossAxisAlignment
//                                                             .start,
//                                                     mainAxisAlignment:
//                                                         MainAxisAlignment.end,
//                                                     children: [
//                                                       Center(
//                                                           child: AppText(
//                                                         textAlign:
//                                                             TextAlign.center,
//                                                         text: recipe.name ??
//                                                             'Recipe Name',
//                                                         fontSize: 16,
//                                                         textColor: Colors.black,
//                                                       )),
//                                                       SizedBox(
//                                                         height: 5,
//                                                       ),
//                                                       AppText(
//                                                         text: 'Time',
//                                                         textColor: AppColors
//                                                             .blackColor,
//                                                         fontSize: 11,
//                                                         fontWeight:
//                                                             FontWeight.w400,
//                                                       ),
//                                                       Row(
//                                                         mainAxisAlignment:
//                                                             MainAxisAlignment
//                                                                 .spaceBetween,
//                                                         children: [
//                                                           AppText(
//                                                               text: recipe
//                                                                       .time ??
//                                                                   'Recipe Name',
//                                                               textColor: AppColors
//                                                                   .blackColor,
//                                                               fontSize: 11),
//                                                           Container(
//                                                               width: 20,
//                                                               height: 20,
//                                                               decoration:
//                                                                   BoxDecoration(
//                                                                 borderRadius:
//                                                                     BorderRadius
//                                                                         .circular(
//                                                                             13),
//                                                                 color: Colors
//                                                                     .white,
//                                                               ),
//                                                               child: Padding(
//                                                                 padding:
//                                                                     const EdgeInsets
//                                                                         .all(
//                                                                         2.0),
//                                                                 child: SvgPicture
//                                                                     .asset(AppAssets
//                                                                         .bookMarkIcon),
//                                                               )),
//                                                         ],
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                               ),
//                                               Positioned(
//                                                   right: 30,
//                                                   top: 0,
//                                                   child: ClipRRect(
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                             100),
//                                                     child: CachedNetworkImage(
//                                                       width: 100,
//                                                       height: 100,
//                                                       fit: BoxFit.cover,
//                                                       imageUrl: recipe.image!,
//                                                       errorWidget: (context,
//                                                               url, error) =>
//                                                           Icon(Icons.error),
//                                                     ),
//                                                   )
//                                                   // : Image.asset(
//                                                   //     AppAssets.foodImage,
//                                                   //     width: 150,
//                                                   //     height: 110,
//                                                   //   ),
//                                                   ),
//                                               Positioned(
//                                                   top: 30,
//                                                   right: 0,
//                                                   child: Container(
//                                                     padding: EdgeInsets.all(3),
//                                                     decoration: BoxDecoration(
//                                                       borderRadius:
//                                                           BorderRadius.circular(
//                                                               20),
//                                                       color: AppColors
//                                                           .lightOrangeColor,
//                                                     ),
//                                                     height: 23,
//                                                     width: 45,
//                                                     child: Row(
//                                                       crossAxisAlignment:
//                                                           CrossAxisAlignment
//                                                               .center,
//                                                       children: [
//                                                         SvgPicture.asset(
//                                                             AppAssets.starIcon),
//                                                         SizedBox(
//                                                           width: 3,
//                                                         ),
//                                                         AppText(
//                                                           text: '4.5',
//                                                           fontWeight:
//                                                               FontWeight.w200,
//                                                           fontSize: 11,
//                                                           textColor:
//                                                               Colors.black,
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   )),
//                                             ]),
//                                           ),
//                                         );
//                                       })),
//                               SizedBox(height: 20),
//                               AppText(
//                                 text: 'New Recipes',
//                                 fontWeight: FontWeight.w600,
//                                 fontSize: 16,
//                                 textColor: Colors.black,
//                               ),
//                               SizedBox(height: 10),
//                               SizedBox(
//                                   height: 127,
//                                   child: ListView.builder(
//                                       scrollDirection: Axis.horizontal,
//                                       itemCount: 7,
//                                       itemBuilder: (context, index) {
//                                         return Padding(
//                                             padding: const EdgeInsets.only(
//                                                 right: 10),
//                                             child: Stack(children: [
//                                               Container(
//                                                 color: Colors.white,
//                                                 width: 251,
//                                                 height: 127,
//                                               ),
//                                               Positioned(
//                                                 right: 0,
//                                                 bottom: 0,
//                                                 child: Container(
//                                                   padding: EdgeInsets.all(10),
//                                                   decoration: BoxDecoration(
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                             12),
//                                                     color: Colors.grey.shade100,
//                                                   ),
//                                                   height: 95,
//                                                   width: 251,
//                                                   child: Column(
//                                                     crossAxisAlignment:
//                                                         CrossAxisAlignment
//                                                             .start,
//                                                     mainAxisAlignment:
//                                                         MainAxisAlignment
//                                                             .spaceBetween,
//                                                     children: [
//                                                       AppText(
//                                                         textAlign:
//                                                             TextAlign.center,
//                                                         text:
//                                                             'Steak with tomato..',
//                                                         fontSize: 14,
//                                                         textColor: Colors.black,
//                                                       ),
//                                                       RatingBar.builder(
//                                                         initialRating: _rating,
//                                                         minRating: 1,
//                                                         direction:
//                                                             Axis.horizontal,
//                                                         allowHalfRating: true,
//                                                         itemCount: 5,
//                                                         itemSize: 12,
//                                                         itemBuilder:
//                                                             (context, _) =>
//                                                                 Icon(
//                                                           Icons.star,
//                                                           color: Colors.amber,
//                                                         ),
//                                                         onRatingUpdate:
//                                                             (double value) {},
//                                                         // onRatingUpdate: (rating) {
//                                                         //   setState(() {
//                                                         //     _rating = rating;
//                                                         //   });
//                                                         // },
//                                                       ),
//                                                       Row(
//                                                         mainAxisAlignment:
//                                                             MainAxisAlignment
//                                                                 .center,
//                                                         children: [
//                                                           Container(
//                                                             width: 25,
//                                                             height: 25,
//                                                             child: ClipRRect(
//                                                               borderRadius:
//                                                                   BorderRadius
//                                                                       .circular(
//                                                                           13),
//                                                               child: Image.asset(
//                                                                   AppAssets
//                                                                       .personImage),
//                                                             ),
//                                                           ),
//                                                           SizedBox(
//                                                             width: 5,
//                                                           ),
//                                                           AppText(
//                                                             text:
//                                                                 'By James Milner',
//                                                             textColor: AppColors
//                                                                 .blackColor,
//                                                             fontSize: 11,
//                                                             fontWeight:
//                                                                 FontWeight.w400,
//                                                           ),
//                                                           SizedBox(
//                                                             width: 50,
//                                                           ),
//                                                           AppText(
//                                                             text: '20 mins',
//                                                             textColor: AppColors
//                                                                 .blackColor,
//                                                             fontSize: 11,
//                                                             fontWeight:
//                                                                 FontWeight.w400,
//                                                           ),
//                                                           SizedBox(
//                                                             width: 5,
//                                                           ),
//                                                           SvgPicture.asset(
//                                                               AppAssets
//                                                                   .timerIcon),
//                                                         ],
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                               ),
//                                               Positioned(
//                                                 right: 0,
//                                                 top: 0,
//                                                 child: Image.asset(
//                                                   AppAssets.recipiesImage,
//                                                   width: 105,
//                                                   height: 94,
//                                                 ),
//                                               ),
//                                             ]));
//                                       }))
//                             ],
//                           ),
//                         );
//                     }
//                   },
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:recipe_food/AppAssets/app_assets.dart';
import 'package:recipe_food/CommenWidget/app_text.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:translator/translator.dart';
import '../Controllers/home_screen_controller.dart';
import '../Helpers/colors.dart';
import 'item_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> dishType = [
    "All",
    "Breakfast",
    "Lunch",
    'Dinner',
    "Desserts"
  ];
  final HomeScreenController controller = Get.put(HomeScreenController());
  final TextEditingController _searchController = TextEditingController();
  bool _isSearchFocused = false;
  double _rating = 0;
  late stt.SpeechToText _speech;
  bool _isListening = false;
  final translator = GoogleTranslator();

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
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
            String translatedText = await _translateText(val.recognizedWords);
            _searchController.text = translatedText;
            _searchRecipes(translatedText);
            setState(() => _isListening = false);
            _speech.stop();
          },
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  Future<String> _translateText(String text) async {
    final translation = await translator.translate(text, from: 'ur', to: 'en');
    return translation.text;
  }

  void _searchRecipes(String query) {
    final filteredRecipes = controller.recipes.where((recipe) {
      return recipe.name!.toLowerCase().contains(query.toLowerCase()) ||
          recipe.ingredients!.any((ingredient) =>
              ingredient.name!.toLowerCase().contains(query.toLowerCase()));
    }).toList();
    controller.filteredRecipes.value = filteredRecipes;
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final bool isTabletScreen = size.width >= 600;
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 7),
                  child: ListTile(
                    title: AppText(
                      text: 'Hello Fola',
                      textColor: Colors.black,
                      fontSize: 20,
                    ),
                    subtitle: AppText(
                      text: 'What are you cooking today?',
                      textColor: Colors.black,
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                    ),
                    trailing: Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        color: AppColors.orangeColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Image.asset(AppAssets.profileIcon),
                    ),
                  ),
                ),
                SizedBox(
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
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.search,
                                  color: Colors.grey,
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: TextFormField(
                                    cursorColor: Colors.grey,
                                    controller: _searchController,
                                    decoration: InputDecoration(
                                      hintText: 'Search',
                                      border: InputBorder.none,
                                    ),
                                    onTap: () {
                                      setState(() {
                                        _isSearchFocused = true;
                                      });
                                    },
                                    onChanged: (value) {
                                      _searchRecipes(value);
                                    },
                                    onSaved: (value) {
                                      _searchRecipes(value!);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
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
                SizedBox(height: 30),
                Obx(() {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10),
                        SizedBox(
                          height: 231,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: controller.filteredRecipes.length,
                            itemBuilder: (context, index) {
                              final recipe = controller.filteredRecipes[index];
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
                                            SizedBox(
                                              height: 5,
                                            ),
                                            AppText(
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
                                                Container(
                                                  width: 20,
                                                  height: 20,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            13),
                                                    color: Colors.white,
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            2.0),
                                                    child: SvgPicture.asset(
                                                        AppAssets.bookMarkIcon),
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
                                              Icon(Icons.error),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 30,
                                      right: 0,
                                      child: Container(
                                        padding: EdgeInsets.all(3),
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
                                    ),
                                  ]),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                SizedBox(height: 20),
                AppText(
                  text: 'New Recipes',
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  textColor: Colors.black,
                ),
                SizedBox(height: 10),
                SizedBox(
                    height: 127,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 7,
                        itemBuilder: (context, index) {
                          return Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Stack(children: [
                                Container(
                                  color: Colors.white,
                                  width: 251,
                                  height: 127,
                                ),
                                Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
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
                                        AppText(
                                          textAlign: TextAlign.center,
                                          text: 'Steak with tomato..',
                                          fontSize: 14,
                                          textColor: Colors.black,
                                        ),
                                        RatingBar.builder(
                                          initialRating: _rating,
                                          minRating: 1,
                                          direction: Axis.horizontal,
                                          allowHalfRating: true,
                                          itemCount: 5,
                                          itemSize: 12,
                                          itemBuilder: (context, _) => Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                          ),
                                          onRatingUpdate: (double value) {},
                                          // onRatingUpdate: (rating) {
                                          //   setState(() {
                                          //     _rating = rating;
                                          //   });
                                          // },
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
                                                    BorderRadius.circular(13),
                                                child: Image.asset(
                                                    AppAssets.personImage),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            AppText(
                                              text: 'By James Milner',
                                              textColor: AppColors.blackColor,
                                              fontSize: 11,
                                              fontWeight: FontWeight.w400,
                                            ),
                                            SizedBox(
                                              width: 50,
                                            ),
                                            AppText(
                                              text: '20 mins',
                                              textColor: AppColors.blackColor,
                                              fontSize: 11,
                                              fontWeight: FontWeight.w400,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
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
                                  child: Image.asset(
                                    AppAssets.recipiesImage,
                                    width: 105,
                                    height: 94,
                                  ),
                                ),
                              ]));
                        }))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
  // bool _isSearchFocused = false;
  // final double _rating = 0;
  // late stt.SpeechToText _speech;
  // bool _isListening = false;
  // final translator = GoogleTranslator();

  // @override
  // void initState() {
  //   super.initState();
  //   _speech = stt.SpeechToText();
  // }

  // void _listen() async {
  //   if (!_isListening) {
  //     bool available = await _speech.initialize(
  //       onStatus: (val) => print('onStatus: $val'),
  //       onError: (val) => print('onError: $val'),
  //     );
  //     if (available) {
  //       setState(() => _isListening = true);
  //       _speech.listen(
  //         onResult: (val) async {
  //           String recognizedText = val.recognizedWords;
  //           String translatedText = await _translateText(recognizedText);
  //           _searchController.text = translatedText;
  //           _searchRecipes(translatedText);
  //           setState(() => _isListening = false);
  //           _speech.stop();
  //         },
  //       );
  //     }
  //   } else {
  //     setState(() => _isListening = false);
  //     _speech.stop();
  //   }
  // }

  // Future<String> _translateText(String text) async {
  //   // Basic heuristic to detect if the text contains Urdu script
  //   bool isUrdu = RegExp(r'[\u0600-\u06FF]').hasMatch(text);
  //   if (isUrdu) {
  //     final translation =
  //         await translator.translate(text, from: 'ur', to: 'en');
  //     return translation.text;
  //   }
  //   return text; // Return the original text if it's not in Urdu
  // }

  // void _searchRecipes(String query) {
  //   final filteredRecipes = controller.recipes.where((recipe) {
  //     return recipe.name!.toLowerCase().contains(query.toLowerCase()) ||
  //         recipe.ingredients!.any((ingredient) =>
  //             ingredient.name!.toLowerCase().contains(query.toLowerCase()));
  //   }).toList();
  //   controller.filteredRecipes.value = filteredRecipes;
  // }
// 
  // bool _isSearchFocused = false;
  // double _rating = 0;
  // late stt.SpeechToText _speech;
  // bool _isListening = false;
  // final translator = GoogleTranslator();

  // @override
  // void initState() {
  //   super.initState();
  //   _speech = stt.SpeechToText();
  // }

  // void _listen() async {
  //   if (!_isListening) {
  //     bool available = await _speech.initialize(
  //       onStatus: (val) => print('onStatus: $val'),
  //       onError: (val) => print('onError: $val'),
  //     );
  //     if (available) {
  //       setState(() => _isListening = true);
  //       _speech.listen(
  //         onResult: (val) async {
  //           String translatedText = await _translateText(val.recognizedWords);
  //           _searchController.text = translatedText;
  //           _searchRecipes(translatedText);
  //           setState(() => _isListening = false);
  //           _speech.stop();
  //         },
  //       );
  //     }
  //   } else {
  //     setState(() => _isListening = false);
  //     _speech.stop();
  //   }
  // }

  // Future<String> _translateText(String text) async {
  //   final translation = await translator.translate(text, from: 'ur', to: 'en');
  //   return translation.text;
  // }

  // void _searchRecipes(String query) {
  //   final filteredRecipes = controller.recipes.where((recipe) {
  //     return recipe.name!.toLowerCase().contains(query.toLowerCase()) ||
  //         recipe.ingredients!.any((ingredient) =>
  //             ingredient.name!.toLowerCase().contains(query.toLowerCase()));
  //   }).toList();
  //   controller.filteredRecipes.value = filteredRecipes;
  // }
