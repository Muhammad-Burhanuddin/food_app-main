import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recipe_food/AppAssets/app_assets.dart';
import 'package:recipe_food/CommenWidget/app_text.dart';
import 'package:recipe_food/Controllers/profile_screen_controller.dart';
import 'package:recipe_food/Pages/settings.dart';
import 'package:recipe_food/ProfileTabContent/recipe_tab.dart';
import 'package:recipe_food/Helpers/colors.dart';
import 'package:recipe_food/model/user_model.dart';
import 'package:recipe_food/Pages/auth_service.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileScreencontroller controller = Get.put(ProfileScreencontroller());
  final AuthService _authService = AuthService();
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
      }
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

    return DefaultTabController(
      length: 3,
      child: Scaffold(
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
                    MaterialPageRoute(builder: (context) => const Settings()),
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
        body: Padding(
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
                      Obx(() => SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: 40,
                            child: TabBar(
                              dividerColor: Colors.transparent,
                              indicator: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Colors.transparent,
                              ),
                              labelPadding:
                                  const EdgeInsets.symmetric(horizontal: 0),
                              onTap: (index) {
                                controller.changeTabIndex(index);
                              },
                              tabs: profileType.map<Widget>((type) {
                                return Tab(
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      splashColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () {
                                        controller.changeTabIndex(
                                            profileType.indexOf(type));
                                      },
                                      child: Container(
                                        height: 35,
                                        padding: const EdgeInsets.all(2),
                                        width: isTabletScreen
                                            ? MediaQuery.of(context).size.width
                                            : 95,
                                        decoration: BoxDecoration(
                                          color: controller.selectedIndex ==
                                                  profileType.indexOf(type)
                                              ? AppColors.primaryColor
                                              : Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            type,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge!
                                                .merge(
                                                  TextStyle(
                                                    color: controller
                                                                .selectedIndex ==
                                                            profileType
                                                                .indexOf(type)
                                                        ? Colors.white
                                                        : AppColors
                                                            .primaryColor,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: isTabletScreen
                                                        ? 20
                                                        : 12,
                                                  ),
                                                ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          )),
                      const SizedBox(height: 10),
                      Expanded(
                        child: Obx(() {
                          switch (controller.selectedIndex) {
                            case 0:
                              return const RecipeTab();
                            case 1:
                              return const RecipeTab();
                            case 2:
                              return const RecipeTab();
                            default:
                              return const SizedBox.shrink();
                          }
                        }),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
