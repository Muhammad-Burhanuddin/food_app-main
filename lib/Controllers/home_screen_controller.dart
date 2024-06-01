import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipe_food/CommenWidget/app_text.dart';
import 'package:recipe_food/CommenWidget/custom_button.dart';
import '../Helpers/colors.dart';
import '../model/recepiemodel.dart';

class HomeScreenController extends GetxController {
  final RxInt _selectedIndex = 0.obs;

  int get selectedIndex => _selectedIndex.value;

  void changeTabIndex(int index) {
    _selectedIndex.value = index;
  }

  // Selected ingredients list
  RxList<RxBool> selectedIngredients = <RxBool>[].obs;

  // Observable list for ingredients fetched from Firestore
  final RxList<String> ingredients = <String>[].obs;

  // Observable list for recipes fetched from Firestore
  final RxList<Recipe> recipes = <Recipe>[].obs;

  // Observable list for filtered recipes
  final RxList<Recipe> filteredRecipes = <Recipe>[].obs;

  // Firestore collection references
  final CollectionReference _ingredientsRef =
      FirebaseFirestore.instance.collection('ingredients');
  final CollectionReference _recipesRef =
      FirebaseFirestore.instance.collection('recipes');

  @override
  void onInit() {
    super.onInit();
    getIngredients();
    getRecipes();
  }

  // Fetch ingredients from Firestore
  Future<void> getIngredients() async {
    try {
      QuerySnapshot querySnapshot = await _ingredientsRef.get();
      final allData = querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      // Assuming your ingredients data has a 'name' field
      ingredients.value =
          allData.map((ingredient) => ingredient['name'] as String).toList();

      // Initialize selectedIngredients list with the same length as ingredients
      selectedIngredients.value =
          List.generate(ingredients.length, (index) => false.obs);
    } catch (e) {
      print("Error getting ingredients: $e");
    }
  }

  // Fetch recipes from Firestore
  void getRecipes() {
    try {
      _recipesRef.snapshots().listen((querySnapshot) {
        final allData =
            querySnapshot.docs.map((doc) => Recipe.fromFirestore(doc)).toList();
        recipes.value = allData;
        filteredRecipes.value = allData;
      });
    } catch (e) {
      print("Error getting recipes: $e");
    }
  }

  // Toggle ingredient selection
  void toggleSelection(int index) {
    selectedIngredients[index].value = !selectedIngredients[index].value;
    update();
  }

  // Apply filter based on selected ingredients
  void applyFilter() {
    final selected = ingredients
        .where((ingredient) =>
            selectedIngredients[ingredients.indexOf(ingredient)].value)
        .toList();
    if (selected.isEmpty) {
      filteredRecipes.value = recipes;
    } else {
      filteredRecipes.value = recipes.where((recipe) {
        return recipe.ingredients!
            .any((ingredient) => selected.contains(ingredient.name));
      }).toList();
    }
    print("Selected Ingredients: $selected");
    update();
  }

  // Show filter bottom sheet
  void showForgetPasswordBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
            height: 500,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                    child: AppText(
                  text: 'Filter Search',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  textColor: Colors.black,
                )),
                SizedBox(height: 10),
                AppText(
                  textAlign: TextAlign.left,
                  text: 'Ingredients',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  textColor: Colors.black,
                ),
                SizedBox(height: 5),
                Obx(() {
                  return Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: List.generate(
                      ingredients.length,
                      (index) => CustomButton(
                        backgroundColor: selectedIngredients[index].value
                            ? AppColors.primaryColor
                            : Colors.transparent,
                        textColor: selectedIngredients[index].value
                            ? Colors.white
                            : AppColors.primaryColor,
                        borderWidth: 1,
                        onTap: () {
                          toggleSelection(index);
                        },
                        fontSize: 11,
                        label: ingredients[index],
                        height: 34,
                        width: 65,
                        borderColor: selectedIngredients[index].value
                            ? Colors.transparent
                            : AppColors.primaryColor,
                      ),
                    ),
                  );
                }),
                SizedBox(height: 10),
                Spacer(),
                Center(
                  child: CustomButton(
                    label: 'Filter',
                    height: 37,
                    width: 174,
                    onTap: () {
                      applyFilter();
                      Navigator.pop(context);
                    },
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }
}
