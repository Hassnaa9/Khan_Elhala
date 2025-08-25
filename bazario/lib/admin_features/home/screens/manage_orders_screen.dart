// dart format width=80
import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';

import '../../../utils/constants/colors.dart';

@RoutePage()
class ManageOrdersScreen extends StatelessWidget {
  const ManageOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Orders',style: TextStyle(
          color: Colors.white,
          fontFamily: "Urbanist",
          fontSize: 24,
        ),),
        backgroundColor: MyColors.kPrimaryColor, // Use your primary color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Order Management',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: MyColors.secondaryPrimaryColor,
                fontFamily: "Urbanist",
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'View, filter, and update the status of customer orders.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 20),

            // User-friendly features: Search, filter, and sort
            // You will implement these here.
            // Example: A Row for search bar and a filter button
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search by Order ID or Customer',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  icon: const Icon(Icons.filter_list),
                  onPressed: () {
                    // Implement filtering logic
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),

            // List of orders
            // Use a ListView, DataTable, or a custom widget to display orders
            Expanded(
              child: ListView.builder(
                itemCount: 10, // Replace with your actual order count
                itemBuilder: (context, index) {
                  // This is a placeholder for a single order item.
                  // You should replace this with a widget that displays
                  // order details like ID, customer, date, status, etc.
                  return Card(
                    elevation: 2,
                    color: Colors.white,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: const Icon(Icons.shopping_bag),
                      title: Text('Order #${1000 + index}'),
                      subtitle: const Text('Customer: Jane Doe - Status: Processing'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        // Navigate to a detailed order screen
                        // context.router.push(OrderDetailsRoute(orderId: '...'));
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}