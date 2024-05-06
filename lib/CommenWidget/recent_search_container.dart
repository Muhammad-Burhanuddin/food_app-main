import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:recipe_food/AppAssets/app_assets.dart';
import 'package:recipe_food/CommenWidget/app_text.dart';

import '../Helpers/colors.dart';

class RecentSearchContainer extends StatelessWidget {
  const RecentSearchContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Opacity(
            opacity: 0.9, // Set opacity value here (0.0 - 1.0)
            child: Image.asset(
              AppAssets.saveItem,
              fit: BoxFit.contain,
            ),
          ),
          Positioned(
            top: 10,
            left: 40,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerRight,
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
                  ),
                ),
                SizedBox(height: 45,),
                AppText(text: 'Traditional spare \nribs baked',fontSize: 14,),
                Row(
                  children: [
                    AppText(text: 'By Chef John',fontSize: 8,fontWeight: FontWeight.w400,),
                    SizedBox(width: 150,),
                    SvgPicture.asset(AppAssets.timerIcon,color: Colors.white,),
                    AppText(text: '20 mins',fontSize: 11,fontWeight: FontWeight.w400,),
                    SizedBox(width: 5,),
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
        ],
      ),
    );

  }
}
