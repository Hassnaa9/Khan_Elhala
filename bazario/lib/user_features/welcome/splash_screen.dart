// dart format width=80
import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:bazario/app/app_router.gr.dart';
import 'package:bazario/utils/constants/image_strings.dart';
import 'package:flutter/material.dart';

import '../../utils/constants/colors.dart';

@RoutePage()
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    // Animate the text from the bottom to the center
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1.5), // Start from below the screen
      end: Offset.zero, // End at the center
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );

    // Animate the glow effect
    _glowAnimation = Tween<double>(
      begin: 0.0,
      end: 10.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    // Start the animation and navigate after it's complete
    _controller.forward().then((_) {
      Timer(const Duration(seconds: 4), () {
        context.router.replace(const WelcomeRoute());
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 0, // Hides the app bar
      ),
      body: Column(
        children: [
          Image.asset(
            ImagesUrl.splashScreen,
          ),
          Center(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.translate(
                  offset: _slideAnimation.value * 200, // Multiplier for distance
                  child: Text(
                    'خَان الحَلا',
                    style: TextStyle(
                      fontFamily: 'Khotam',
                      fontSize: 90,
                      fontWeight: FontWeight.bold,
                      color: MyColors.kPrimaryColor,
                      shadows: [
                        Shadow(
                          blurRadius: _glowAnimation.value,
                          color: Colors.white,
                          offset: const Offset(0, 0),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}