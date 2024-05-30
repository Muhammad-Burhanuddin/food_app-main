import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:recipe_food/Pages/item_detail_screen.dart';

import '../AppAssets/app_assets.dart';
import '../CommenWidget/app_text.dart';
import '../Helpers/colors.dart';
import '../model/recepiemodel.dart';

class SearchByIngredients extends StatefulWidget {
  const SearchByIngredients({super.key});

  @override
  State<SearchByIngredients> createState() => _SearchByIngredientsState();
}

class _SearchByIngredientsState extends State<SearchByIngredients> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<QuerySnapshot>(
            stream:
                FirebaseFirestore.instance.collection('recipes').snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return CircularProgressIndicator();
                default:
                  return GridView.count(
                      scrollDirection: Axis.vertical,
                      crossAxisCount: 2,
                      children: List.generate(
                        snapshot.data!.docs.length,
                        (index) {
                          DocumentSnapshot doc = snapshot.data!.docs[index];
                          final data = doc.data() as Map<String, dynamic>;
                          Recipe recipe = Recipe(
                            image: data['image'] as String?,
                            name: data['name'] as String?,
                            procedure: data['procedure'] as String?,
                            ingredients: (data['ringredient'] as List<dynamic>?)
                                ?.map((item) => Ingredient.fromMap(
                                    item as Map<String, dynamic>))
                                .toList(),
                            time: data['time'] as String?,
                          );
                          return Padding(
                            padding: const EdgeInsets.all(10),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ItemDetailScreen(recipe: recipe)),
                                );
                              },
                              child: Stack(children: [
                                Positioned(
                                  right: 0,
                                  top: 50,
                                  left: 0,
                                  bottom: 0,
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.grey.shade200,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Center(
                                            child: AppText(
                                          textAlign: TextAlign.center,
                                          text: recipe.name ?? 'Recipe Name',
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
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            AppText(
                                                text: recipe.time ??
                                                    'Recipe Name',
                                                textColor: AppColors.blackColor,
                                                fontSize: 11),
                                            Container(
                                                width: 20,
                                                height: 20,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(13),
                                                  color: Colors.white,
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(2.0),
                                                  child: SvgPicture.asset(
                                                      AppAssets.bookMarkIcon),
                                                )),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                    right: 50,
                                    top: 0,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: CachedNetworkImage(
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                        imageUrl: recipe.image!,
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                      ),
                                    )
                                    // : Image.asset(
                                    //     AppAssets.foodImage,
                                    //     width: 150,
                                    //     height: 110,
                                    //   ),
                                    ),
                                Positioned(
                                    top: 30,
                                    right: 20,
                                    child: Container(
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
                                    )),
                              ]),
                            ),
                          );
                        },
                      ));
              }
            }));
  }
}
