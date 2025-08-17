import 'package:auto_route/annotations.dart';
import 'package:bazario/features/home/screens/widgets/category_list.dart';
import 'package:bazario/features/home/screens/widgets/product_cart.dart';
import 'package:bazario/features/home/screens/widgets/search_bar.dart';
import 'package:bazario/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:auto_route/auto_route.dart';
import 'package:bazario/app/app_router.gr.dart';
import '../../../data/repositories/home_provider.dart';
import '../../../utils/constants/image_strings.dart';

@RoutePage()
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // The index of the selected bottom navigation item

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigate based on the tapped index
    switch (index) {
      case 0:
      context.router.push(HomeRoute());
        break;
      case 1:
        context.router.push(MyCartRoute());
        break;
      case 2:
      // Navigate to the Wishlist screen
        context.router.push(WishlistRoute());        break;
      case 3:
        context.router.push(const ProfileRoute());
        break;
    }
  }

  // Widget for the Banner/Hero section
  Widget _buildBannerSection() {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            image: AssetImage(ImagesUrl.bannerImg),
            fit: BoxFit.cover,
          ),
        ),
        child: const Center(
          child: Text(
            '50% \nSALE',
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  // Widget for Flash Sale Filters
  Widget _buildFlashSaleFilters(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context);
    return SizedBox(
      height: .04 * MediaQuery.of(context).size.height,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: homeProvider.flashSaleFilters.length,
        itemBuilder: (context, index) {
          final filter = homeProvider.flashSaleFilters[index];
          final isSelected = homeProvider.selectedFilterIndex == index;
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
                  homeProvider.selectFilter(index);
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
    final products = Provider.of<HomeProvider>(context).products;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const CustomSearchBar(),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              _buildBannerSection(),
              const SizedBox(height: 25),
              const Text(
                'Category',
                style: TextStyle(fontSize: 22, fontFamily: "Urbanist"),
              ),
              const SizedBox(height: 15),
              const CategoryList(),
              const SizedBox(height: 25),
              const Text(
                'Flash Sale',
                style: TextStyle(fontSize: 22, fontFamily: "Urbanist"),
              ),
              const SizedBox(height: 15),
              _buildFlashSaleFilters(context),
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
      bottomNavigationBar: BottomNavigationBar(
        // Implementation of Bottom Nav Bar
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Search'),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite,),
              label: 'Whish list'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _selectedIndex, // Set the current index
        selectedItemColor: MyColors.kPrimaryColor,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: _onItemTapped, // Handle tap events
      ),
    );
  }
}