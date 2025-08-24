// dart format width=80
import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:bazario/utils/constants/colors.dart';

import '../../../utils/constants/image_strings.dart';

@RoutePage()
class TrackOrderScreen extends StatelessWidget {
  const TrackOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.router.pop(),
        ),
        title: const Text(
          'Track Order',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Info Section
              _buildProductCard(),
              const SizedBox(height: 20),

              // Order Details Section
              _buildSectionTitle('Order Details'),
              _buildOrderDetails(),
              const SizedBox(height: 20),

              // Order Status Section (Timeline)
              _buildSectionTitle('Order Status'),
              _buildOrderStatusTimeline(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                ImagesUrl.prod2Img,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Brown Suite',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Size: XL | Qty: 10pcs',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    '\$120',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        fontFamily: 'Urbanist',
      ),
    );
  }

  Widget _buildOrderDetails() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildDetailRow('Expected Delivery Date', '03 Sep 2023'),
            const SizedBox(height: 10),
            _buildDetailRow('Tracking ID', 'TRK452126542'),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.grey[600])),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildOrderStatusTimeline() {
    return Column(
      children: [
        _buildTimelineItem(
          'Order Placed',
          '23 Aug 2023, 04:25 PM',
          Icons.description_outlined,
          isCompleted: true,
        ),
        _buildTimelineItem(
          'In Progress',
          '23 Aug 2023, 03:54 PM',
          Icons.inventory_2_outlined,
          isCompleted: true,
        ),
        _buildTimelineItem(
          'Shipped',
          'Expected 02 Sep 2023',
          Icons.local_shipping_outlined,
          isCompleted: false,
        ),
        _buildTimelineItem(
          'Delivered',
          '23 Aug 2023, 2023',
          Icons.card_giftcard_outlined,
          isCompleted: false,
        ),
      ],
    );
  }

  Widget _buildTimelineItem(String status, String date, IconData icon,
      {required bool isCompleted}) {
    final color = isCompleted ? MyColors.kPrimaryColor : Colors.grey[400];
    final textColor = isCompleted ? Colors.black : Colors.grey[600];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
              child: Icon(
                isCompleted ? Icons.check : Icons.circle,
                color: Colors.white,
                size: 16,
              ),
            ),
            if (status != 'Delivered')
              SizedBox(
                height: 50,
                child: VerticalDivider(
                  color: color,
                  thickness: 2,
                  width: 2,
                ),
              ),
          ],
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                status,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                date,
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
        ),
        Icon(icon, color: Colors.grey[400]),
      ],
    );
  }
}