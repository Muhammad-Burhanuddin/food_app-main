import 'package:flutter/material.dart';

import 'package:recipe_food/CommenWidget/app_text.dart';

import '../Helpers/colors.dart';


class ProcedureContainer extends StatelessWidget {
  const ProcedureContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 15,vertical: 15),
    margin: EdgeInsets.only(bottom: 10),
    width: 315,
    decoration: BoxDecoration(
    color: Colors.grey.shade200,
    borderRadius: BorderRadius.circular(10),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(text: 'Step 1',fontSize: 16,textColor: Colors.black,),
        SizedBox(height: 5,),
        AppText(text: 'Lorem Ipsum tempor incididunt ut labore et dolore,in voluptate velit esse cillum dolore eu fugiat nulla pariatur?',fontSize: 14,textColor: AppColors.greyColor,),

      ],
    ),
    );
  }
}
