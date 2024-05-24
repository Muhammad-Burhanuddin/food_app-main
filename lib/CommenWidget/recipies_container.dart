import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:recipe_food/AppAssets/app_assets.dart';
import 'package:recipe_food/CommenWidget/app_text.dart';
import 'package:recipe_food/Helpers/colors.dart';

class RecipiesContainer extends StatefulWidget {
  const RecipiesContainer({super.key, required String recipeName});

  @override
  State<RecipiesContainer> createState() => _RecipiesContainerState();
}

class _RecipiesContainerState extends State<RecipiesContainer> {
  double _rating = 0;
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
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
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                onRatingUpdate: (rating) {
                  setState(() {
                    _rating = rating;
                  });
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 25,
                    height: 25,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(13),
                      child: Image.asset(AppAssets.personImage),
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
                  SvgPicture.asset(AppAssets.timerIcon),
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
    ]);
  }
}
