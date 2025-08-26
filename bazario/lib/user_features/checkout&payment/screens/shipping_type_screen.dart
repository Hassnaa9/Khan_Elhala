// dart format width=80
import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:bazario/utils/constants/colors.dart';
import 'package:provider/provider.dart'; // Import Provider
import '../../../app/app_router.gr.dart';
import '../../../data/repositories/shipping_provider.dart';

@RoutePage()
class ShippingTypeScreen extends StatefulWidget {
  const ShippingTypeScreen({super.key});

  @override
  State<ShippingTypeScreen> createState() =>
      _ShippingTypeScreenState();
}

class _ShippingTypeScreenState extends State<ShippingTypeScreen> {
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
        title: const Text('Choose Shipping',
            style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: shippingProvider.shippingTypes.length,
                itemBuilder: (context, index) {
                  final shippingType = shippingProvider.shippingTypes[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: RadioListTile<int>(
                      value: index,
                      groupValue: shippingProvider.getSelectedShippingTypeIndex(),
                      onChanged: (int? value) {
                        shippingProvider.selectShippingType(shippingType);
                      },
                      title: Row(
                        children: [
                          Icon(
                            shippingType.icon,
                            color: MyColors.kPrimaryColor,
                          ),
                          const SizedBox(width: 15),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                shippingType.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                'Estimated Arrival: ${shippingType.date}',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ],
                      ),
                      activeColor: MyColors.kPrimaryColor,
                      controlAffinity: ListTileControlAffinity.trailing,
                    ),
                  );
                },
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