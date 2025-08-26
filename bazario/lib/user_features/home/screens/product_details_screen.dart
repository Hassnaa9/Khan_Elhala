// dart format width=80
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/annotations.dart';
import 'package:provider/provider.dart';
import 'package:bazario/app/app_router.gr.dart';
import '../../../data/repositories/home_provider.dart' hide CartItem;
import '../../../data/services/cart_service.dart';
import '../../../utils/constants/colors.dart';
import '../models/product.dart';
import '../models/cart_item.dart';

@RoutePage()
class ProductDetailsScreen extends StatefulWidget {
  final Product product;
  const ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  // Use the singleton instance directly
  final CartService _cartService = CartService();

  // Dummy data for options
  final List<String> _sizes = ['S', 'M', 'L', 'XL', 'XXL', 'XXXL'];

  // Color data with names for better tracking
  final List<Map<String, dynamic>> _colorsData = [
    {'color': Colors.brown[200]!, 'name': 'Light Brown'},
    {'color': Colors.black, 'name': 'Black'},
    {'color': Colors.grey[400]!, 'name': 'Grey'},
    {'color': Colors.brown[400]!, 'name': 'Medium Brown'},
    {'color': Colors.orange, 'name': 'Orange'},
    {'color': Colors.brown, 'name': 'Dark Brown'},
  ];

  int _selectedSizeIndex = 2; // Default to 'L'
  int _selectedColorIndex = 0; // Default to first color

  // Getter methods for selected values
  String get selectedSize => _sizes[_selectedSizeIndex];
  String get selectedColorName => _colorsData[_selectedColorIndex]['name'];
  Color get selectedColor => _colorsData[_selectedColorIndex]['color'];

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
        // The corrected code for the favorite icon
        actions: [
          Consumer<HomeProvider>(
            builder: (context, homeProvider, child) {
              final productFromProvider = homeProvider.products
                  .firstWhere((element) => element.id == widget.product.id);
              return IconButton(
                icon: Icon(
                  productFromProvider.isFavorite
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: productFromProvider.isFavorite ? Colors.red : Colors.grey,
                ),
                onPressed: () {
                  homeProvider.toggleFavorite(widget.product.id);
                },
              );
            },
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
              child: Image.network(
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
          Text(widget.product.category, style: TextStyle(color: Colors.grey)),
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
          Text(
            widget.product.description,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.grey),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                _showFullDescription(context);
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
                  side: BorderSide(
                    color: isSelected ? MyColors.kPrimaryColor : Colors.grey[300]!,
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 20),
          Text('Select Color: $selectedColorName',
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Urbanist")),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10.0,
            children: List.generate(_colorsData.length, (index) {
              final isSelected = _selectedColorIndex == index;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedColorIndex = index;
                  });
                },
                child: Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    color: _colorsData[index]['color'],
                    shape: BoxShape.circle,
                    border: isSelected
                        ? Border.all(color: MyColors.kPrimaryColor, width: 3)
                        : Border.all(color: Colors.grey[300]!, width: 1),
                  ),
                  child: isSelected
                      ? const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 20,
                  )
                      : null,
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
      child: Column(
        children: [
          // Display selected options
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Selected Options:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text('Size: $selectedSize',
                        style: const TextStyle(fontSize: 14)),
                    const SizedBox(width: 20),
                    Text('Color: $selectedColorName',
                        style: const TextStyle(fontSize: 14)),
                  ],
                ),
              ],
            ),
          ),
          // Price and Add to Cart button
          Row(
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
                  // Create a new CartItem instance with the selected options
                  final newCartItem = CartItem(
                    product: widget.product,
                    quantity: 1,
                    selectedSize: selectedSize,
                    selectedColor: selectedColorName,
                  );

                  // Use the CartService to add the item to the Hive database
                  _cartService.addItemToCart(newCartItem);

                  // Show confirmation snackbar
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '${widget.product.name} (Size: $selectedSize, Color: $selectedColorName) added to cart!',
                      ),
                      backgroundColor: MyColors.kPrimaryColor,
                      duration: const Duration(seconds: 2),
                    ),
                  );

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
        ],
      ),
    );
  }

  // Method to show full description in a dialog
  void _showFullDescription(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(widget.product.name),
          content: SingleChildScrollView(
            child: Text(
              widget.product.description,
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Close',
                style: TextStyle(color: MyColors.kPrimaryColor),
              ),
            ),
          ],
        );
      },
    );
  }
}