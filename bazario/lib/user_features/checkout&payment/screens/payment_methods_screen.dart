// dart format width=80
import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import '../../home/models/cart_item.dart';
import '../../../app/app_router.gr.dart';
import '../../../data/repositories/payment_provider.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/image_strings.dart';

@RoutePage()
class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

// REMOVE THIS CLASS IF IT'S NOT USED ELSEWHERE,
// OTHERWISE MAKE SURE IT'S PROPERLY DEFINED.
// class CardItem {}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  String? _selectedPaymentOption;

  @override
  Widget build(BuildContext context) {
    final paymentProvider = Provider.of<PaymentProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: MyColors.kPrimaryColor),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          'Payment Methods',
          style: TextStyle(color: MyColors.kPrimaryColor),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Credit & Debit Card',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: MyColors.kPrimaryColor,
                fontFamily: 'Urbanist',
              ),
            ),
            const SizedBox(height: 10),
            Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              elevation: 0,
              child: ListTile(
                leading: const Icon(Icons.credit_card_outlined,
                    color: MyColors.kPrimaryColor),
                title: const Text('Add Card'),
                trailing:
                const Icon(Icons.chevron_right, color: MyColors.kPrimaryColor),
                onTap: () {
                  context.router.push(AddCardRoute());
                },
              ),
            ),
            if (paymentProvider.savedCards.isNotEmpty)
              _buildSavedCardList(paymentProvider),
            const SizedBox(height: 30),
            const Text(
              'More Payment Options',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: MyColors.kPrimaryColor,
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
        child: ValueListenableBuilder<Box<CartItem>>(
          valueListenable: Hive.box<CartItem>('cartBox').listenable(),
          builder: (BuildContext context, box, Widget? child) {
            final cartItems = box.values.toList();
            final double subTotal = cartItems.fold(
                0.0, (sum, item) => sum + (item.product.price * item.quantity));
            const double deliveryFee = 25.00;
            const double discount = 10.00;
            final double totalCost = subTotal + deliveryFee - discount;

            // Prepare order details from cartItems
            // This is an example, adjust it to your CartItem model
            final List<Map<String, dynamic>> orderItemsDetails =
            cartItems.map((item) {
              return {
                'product_id': item.product.id, // Assuming your Product model has an id
                'product_name': item.product.name, // Assuming your Product model has a name
                'quantity': item.quantity,
                'price_per_unit': item.product.price,
              };
            }).toList();

            final Map<String, dynamic> orderDetails = {
              'items': orderItemsDetails,
              'sub_total': subTotal,
              'delivery_fee': deliveryFee,
              'discount': discount,
              'total_cost': totalCost,
              'payment_method': _selectedPaymentOption ?? (paymentProvider.selectedCardData != null ? 'Card' : 'N/A'),
              'timestamp': DateTime.now().toIso8601String(), // Optional: add a timestamp
              // Add other relevant order details here (e.g., user ID, shipping address)
            };

            return ElevatedButton(
              onPressed: () async {
                if (_selectedPaymentOption == null &&
                    paymentProvider.selectedCardData == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Please select a payment method.')),
                  );
                  return;
                }

                if (_selectedPaymentOption == 'Paypal') {
                  paymentProvider.selectPaymentMethod(PaymentMethod.paypal);
                } else if (_selectedPaymentOption == 'Apple Pay') {
                  paymentProvider.selectPaymentMethod(PaymentMethod.applePay);
                } else if (_selectedPaymentOption == 'Google Pay') {
                  paymentProvider.selectPaymentMethod(PaymentMethod.googlePay);
                } else if (paymentProvider.selectedCardData != null) {
                  paymentProvider.selectPaymentMethod(PaymentMethod.card);
                }


                // **MODIFIED PART:**
                // Pass subTotal and orderDetails to the provider
                await paymentProvider.processPaymentAndStoreOrder(
                  amount: totalCost, // Using totalCost for payment processing
                  currency: 'usd', // Consider making this dynamic or a constant
                  orderDetailsForPayment: { // Details specifically for the payment gateway if different
                    'description': 'Payment for order', // Example
                    'items_count': cartItems.length,
                  },
                  fullOrderDetailsForFirebase: orderDetails, // Pass the detailed order info
                );

                if (paymentProvider.status == PaymentStatus.success) {
                  // Optionally, you might want to clear the cart here
                  // Hive.box<CartItem>('cartBox').clear();
                  context.router.push(PaymentSuccessfulRoute());
                } else if (paymentProvider.status == PaymentStatus.error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(paymentProvider.errorMessage ?? 'An unknown error occurred')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: MyColors.kPrimaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child:
              const Text('Confirm Payment', style: TextStyle(fontSize: 16)),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPaymentOption(String title, String imagePath, String value) {
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
            Provider.of<PaymentProvider>(context, listen: false)
                .selectedCardData = null;
          });
        },
        activeColor: MyColors.kPrimaryColor,
      ),
      onTap: () {
        setState(() {
          _selectedPaymentOption = value;
          Provider.of<PaymentProvider>(context, listen: false)
              .selectedCardData = null;
        });
      },
    );
  }

  Widget _buildSavedCardList(PaymentProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        const Text(
          'Your Saved Cards',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: MyColors.kPrimaryColor,
            fontFamily: 'Urbanist',
          ),
        ),
        const SizedBox(height: 10),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: provider.savedCards.length,
          itemBuilder: (context, index) {
            final card = provider.savedCards[index];
            final bool isSelected = provider.selectedCardData != null &&
                provider.selectedCardData!['lastFour'] == card['lastFour']; // Assuming lastFour is unique enough for this check

            return Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              elevation: 0,
              child: ListTile(
                leading: const Icon(Icons.credit_card_outlined,
                    color: MyColors.kPrimaryColor),
                title: Text('**** **** **** ${card['lastFour']}'),
                subtitle: Text('Card holder: ${card['cardHolderName']}'),
                trailing: Radio<Map<String, dynamic>>(
                  value: card,
                  groupValue: provider.selectedCardData,
                  onChanged: (Map<String, dynamic>? newValue) {
                    setState(() {
                      provider.selectedCardData = newValue;
                      _selectedPaymentOption = null; // Clear other payment options
                    });
                    // No need to call selectPaymentMethod here, it's called before processing
                  },
                  activeColor: MyColors.kPrimaryColor,
                ),
                onTap: () {
                  setState(() {
                    provider.selectedCardData = card;
                    _selectedPaymentOption = null; // Clear other payment options
                  });
                  // No need to call selectPaymentMethod here, it's called before processing
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
