import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import '../AppAssets/app_assets.dart';
import '../CommenWidget/app_text.dart';
import '../Helpers/colors.dart';
import '../Pages/item_detail_screen.dart';
import '../model/recepiemodel.dart';

class AllTab extends StatelessWidget {
  final double _rating = 0;

  const AllTab({super.key});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('recipes').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const CircularProgressIndicator();
          default:
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    SizedBox(
                        height: 231,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              DocumentSnapshot doc = snapshot.data!.docs[index];
                              final data = doc.data() as Map<String, dynamic>;
                              Recipe recipe = Recipe(
                                image: data['image'] as String?,
                                name: data['name'] as String?,
                                procedure: data['procedure'] as String?,
                                ingredients:
                                    (data['ringredient'] as List<dynamic>?)
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
                                                          AppAssets
                                                              .bookMarkIcon),
                                                    )),
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
                                        )
                                        // : Image.asset(
                                        //     AppAssets.foodImage,
                                        //     width: 150,
                                        //     height: 110,
                                        //   ),
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
                                              const AppText(
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
                            })),
                    const SizedBox(height: 20),
                    const AppText(
                      text: 'New Recipes',
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      textColor: Colors.black,
                    ),
                    const SizedBox(height: 10),
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
                                            const AppText(
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
                                              itemBuilder: (context, _) =>
                                                  const Icon(
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
                                                SizedBox(
                                                  width: 25,
                                                  height: 25,
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            13),
                                                    child: Image.asset(
                                                        AppAssets.personImage),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                const AppText(
                                                  text: 'By James Milner',
                                                  textColor:
                                                      AppColors.blackColor,
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                                const SizedBox(
                                                  width: 50,
                                                ),
                                                const AppText(
                                                  text: '20 mins',
                                                  textColor:
                                                      AppColors.blackColor,
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                                const SizedBox(
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
            );
        }
      },
    );
  }
}
