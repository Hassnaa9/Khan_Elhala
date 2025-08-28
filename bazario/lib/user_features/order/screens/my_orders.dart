// my_orders_screen.dart
import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:bazario/app/app_router.gr.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive_ce/hive.dart';
import 'package:bazario/utils/constants/colors.dart';
import 'package:provider/provider.dart';

import '../../../data/repositories/payment_provider.dart';

@RoutePage()
class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String _selectedFilter = 'all';
  bool _isLoading = false;
  List<Map<String, dynamic>> _localOrders = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadLocalOrders();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /// Load orders from local Hive storage
  void _loadLocalOrders() {
    setState(() {
      _isLoading = true;
    });

    try {
      if (Hive.isBoxOpen('transactions')) {
        final transactionsBox = Hive.box('transactions');
        _localOrders = transactionsBox.values
            .map((e) => Map<String, dynamic>.from(e))
            .toList()
            .reversed
            .toList(); // Most recent first
      }
    } catch (e) {
      print('Error loading local orders: $e');
      _localOrders = [];
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'My Orders',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontFamily: 'Urbanist',
          ),
        ),
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
              const PopupMenuItem(value: 'this_month', child: Text('This Month')),
            ],
            icon: const Icon(Icons.filter_list, color: Colors.black),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: MyColors.kPrimaryColor,
          unselectedLabelColor: Colors.grey,
          indicatorColor: MyColors.kPrimaryColor,
          tabs: const [
            Tab(text: 'Cloud Orders'),
            Tab(text: 'Local Orders'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildCloudOrdersTab(),
          _buildLocalOrdersTab(),
        ],
      ),
    );
  }

  /// Build cloud orders tab (from Firebase)
  Widget _buildCloudOrdersTab() {
    final user = _auth.currentUser;

    if (user == null) {
      return _buildEmptyState(
        icon: Icons.person_off,
        title: 'Not Signed In',
        subtitle: 'Please sign in to view your cloud orders',
        action: ElevatedButton(
          onPressed: () {
            // Navigate to sign in
            context.router.push(const SignInRoute());
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: MyColors.kPrimaryColor,
            foregroundColor: Colors.white,
          ),
          child: const Text('Sign In'),
        ),
      );
    }

    return Consumer<PaymentProvider>(
      builder: (context, paymentProvider, child) {
        if (!paymentProvider.isInitialized) {
          return const Center(child: CircularProgressIndicator());
        }

        final appId = paymentProvider.appId;

        return StreamBuilder<QuerySnapshot>(
          stream: _getCloudOrdersStream(user.uid, appId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return _buildErrorState(snapshot.error.toString());
            }

            final orders = snapshot.data?.docs ?? [];
            final filteredOrders = _filterOrders(orders.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              data['_docId'] = doc.id;
              return data;
            }).toList());

            if (filteredOrders.isEmpty) {
              return _buildEmptyState(
                icon: Icons.shopping_cart_outlined,
                title: 'No Orders Found',
                subtitle: _selectedFilter == 'all'
                    ? 'You haven\'t made any orders yet'
                    : 'No orders match the selected filter',
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                setState(() {}); // Refresh the stream
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: filteredOrders.length,
                itemBuilder: (context, index) {
                  final order = filteredOrders[index];
                  return _buildCloudOrderCard(order);
                },
              ),
            );
          },
        );
      },
    );
  }

  /// Build local orders tab (from Hive)
  Widget _buildLocalOrdersTab() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final filteredOrders = _filterLocalOrders(_localOrders);

    if (filteredOrders.isEmpty) {
      return _buildEmptyState(
        icon: Icons.storage,
        title: 'No Local Orders',
        subtitle: _selectedFilter == 'all'
            ? 'No orders stored locally on this device'
            : 'No local orders match the selected filter',
        action: ElevatedButton(
          onPressed: _loadLocalOrders,
          style: ElevatedButton.styleFrom(
            backgroundColor: MyColors.kPrimaryColor,
            foregroundColor: Colors.white,
          ),
          child: const Text('Refresh'),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        _loadLocalOrders();
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: filteredOrders.length,
        itemBuilder: (context, index) {
          final order = filteredOrders[index];
          return _buildLocalOrderCard(order);
        },
      ),
    );
  }

  /// Get cloud orders stream from Firebase
  Stream<QuerySnapshot> _getCloudOrdersStream(String userId, String appId) {
    return _firestore
        .collection('artifacts')
        .doc(appId)
        .collection('public')
        .doc('data')
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  /// Filter cloud orders based on selected filter
  List<Map<String, dynamic>> _filterOrders(List<Map<String, dynamic>> orders) {
    switch (_selectedFilter) {
      case 'completed':
        return orders.where((order) => order['status'] == 'completed').toList();
      case 'pending':
        return orders.where((order) => order['status'] == 'pending').toList();
      case 'this_month':
        final now = DateTime.now();
        final thisMonth = DateTime(now.year, now.month, 1);
        return orders.where((order) {
          final timestamp = order['timestamp'];
          if (timestamp is Timestamp) {
            return timestamp.toDate().isAfter(thisMonth);
          } else if (order['createdAt'] != null) {
            final date = DateTime.tryParse(order['createdAt'].toString());
            return date?.isAfter(thisMonth) ?? false;
          }
          return false;
        }).toList();
      default:
        return orders;
    }
  }

  /// Filter local orders based on selected filter
  List<Map<String, dynamic>> _filterLocalOrders(List<Map<String, dynamic>> orders) {
    switch (_selectedFilter) {
      case 'completed':
        return orders.where((order) => order['status'] == 'completed').toList();
      case 'pending':
        return orders.where((order) => order['status'] == 'pending').toList();
      case 'this_month':
        final now = DateTime.now();
        final thisMonth = DateTime(now.year, now.month, 1);
        return orders.where((order) {
          final timestamp = order['timestamp'];
          if (timestamp != null) {
            final date = DateTime.tryParse(timestamp.toString());
            return date?.isAfter(thisMonth) ?? false;
          }
          return false;
        }).toList();
      default:
        return orders;
    }
  }

  /// Build cloud order card
  Widget _buildCloudOrderCard(Map<String, dynamic> orderData) {
    final orderId = orderData['orderId']?.toString() ?? orderData['_docId'] ?? 'Unknown';
    final amount = double.tryParse(orderData['amount']?.toString() ?? '0') ?? 0.0;
    final currency = orderData['currency']?.toString().toUpperCase() ?? 'USD';
    final paymentMethod = orderData['paymentMethod']?.toString() ?? 'Unknown';
    final status = orderData['status']?.toString() ?? 'Unknown';

    DateTime? orderDate;
    final timestamp = orderData['timestamp'];
    if (timestamp is Timestamp) {
      orderDate = timestamp.toDate();
    } else if (orderData['createdAt'] != null) {
      orderDate = DateTime.tryParse(orderData['createdAt'].toString());
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 0,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Order header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Order #${_truncateId(orderId)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            fontFamily: 'Urbanist',
                          ),
                        ),
                        if (orderDate != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            _formatDateTime(orderDate),
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                              fontFamily: 'Urbanist',
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  _buildStatusChip(status),
                ],
              ),

              const SizedBox(height: 16),

              // Order details
              Row(
                children: [
                  Expanded(
                    child: _buildDetailColumn(
                      'Amount',
                      '$currency ${amount.toStringAsFixed(2)}',
                      Icons.attach_money,
                    ),
                  ),
                  Expanded(
                    child: _buildDetailColumn(
                      'Payment',
                      _formatPaymentMethod(paymentMethod),
                      _getPaymentMethodIcon(paymentMethod),
                    ),
                  ),
                ],
              ),

              if (orderData['cardInfo'] != null) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.credit_card, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 8),
                    Text(
                      '**** ${orderData['cardInfo']['lastFour'] ?? '****'}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                        fontFamily: 'Urbanist',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      orderData['cardInfo']['cardHolderName'] ?? '',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                        fontFamily: 'Urbanist',
                      ),
                    ),
                  ],
                ),
              ],

              const SizedBox(height: 16),

              // Action buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: () => _showOrderDetails(orderData, isCloud: true),
                    icon: const Icon(Icons.info_outline, size: 16),
                    label: const Text('Details'),
                    style: TextButton.styleFrom(
                      foregroundColor: MyColors.kPrimaryColor,
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (status.toLowerCase() == 'completed')
                    TextButton.icon(
                      onPressed: () => _reorderOrder(orderData),
                      icon: const Icon(Icons.refresh, size: 16),
                      label: const Text('Reorder'),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.green,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build local order card
  Widget _buildLocalOrderCard(Map<String, dynamic> orderData) {
    final orderId = orderData['id']?.toString() ?? 'Unknown';
    final amount = double.tryParse(orderData['amount']?.toString() ?? '0') ?? 0.0;
    final currency = orderData['currency']?.toString().toUpperCase() ?? 'USD';
    final paymentMethod = orderData['method']?.toString() ?? 'Unknown';
    final status = orderData['status']?.toString() ?? 'Unknown';

    DateTime? orderDate;
    if (orderData['timestamp'] != null) {
      orderDate = DateTime.tryParse(orderData['timestamp'].toString());
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 0,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.orange[200]!),
          color: Colors.orange[50],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Local badge and order info
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.orange[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.storage, size: 12, color: Colors.orange[700]),
                        const SizedBox(width: 4),
                        Text(
                          'LOCAL',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  _buildStatusChip(status),
                ],
              ),

              const SizedBox(height: 12),

              // Order details
              Text(
                'Order #${_truncateId(orderId)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  fontFamily: 'Urbanist',
                ),
              ),

              if (orderDate != null) ...[
                const SizedBox(height: 4),
                Text(
                  _formatDateTime(orderDate),
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                    fontFamily: 'Urbanist',
                  ),
                ),
              ],

              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: _buildDetailColumn(
                      'Amount',
                      '$currency ${amount.toStringAsFixed(2)}',
                      Icons.attach_money,
                    ),
                  ),
                  Expanded(
                    child: _buildDetailColumn(
                      'Payment',
                      _formatPaymentMethod(paymentMethod),
                      _getPaymentMethodIcon(paymentMethod),
                    ),
                  ),
                ],
              ),

              if (orderData['cardData'] != null) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.credit_card, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 8),
                    Text(
                      '**** ${orderData['cardData']['lastFour'] ?? '****'}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                        fontFamily: 'Urbanist',
                      ),
                    ),
                    if (orderData['cardData']['cardHolderName'] != null) ...[
                      const SizedBox(width: 16),
                      Text(
                        orderData['cardData']['cardHolderName'],
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                          fontFamily: 'Urbanist',
                        ),
                      ),
                    ],
                  ],
                ),
              ],

              const SizedBox(height: 16),

              // Action button
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: () => _showOrderDetails(orderData, isCloud: false),
                    icon: const Icon(Icons.info_outline, size: 16),
                    label: const Text('Details'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.orange[700],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build detail column widget
  Widget _buildDetailColumn(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
                fontFamily: 'Urbanist',
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                fontFamily: 'Urbanist',
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Build status chip
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
          fontFamily: 'Urbanist',
        ),
      ),
    );
  }

  /// Build empty state widget
  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? action,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
                fontFamily: 'Urbanist',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
                fontFamily: 'Urbanist',
              ),
              textAlign: TextAlign.center,
            ),
            if (action != null) ...[
              const SizedBox(height: 24),
              action,
            ],
          ],
        ),
      ),
    );
  }

  /// Build error state widget
  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 80,
              color: Colors.red,
            ),
            const SizedBox(height: 24),
            const Text(
              'Error Loading Orders',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.red,
                fontFamily: 'Urbanist',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontFamily: 'Urbanist',
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                setState(() {}); // Refresh
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  /// Show order details dialog
  void _showOrderDetails(Map<String, dynamic> orderData, {required bool isCloud}) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          constraints: const BoxConstraints(maxHeight: 600),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isCloud ? MyColors.kPrimaryColor : Colors.orange,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      isCloud ? Icons.cloud : Icons.storage,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        isCloud ? 'Cloud Order Details' : 'Local Order Details',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Urbanist',
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close, color: Colors.white),
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...orderData.entries.map((entry) {
                        if (entry.key.startsWith('_')) return const SizedBox.shrink();

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 120,
                                child: Text(
                                  '${_formatKey(entry.key)}:',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    fontFamily: 'Urbanist',
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  _formatValue(entry.value),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Urbanist',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Reorder functionality
  void _reorderOrder(Map<String, dynamic> orderData) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reorder'),
        content: const Text('Would you like to place this order again?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Navigate to payment screen with order details
              context.router.push(PaymentMethodsRoute(
               ));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: MyColors.kPrimaryColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Reorder'),
          ),
        ],
      ),
    );
  }

  /// Helper methods
  String _truncateId(String id) {
    return id.length > 8 ? id.substring(0, 8) : id;
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

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

  IconData _getPaymentMethodIcon(String method) {
    switch (method.toLowerCase()) {
      case 'card':
        return Icons.credit_card;
      case 'paypal':
        return Icons.account_balance_wallet;
      case 'applepay':
        return Icons.phone_iphone;
      case 'googlepay':
        return Icons.android;
      case 'cashondelivery':
        return Icons.money;
      default:
        return Icons.payment;
    }
  }

  String _formatKey(String key) {
    return key.split('_').map((word) =>
    word[0].toUpperCase() + word.substring(1)
    ).join(' ');
  }

  String _formatValue(dynamic value) {
    if (value is Timestamp) {
      return _formatDateTime(value.toDate());
    } else if (value is Map) {
      return value.entries.map((e) => '${e.key}: ${e.value}').join(', ');
    } else if (value is List) {
      return value.join(', ');
    }
    return value.toString();
  }
}