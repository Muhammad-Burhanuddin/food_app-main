import 'package:get/get.dart';

class ProfileScreencontroller extends GetxController{
  final RxInt _selectedIndex = 0.obs;

  int get selectedIndex => _selectedIndex.value;

  void changeTabIndex(int index) {
    _selectedIndex.value = index;
  }
}