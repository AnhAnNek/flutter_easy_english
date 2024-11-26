import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'order_detail_screen.dart';

class Order {
  final String id;
  final double totalAmount;
  final String currency;
  String status;
  final String updatedAt;
  final String username;

  Order({
    required this.id,
    required this.totalAmount,
    required this.currency,
    required this.status,
    required this.updatedAt,
    required this.username,
  });
}

class OrderTabScreen extends StatefulWidget {
  @override
  _OrderTabScreenState createState() => _OrderTabScreenState();
}

class _OrderTabScreenState extends State<OrderTabScreen> {
  // Sample data
  List<Order> orders = [
    Order(
      id: '1',
      totalAmount: 100.0,
      currency: 'USD',
      status: 'PENDING_PAYMENT',
      updatedAt: '2024-11-24',
      username: 'john_doe',
    ),
    Order(
      id: '2',
      totalAmount: 200.0,
      currency: 'USD',
      status: 'PAID',
      updatedAt: '2024-11-23',
      username: 'jane_doe',
    ),
    Order(
      id: '3',
      totalAmount: 150.0,
      currency: 'USD',
      status: 'REFUNDED',
      updatedAt: '2024-11-22',
      username: 'john_doe',
    ),
    Order(
      id: '4',
      totalAmount: 50.0,
      currency: 'USD',
      status: 'FAILED',
      updatedAt: '2024-11-21',
      username: 'alice_smith',
    ),
  ];

  String searchQuery = '';
  String selectedStatus = 'ALL';

  // Order statuses
  final List<String> statuses = [
    'ALL',
    'PENDING_PAYMENT',
    'PAID',
    'FAILED',
    'REFUNDED',
    'EXPIRED',
  ];

  // Map for converting status values to display-friendly text
  final Map<String, String> statusDisplayMap = {
    'PENDING_PAYMENT': 'PENDING',
    'PAID': 'PAID',
    'FAILED': 'FAILED',
    'REFUNDED': 'REFUNDED',
    'EXPIRED': 'EXPIRED',
    'ALL': 'ALL',
  };

  // Helper method to get display-friendly status text
  String getDisplayStatus(String status) {
    return statusDisplayMap[status] ?? status;
  }

  @override
  Widget build(BuildContext context) {
    // Filter orders by username and status
    List<Order> filteredOrders = orders.where((order) {
      final matchesUsername = order.username
          .toLowerCase()
          .contains(searchQuery.toLowerCase());

      final matchesStatus =
          selectedStatus == 'ALL' || order.status == selectedStatus;

      return matchesUsername && matchesStatus;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order List'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Username search field
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search by Username',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),
          // Status filter dropdown
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: DropdownButtonFormField<String>(
              value: selectedStatus,
              items: statuses.map((status) {
                return DropdownMenuItem(
                  value: status,
                  child: Text(getDisplayStatus(status)),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: 'Filter by Status',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  selectedStatus = value!;
                });
              },
            ),
          ),
          const SizedBox(height: 10),
          // Order list
          Expanded(
            child: ListView.builder(
              itemCount: filteredOrders.length,
              itemBuilder: (context, index) {
                final order = filteredOrders[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 4.0),
                  child: Slidable(
                    key: ValueKey(order.id),
                    endActionPane: ActionPane(
                      motion: const DrawerMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (context) {
                            // Implement delete functionality
                            setState(() {
                              orders.remove(order);
                            });
                          },
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: 'Delete',
                        ),
                      ],
                    ),
                    child: Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        title: Text(
                          'Order ID: ${order.id}',
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Username: ${order.username}'),
                            Text('Price: ${order.totalAmount.toStringAsFixed(2)} ${order.currency}'),
                            Text('Updated At: ${order.updatedAt}'),
                          ],
                        ),
                        trailing: DropdownButton<String>(
                          value: order.status,
                          items: statuses
                              .where((status) => status != 'ALL') // Exclude "ALL"
                              .map((status) => DropdownMenuItem(
                            value: status,
                            child: Text(getDisplayStatus(status)),
                          ))
                              .toList(),
                          onChanged: (value) {
                            if (value != null && value != order.status) {
                              showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: Text('Confirm Status Change'),
                                  content: Text(
                                      'Are you sure you want to change the status to "${getDisplayStatus(value)}"?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(ctx).pop();
                                      },
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        setState(() {
                                          order.status = value;
                                        });
                                        Navigator.of(ctx).pop();
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Order status updated to "${getDisplayStatus(value)}"',
                                            ),
                                          ),
                                        );
                                      },
                                      child: const Text('Confirm'),
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                        ),
                        onTap: () {
                          // Navigate to the order detail screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OrderDetailScreen(
                                orderId: order.id, // Pass the order ID
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}