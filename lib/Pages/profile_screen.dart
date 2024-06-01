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
import 'package:recipe_food/ProfileTabContent/tag_tab.dart';
import 'package:recipe_food/ProfileTabContent/vidieo-tab.dart';
import 'package:recipe_food/Helpers/colors.dart';
import 'package:recipe_food/model/user_model.dart';
import 'package:recipe_food/Pages/auth_service.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart';

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

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final bool isTabletScreen = size.width >= 600;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: AppColors.primaryColor,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: AppText(
            text: 'Profile',
            textColor: Colors.white,
            fontSize: 18,
          ),
          actions: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Settings()),
                  );
                },
                child: Icon(
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
              ? Center(child: CircularProgressIndicator())
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
                          decoration: BoxDecoration(shape: BoxShape.circle),
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
                      SizedBox(height: 20),
                      AppText(
                        text: _user!.name ?? 'N/A',
                        textColor: Colors.black,
                        fontSize: 18,
                      ),
                      SizedBox(height: 2),
                      AppText(
                        text: 'Chef',
                        textColor: Colors.grey,
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                      ),
                      SizedBox(height: 10),
                      AppText(
                        text: 'Private Chef \n'
                            'Passionate about food and life 🥘🍲🍝🍱\n'
                            'More...',
                        textColor: Colors.grey,
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                      ),
                      SizedBox(height: 20),
                      Obx(() => Container(
                            width: MediaQuery.of(context).size.width,
                            height: 40,
                            child: TabBar(
                              dividerColor: Colors.transparent,
                              indicator: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Colors.transparent,
                              ),
                              labelPadding: EdgeInsets.symmetric(horizontal: 0),
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
                      SizedBox(height: 10),
                      Expanded(
                        child: Obx(() {
                          switch (controller.selectedIndex) {
                            case 0:
                              return RecipeTab();
                            case 1:
                              return const VideosTab();
                            case 2:
                              return const TagTab();
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
