import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingController extends GetxController {
  static OnboardingController get instance => Get.find();
  // variablese
  final pageController = PageController();
  Rx<int> currentPageIndex = 0.obs; // Reactive variable for the current index
  void updatePageIndicator(int index) => currentPageIndex.value= index;
  void dotNavigationClick(index){
    currentPageIndex.value = index;
    pageController.jumpTo(index); // Navigate to the selected page
  }

  void nextPage(){
    if (currentPageIndex.value < 2) { // Assuming there are 3 pages (0, 1, 2)
      currentPageIndex.value++;
      pageController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else {
      skipPage(); // If on the last page, skip to the next action
    }
  }

  void skipPage() {
    currentPageIndex.value = 2; // Assuming the last page is the one to skip to
    pageController.jumpToPage(2); // Navigate to the last page
    // Logic to skip the onboarding page
    // This could involve navigating to the next screen or updating the state
    Get.offAllNamed(''); // Example navigation to home screen
  }

  void prevPage() {
    if (currentPageIndex.value > 0) { // Assuming there are 3 pages (0, 1, 2)
      currentPageIndex.value--;
      pageController.previousPage(duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else {
      skipPage(); // If on the last page, skip to the next action
    }
  }
}