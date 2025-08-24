// dart format width=80
import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:bazario/utils/constants/colors.dart';

import '../../../app/app_router.gr.dart';

@RoutePage()
class ShippingTypeScreen extends StatefulWidget {
  const ShippingTypeScreen({super.key});

  @override
  State<ShippingTypeScreen> createState() =>
      _ShippingTypeScreenState();
}

class _ShippingTypeScreenState extends State<ShippingTypeScreen> {
  // Dummy list of shipping options
  final List<Map<String, dynamic>> _shippingOptions = [
    {
      'name': 'Economy',
      'icon': Icons.local_shipping_outlined,
      'date': '25 August 2023',
    },
    {
      'name': 'Regular',
      'icon': Icons.local_shipping_outlined,
      'date': '24 August 2023',
    },
    {
      'name': 'Cargo',
      'icon': Icons.local_shipping_outlined,
      'date': '22 August 2023',
    },
    {
      'name': 'Friend\'s House',
      'icon': Icons.location_on_outlined,
      'date': '2464 Royal Ln. Mesa, New Jersey 45463',
    },
  ];

  // Currently selected shipping option index
  int _selectedOptionIndex = 0;

  @override
  Widget build(BuildContext context) {
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
                itemCount: _shippingOptions.length,
                itemBuilder: (context, index) {
                  return Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: RadioListTile<int>(
                      value: index,
                      groupValue: _selectedOptionIndex,
                      onChanged: (int? value) {
                        setState(() {
                          _selectedOptionIndex = value!;
                        });
                      },
                      title: Row(
                        children: [
                          Icon(
                            _shippingOptions[index]['icon'],
                            color: MyColors.kPrimaryColor,
                          ),
                          const SizedBox(width: 15),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _shippingOptions[index]['name'],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                'Estimated Arrival: ${_shippingOptions[index]['date']}',
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