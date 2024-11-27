import 'package:flutter/material.dart';
import 'package:flutter_easy_english/services/i_order_service.dart';
import 'package:flutter_easy_english/utils/toast_utils.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:logger/logger.dart';
import '../utils/methods.dart';
import 'order_detail_screen.dart';

class OrderTabScreen extends StatefulWidget {
  @override
  _OrderTabScreenState createState() => _OrderTabScreenState();
}

class _OrderTabScreenState extends State<OrderTabScreen> {
  final _logger = Logger();
  late final IOrderService _orderService;
  List<Map<String, dynamic>> orders = [];
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

  final Map<String, String> statusDisplayMap = {
    'PENDING_PAYMENT': 'PENDING',
    'PAID': 'PAID',
    'FAILED': 'FAILED',
    'REFUNDED': 'REFUNDED',
    'EXPIRED': 'EXPIRED',
    'ALL': 'ALL',
  };

  String getDisplayStatus(String status) {
    return statusDisplayMap[status] ?? status;
  }

  @override
  void initState() {
    super.initState();
    _orderService =
    Provider.of<IOrderService>(context, listen: false);

    _fetchOrders(); // Fetch initial orders
  }

  Future<void> _fetchOrders() async {
    try {
      final fetchedOrders = await _orderService.getOrdersForAdmin(0, 100);
      setState(() {
        orders = fetchedOrders['content']?.cast<Map<String, dynamic>>() ?? [];
      });
    } catch (error) {
      _logger.e('Error fetching orders: $error');
    }
  }

  Future<void> _updateOrderStatus(orderId, newStatus) async {
    try {
      IOrderService orderService =
      Provider.of<IOrderService>(context, listen: false);

      await orderService.updateOrderStatus(orderId, newStatus);
      setState(() {
        orders = orders.map((order) {
          if (order['id'] == orderId) {
            order['status'] = newStatus;
          }
          return order;
        }).toList();
      });
      ToastUtils.showInfo('Order status updated to "${getDisplayStatus(newStatus)}"');
    } catch (error) {
      _logger.i('Error updating order status: $error');
      ToastUtils.showError('$error');
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredOrders = orders.where((order) {
      final matchesUsername = order['username']
          .toString()
          .toLowerCase()
          .contains(searchQuery.toLowerCase());

      final matchesStatus =
          selectedStatus == 'ALL' || order['status'] == selectedStatus;

      return matchesUsername && matchesStatus;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order List'),
        centerTitle: true,
      ),
      body: Column(
        children: [
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
          Expanded(
            child: ListView.builder(
              itemCount: filteredOrders.length,
              itemBuilder: (context, index) {
                final order = filteredOrders[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 4.0),
                  child: Slidable(
                    key: ValueKey(order['id']),
                    endActionPane: ActionPane(
                      motion: const DrawerMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (context) {
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
                          'Order ID: ${order['id']}',
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Username: ${order['username']}'),
                            Text(
                              'Price: ${vndFormat.format(order['totalAmount'] ?? 0)}',
                            ),
                            Text('Updated At: ${order['updatedAt']}'),
                          ],
                        ),
                        trailing: DropdownButton<String>(
                          value: order['status'],
                          items: statuses
                              .where((status) => status != 'ALL')
                              .map((status) => DropdownMenuItem(
                            value: status,
                            child: Text(getDisplayStatus(status)),
                          ))
                              .toList(),
                          onChanged: (value) {
                            if (value != null && value != order['status']) {
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
                                        _updateOrderStatus(order['id'], value);
                                        Navigator.of(ctx).pop();
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OrderDetailScreen(
                                order: order,
                                orderService: _orderService,
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