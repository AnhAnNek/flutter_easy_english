import 'package:flutter/material.dart';
import 'package:flutter_easy_english/screens/category_screen.dart';
import 'package:flutter_easy_english/screens/course_screen.dart';
import 'package:flutter_easy_english/screens/level_screen.dart';
import 'package:flutter_easy_english/screens/topic_screen.dart';

class CourseTabScreen extends StatelessWidget {
  final List<String> courseItems = [
    'Course',
    'Level',
    'Topic',
    'Category',
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: courseItems.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Icon(Icons.book_outlined, color: Colors.blue),
          title: Text(courseItems[index]),
          trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          onTap: () {
            // Chuyển màn hình tương ứng
            switch (index) {
              case 0:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CourseScreen()),
                );
                break;
              case 1:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LevelScreen()),
                );
                break;
              case 2:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TopicScreen()),
                );
                break;
              case 3:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CategoryScreen()),
                );
                break;
            }
          },
        );
      },
    );
  }
}
