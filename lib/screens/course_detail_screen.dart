import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

// Đối tượng Course
class Course {
  String title;
  String description;
  String ownerUsername;
  String imagePreview;
  String topic;
  String level;
  String category;
  String duration;
  String status;

  Course({
    required this.title,
    required this.description,
    required this.ownerUsername,
    required this.imagePreview,
    required this.topic,
    required this.level,
    required this.category,
    required this.duration,
    required this.status,
  });
}

class CourseDetailScreen extends HookWidget {
  // Dữ liệu giả cho dropdowns
  final List<String> topics = ["Programming", "Design", "Marketing", "Business"];
  final List<String> levels = ["Beginner", "Intermediate", "Advanced"];
  final List<String> categories = ["Technology", "Art", "Science", "Math"];
  final List<String> statuses = ["Active", "Inactive", "Draft"];

  CourseDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Fake dữ liệu cho Course
    final course = useState(
      Course(
        title: "Flutter Development",
        description: "Learn how to build beautiful and responsive apps with Flutter.",
        ownerUsername: "john_doe",
        imagePreview: "http://10.147.20.214:9000/easy-english/image/course2.jpg",
        topic: "Programming",
        level: "Beginner",
        category: "Technology",
        duration: "15",
        status: "Active",
      ),
    );

    // Hooks để quản lý dropdowns
    final selectedTopic = useState(course.value.topic);
    final selectedLevel = useState(course.value.level);
    final selectedCategory = useState(course.value.category);
    final selectedStatus = useState(course.value.status);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Course Details",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white70,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Preview
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(
                    course.value.imagePreview,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Title
              Text(
                "Title",
                style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 5),
              TextField(
                controller: TextEditingController(text: course.value.title),
                onChanged: (value) => course.value.title = value,
                decoration: InputDecoration(
                  hintText: "Enter course title",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Description
              Text(
                "Description",
                style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 5),
              TextField(
                controller: TextEditingController(text: course.value.description),
                onChanged: (value) => course.value.description = value,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: "Enter course description",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Owner Username
              Text(
                "Owner Username",
                style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 5),
              TextField(
                controller: TextEditingController(text: course.value.ownerUsername),
                onChanged: (value) => course.value.ownerUsername = value,
                decoration: InputDecoration(
                  hintText: "Enter owner username",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Topic Dropdown
              Text(
                "Topic",
                style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 5),
              DropdownButtonFormField<String>(
                value: selectedTopic.value,
                items: topics
                    .map((topic) => DropdownMenuItem(
                  value: topic,
                  child: Text(topic),
                ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    selectedTopic.value = value;
                    course.value.topic = value;
                  }
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Level Dropdown
              Text(
                "Level",
                style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 5),
              DropdownButtonFormField<String>(
                value: selectedLevel.value,
                items: levels
                    .map((level) => DropdownMenuItem(
                  value: level,
                  child: Text(level),
                ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    selectedLevel.value = value;
                    course.value.level = value;
                  }
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Category Dropdown
              Text(
                "Category",
                style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 5),
              DropdownButtonFormField<String>(
                value: selectedCategory.value,
                items: categories
                    .map((category) => DropdownMenuItem(
                  value: category,
                  child: Text(category),
                ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    selectedCategory.value = value;
                    course.value.category = value;
                  }
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Duration
              Text(
                "Duration (hours)",
                style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 5),
              TextField(
                controller: TextEditingController(text: course.value.duration),
                onChanged: (value) => course.value.duration = value,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "Enter course duration",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Status Dropdown
              Text(
                "Status",
                style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 5),
              DropdownButtonFormField<String>(
                value: selectedStatus.value,
                items: statuses
                    .map((status) => DropdownMenuItem(
                  value: status,
                  child: Text(status),
                ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    selectedStatus.value = value;
                    course.value.status = value;
                  }
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Save Button
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    EasyLoading.showSuccess("Course details saved!");
                  },
                  icon: const Icon(FontAwesomeIcons.save),
                  label: Text(
                    "Save",
                    style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlue,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}