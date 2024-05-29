import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recipe_food/AppAssets/app_assets.dart';
import 'package:recipe_food/CommenWidget/app_text.dart';

import '../Helpers/colors.dart';

class IngredientContainer extends StatelessWidget {
  const IngredientContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(bottom: 10),
      width: 315,
      height: 76,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Image.asset(AppAssets.tomato),
          SizedBox(
            width: 10,
          ),
          AppText(
            text: 'Tomatos',
            fontSize: 16,
            textColor: Colors.black,
          ),
          Spacer(),
          AppText(
            text: '500g',
            fontSize: 14,
            textColor: AppColors.greyColor,
          ),
        ],
      ),
    );
  }
}
