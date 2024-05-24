import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipe_food/AppAssets/app_assets.dart';
import 'package:recipe_food/CommenWidget/app_text.dart';
import 'package:recipe_food/CommenWidget/recent_search_container.dart';
import '../Controllers/home_screen_controller.dart';
import '../Helpers/colors.dart';
import '../HomeTabContent/all_tab.dart';
import '../HomeTabContent/asian_tab.dart';
import '../HomeTabContent/chines_tab.dart';
import '../HomeTabContent/indian_tab.dart';
import '../HomeTabContent/italian_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> dishType = [
    "All",
    "Breakfast",
    "Lunch",
    'Dinner',
    "Desserts"
  ];
  final HomeScreenController controller = Get.put(HomeScreenController());
  final TextEditingController _searchController = TextEditingController();
  bool _isSearchFocused = false;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final bool isTabletScreen = size.width >= 600;
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 7),
                  child: ListTile(
                    title: AppText(
                      text: 'Hello Fola',
                      textColor: Colors.black,
                      fontSize: 20,
                    ),
                    subtitle: AppText(
                      text: 'What are you cooking today?',
                      textColor: Colors.black,
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                    ),
                    trailing: Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        color: AppColors.orangeColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Image.asset(AppAssets.profileIcon),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _isSearchFocused = true;
                            });
                          },
                          child: Container(
                            height: 45,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.search,
                                  color: Colors.grey,
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: TextFormField(
                                    cursorColor: Colors.grey,
                                    controller: _searchController,
                                    decoration: InputDecoration(
                                      hintText: 'Search',
                                      border: InputBorder.none,
                                    ),
                                    onTap: () {
                                      setState(() {
                                        _isSearchFocused = true;
                                      });
                                    },
                                    onChanged: (value) {
                                      // Perform search functionality here
                                    },
                                    onSaved: (value) {
                                      // Perform search functionality here
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          controller.showForgetPasswordBottomSheet(context);
                        },
                        child: Container(
                          height: 45,
                          width: 45,
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Image.asset(AppAssets.filterIcon),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 30),
                AnimatedSwitcher(
                  duration: Duration(milliseconds: 300),
                  child: _isSearchFocused
                      ? Column(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              height: 40,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Recent Searches',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.clear),
                                    onPressed: () {
                                      setState(() {
                                        _isSearchFocused = false;
                                        _searchController.clear();
                                      });
                                    },
                                  )
                                ],
                              ),
                            ),
                            ListView.builder(
                                shrinkWrap: true,
                                itemCount: 2,
                                itemBuilder: (index, context) {
                                  return RecentSearchContainer();
                                }),
                          ],
                        )
                      : Obx(
                          () => Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
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
                              tabs: dishType.map<Widget>((type) {
                                return Tab(
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      splashColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () {
                                        controller.changeTabIndex(
                                            dishType.indexOf(type));
                                      },
                                      child: Container(
                                        height: 35,
                                        padding: const EdgeInsets.all(2),
                                        width: isTabletScreen
                                            ? MediaQuery.of(context).size.width
                                            : 60,
                                        decoration: BoxDecoration(
                                          color: controller.selectedIndex ==
                                                  dishType.indexOf(type)
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
                                                            dishType
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
                          ),
                        ),
                ),
                _isSearchFocused
                    ? Center()
                    : Expanded(
                        child: Obx(() {
                          switch (controller.selectedIndex) {
                            case 0:
                              return AllTab();
                            case 1:
                              return const IndianTab();
                            case 2:
                              return const ItalianTab();
                            case 3:
                              return const chinesTab();
                            case 4:
                              return const AsianTab();
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
