// dart format width=80
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../data/repositories/home_provider.dart';

class CategoryList extends StatelessWidget {
  const CategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    // Access the categories from the HomeProvider
    final categories = Provider.of<HomeProvider>(context).categories;

    return SizedBox(
      height: 90,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: categories.map((category) {
          return Column(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Color(0xffD9A9A9),
                child: Image.asset(category.icon,),
              ),
              const SizedBox(height: 5),
              Text(category.name,style: TextStyle(fontSize: 14,fontFamily: "Urbanist"),),
            ],
          );
        }).toList(),
      ),
    );
  }
}