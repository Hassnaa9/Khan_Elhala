// dart format width=80
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/annotations.dart';
import 'package:provider/provider.dart';
import 'package:bazario/app/app_router.gr.dart';
import '../../../data/repositories/home_provider.dart';
import '../../../utils/constants/colors.dart';
import '../models/product.dart';

@RoutePage()
class ProductDetailsScreen extends StatefulWidget {
  final Product product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  // Dummy data for options
  final List<String> _sizes = ['S', 'M', 'L', 'XL', 'XXL', 'XXXL'];
  final List<Color> _colors = [
    Colors.brown[200]!,
    Colors.black,
    Colors.grey[400]!,
    Colors.brown[400]!,
    Colors.orange,
    Colors.brown,
  ];
  int _selectedSizeIndex = 2; // Default to 'L'
  int _selectedColorIndex = 0;

  // No need for _productImages or PageController
  // since we are only showing one image.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.router.pop(),
        ),
        title: const Text('Product Details',
            style: TextStyle(color: Colors.black)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Directly display the product image passed from the Home Screen
            SizedBox(
              height: MediaQuery.of(context).size.height * .4,
              width: double.infinity,
              child: Image.asset(
                widget.product.imageUrl,
                fit: BoxFit.fill,
              ),
            ),
            _buildProductInfo(),
            _buildSizeAndColorSelection(),
            _buildDetailsSection(),
            _buildTotalPriceAndButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildProductInfo() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Female's Style", style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 10),
          Text(widget.product.name,
              style: Theme.of(context).textTheme.headlineMedium),
        ],
      ),
    );
  }

  Widget _buildDetailsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Product Details',
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 5),
          const Text(
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.grey),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                // TODO: Implement "Read more" functionality
              },
              child: Text('Read more',
                  style: TextStyle(color: MyColors.kPrimaryColor)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSizeAndColorSelection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Select Size',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Urbanist")),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8.0,
            children: List.generate(_sizes.length, (index) {
              final isSelected = _selectedSizeIndex == index;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedSizeIndex = index;
                  });
                },
                child: Chip(
                  label: Text(_sizes[index]),
                  backgroundColor:
                  isSelected ? MyColors.kPrimaryColor : Colors.white,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 20),
          const Text('Select Color: Brown',
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10.0,
            children: List.generate(_colors.length, (index) {
              final isSelected = _selectedColorIndex == index;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedColorIndex = index;
                  });
                },
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: _colors[index],
                    shape: BoxShape.circle,
                    border: isSelected
                        ? Border.all(color: Colors.brown, width: 3)
                        : null,
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalPriceAndButton() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Total Price', style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 5),
              Text('\$${widget.product.price.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.headlineSmall),
            ],
          ),
          ElevatedButton.icon(
            onPressed: () {
              // Get the provider
              final homeProvider =
              Provider.of<HomeProvider>(context, listen: false);

              // Add the product to the cart
              homeProvider.addToCart(widget.product);

              // Navigate to the My Cart screen
              context.router.push(const MyCartRoute());
            },
            icon: const Icon(Icons.shopping_bag_outlined),
            label: const Text('Add to Cart'),
            style: ElevatedButton.styleFrom(
              backgroundColor: MyColors.kPrimaryColor,
              foregroundColor: Colors.white,
              padding:
              const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
            ),
          ),
        ],
      ),
    );
  }
}