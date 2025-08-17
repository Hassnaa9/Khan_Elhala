// dart format width=80
import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:bazario/app/app_router.gr.dart';
import 'package:bazario/utils/constants/image_strings.dart';
import 'package:flutter/material.dart';
import 'package:bazario/utils/constants/colors.dart';

// Placeholder model for an Order Item
class OrderItem {
  final String imageUrl;
  final String productName;
  final String details;
  final double price;

  OrderItem({
    required this.imageUrl,
    required this.productName,
    required this.details,
    required this.price,
  });
}

@RoutePage()
class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<OrderItem> _activeOrders = [
    OrderItem(
      imageUrl: ImagesUrl.prod1Img,
      productName: 'Brown Jacket',
      details: 'Size: XL | Qty: 10pcs',
      price: 83.97,
    ),
    OrderItem(
      imageUrl: ImagesUrl.prod2Img,
      productName: 'Brown Suit',
      details: 'Size: XL | Qty: 10pcs',
      price: 120.00,
    ),
    OrderItem(
      imageUrl: ImagesUrl.prod3Img,
      productName: 'Brown Suit',
      details: 'Size: XL | Qty: 10pcs',
      price: 120.00,
    ),
  ];

  final List<OrderItem> _completedOrders = [
    OrderItem(
      imageUrl: ImagesUrl.prod3Img,
      productName: 'Brown Jacket',
      details: 'Size: XL | Qty: 10pcs',
      price: 83.97,
    ),
    OrderItem(
      imageUrl: ImagesUrl.prod4Img,
      productName: 'Brown Suit',
      details: 'Size: XL | Qty: 10pcs',
      price: 120.00,
    ),
  ];

  final List<OrderItem> _cancelledOrders = [
    OrderItem(
      imageUrl: ImagesUrl.prod5Img,
      productName: 'Brown Jacket',
      details: 'Size: XL | Qty: 10pcs',
      price: 83.97,
    ),
    OrderItem(
      imageUrl: ImagesUrl.prod2Img,
      productName: 'Brown Suit',
      details: 'Size: XL | Qty: 10pcs',
      price: 120.00,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
          onPressed: () => context.router.pop(),
        ),
        title: const Text(
          'My Orders',
          style: TextStyle(color: Colors.black),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: MyColors.kPrimaryColor,
          unselectedLabelColor: Colors.black54,
          indicatorColor: MyColors.kPrimaryColor,
          indicatorSize: TabBarIndicatorSize.label,
          labelStyle: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 16),
          unselectedLabelStyle: const TextStyle(fontSize: 14),
          tabs: const [
            Tab(text: 'Active'),
            Tab(text: 'Completed'),
            Tab(text: 'Cancelled'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOrderList(_activeOrders, 'Track Order'),
          _buildOrderList(_completedOrders, 'Leave Review'),
          _buildOrderList(_cancelledOrders, 'Re-Order'),
        ],
      ),
    );
  }

  Widget _buildOrderList(List<OrderItem> orders, String buttonText) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return _buildOrderCard(order, buttonText);
        },
      ),
    );
  }

  Widget _buildOrderCard(OrderItem order, String buttonText) {
    Color buttonColor = MyColors.kPrimaryColor;
    Color buttonTextColor = Colors.white;
    onPressed() {
      if(buttonText =='Leave Review') {
        context.router.push(LeaveReviewRoute());
      } else if(buttonText == 'Track Order')
        {context.router.push(TrackOrderRoute());}
    }

    if (buttonText == 'Leave Review' || buttonText == 'Re-Order') {
      buttonColor = Colors.transparent;
      buttonTextColor = MyColors.kPrimaryColor;
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                order.imageUrl,
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
                  Text(
                    order.productName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    order.details,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '\$${order.price.toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 15),
            ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                foregroundColor: buttonTextColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                  side: (buttonText == 'Leave Review' || buttonText == 'Re-Order')
                      ? BorderSide(color: MyColors.kPrimaryColor)
                      : BorderSide.none,
                ),
                padding: const EdgeInsets.symmetric(
                    horizontal: 15, vertical: 10),
                elevation: (buttonText == 'Leave Review' || buttonText == 'Re-Order') ? 0 : null,
              ),
              child: Text(
                buttonText,
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}