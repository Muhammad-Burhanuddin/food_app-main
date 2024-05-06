import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recipe_food/CommenWidget/app_text.dart';

import '../CommenWidget/item_container.dart';
import '../CommenWidget/recipies_container.dart';


class AllTab extends StatelessWidget {
  const AllTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            SizedBox(
              height: 231,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 7,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: ItemContainer(),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            AppText(
              text: 'New Recipes',
              fontWeight: FontWeight.w600,
              fontSize: 16,
              textColor: Colors.black,
            ),
            SizedBox(height: 10),
            SizedBox(
              height: 127,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 7,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: RecipiesContainer(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

