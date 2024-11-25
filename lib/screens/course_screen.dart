import 'package:flutter/material.dart';

import 'course_detail_screen.dart';

class CourseScreen extends StatefulWidget {
  @override
  _CourseScreenState createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  // Dữ liệu giả cho danh sách khóa học
  List<Map<String, dynamic>> courses = [
    {
      'title': 'Flutter for Beginners',
      'imagePreview':
      'http://10.147.20.214:9000/easy-english/image/course2.jpg', // URL giả cho hình ảnh
      'ownerUsername': 'John Doe',
      'price': 20.0,
    },
    {
      'title': 'Advanced Dart Programming',
      'imagePreview':
      'http://10.147.20.214:9000/easy-english/image/course2.jpg', // URL giả cho hình ảnh
      'ownerUsername': 'Jane Smith',
      'price': 25.0,
    },
    {
      'title': 'UI/UX Design Basics',
      'imagePreview':
      'http://10.147.20.214:9000/easy-english/image/course2.jpg', // URL giả cho hình ảnh
      'ownerUsername': 'Alice Johnson',
      'price': 15.0,
    },
    {
      'title': 'React Native Crash Course',
      'imagePreview':
      'http://10.147.20.214:9000/easy-english/image/course2.jpg', // URL giả cho hình ảnh
      'ownerUsername': 'Bob Williams',
      'price': 30.0,
    },
  ];

  // Biến để lưu trữ danh sách tìm kiếm
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    // Lọc danh sách khóa học dựa trên từ khóa tìm kiếm
    List<Map<String, dynamic>> filteredCourses = courses
        .where((course) =>
        course['title'].toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Courses'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Thanh tìm kiếm
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search Courses',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value; // Cập nhật từ khóa tìm kiếm
                });
              },
            ),
          ),
          // Danh sách khóa học
          Expanded(
            child: filteredCourses.isEmpty
                ? const Center(
              child: Text(
                'No courses found!',
                style:
                TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            )
                : ListView.builder(
              itemCount: filteredCourses.length,
              itemBuilder: (context, index) {
                final course = filteredCourses[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 5.0),
                  elevation: 2.0,
                  child: ListTile(
                    leading: Image.network(
                      course['imagePreview'],
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                    title: Text(
                      course['title'],
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                        'Teacher: ${course['ownerUsername']}\nPrice: \$${course['price']}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          courses.remove(course); // Xóa khóa học
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${course['title']} removed!'),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                    ),
                    onTap: () {
                      // Điều hướng đến màn hình chi tiết
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CourseDetailScreen(),
                        ),
                      );
                    },
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