import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recipe_food/AppAssets/app_assets.dart';
import 'package:recipe_food/CommenWidget/app_text.dart';
import 'package:recipe_food/Controllers/profile_screen_controller.dart';
import 'package:recipe_food/Pages/add_recipes.dart';
import 'package:recipe_food/Pages/item_detail_screen.dart';
import 'package:recipe_food/Pages/settings.dart' as recipe_food_settings;
import 'package:recipe_food/Helpers/colors.dart';
import 'package:recipe_food/model/recepiemodel.dart';
import 'package:recipe_food/model/user_model.dart';
import 'package:recipe_food/Pages/auth_service.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../CommenWidget/custom_button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileScreencontroller controller = Get.put(ProfileScreencontroller());
  final AuthService _authService = AuthService();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Recipe> _userRecipes = [];
  UserModel? _user;
  File? _imageFile;
  final List<String> profileType = ["Recipe", "Videos", "Tag"];

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final User? currentUser = _authService.getCurrentUser();
    if (currentUser != null) {
      final UserModel? user =
          await _authService.fetchUserDetails(currentUser.uid);
      if (user != null) {
        setState(() {
          _user = user;
        });
        _fetchUserRecipes(
            currentUser.uid); // Fetch recipes for the current user
      }
    }
  }

  Future<void> _fetchUserRecipes(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('recipes')
          .where('userId', isEqualTo: userId)
          .get();

      print('Fetched ${snapshot.docs.length} recipes'); // Debugging line
      final recipes = snapshot.docs.map((doc) {
        return Recipe.fromFirestore(doc);
      }).toList();

      setState(() {
        _userRecipes = recipes;
      });
    } catch (e) {
      print('Error fetching recipes: $e');
    }
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
        _uploadProfilePicture();
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future<void> _uploadProfilePicture() async {
    if (_imageFile == null) return;

    try {
      final firebase_storage.Reference storageRef = firebase_storage
          .FirebaseStorage.instance
          .ref()
          .child('profile_pictures/${_user!.userId}');
      await storageRef.putFile(_imageFile!);
      final String downloadUrl = await storageRef.getDownloadURL();
      await _authService.updateUserProfilePicture(_user!.userId!, downloadUrl);
      setState(() {
        _user!.imageUrl = downloadUrl;
      });
    } catch (e) {
      print('Error uploading profile picture: $e');
    }
  }

  void _showEditDialog() {
    if (_user == null) {
      // Handle the case where _user is null
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User data is not available")),
      );
      return;
    }

    TextEditingController nameController =
        TextEditingController(text: _user!.name);
    TextEditingController bioController =
        TextEditingController(text: _user!.bio);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Profile"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Name"),
              ),
              TextField(
                controller: bioController,
                decoration: const InputDecoration(labelText: "Bio"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                String updatedName = nameController.text.trim();
                String updatedBio = bioController.text.trim();

                await _authService.updateUserProfile(
                    _user!.userId!, updatedName, updatedBio);

                setState(() {
                  _user!.name = updatedName;
                  _user!.bio = updatedBio;
                });

                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final bool isTabletScreen = size.width >= 600;

    final user = _authService.getCurrentUser;
    if (user == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final containerWidth = screenWidth * 1; // 80% of screen width
    final containerHeight = screenHeight * 0.2; // 20% of screen height
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const AppText(
          text: 'Profile',
          textColor: Colors.white,
          fontSize: 18,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const recipe_food_settings.Settings()),
                );
              },
              child: const Icon(
                Icons.more_horiz_outlined,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: _user == null
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          height: 150,
                          width: 150,
                          decoration:
                              const BoxDecoration(shape: BoxShape.circle),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Image.network(
                              _user!.imageUrl ?? AppAssets.profilePhoto,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  AppAssets.profilePhoto,
                                  fit: BoxFit.cover,
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AppText(
                            text: _user!.name ?? 'N/A',
                            textColor: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.grey),
                            onPressed: _showEditDialog,
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      AppText(
                        text: _user!.bio ?? 'Bio',
                        textColor: Colors.grey,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomButton(
                            width: 200,
                            label: 'Add New Recipe',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const AddRecipeScreen()),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _userRecipes.isEmpty
                          ? const Center(child: Text('No recipes available'))
                          : Container(
                              height: screenHeight * 0.4,
                              child: ListView.builder(
                                itemCount: _userRecipes.length,
                                itemBuilder: (context, index) {
                                  final recipe = _userRecipes[index];
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        // Navigate to recipe detail page
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ItemDetailScreen(
                                                    recipe: recipe),
                                          ),
                                        );
                                      },
                                      child: Card(
                                        elevation: 4,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(20),
                                          child: Row(
                                            children: [
                                              CachedNetworkImage(
                                                imageUrl: recipe.image!,
                                                width: 80,
                                                height: 80,
                                                fit: BoxFit.cover,
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const Icon(Icons.error),
                                              ),
                                              const SizedBox(width: 10),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      recipe.name!,
                                                      style: const TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    const SizedBox(height: 5),
                                                    Text(
                                                      'Time: ${recipe.time}',
                                                      style: const TextStyle(
                                                          fontSize: 12),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
