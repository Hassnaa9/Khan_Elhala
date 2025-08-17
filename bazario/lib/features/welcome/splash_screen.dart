// dart format width=80
import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:bazario/app/app_router.gr.dart';
import 'package:bazario/utils/constants/image_strings.dart';
import 'package:flutter/material.dart';

@RoutePage()
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 5), () {
      context.router.replace(const WelcomeRoute());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            ImagesUrl.splashScreen,
            fit: BoxFit.fill,
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height / 4,
            left: MediaQuery.of(context).size.width / 4,
            child: Text(
              'خَان الحَلا',
              style: TextStyle(
                fontFamily: 'Khotam',
                fontSize: 80,
                fontWeight: FontWeight.bold,
                color: Colors.brown.shade800,
                shadows: [
                  Shadow(
                    blurRadius: 5.0,
                    color: Colors.black.withOpacity(0.3),
                    offset: const Offset(2.0, 2.0),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}