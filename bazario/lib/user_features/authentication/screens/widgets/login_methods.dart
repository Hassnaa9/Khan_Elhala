import 'package:bazario/user_features/authentication/screens/widgets/social_signin_button.dart';
import 'package:bazario/utils/constants/image_strings.dart';
import 'package:flutter/material.dart';


class login_methods extends StatelessWidget {
  final double screenWidth, screenHeight;
  final VoidCallback? onGoogleTap; // Callback for Google login
  final VoidCallback? onFacebookTap; // Callback for Facebook login

  const login_methods({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
    this.onGoogleTap,
    this.onFacebookTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: SocialSignInButton(
            iconPath: ImagesUrl.facebookIcon,
            width: screenWidth * .6,
            onPressed: onFacebookTap ?? () {}, // Use Facebook callback
          ),
        ),
        Expanded(
          child: SocialSignInButton(
            iconPath: ImagesUrl.googleIcon,
            width: screenWidth * .6,
            onPressed: onGoogleTap ?? () {}, // Use Google callback
          ),
        ),
        Expanded(
          child: SocialSignInButton(
            iconPath: ImagesUrl.appleIcon,
            width: screenWidth * .6,
            onPressed: () {
              // Apple sign-in action (not implemented here)
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Apple Sign-In not implemented')),
              );
            },
          ),
        ),
      ],
    );
  }
}