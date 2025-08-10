import 'package:bazario/features/authentication/screens/signUp_screen.dart';
import 'package:bazario/features/onboarding/controllers/onboarding_controller.dart';
import 'package:bazario/utils/constants/colors.dart';
import 'package:bazario/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class OnboardingSkipButton extends StatelessWidget {
  const OnboardingSkipButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: Sizes.defaultSpace+5,
      right: Sizes.defaultSpace - 10,
      child: TextButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => SignUpScreen()),
          );
        },
        style: TextButton.styleFrom(
          // Set the background color and shape here
          backgroundColor: MyColors.kPrimaryColor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          // Set the text color here
          foregroundColor: Colors.white,
        ),
        child: Text(
          'Skip to sign up direct',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}