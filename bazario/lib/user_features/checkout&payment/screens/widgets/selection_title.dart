import 'package:flutter/material.dart';

class SelectionTitle extends StatelessWidget {
  SelectionTitle(this.title, {super.key});
  String title;
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'Urbanist',
          ),
        ),
      );
  }
}
