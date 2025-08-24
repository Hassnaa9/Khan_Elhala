import 'package:bazario/user_features/location/location_page_view_body.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';

class LocationPageView extends StatelessWidget {
  const LocationPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      useInheritedMediaQuery: true,
      builder: DevicePreview.appBuilder,
      locale: DevicePreview.locale(context),
      debugShowCheckedModeBanner: false,
      home:  LocationPageViewBody(),
    );
  }
}






