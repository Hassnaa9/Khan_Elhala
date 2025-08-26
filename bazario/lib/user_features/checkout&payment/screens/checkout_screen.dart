// dart format width=80
import 'package:auto_route/auto_route.dart';
import 'package:bazario/user_features/checkout&payment/screens/widgets/address_card.dart';
import 'package:bazario/user_features/checkout&payment/screens/widgets/order_list.dart';
import 'package:bazario/user_features/checkout&payment/screens/widgets/selection_title.dart';
import 'package:bazario/user_features/checkout&payment/screens/widgets/shipping_type.dart';
import 'package:flutter/material.dart';
import 'package:bazario/utils/constants/colors.dart';
import '../../../app/app_router.gr.dart';

@RoutePage()
class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
              SelectionTitle('Shipping Address'),
              AddressCard(),
              const SizedBox(height: 20),

              // Choose Shipping Type Section
              SelectionTitle('Choose Shipping Type'),
              ShippingType(),
              const SizedBox(height: 20),

              // Order List Section
              SelectionTitle('Order List'),
              const SizedBox(height: 10),
              OrderList(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            context.router.push(PaymentMethodsRoute());
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
}