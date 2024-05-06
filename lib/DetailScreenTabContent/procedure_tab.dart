import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:recipe_food/CommenWidget/procedure_container.dart';

import '../AppAssets/app_assets.dart';
import '../CommenWidget/app_text.dart';
import '../Helpers/colors.dart';




class ProcedureTab extends StatefulWidget {
  const ProcedureTab({super.key});

  @override
  State<ProcedureTab> createState() => _ProcedureTabState();
}

class _ProcedureTabState extends State<ProcedureTab> {
  @override
  Widget build(BuildContext context) {
    return  Column(
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
              ProcedureContainer(),
              ProcedureContainer(),
              ProcedureContainer(),
              ProcedureContainer(),
              ProcedureContainer(),
              ProcedureContainer(),
              ProcedureContainer(),
              ProcedureContainer(),
              ProcedureContainer(),
            ],
          ),
        ),
      ],
    );

  }
}
