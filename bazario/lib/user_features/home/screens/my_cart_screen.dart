// dart format width=80
import 'package:flutter/material.dart';
import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:provider/provider.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

import 'package:bazario/utils/constants/colors.dart';
import '../../../data/services/cart_service.dart';
import '../models/cart_item.dart';
import '../../../app/app_router.gr.dart';
import '../../../data/repositories/home_provider.dart' hide CartItem;
import '../models/product.dart';

@RoutePage()
class MyCartScreen extends StatefulWidget {
  const MyCartScreen({super.key});

  @override
  State<MyCartScreen> createState() => _MyCartScreenState();
}

class _MyCartScreenState extends State<MyCartScreen> {
  // Use the singleton instance of the CartService
  final CartService _cartService = CartService();

  void _showRemoveFromCartDialog(CartItem item) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Remove from Cart?',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 20),
              // Cart item card
              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          item.product.imageUrl,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.product.name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold)),
                          if (item.selectedSize != null)
                            Text('Size: ${item.selectedSize}',
                                style: TextStyle(color: Colors.grey[600])),
                          if (item.selectedColor != null)
                            Text('Color: ${item.selectedColor}',
                                style: TextStyle(color: Colors.grey[600])),
                          Text('\$${item.product.price.toStringAsFixed(2)}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const Spacer(),
                      // Quantity control
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Use CartService to remove the item from Hive
                        _cartService.removeItemFromCart(item.product.id);
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.brown,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text('Yes, Remove'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _incrementQuantity(CartItem item) {
    final newQuantity = item.quantity + 1;
    // Use CartService to update the quantity in Hive
    _cartService.updateItemQuantity(item.product.id, newQuantity);
  }

  void _decrementQuantity(CartItem item) {
    if (item.quantity > 1) {
      final newQuantity = item.quantity - 1;
      // Use CartService to update the quantity in Hive
      _cartService.updateItemQuantity(item.product.id, newQuantity);
    } else {
      _showRemoveFromCartDialog(item);
    }
  }

  Widget _buildQuantityButton(IconData icon, VoidCallback onPressed) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: MyColors.secondaryPrimaryColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: IconButton(
        icon: Icon(icon, size: 18),
        onPressed: onPressed,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.router.pop(),
        ),
        title: const Text('My Cart',style: TextStyle(color: MyColors.kPrimaryColor),),
        centerTitle: true,
      ),
      // Use a ValueListenableBuilder to listen to changes in the Hive box
      body: ValueListenableBuilder<Box<CartItem>>(
        valueListenable: Hive.box<CartItem>('cartBox').listenable(),
        builder: (context, box, child) {
          final cartItems = box.values.toList();
          final isCartNotEmpty = cartItems.isNotEmpty;

          // Calculate totals based on the items from the Hive box
          final double subTotal = cartItems.fold(
              0.0, (sum, item) => sum + (item.product.price * item.quantity));
          const double deliveryFee = 25.00; // Example fixed cost
          const double discount = 10.00; // Example fixed discount
          final double totalCost = subTotal + deliveryFee - discount;

          return Column(
            children: [
              Expanded(
                child: isCartNotEmpty
                    ? ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final item = cartItems[index];
                    return Dismissible(
                      key: Key(item.product.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        decoration: BoxDecoration(
                          color: Colors.red[400],
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      confirmDismiss: (direction) async {
                        _showRemoveFromCartDialog(item);
                        return false;
                      },
                      child: Card(
                        color: Colors.white,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  item.product.imageUrl,
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(item.product.name,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  if (item.selectedSize != null)
                                    Text('Size: ${item.selectedSize}',
                                        style: TextStyle(
                                            color: Colors.grey[600])),
                                  if (item.selectedColor != null)
                                    Text('Color: ${item.selectedColor}',
                                        style: TextStyle(
                                            color: Colors.grey[600])),
                                  Text(
                                      '\$${item.product.price.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                              const Spacer(),
                              Row(
                                children: [
                                  _buildQuantityButton(Icons.remove,
                                          () => _decrementQuantity(item)),
                                  const SizedBox(width: 5),
                                  Text(item.quantity.toString()),
                                  const SizedBox(width: 5),
                                  _buildQuantityButton(
                                      Icons.add, () => _incrementQuantity(item)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                )
                    : const Center(
                  child: Text('Your cart is empty.'),
                ),
              ),
              // Price summary and checkout section
              if (isCartNotEmpty)
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: MyColors.kPrimaryColor,
                    borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(30)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Added this section for "Promo Code" and "See Coupons"
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Promo Code',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              context.router.push(const CouponRoute());
                            },
                            child: const Text(
                              'See Coupons',
                              style: TextStyle(
                                  color: Colors.white,
                                  decoration: TextDecoration.underline,
                                  decorationColor: Colors.amber),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Enter Promo Code',
                                hintStyle: const TextStyle(color: Colors.grey),
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: MyColors.kPrimaryColor,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 15),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                            ),
                            child: const Text('Apply'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _buildPriceRow('Sub-Total', subTotal),
                      const SizedBox(height: 5),
                      _buildPriceRow('Delivery Fee', deliveryFee),
                      const SizedBox(height: 5),
                      _buildPriceRow('Discount', -discount, isDiscount: true),
                      const SizedBox(height: 10),
                      const Divider(color: Colors.white),
                      _buildPriceRow('Total Cost', totalCost, isTotal: true),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          context.router.push(const CheckoutRoute());
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: MyColors.kPrimaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                        ),
                        child: const Text('Proceed to Checkout'),
                      ),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPriceRow(String label, double price,
      {bool isDiscount = false, bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isTotal ? Colors.white : Colors.white70,
            fontSize: isTotal ? 18 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          '${isDiscount ? '-' : ''}\$${price.abs().toStringAsFixed(2)}',
          style: TextStyle(
            color: isTotal ? Colors.white : Colors.white,
            fontSize: isTotal ? 18 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}