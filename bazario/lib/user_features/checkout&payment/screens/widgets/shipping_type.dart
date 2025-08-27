import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../../../../app/app_router.gr.dart';
import '../../../../data/repositories/shipping_provider.dart';
import 'package:provider/provider.dart'; // Import Provider

class ShippingType extends StatelessWidget {
  const ShippingType({super.key});

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
              Icon(
                shippingProvider.selectedShippingType?.icon,
                color: Colors.brown,
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      shippingProvider.selectedShippingType?.name ?? 'No type selected',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Estimated Arrival: ${shippingProvider.selectedShippingType?.date ?? 'N/A'}',
                      style: TextStyle(color: Colors.grey[600]),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  context.router.push(ShippingTypeRoute());
                },
                child: const Text('CHANGE', style: TextStyle(color: Colors.brown)),
              ),
            ],
          ),
        ),
      );
    }
  }
