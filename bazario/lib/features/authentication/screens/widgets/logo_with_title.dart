import 'package:flutter/material.dart';


class LogoWithTitle extends StatelessWidget {
  final String title, subText;
  final List<Widget> children;

  const LogoWithTitle({
    super.key,
    required this.title,
    this.subText = '',
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SafeArea(
        child:SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
          child: Column(
            children: [
              SizedBox(height: size.height * 0.04),
              Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: size.height * 0.02),
                child: Text(
                  subText,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    height: size.height*.002,
                    color: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .color!
                        .withOpacity(0.84),
                  ),
                ),
              ),
              SizedBox(height: size.height*.02,),
              ...children,
            ],
          ),
        )
    );
  }
}