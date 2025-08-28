// admin_dashboard_orders_screen.dart
import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bazario/utils/constants/colors.dart';
@RoutePage()
class AdminOrders extends StatefulWidget {

  const AdminOrders({
    super.key,
  });

  @override
  State<AdminOrders> createState() => _AdminOrdersState();
}

class _AdminOrdersState extends State<AdminOrders> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _selectedFilter = 'all';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders Dashboard'),
        backgroundColor: MyColors.kPrimaryColor,
        foregroundColor: Colors.white,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                _selectedFilter = value;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'all', child: Text('All Orders')),
              const PopupMenuItem(value: 'completed', child: Text('Completed')),
              const PopupMenuItem(value: 'pending', child: Text('Pending')),
              const PopupMenuItem(value: 'today', child: Text('Today')),
            ],
            icon: const Icon(Icons.filter_list),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _getOrdersStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Error: ${snapshot.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {}); // Refresh
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final orders = snapshot.data?.docs ?? [];

          if (orders.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No orders found',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Orders will appear here when customers make purchases',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              // Summary Cards
              Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    _buildSummaryCard(
                      'Total Orders',
                      orders.length.toString(),
                      Icons.shopping_cart,
                      MyColors.kPrimaryColor,
                    ),
                    const SizedBox(width: 16),
                    _buildSummaryCard(
                      'Revenue',
                      _calculateTotalRevenue(orders),
                      Icons.attach_money,
                      Colors.green,
                    ),
                  ],
                ),
              ),

              // Orders List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    final orderData = order.data() as Map<String, dynamic>;

                    return _buildOrderCard(orderData, order.id);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  /// Get orders stream based on selected filter
  Stream<QuerySnapshot> _getOrdersStream() {
    Query query = _firestore
        .collection('artifacts')
        .doc('bazario')
        .collection('public')
        .doc('data')
        .collection('orders')
        .orderBy('timestamp', descending: true);

    switch (_selectedFilter) {
      case 'completed':
        query = query.where('status', isEqualTo: 'completed');
        break;
      case 'pending':
        query = query.where('status', isEqualTo: 'pending');
        break;
      case 'today':
        final today = DateTime.now();
        final startOfDay = DateTime(today.year, today.month, today.day);
        query = query.where('timestamp', isGreaterThanOrEqualTo: startOfDay);
        break;
    }

    return query.snapshots();
  }

  /// Build summary card widget
  Widget _buildSummaryCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build order card widget
  Widget _buildOrderCard(Map<String, dynamic> orderData, String documentId) {
    final amount = orderData['amount']?.toString() ?? '0.00';
    final currency = orderData['currency']?.toString().toUpperCase() ?? 'USD';
    final paymentMethod = orderData['paymentMethod']?.toString() ?? 'Unknown';
    final status = orderData['status']?.toString() ?? 'Unknown';
    final orderId = orderData['orderId']?.toString() ?? documentId;
    final userId = orderData['userId']?.toString() ?? 'Anonymous';

    // Handle timestamp
    final timestamp = orderData['timestamp'];
    DateTime? orderDate;
    if (timestamp is Timestamp) {
      orderDate = timestamp.toDate();
    } else if (orderData['createdAt'] != null) {
      orderDate = DateTime.tryParse(orderData['createdAt'].toString());
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order #${orderId.length > 8 ? orderId.substring(0, 8) : orderId}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      if (orderDate != null)
                        Text(
                          _formatDateTime(orderDate),
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                ),
                _buildStatusChip(status),
              ],
            ),

            const SizedBox(height: 12),

            // Order Details
            Row(
              children: [
                Expanded(
                  child: _buildDetailItem('Amount', '$currency $amount'),
                ),
                Expanded(
                  child: _buildDetailItem('Payment', _formatPaymentMethod(paymentMethod)),
                ),
              ],
            ),

            const SizedBox(height: 8),

            Row(
              children: [
                Expanded(
                  child: _buildDetailItem('Customer ID', userId.length > 10 ? '${userId.substring(0, 10)}...' : userId),
                ),
                if (orderData['cardInfo'] != null)
                  Expanded(
                    child: _buildDetailItem(
                      'Card',
                      '**** ${orderData['cardInfo']['lastFour'] ?? '****'}',
                    ),
                  ),
              ],
            ),

            // Action Buttons
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => _showOrderDetails(orderData, documentId),
                  child: const Text('View Details'),
                ),
                if (status == 'pending') ...[
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () => _updateOrderStatus(documentId, 'completed'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Mark Complete'),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Build detail item widget
  Widget _buildDetailItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  /// Build status chip widget
  Widget _buildStatusChip(String status) {
    Color chipColor;
    switch (status.toLowerCase()) {
      case 'completed':
        chipColor = Colors.green;
        break;
      case 'pending':
        chipColor = Colors.orange;
        break;
      case 'cancelled':
        chipColor = Colors.red;
        break;
      default:
        chipColor = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: chipColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: chipColor.withOpacity(0.3)),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: chipColor,
        ),
      ),
    );
  }

  /// Calculate total revenue from orders
  String _calculateTotalRevenue(List<QueryDocumentSnapshot> orders) {
    double total = 0.0;
    for (final order in orders) {
      final data = order.data() as Map<String, dynamic>;
      final amount = double.tryParse(data['amount']?.toString() ?? '0') ?? 0.0;
      total += amount;
    }
    return '\$${total.toStringAsFixed(2)}';
  }

  /// Format payment method for display
  String _formatPaymentMethod(String method) {
    switch (method.toLowerCase()) {
      case 'card':
        return 'Card';
      case 'paypal':
        return 'PayPal';
      case 'applepay':
        return 'Apple Pay';
      case 'googlepay':
        return 'Google Pay';
      case 'cashondelivery':
        return 'COD';
      default:
        return method;
    }
  }

  /// Format date time for display
  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  /// Show order details dialog
  void _showOrderDetails(Map<String, dynamic> orderData, String documentId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Order Details #${orderData['orderId'] ?? documentId}'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ...orderData.entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 100,
                        child: Text(
                          '${entry.key}:',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(child: Text(entry.value.toString())),
                    ],
                  ),
                );
              }).toList(),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  /// Update order status
  Future<void> _updateOrderStatus(String documentId, String newStatus) async {
    try {
      await _firestore
          .collection('artifacts')
          .doc('bazario')
          .collection('public')
          .doc('data')
          .collection('orders')
          .doc(documentId)
          .update({
        'status': newStatus,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Order status updated to $newStatus'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update order: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}