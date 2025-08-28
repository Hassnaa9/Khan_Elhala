// payment_successful_screen.dart
import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:bazario/app/app_router.gr.dart';
import 'package:flutter/material.dart';
import 'package:bazario/utils/constants/colors.dart';

@RoutePage()
class PaymentSuccessfulScreen extends StatelessWidget {
  final String? orderId;
  final double? amount;
  final String? paymentMethod;

  const PaymentSuccessfulScreen({
    super.key,
    this.orderId,
    this.amount,
    this.paymentMethod,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const SizedBox(), // Remove back button
        centerTitle: true,
        title: const Text(
          'Payment Successful',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Success Icon
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: MyColors.kPrimaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle,
                size: 80,
                color: MyColors.kPrimaryColor,
              ),
            ),

            const SizedBox(height: 32),

            // Success Title
            const Text(
              'Payment Successful!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontFamily: 'Urbanist',
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 16),

            // Success Message
            const Text(
              'Your order has been placed successfully and saved to the system. The admin can now view your order details in the dashboard.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontFamily: 'Urbanist',
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 32),

            // Order Details Card
            if (orderId != null || amount != null || paymentMethod != null) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Order Details',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Urbanist',
                      ),
                    ),
                    const SizedBox(height: 16),

                    if (orderId != null) ...[
                      _buildDetailRow('Order ID', orderId!),
                      const SizedBox(height: 12),
                    ],

                    if (amount != null) ...[
                      _buildDetailRow('Amount', '\$${amount!.toStringAsFixed(2)}'),
                      const SizedBox(height: 12),
                    ],

                    if (paymentMethod != null) ...[
                      _buildDetailRow('Payment Method', _formatPaymentMethod(paymentMethod!)),
                      const SizedBox(height: 12),
                    ],

                    _buildDetailRow('Status', 'Completed'),
                    const SizedBox(height: 12),
                    _buildDetailRow('Date', _formatDate(DateTime.now())),
                  ],
                ),
              ),
              const SizedBox(height: 32),
            ],

            // Admin Note
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: MyColors.kPrimaryColor.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: MyColors.kPrimaryColor.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: MyColors.kPrimaryColor,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Your order has been saved to Firebase and is now visible to the admin in their dashboard.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                        fontFamily: 'Urbanist',
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Action Buttons
            Column(
              children: [
                // Continue Shopping Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate back to home or shopping screen
                      context.router.push(const HomeRoute());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MyColors.kPrimaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Continue Shopping',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Urbanist',
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // View Orders Button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      // Navigate to orders screen
                      context.router.push(const MyOrdersRoute());
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: MyColors.kPrimaryColor,
                      side: BorderSide(color: MyColors.kPrimaryColor),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'View My Orders',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Urbanist',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Helper method to build detail rows
  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
            fontFamily: 'Urbanist',
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black,
            fontFamily: 'Urbanist',
          ),
        ),
      ],
    );
  }

  /// Format payment method for display
  String _formatPaymentMethod(String method) {
    switch (method.toLowerCase()) {
      case 'card':
        return 'Credit/Debit Card';
      case 'paypal':
        return 'PayPal';
      case 'applepay':
        return 'Apple Pay';
      case 'googlepay':
        return 'Google Pay';
      case 'cashondelivery':
        return 'Cash on Delivery';
      default:
        return method.toUpperCase();
    }
  }

  /// Format date for display
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} at ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}