import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:recipe_food/AppAssets/app_assets.dart';
import 'package:recipe_food/CommenWidget/app_text.dart';
import 'package:recipe_food/CommenWidget/custom_button.dart';
import 'package:recipe_food/DetailScreenTabContent/procedure_tab.dart';
import 'package:recipe_food/model/recepiemodel.dart';
import 'package:recipe_food/routes/route_name.dart';
import '../Controllers/item_detail_screen_controller.dart';
import '../Helpers/colors.dart';

class ItemDetailScreen extends StatefulWidget {
  final Recipe recipe;
  const ItemDetailScreen({super.key, required this.recipe});

  @override
  State<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final containerWidth = screenWidth * 1; // 80% of screen width
    final containerHeight = screenHeight * 0.2; // 20% of screen height
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
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  width: containerWidth,
                  height: containerHeight,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade600,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Opacity(
                          opacity: 0.8,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl: '${widget.recipe.image}',
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            ),
                          )),
                      Positioned(
                        top: containerHeight * 0.07,
                        left: containerWidth * 0.03,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: AppColors.lightOrangeColor,
                              ),
                              height: 23,
                              width: 45,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(AppAssets.starIcon),
                                  SizedBox(
                                    width: 3,
                                  ),
                                  AppText(
                                    text: '4.5',
                                    fontWeight: FontWeight.w200,
                                    fontSize: 11,
                                    textColor: Colors.black,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: containerHeight * 0.35),
                            AppText(
                              text: 'Traditional spare \nribs baked',
                              fontSize: 14,
                            ),
                            Row(
                              children: [
                                AppText(
                                  text: 'By Chef John',
                                  fontSize: 8,
                                  fontWeight: FontWeight.w400,
                                ),
                                SizedBox(width: containerWidth * 0.44),
                                SvgPicture.asset(
                                  AppAssets.timerIcon,
                                  color: Colors.white,
                                ),
                                SizedBox(width: containerWidth * 0.02),
                                AppText(
                                  text:
                                      '${widget.recipe.time ?? 'Recipe time'}',
                                  fontSize: 11,
                                  fontWeight: FontWeight.w400,
                                ),
                                SizedBox(width: containerWidth * 0.02),
                                Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(13),
                                      color: Colors.white,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: SvgPicture.asset(
                                          AppAssets.bookMarkIcon),
                                    )),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppText(
                      text: '${widget.recipe.name ?? 'Recipe name'}',
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
                        return Column(
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset(AppAssets.serveIcon),
                                SizedBox(width: 5),
                                AppText(
                                  text: '1 serve',
                                  fontSize: 11,
                                  textColor: AppColors.greyColor,
                                ),
                                Spacer(),
                                AppText(
                                  text:
                                      '${widget.recipe.ingredients?.length ?? 0} Items',
                                  fontSize: 11,
                                  textColor: AppColors.greyColor,
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Expanded(
                              child: ListView.builder(
                                itemCount:
                                    widget.recipe.ingredients?.length ?? 0,
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, int index) {
                                  final ingredient =
                                      widget.recipe.ingredients?[index];
                                  return Container(
                                    padding: EdgeInsets.all(10),
                                    margin: EdgeInsets.only(bottom: 10),
                                    width: 315,
                                    height: 76,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      children: [
                                        Image.asset(AppAssets.tomato),
                                        SizedBox(width: 10),
                                        AppText(
                                          text: ingredient ?? '',
                                          fontSize: 16,
                                          textColor: Colors.black,
                                        ),
                                        Spacer(),
                                        AppText(
                                          text: '500g',
                                          fontSize: 14,
                                          textColor: AppColors.greyColor,
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        );
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
              unratedColor: Colors
                  .amber, // Set the unratedColor to amber for the border color
              initialRating: _rating,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemSize: 30,
              itemBuilder: (context, index) {
                return Icon(
                  index < _rating.floor() ? Icons.star : Icons.star_border,
                  color: index < _rating.floor()
                      ? Colors.amber
                      : Colors.amber, // Set color to amber for selected icons
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
