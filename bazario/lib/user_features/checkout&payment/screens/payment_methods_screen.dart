// dart format width=80
import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:bazario/utils/constants/colors.dart';

import '../../../app/app_router.gr.dart';
import '../../../utils/constants/image_strings.dart';

@RoutePage()
class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() =>
      _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  // Use a string to represent the selected payment option's name
  String? _selectedPaymentOption;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          'Payment Methods',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            // Credit & Debit Card Section
            const Text(
              'Credit & Debit Card',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'Urbanist',
              ),
            ),
            const SizedBox(height: 10),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              elevation: 0,
              child: ListTile(
                leading: const Icon(Icons.credit_card_outlined),
                title: const Text('Add Card'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  context.router.push(AddCardRoute());
                },
              ),
            ),
            const SizedBox(height: 30),
            // More Payment Options Section
            const Text(
              'More Payment Options',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'Urbanist',
              ),
            ),
            const SizedBox(height: 10),
            _buildPaymentOption(
              'Paypal',
              ImagesUrl.paypal,
              'Paypal',
            ),
            const Divider(height: 0),
            _buildPaymentOption(
              'Apple Pay',
              ImagesUrl.applePay,
              'Apple Pay',
            ),
            const Divider(height: 0),
            _buildPaymentOption(
              'Google Pay',
              ImagesUrl.googlePay,
              'Google Pay',
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            context.router.push(PaymentSuccessfulRoute());
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: MyColors.kPrimaryColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: const Text('Confirm Payment', style: TextStyle(fontSize: 16)),
        ),
      ),
    );
  }

  Widget _buildPaymentOption(
      String title, String imagePath, String value) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
      leading: Image.asset(
        imagePath,
        width: 40,
        height: 40,
      ),
      title: Text(title),
      trailing: Radio<String>(
        value: value,
        groupValue: _selectedPaymentOption,
        onChanged: (String? newValue) {
          setState(() {
            _selectedPaymentOption = newValue;
          });
        },
        activeColor: MyColors.kPrimaryColor,
      ),
      onTap: () {
        setState(() {
          _selectedPaymentOption = value;
        });
      },
    );
  }
}