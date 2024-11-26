import 'package:flutter/material.dart';

class OrderItem {
  final String id;
  final String imagePreview;
  final String title;
  final String ownerUsername;
  final double price;

  OrderItem({
    required this.id,
    required this.imagePreview,
    required this.title,
    required this.ownerUsername,
    required this.price,
  });
}

class OrderDetailScreen extends StatefulWidget {
  final String orderId;

  const OrderDetailScreen({Key? key, required this.orderId}) : super(key: key);

  @override
  _OrderDetailScreenState createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  // Dữ liệu giả cho danh sách orderItem
  List<OrderItem> orderItems = [
    OrderItem(
      id: '1',
      imagePreview: 'http://10.147.20.214:9000/easy-english/image/course2.jpg',
      title: 'Smartphone',
      ownerUsername: 'john_doe',
      price: 699.99,
    ),
    OrderItem(
      id: '2',
      imagePreview: 'http://10.147.20.214:9000/easy-english/image/course2.jpg',
      title: 'Laptop',
      ownerUsername: 'jane_doe',
      price: 999.99,
    ),
    OrderItem(
      id: '3',
      imagePreview: 'http://10.147.20.214:9000/easy-english/image/course2.jpg',
      title: 'Headphones',
      ownerUsername: 'alice_smith',
      price: 199.99,
    ),
    OrderItem(
      id: '4',
      imagePreview: 'http://10.147.20.214:9000/easy-english/image/course2.jpg',
      title: 'Smartwatch',
      ownerUsername: 'bob_brown',
      price: 249.99,
    ),
  ];

  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    // Lọc danh sách orderItems theo title
    List<OrderItem> filteredOrderItems = orderItems.where((item) {
      return item.title.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Order Detail: ${widget.orderId}'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Tìm kiếm theo title
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
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
          // Danh sách orderItem
          Expanded(
            child: ListView.builder(
              itemCount: filteredOrderItems.length,
              itemBuilder: (context, index) {
                final item = filteredOrderItems[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 4.0),
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          item.imagePreview,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Icon(Icons.error, size: 50),
                        ),
                      ),
                      title: Text(
                        item.title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Teacher: ${item.ownerUsername}'),
                          Text(
                            '\$${item.price.toStringAsFixed(2)}',
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      // Xóa nút `>` bên phải
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