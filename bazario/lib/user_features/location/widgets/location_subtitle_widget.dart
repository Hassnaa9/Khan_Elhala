import 'package:flutter/material.dart';
import 'package:flutter_auto_size_text/flutter_auto_size_text.dart';

class LocationSubtitleWidget extends StatelessWidget {
  const LocationSubtitleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.0),
      child: AutoSizeText(
        "We need to know your location in order_list.dart to suggest nearby services.",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 14,
          color: Color(0xffa9a9a9),
          fontWeight: FontWeight.w600,
        ),
        maxLines: 2,
        minFontSize: 10,
      ),
    );
  }
}
