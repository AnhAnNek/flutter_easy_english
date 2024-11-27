import 'package:flutter/material.dart';
import 'package:flutter_easy_english/services/i_order_service.dart';
import 'package:flutter_easy_english/utils/methods.dart';
import 'package:intl/intl.dart';

class OrderDetailScreen extends StatefulWidget {
  final dynamic order;
  final IOrderService orderService;

  const OrderDetailScreen({
    Key? key,
    required this.order,
    required this.orderService,
  }) : super(key: key);

  @override
  _OrderDetailScreenState createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  List<Map<String, dynamic>> orderItems = [];
  String searchQuery = '';
  int currentPage = 0;
  bool isLoading = false;
  bool isLastPage = false;

  @override
  void initState() {
    super.initState();
    _fetchOrderItems();
  }

  Future<void> _fetchOrderItems({bool isPagination = false}) async {
    if (isLoading || (isPagination && isLastPage)) return;

    setState(() {
      isLoading = true;
    });

    try {
      final data = await widget.orderService.getOrderItemsByOrderId(
        widget.order['id'].toString(),
        currentPage,
        10, // Page size
      );

      final List<Map<String, dynamic>> fetchedItems =
      List<Map<String, dynamic>>.from(data['content']);

      setState(() {
        if (isPagination) {
          orderItems.addAll(fetchedItems);
        } else {
          orderItems = fetchedItems;
        }
        isLastPage = data['last'] ?? true;
        currentPage++;
      });
    } catch (error) {
      // Handle any errors
      print('Error fetching order items: $error');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredOrderItems = orderItems.where((item) {
      return (item['course']['title'] as String)
          .toLowerCase()
          .contains(searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Order Detail: ${widget.order['id']}'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Order Summary
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Order ID: ${widget.order['id']}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          '${vndFormat.format(widget.order['totalAmount'] ?? 0)}',
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text('Currency: ${widget.order['currency'] ?? 'VND'}'),
                    Text(
                      'Created At: ${widget.order['createdAt'] != null ? dateFormat.format(DateTime.parse(widget.order['createdAt'])) : ''}',
                    ),
                    Text(
                      'Updated At: ${widget.order['updatedAt'] != null ? dateFormat.format(DateTime.parse(widget.order['updatedAt'])) : ''}',
                    ),
                    Text(
                      'Status: ${widget.order['status'] ?? ''}',
                    ),
                    Text('Username: ${widget.order['username'] ?? ''}'),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Search bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Search by Title',
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
          const SizedBox(height: 10),
          // Order Items List
          Expanded(
            child: ListView.builder(
              itemCount: filteredOrderItems.length + 1,
              itemBuilder: (context, index) {
                if (index == filteredOrderItems.length) {
                  // Show a loading indicator if fetching more data
                  return isLastPage
                      ? const SizedBox.shrink()
                      : const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                final item = filteredOrderItems[index];
                return Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          item['course']['imagePreview'] ?? '',
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.error, size: 50),
                        ),
                      ),
                      title: Text(
                        item['course']['title'] ?? '',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Teacher: ${item['course']['ownerUsername'] ?? ''}'),
                          Text(
                            '${vndFormat.format(item['price'] ?? 0)}',
                            style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
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