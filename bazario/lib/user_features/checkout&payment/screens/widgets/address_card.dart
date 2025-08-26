import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../../../../app/app_router.gr.dart';
import '../../../../data/repositories/shipping_provider.dart';
import 'package:provider/provider.dart'; // Import Provider

class AddressCard extends StatelessWidget {
  const AddressCard({super.key});

  @override
  Widget build(BuildContext context) {
    final shippingProvider = Provider.of<ShippingProvider>(context);
    return Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              const Icon(Icons.location_on_outlined, color: Colors.brown),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      shippingProvider.selectedAddress?.name ?? 'No address selected',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      shippingProvider.selectedAddress?.address ?? 'Please choose an address',
                      style: TextStyle(color: Colors.grey[600]),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  context.router.push(ShippingAddressRoute());
                },
                child: const Text('CHANGE', style: TextStyle(color: Colors.brown)),
              ),
            ],
          ),
        ),
      );
    }
}
