import 'package:flutter/material.dart';

class LocationIconWidget extends StatelessWidget {
  const LocationIconWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 120,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xffededed),
      ),
      child: const Center(
        child: Icon(
          Icons.location_on_rounded,
          color: Color(0xff704f38),
          size: 60,
        ),
      ),
    );
  }
}