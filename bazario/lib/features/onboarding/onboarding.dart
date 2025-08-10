import 'package:bazario/features/onboarding/controllers/onboarding_controller.dart';
import 'package:bazario/features/onboarding/widgets/onboarding_dot_nav.dart';
import 'package:bazario/features/onboarding/widgets/onboarding_page.dart';
import 'package:bazario/features/onboarding/widgets/onboarding_skip_button.dart';
import 'package:bazario/utils/constants/colors.dart';
import 'package:bazario/utils/constants/image_strings.dart';
import 'package:bazario/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../authentication/screens/signUp_screen.dart'; // Make sure this is the correct path

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnboardingController());

    return Scaffold(
      body: Stack(
        children: [
          // Onboarding Pages
          PageView(
            controller: controller.pageController,
            onPageChanged: controller.updatePageIndicator,
            children: const [
              OnboardingPage(onboardingImage: ImagesUrl.welcome3),
              OnboardingPage(onboardingImage: ImagesUrl.welcome2),
              OnboardingPage(onboardingImage: ImagesUrl.welcome1),
            ],
          ),

          // Skip Button
          const OnboardingSkipButton(),

          // Previous Button
          Obx(
                () => controller.currentPageIndex.value > 0
                ? Positioned(
              left: Sizes.defaultSpace,
              bottom: Sizes.defaultSpace + 40,
              child: ElevatedButton(
                onPressed: () => OnboardingController.instance.prevPage(),
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  elevation: 0,
                  backgroundColor: MyColors.kPrimaryColor,
                ),
                child: Image.asset(
                  ImagesUrl.leftArrow,
                  width: Sizes.iconLg,
                  height: Sizes.iconMd,
                ),
              ),
            )
                : const SizedBox.shrink(),
          ),

          // Dot Navigation
          const OnboardingDotNavigation(),

          // Next Button or Get Started Button
          Obx(
                () => Positioned(
              right: Sizes.defaultSpace,
              bottom: Sizes.defaultSpace + 40,
              child: ElevatedButton(
                onPressed: () {
                  // The action is correctly triggered here
                  if (controller.currentPageIndex.value == 2) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const SignUpScreen()),
                    );
                  } else {
                    OnboardingController.instance.nextPage();
                  }
                },
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  elevation: 0,
                  backgroundColor: Color(0xffD9D9D9),
                ),
                child: Image.asset(
                  controller.currentPageIndex.value == 2
                      ? ImagesUrl.enterArrow // Use a different icon for the last page
                      : ImagesUrl.rightArrow,
                  width: Sizes.iconLg,
                  height: Sizes.iconLg,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}