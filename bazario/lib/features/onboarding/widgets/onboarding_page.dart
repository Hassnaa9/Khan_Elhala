import 'package:bazario/utils/constants/colors.dart'; // Make sure this is imported
import 'package:bazario/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

import '../../../utils/constants/texts.dart';

class OnboardingPage extends StatelessWidget {
  final String onboardingImage ;
  const OnboardingPage({super.key, required this.onboardingImage});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height; // Note: This looks like a typo, should be .height
    return
      Padding(
        padding: const EdgeInsets.all(Sizes.defaultSpace+10),
        child: Column(
          children: [
            Image(
              image: AssetImage(onboardingImage),
              width:screenWidth*.784,
              fit: BoxFit.cover,
              alignment: Alignment.center,
            ),
            const SizedBox(height: Sizes.spaceBtwItems,),
            Text(
              TextStrings.onboardingTitle1,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: MyColors.kPrimaryColor,
                fontSize: 36,
                fontFamily: "Galindo"
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Sizes.spaceBtwItems,),
            Text(
              TextStrings.onboardingSubTitle1,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: MyColors.secondaryPrimaryColor,
                fontSize: 16,
                fontFamily: "Inter"
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
  }
}