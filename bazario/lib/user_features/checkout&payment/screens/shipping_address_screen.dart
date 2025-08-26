// dart format width=80
import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:bazario/app/app_router.gr.dart';
import 'package:flutter/material.dart';
import 'package:bazario/utils/constants/colors.dart';
import 'package:provider/provider.dart';

import '../../../data/repositories/shipping_provider.dart'; // Import Provider

@RoutePage()
class ShippingAddressScreen extends StatefulWidget {
  const ShippingAddressScreen({super.key});

  @override
  State<ShippingAddressScreen> createState() =>
      _ShippingAddressScreenState();
}

class _ShippingAddressScreenState extends State<ShippingAddressScreen> {
  @override
  Widget build(BuildContext context) {
    final shippingProvider = Provider.of<ShippingProvider>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.router.pop(),
        ),
        title: const Text('Shipping Address',
            style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // List of addresses with radio buttons
            Expanded(
              child: ListView.builder(
                itemCount: shippingProvider.allAddresses.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  final address = shippingProvider.allAddresses[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    elevation: 0,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: RadioListTile<int>(
                      title: Text(address.name,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(
                        address.address,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      value: index,
                      groupValue: shippingProvider.getSelectedAddressIndex(),
                      onChanged: (int? value) {
                        shippingProvider.selectAddress(address);
                      },
                      activeColor: MyColors.kPrimaryColor,
                      controlAffinity: ListTileControlAffinity.trailing,
                    ),
                  );
                },
              ),
            ),

            // Button to add a new address
            const SizedBox(height: 20),
            Container(
              height: 60,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(
                    color: MyColors.kPrimaryColor, style: BorderStyle.solid),
                borderRadius: BorderRadius.circular(15),
              ),
              child: TextButton.icon(
                onPressed: () {
                  // TODO: Implement logic to add new shipping address
                },
                icon: const Icon(Icons.add, color: Colors.brown),
                label: const Text('Add New Shipping Address',
                    style: TextStyle(color: Colors.brown)),
              ),
            ),
          ],
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
          child: const Text('Apply', style: TextStyle(fontSize: 16)),
        ),
      ),
    );
  }
}