import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:recipe_food/AppAssets/app_assets.dart';
import 'package:recipe_food/CommenWidget/app_text.dart';
import 'package:recipe_food/CommenWidget/custom_button.dart';
import 'package:recipe_food/DetailScreenTabContent/Ingrident_tab.dart';
import 'package:recipe_food/DetailScreenTabContent/procedure_tab.dart';
import 'package:recipe_food/routes/route_name.dart';

import '../CommenWidget/saved_container.dart';
import '../Controllers/item_detail_screen_controller.dart';
import '../Helpers/colors.dart';

class ItemDetailScreen extends StatefulWidget {
  const ItemDetailScreen({super.key});

  @override
  State<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final ItemDetailScreenController controller =
        Get.put(ItemDetailScreenController());
    List<String> DetailType = ["Ingrident", "Procedure"];
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: GestureDetector(
                onTap: () {
                  _showPopupMenu(context);
                },
                child: Icon(
                  Icons.more_horiz_rounded,
                ),
              ),
            )
          ],
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                SavedContainer(),
                SizedBox(
                  height: 10,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppText(
                      text: 'Spicy chicken burger with\nFrench fries',
                      textColor: Colors.black,
                      fontSize: 16,
                    ),
                    AppText(
                      text: '(13k Reviews)',
                      textColor: AppColors.greyColor,
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(shape: BoxShape.circle),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          AppAssets.profilePhoto,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppText(
                          text: 'Laura wilson',
                          fontSize: 14,
                          textColor: Colors.black,
                        ),
                        Row(
                          children: [
                            SvgPicture.asset(AppAssets.locationIcon),
                            SizedBox(
                              width: 5,
                            ),
                            AppText(
                              text: 'Lagos, Nigeria',
                              fontSize: 11,
                              textColor: AppColors.greyColor,
                            ),
                          ],
                        ),
                      ],
                    ),
                    Spacer(),
                    CustomButton(
                      label: 'Follow',
                      width: 85,
                      height: 37,
                      fontSize: 11,
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Obx(() => Container(
                      width: MediaQuery.of(context).size.width,
                      height: 40,
                      child: TabBar(
                        // isScrollable: true,
                        dividerColor: Colors.transparent,
                        indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.transparent,
                        ),
                        labelPadding: EdgeInsets.symmetric(horizontal: 0),
                        onTap: (index) {
                          controller.changeTabIndex(index);
                        },
                        tabs: DetailType.map<Widget>((type) {
                          return Tab(
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () {
                                  controller
                                      .changeTabIndex(DetailType.indexOf(type));
                                },
                                child: Container(
                                  height: 35,
                                  padding: const EdgeInsets.all(2),
                                  width: MediaQuery.of(context).size.width * .5,
                                  decoration: BoxDecoration(
                                    color: controller.selectedIndex ==
                                            DetailType.indexOf(type)
                                        ? AppColors.primaryColor
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(10),
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
                                              color: controller.selectedIndex ==
                                                      DetailType.indexOf(type)
                                                  ? Colors.white
                                                  : AppColors.primaryColor,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12,
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
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: Obx(() {
                    switch (controller.selectedIndex) {
                      case 0:
                        return IngridientTab();
                      case 1:
                        return const ProcedureTab();
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

  void _showPopupMenu(BuildContext context) {
    final RenderBox overlay =
        Overlay.of(context)!.context.findRenderObject() as RenderBox;
    final double paddingFromTop = kToolbarHeight + 20;
    final double paddingFromRight = kToolbarHeight + 70;
    final Offset offset = Offset(
      MediaQuery.of(context).size.width - 70 - paddingFromRight,
      paddingFromTop,
    );
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy,
        offset.dx + 70,
        offset.dy + 70,
      ),
      items: [
        PopupMenuItem(
          child: Row(
            children: [
              SvgPicture.asset(AppAssets.shareIcon),
              SizedBox(
                width: 10,
              ),
              Text('Share'),
            ],
          ),
          onTap: () {
            _showShareDialog(context);
          },
        ),

        PopupMenuItem(
          child: Row(
            children: [
              SvgPicture.asset(AppAssets.rateRecipeIcon),
              SizedBox(
                width: 10,
              ),
              Text('Rate Recipe'),
            ],
          ),
          onTap: () {
            _showRateDialog(context);
          },
        ),
        PopupMenuItem(
          child: Row(
            children: [
              SvgPicture.asset(AppAssets.messageIcon),
              SizedBox(
                width: 10,
              ),
              Text('Review'),
            ],
          ),
          onTap: () {
            Get.toNamed(RouteName.reviewsScreen);
          },
        ),
        PopupMenuItem(
          child: Row(
            children: [
              SvgPicture.asset(AppAssets.unsavedIcon),
              SizedBox(
                width: 10,
              ),
              Text('Unsave'),
            ],
          ),
          onTap: () {
            // Handle Option 2
          },
        ),
        // Add more PopupMenuItems as needed
      ],
    );
  }

  void _showShareDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        title: AppText(
          text: 'Recipe Link ',
          textColor: Colors.black,
          fontSize: 20,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              text:
                  'Copy recipe link and share your recipe link with friends and family.',
              fontWeight: FontWeight.w400,
              textColor: AppColors.greyColor,
              fontSize: 11,
            ),
            SizedBox(height: 10),
            Container(
              width: 280,
              height: 43,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Row(
                  children: [
                    SizedBox(
                      width: 7,
                    ),
                    AppText(
                      text: 'app.Recipe.co/jollof_rice',
                      textColor: Colors.black,
                    ),
                    Spacer(),
                    Container(
                      height: 43,
                      width: 50,
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: AppText(
                          text: 'Copy',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showRateDialog(BuildContext context) {
    double _rating = 0;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        title: AppText(
          textAlign: TextAlign.center,
          text: 'Rate recipe',
          textColor: Colors.black,
          fontSize: 20,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RatingBar.builder(
              unratedColor: Colors.amber, // Set the unratedColor to amber for the border color
              initialRating: _rating,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemSize: 30,
              itemBuilder: (context, index) {
                return Icon(
                  index < _rating.floor()
                      ? Icons.star
                      : Icons.star_border,
                  color: index < _rating.floor() ? Colors.amber : Colors.amber, // Set color to amber for selected icons
                );
              },
              onRatingUpdate: (rating) {
                setState(() {
                  _rating = rating;
                });
              },
            ),

            SizedBox(height: 20),
            CustomButton(
              onTap: () {
                Navigator.pop(context);
              },
              backgroundColor: Colors.amber,
              label: 'Send',
              width: 70,
              height: 35,
              fontSize: 12,
            ),
          ],
        ),
      ),
    );
  }
}
