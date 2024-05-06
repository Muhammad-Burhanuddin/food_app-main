import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:recipe_food/AppAssets/app_assets.dart';
import '../CommenWidget/Ingrediant_container.dart';
import '../CommenWidget/app_text.dart';
import '../Helpers/colors.dart';

class IngridientTab extends StatefulWidget {
  const IngridientTab({Key? key});

  @override
  State<IngridientTab> createState() => _IngridientTabState();
}

class _IngridientTabState extends State<IngridientTab> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            SvgPicture.asset(AppAssets.serveIcon),
            SizedBox(
              width: 5,
            ),
            AppText(
              text: '1 serve',
              fontSize: 11,
              textColor: AppColors.greyColor,
            ),
            Spacer(),
            AppText(
              text: '10 Items',
              fontSize: 11,
              textColor: AppColors.greyColor,
            ),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Expanded(
          child: ListView(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            children: [
              IngredientContainer(),
              IngredientContainer(),
              IngredientContainer(),
              IngredientContainer(),
              IngredientContainer(),
            ],
          ),
        ),
      ],
    );
  }
}
