// dart format width=80
import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bazario/features/home/screens/widgets/product_cart.dart';
import 'package:bazario/utils/constants/colors.dart';

import '../../../data/repositories/home_provider.dart';

@RoutePage()
class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  // Widget for Wishlist Filters
  Widget _buildWishlistFilters(BuildContext context) {
    // Assuming your HomeProvider has a list of filters and a selected index
    final homeProvider = Provider.of<HomeProvider>(context);
    final filters = ['All', 'Jacket', 'Shirt', 'Pant', 'T-Shirt'];
    return SizedBox(
      height: .04 * MediaQuery.of(context).size.height,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          // Use a state management solution (e.g., Provider) to manage selection
          // final isSelected = homeProvider.selectedWishlistFilterIndex == index;
          final isSelected = index == 0; // Placeholder for now
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: ChoiceChip(
              label: Text(
                filter,
                style: const TextStyle(
                    fontFamily: "Urbanist",
                    fontSize: 15,
                    fontWeight: FontWeight.w600),
              ),
              selected: isSelected,
              onSelected: (selected) {
                // TODO: Implement selection logic for filtering
              },
              selectedColor: MyColors.kPrimaryColor,
              labelStyle: TextStyle(
                  color: isSelected ? Colors.white : Colors.black87),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Assuming HomeProvider has a 'wishlistProducts' getter
    // that returns a list of favorite products.
    final products = Provider.of<HomeProvider>(context).products; // Use products as placeholder

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('My Wishlist'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15),
              _buildWishlistFilters(context),
              const SizedBox(height: 25),
              GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.7,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  return ProductCard(product: products[index]);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}