
import 'package:get/get.dart';

class SignUpController extends GetxController{

  RxBool isChecked = false.obs;
  void check(){

    isChecked.value = !isChecked.value;
  }
}