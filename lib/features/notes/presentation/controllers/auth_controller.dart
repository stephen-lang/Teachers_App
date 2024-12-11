import 'package:get/get.dart';

class AuthController extends GetxController {
  var userName = ''.obs; // Observable username

  void updateUserName(String name) {
    userName.value = name;
    print("Username updated to: $name"); // Debug log
  }
}

