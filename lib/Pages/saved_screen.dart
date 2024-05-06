import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipe_food/CommenWidget/app_text.dart';
import 'package:recipe_food/CommenWidget/saved_container.dart';
import 'package:recipe_food/routes/route_name.dart';

class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: AppText(
            text: 'Saved Recipies',
            fontSize: 18,
            textColor: Colors.black,
          ),
          centerTitle: true,
        ),
        body: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
            itemCount: 7,
            itemBuilder: (index, context) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GestureDetector(
                onTap: (){
                  Get.toNamed(RouteName.itemDetailScreen);
                },
                child: SavedContainer()),
          );
        }));
  }
}
