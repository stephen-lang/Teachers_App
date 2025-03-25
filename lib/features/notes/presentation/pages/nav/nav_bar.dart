import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'NavigationController.dart';

class NavigationMenu extends StatelessWidget {
 
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController( ));

    return Scaffold(
      body: Obx(() => controller.pages[controller.selectedIndex.value]),
      bottomNavigationBar: Obx(
        () => NavigationBar(
          height: 80,
          elevation: 0,
          surfaceTintColor: Colors.blue,
          indicatorColor: Colors.blue,
          backgroundColor:
              const Color.fromARGB(255, 225, 235, 248).withOpacity(0.21),
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home), label: "Home"),
            NavigationDestination(icon: Icon(Icons.chat_bubble), label: "Chat"),
            NavigationDestination(
                icon: Icon(Icons.upload_file), label: "Upload"),
            NavigationDestination(
                icon: Icon(Icons.inbox_rounded), label: "Entry"),
          ],
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: (newIndex) {
            controller.selectedIndex.value = newIndex;
          },
        ),
      ),
    );
  }
}
/*
class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;
 
  // Retrieve the reactive username from the AuthController
  final authController = Get.find<AuthController>();

  late final pages = [
    Dash(userName: authController.userName.value), // Pass `userName` to the Dash page
    // Add other pages here, ensuring each can use `userName` if needed
   //Homepage(),
    //const UploadPage(),
   // const SinglePage(),
  ];
}
*/

