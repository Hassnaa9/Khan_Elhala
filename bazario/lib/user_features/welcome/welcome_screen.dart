import 'package:auto_route/auto_route.dart';
import 'package:bazario/utils/constants/colors.dart';
import 'package:bazario/utils/constants/image_strings.dart';
import 'package:bazario/utils/constants/texts.dart';
import 'package:flutter/material.dart';

import '../../app/app_router.gr.dart';
import '../onboarding/onboarding.dart';
@RoutePage()
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Row(
            children: [
              Column(
                children: [
                  Container(
                  width: screenWidth*.445,
                  height: screenHeight*.529,
                  margin: EdgeInsetsGeometry.directional(start: 20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                    image: DecorationImage(
                      image: AssetImage(ImagesUrl.welcome1),
                      fit: BoxFit.cover, // Use BoxFit.cover for rounded images
                    ),                  ),
                ),
                ]
              ),
              SizedBox(width: 20,),
              Column(
                children: [
                  Container(
                    width: screenWidth*.389,
                    height: screenHeight*.288,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                      image: DecorationImage(
                        image: AssetImage(ImagesUrl.welcome2),
                        fit: BoxFit.cover, // Use BoxFit.cover for rounded images
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                  Container(
                    width: screenWidth*.389,
                    height: screenHeight*.177,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      image: DecorationImage(
                        image: AssetImage(ImagesUrl.welcome3),
                        fit: BoxFit.cover, // Use BoxFit.cover for rounded images
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
          SizedBox(height: 20,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("khan El-hala",
                style: TextStyle(
                    fontFamily: "Galindo",
                    fontSize: 36,
                    color: MyColors.kPrimaryColor
                ),),
              Text(TextStrings.welcomeTitle,
                textAlign: TextAlign.center
              ,style: TextStyle(
                    fontFamily: "Galindo",
                    fontSize: 20,
                    color: MyColors.secondaryPrimaryColor
                ),)
            ],
          ),
          ElevatedButton(
            onPressed: () {
              context.router.push(const OnboardingRoute());
            },
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: MyColors.kPrimaryColor,
              minimumSize: Size(screenWidth*.914, screenHeight * .068),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32)),
              ),
            ),
            child: Text("Let’s Get Started",style: TextStyle(color: Colors.white,
            fontFamily: "Urbanist",
            fontSize: 20),), // Localized
          ),
          SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("already have an account?",
                style: TextStyle(color: Colors.black,
                    fontFamily: "Urbanist",
                    fontSize: 16),),
              TextButton(
                onPressed: ()=> context.router.replace(SignInRoute()),
                child: Text("Sign in",
                  style:  TextStyle(color: MyColors.kPrimaryColor,
                      fontFamily: "Urbanist",
                      fontSize: 16),),
              )
            ],
          )
        ],
      ),
    );
  }
}
