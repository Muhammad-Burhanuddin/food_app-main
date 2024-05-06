import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:recipe_food/AppAssets/app_assets.dart';
import 'package:recipe_food/CommenWidget/app_text.dart';
import 'package:recipe_food/Helpers/colors.dart';

class ItemContainer extends StatelessWidget {
  const ItemContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        color: Colors.white,
        width: 150,
        height: 231,
      ),
      Positioned(
        right: 0,
        bottom: 0,
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey.shade200,
          ),
          height: 176,
          width: 150,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Center(child: AppText(textAlign: TextAlign.center,text: 'Classic Greek \n Salad',fontSize: 14,textColor: Colors.black,)),
              SizedBox(height: 5,),
              AppText(text: 'Time',textColor: AppColors.blackColor,fontSize: 11,fontWeight: FontWeight.w400,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText(text: '15 Mins',textColor: AppColors.blackColor,fontSize: 11),
                Container(
                  width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(13),
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: SvgPicture.asset(AppAssets.bookMarkIcon),
                    )),
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
          AppAssets.foodImage,
          width: 150,
          height: 110,
        ),
      ),
      Positioned(
          top: 30,
          right: 0,
          child: Container(
            padding: EdgeInsets.all(3),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: AppColors.lightOrangeColor,
            ),
            height: 23,
            width: 45,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(AppAssets.starIcon),
                SizedBox(width: 3,),
                AppText(text: '4.5',fontWeight: FontWeight.w200,fontSize: 11,textColor: Colors.black,),
              ],
            ),
          )),
    ]);
  }
}
