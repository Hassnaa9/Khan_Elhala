// dart format width=80
import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:bazario/utils/constants/colors.dart';

@RoutePage()
class CouponScreen extends StatelessWidget {
  const CouponScreen({super.key});

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
            context.router.pop();
          },
        ),
        title: const Text(
          'Coupon',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Best offers for you',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Urbanist',
              ),
            ),
            const SizedBox(height: 10),
            _buildCouponCard(
              'WELCOME200',
              'Add items worth \$2 more to unlock',
              'Get 50% OFF',
            ),
            _buildCouponCard(
              'CASHBACK12',
              'Add items worth \$2 more to unlock',
              'Up to \$12.00 cashback',
            ),
            _buildCouponCard(
              'FEST2COST',
              'Add items worth \$28 more to unlock',
              'Get 50% OFF for Combo',
            ),
            _buildCouponCard(
              'WELCOME200',
              'Add items worth \$2 more to unlock',
              'Get 50% OFF',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCouponCard(
      String code, String condition, String discount) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 2,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        code,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        condition,
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(Icons.stars_rounded,
                              color: MyColors.kPrimaryColor, size: 20),
                          const SizedBox(width: 5),
                          Text(
                            discount,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: MyColors.kPrimaryColor),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // This is a simple representation of the coupon's right edge.
                // For a more complex design (like the dashed border), you'd need
                // to use a custom painter or a more complex widget.
                const SizedBox(width: 10),
                SizedBox(
                  width: 30,
                  child: Center(
                    child: Column(
                      children: List.generate(
                        6,
                            (index) => Container(
                          width: 4,
                          height: 4,
                          margin: const EdgeInsets.symmetric(vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 0, indent: 16, endIndent: 16),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () {
                // TODO: Implement copy coupon code logic
              },
              child: Text(
                'COPY CODE',
                style: TextStyle(
                    color: MyColors.kPrimaryColor.withOpacity(0.8),
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}