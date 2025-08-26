// dart format width=80
import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bazario/utils/constants/colors.dart';
import '../../../app/app_router.gr.dart';
import '../../../data/repositories/home_provider.dart';

@RoutePage()
class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Access cart items from the provider
    final cartItems = Provider.of<HomeProvider>(context).cartItems;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.router.pop(),
        ),
        title: const Text(
          'Checkout',
          style: TextStyle(color: MyColors.kPrimaryColor),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Shipping Address Section
              _buildSectionTitle('Shipping Address'),
              _buildAddressCard(),
              const SizedBox(height: 20),

              // Choose Shipping Type Section
              _buildSectionTitle('Choose Shipping Type'),
              _buildShippingTypeCard(),
              const SizedBox(height: 20),

              // Order List Section
              _buildSectionTitle('Order List'),
              const SizedBox(height: 10),
              _buildOrderList(cartItems),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            context.router.push(ShippingAddressRoute());
            },
          style: ElevatedButton.styleFrom(
            backgroundColor: MyColors.kPrimaryColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: const Text('Continue to Payment',
              style: TextStyle(fontSize: 16)),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
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

    // Corrected _buildAddressCard() method
    Widget _buildAddressCard() {
      return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              const Icon(Icons.location_on_outlined, color: Colors.brown),
              const SizedBox(width: 15),
              Expanded( // Wrap the Column in an Expanded widget
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Home', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 5),
                    Text(
                      '1901 Thornridge Cir. Shiloh, Hawaii 81063',
                      style: TextStyle(color: Colors.grey[600]),
                      overflow: TextOverflow.ellipsis, // Add this for good measure
                    ),
                  ],
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {},
                child: const Text('CHANGE', style: TextStyle(color: Colors.brown)),
              ),
            ],
          ),
        ),
      );
    }

  // Corrected _buildShippingTypeCard() method
  Widget _buildShippingTypeCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const Icon(Icons.local_shipping_outlined, color: Colors.brown),
            const SizedBox(width: 15),
            Expanded( // Wrap the Column in an Expanded widget
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Economy', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  Text(
                    'Estimated Arrival 25 August 2023',
                    style: TextStyle(color: Colors.grey[600]),
                    overflow: TextOverflow.ellipsis, // Optional but good practice
                  ),
                ],
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () {},
              child: const Text('CHANGE', style: TextStyle(color: Colors.brown)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderList(List<CartItem> cartItems) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: cartItems.length,
      itemBuilder: (context, index) {
        final item = cartItems[index];
        return Card(
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.product.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 5),
                    Text('Size: XL',
                        style: TextStyle(color: Colors.grey[600])),
                    const SizedBox(height: 5),
                    Text('\$${item.product.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}