import 'dart:async';

import 'package:bazario/features/welcome/welcome_screen.dart';
import 'package:bazario/utils/constants/image_strings.dart';
import 'package:flutter/material.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState(){
    super.initState();
    // Wait for 3 seconds, then navigate
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const WelcomeScreen()),
      );
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Image.asset(ImagesUrl.splash_screen,fit: BoxFit.fill,),
    );
  }
}
