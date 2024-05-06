import 'package:flutter/material.dart';
import 'package:recipe_food/CommenWidget/app_text.dart';
import 'package:recipe_food/CommenWidget/custom_button.dart';

import '../AppAssets/app_assets.dart';
import '../Helpers/colors.dart';

class ReviewsContainer extends StatelessWidget {
  const ReviewsContainer({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      height: 94,
      width: 313,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 31,
                width: 31,
                decoration: BoxDecoration(
                    shape: BoxShape.circle
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(AppAssets.profilePhoto,fit: BoxFit.cover,),
                ),
              ),
              SizedBox(width: 10,),
              Column(
                children: [
                  AppText(text: 'Bella Throne',fontSize: 11,textColor: Colors.black,),
                  AppText(text: 'Bella Throne',fontSize: 8,textColor: AppColors.greyColor,fontWeight: FontWeight.w400,),
                ],
              ),
            ],
          ),
          SizedBox(height: 5,),
          AppText(text: 'Lorem Ipsum tempor incididunt ut labore et dolore,inise voluptate velit esse cillum',fontSize: 11,textColor: Colors.black54,),
          SizedBox(height: 5,),
          Row(
            children: [
              CustomButton(backgroundColor:Colors.tealAccent.shade700,label: '👍 9',textColor:Colors.black,width: 29,height: 18,fontSize: 8,),
              SizedBox(width: 5,),
              CustomButton(backgroundColor:Colors.teal.shade100,label: '👎 1',textColor:Colors.black,width: 29,height: 18,fontSize: 8,),

            ],
          )
        ],
      ),
    );
  }
}
