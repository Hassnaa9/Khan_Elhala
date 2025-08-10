import 'package:bazario/features/onboarding/controllers/onboarding_controller.dart';
import 'package:bazario/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';


class OnboardingDotNavigation extends StatelessWidget {
  const OnboardingDotNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = OnboardingController.instance;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return Positioned(
        bottom: screenHeight*.1,
        left: screenWidth*.4,
        child: SmoothPageIndicator(controller: controller.pageController,onDotClicked: controller.dotNavigationClick, count: 3,effect: ExpandingDotsEffect(activeDotColor: dark? MyColors.light : MyColors.dark,dotHeight: 6),));
  }
}