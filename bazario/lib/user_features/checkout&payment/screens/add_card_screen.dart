// dart format width=80
import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:bazario/utils/constants/colors.dart';
import 'package:provider/provider.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:auto_route/auto_route.dart';

import '../../../data/repositories/payment_provider.dart';

@RoutePage()
class AddCardScreen extends StatefulWidget {
  const AddCardScreen({super.key});

  @override
  State<AddCardScreen> createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCardScreen> {
  bool _saveCard = false;

  // Controllers to get the text from the input fields
  final TextEditingController _cardHolderNameController = TextEditingController();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();

  // Dispose of controllers when the state is removed to prevent memory leaks
  @override
  void dispose() {
    _cardHolderNameController.dispose();
    _cardNumberController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  /// This function handles the card saving logic.
  void _addCard() {
    // Get the PaymentProvider instance
    final paymentProvider = Provider.of<PaymentProvider>(context, listen: false);

    // Collect the data from the text fields
    final cardData = {
      'cardHolderName': _cardHolderNameController.text,
      'cardNumber': _cardNumberController.text,
      'expiryDate': _expiryDateController.text,
      'cvv': _cvvController.text,
    };

    // Call the saveCard method in the provider
    paymentProvider.saveCard(cardData);

    // Optionally show a confirmation message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Card added successfully!')),
    );

    // Navigate back to the previous screen
    context.router.pop();
  }

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
          'Add Card',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Credit Card Design
              _buildCreditCard(),
              const SizedBox(height: 30),

              // Card Holder Name Input, now with a controller
              _buildTextInput(
                'Card Holder Name',
                'Esther Howard',
                _cardHolderNameController,
              ),

              // Card Number Input, now with a controller
              const SizedBox(height: 20),
              _buildTextInput(
                'Card Number',
                '4716 9627 1635 8047',
                _cardNumberController,
              ),

              // Expiry Date and CVV Input, now with controllers
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _buildTextInput(
                      'Expiry Date',
                      '02/30',
                      _expiryDateController,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: _buildTextInput(
                      'CVV',
                      '000',
                      _cvvController,
                    ),
                  ),
                ],
              ),

              // Save Card Checkbox
              const SizedBox(height: 20),
              Row(
                children: [
                  Checkbox(
                    value: _saveCard,
                    onChanged: (bool? newValue) {
                      setState(() {
                        _saveCard = newValue ?? false;
                      });
                    },
                    activeColor: MyColors.kPrimaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                  ),
                  const Text('Save Card'),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: _addCard, // Call the new _addCard function
          style: ElevatedButton.styleFrom(
            backgroundColor: MyColors.kPrimaryColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: const Text('Add Card', style: TextStyle(fontSize: 16)),
        ),
      ),
    );
  }

  Widget _buildCreditCard() {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: MyColors.kPrimaryColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background circles (can be implemented with a custom painter or a stacked image)
          Positioned(
            top: -50,
            right: -50,
            child: CircleAvatar(
              radius: 80,
              backgroundColor: Colors.white.withOpacity(0.1),
            ),
          ),
          Positioned(
            top: -20,
            right: -20,
            child: CircleAvatar(
              radius: 60,
              backgroundColor: Colors.white.withOpacity(0.1),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Text(
                    'VISA',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  '4716 9627 1635 8047',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Card holder name',
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.7))),
                        const SizedBox(height: 5),
                        const Text('Esther Howard',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Expiry date',
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.7))),
                        const SizedBox(height: 5),
                        const Text('02/30',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const Icon(Icons.credit_card,
                        color: Colors.white, size: 40),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Update the helper method to accept a controller
  Widget _buildTextInput(String label, String hintText,
      TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: controller, // Assign the controller here
          decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.grey[200],
            contentPadding:
            const EdgeInsets.symmetric(vertical: 18, horizontal: 15),
          ),
        ),
      ],
    );
  }
}
