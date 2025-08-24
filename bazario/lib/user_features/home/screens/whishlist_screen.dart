// dart format width=80
import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bazario/user_features/home/screens/widgets/product_card.dart';
import 'package:bazario/utils/constants/colors.dart';

import '../../../data/repositories/home_provider.dart';
import '../models/product.dart';

@RoutePage()
class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  // Widget for Wishlist Filters
  Widget _buildWishlistFilters(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context);
    final filters = homeProvider.wishlistFilters;
    return SizedBox(
      height: .04 * MediaQuery.of(context).size.height,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected =
              homeProvider.selectedWishlistFilterIndex == index;
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
                if (selected) {
                  homeProvider.updateWishlistFilters(index);
                }
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
    final products = Provider.of<HomeProvider>(context).wishlistProducts;
    final homeProvider = Provider.of<HomeProvider>(context);
    final selectedFilterIndex = homeProvider.selectedWishlistFilterIndex;

    List<Product> filteredProducts;
    if (selectedFilterIndex == 0) {
      filteredProducts = products;
    } else {
      final selectedCategory = homeProvider.wishlistFilters[selectedFilterIndex];
      filteredProducts = products
          .where((product) => product.category == selectedCategory)
          .toList();
    }

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
              if (filteredProducts.isEmpty)
                const Center(
                  child: Text('Your wishlist is empty.'),
                )
              else
                GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: filteredProducts.length,
                  itemBuilder: (context, index) {
                    return ProductCard(product: filteredProducts[index]);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}