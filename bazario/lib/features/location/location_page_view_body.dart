import 'package:auto_route/annotations.dart';
import 'package:bazario/features/location/widgets/allow_location_access_button_widget.dart';
import 'package:bazario/features/location/widgets/circle_location_icon_widget.dart';
import 'package:bazario/features/location/widgets/location_subtitle_widget.dart';
import 'package:flutter/material.dart';
@RoutePage()
class LocationPageViewBody extends StatelessWidget {
  const LocationPageViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LocationIconWidget(),
            SizedBox(height: 30),
            Text(
              'What is Your Location?',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
            ),
            SizedBox(height: 10),
            LocationSubtitleWidget(),
            SizedBox(height: 30),
            LocationAccessScreen(),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
