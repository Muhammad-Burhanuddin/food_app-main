import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../AppAssets/app_assets.dart';
import '../CommenWidget/custom_text_form_field.dart';
import '../CommenWidget/custom_button.dart';
import '../Helpers/colors.dart';

class AddRecipeScreen extends StatefulWidget {
  const AddRecipeScreen({Key? key}) : super(key: key);

  @override
  State<AddRecipeScreen> createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  // Image file to hold the picked image
  File? _imageFile;

// Function to pick an image from the gallery
  Future<void> _pickImage() async {
    try {
      // Use ImagePicker to select an image
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
        // Call the upload method
        await _uploadRecipeImage();
      }
    } catch (e) {
      print('Error picking image: $e');
      Get.snackbar("Error", "Failed to pick image.");
    }
  } // Ensure you have a variable to store the uploaded image URL

  String? _uploadedImageUrl;

  Future<void> _uploadRecipeImage() async {
    // Ensure the user is authenticated
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Get.snackbar("Error", "You need to log in first!");
      return;
    }

    // Fallback URL
    const fallbackUrl =
        "https://images.immediate.co.uk/production/volatile/sites/30/2020/08/chorizo-mozarella-gnocchi-bake-cropped-9ab73a3.jpg?quality=90&resize=556,505";

    if (_imageFile == null) {
      // Use fallback URL if no image file is selected
      setState(() {
        _uploadedImageUrl = fallbackUrl;
      });
      Get.snackbar("Info", "No image selected, using default image.");
      return;
    }

    try {
      // Generate a unique file name using the current timestamp
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();

      // Create a reference to the Firebase Storage location
      final storageRef =
          FirebaseStorage.instance.ref().child('images/$fileName.jpg');

      // Upload the file
      await storageRef.putFile(_imageFile!);

      // Get the download URL for the uploaded image
      final String downloadUrl = await storageRef.getDownloadURL();

      // Save the download URL in the state
      setState(() {
        _uploadedImageUrl = downloadUrl;
      });

      Get.snackbar("Success", "Image uploaded successfully!");
    } catch (e) {
      print('Error uploading image: $e');

      // Use fallback URL in case of an upload error
      setState(() {
        _uploadedImageUrl = fallbackUrl;
      });
      Get.snackbar("Error", "Failed to upload image, using default image.");
    }
  }

  final TextEditingController nameController = TextEditingController();
  final TextEditingController procedureController = TextEditingController();
  final TextEditingController ratingController = TextEditingController();
  final TextEditingController ratingCountController = TextEditingController();
  final TextEditingController ingredientNameController =
      TextEditingController();
  final TextEditingController ingredientPriceController =
      TextEditingController();
  final TextEditingController ingredientTimeController =
      TextEditingController();
  final RxList<Map<String, String>> ingredients = <Map<String, String>>[].obs;

  void _addRecipe() async {
    final String name = nameController.text.trim();
    final String procedure = procedureController.text.trim();
    final String rating = ratingController.text.trim();
    final String ratingCount = ratingCountController.text.trim();
    final String time = ingredientTimeController.text.trim();

    if (name.isEmpty ||
        procedure.isEmpty ||
        ingredients.isEmpty ||
        time.isEmpty) {
      Get.snackbar(
          "Error", "Please fill all fields and add at least one ingredient.");
      return;
    }

    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      Get.snackbar("Error", "You must be logged in to add a recipe.");
      return;
    }

    final Map<String, dynamic> recipeData = {
      "userId": currentUser.uid,
      "name": name,
      "image": _uploadedImageUrl,
      "procedure": procedure,
      "time": time,
      "rating": double.tryParse(rating) ?? 0.0,
      "ratingCount": int.tryParse(ratingCount) ?? 0,
      "ringredient": ingredients,
    };

    try {
      await FirebaseFirestore.instance.collection('recipes').add(recipeData);
      Get.snackbar("Success", "Recipe added successfully!");
      print("Recipe Data: $recipeData");

      // Clear form fields after saving
      nameController.clear();
      ingredientTimeController.clear();
      procedureController.clear();
      ratingController.clear();
      ratingCountController.clear();
      ingredients.clear();
    } catch (e) {
      Get.snackbar("Error", "Failed to add recipe: $e");
      print("Error saving recipe: $e");
    }
  }

  void _addIngredient() {
    final String ingredientName = ingredientNameController.text.trim();
    final String ingredientPrice = ingredientPriceController.text.trim();

    if (ingredientName.isEmpty || ingredientPrice.isEmpty) {
      Get.snackbar("Error", "Please fill all ingredient fields.");
      return;
    }

    ingredients.add({
      "name": ingredientName,
      "price": ingredientPrice,
    });

    ingredientNameController.clear();
    ingredientPriceController.clear();
    ingredientTimeController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Recipe"),
        backgroundColor: AppColors.primaryColor,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

            // Display the picked image
            if (_imageFile != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Image.file(
                  _imageFile!,
                  height: 150,
                  width: 150,
                  fit: BoxFit.cover,
                ),
              ),
            // Button to pick an image
            CustomButton(
              onTap: _pickImage,
              label: "Pick Image",
              height: 50,
            ),
            const SizedBox(height: 16),

            CustomTextFormField(
              label: "Recipe Name",
              hintText: "Enter recipe name",
              controller: nameController,
            ),
            const SizedBox(height: 16),
            CustomTextFormField(
              label: "Procedure",
              hintText: "Enter cooking procedure",
              controller: procedureController,
            ),
            const SizedBox(height: 16),
            CustomTextFormField(
              label: "Recipe Time",
              hintText: "Enter preparation time (e.g., 15 min)",
              controller: ingredientTimeController,
            ),
            const SizedBox(height: 16),
            const Text("Ingredients",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            CustomTextFormField(
              label: "Ingredient Name",
              hintText: "Enter ingredient name",
              controller: ingredientNameController,
            ),
            const SizedBox(height: 16),
            CustomTextFormField(
              label: "Ingredient Price",
              hintText: "Enter ingredient price (e.g., Rs. 165 p/KG)",
              controller: ingredientPriceController,
            ),
            const SizedBox(height: 16),
            CustomButton(
              onTap: _addIngredient,
              label: "Add Ingredient",
              height: 50,
            ),
            const SizedBox(height: 16),
            Obx(
              () => ingredients.isEmpty
                  ? const Text("No ingredients added yet.")
                  : Column(
                      children: ingredients
                          .map((ingredient) => ListTile(
                                title: Text(ingredient["name"]!),
                                subtitle:
                                    Text("Price: ${ingredient["price"]}, }"),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () =>
                                      ingredients.remove(ingredient),
                                ),
                              ))
                          .toList(),
                    ),
            ),
            const SizedBox(height: 16),
            CustomButton(
              onTap: _addRecipe,
              label: "Save Recipe",
              height: 55,
            ),
          ],
        ),
      ),
    );
  }
}
