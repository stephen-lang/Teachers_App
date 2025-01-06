import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teacherapp_cleanarchitect/features/notes/presentation/pages/Single/Single.dart';
import 'package:teacherapp_cleanarchitect/features/notes/presentation/pages/chat/chat.dart';
import 'package:teacherapp_cleanarchitect/features/notes/presentation/pages/home/dashboard.dart';
import 'package:teacherapp_cleanarchitect/features/notes/presentation/pages/upload/upload.dart';
import '../../controllers/auth_controller.dart';

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  // Retrieve the reactive username from the AuthController
  final authController = Get.find<AuthController>();

  // Dynamically update pages whenever `userName` changes
  List<Widget> get pages => [
        Obx(() => Dash(userName: authController.userName.value)), // Reactive username
        chatpage(),
        const UploadPage(),
        const SinglePage()
        // Add other pages here, using `authController.userName.value` if needed
        // Obx(() => ChatPage(userName: authController.userName.value)),
        // Obx(() => UploadPage(userName: authController.userName.value)),
      ];
}
