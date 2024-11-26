import 'package:flutter/material.dart';
import 'package:flutter_easy_english/services/i_category_service.dart';
import 'package:flutter_easy_english/services/i_level_service.dart';
import 'package:flutter_easy_english/services/i_topic_service.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CourseDetailScreen extends HookWidget {
  final Map<String?, String> statusDisplayMapping= {
    null: 'All',
    'PUBLISHED': 'Published',
    'REJECTED': 'Rejected',
    'PENDING_APPROVAL': 'Pending Approval',
    'DRAFT': 'Draft',
    'DELETED': 'Deleted',
  };

  CourseDetailScreen({
    Key? key,
    dynamic courseId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final levels = useState<List<Map<String, dynamic>>>([]);
    final topics = useState<List<Map<String, dynamic>>>([]);
    final categories = useState<List<Map<String, dynamic>>>([]);

    // Fake data for course
    final course = useState<Map<String, dynamic>>({
      'title': "Flutter Development",
      'description': "Learn how to build beautiful and responsive apps with Flutter.",
      'ownerUsername': "john_doe",
      'imagePreview': "http://10.147.20.214:9000/easy-english/image/course2.jpg",
      'topic': "Programming",
      'level': "Beginner",
      'category': "Technology",
      'duration': "15",
      'status': "PUBLISHED",
    });

    // Hooks for dropdowns
    final selectedTopic = useState(course.value["topic"]);
    final selectedLevel = useState(course.value["level"]);
    final selectedCategory = useState(course.value["category"]);
    final selectedStatus = useState(course.value["status"]);

    // Fetch dropdown data
    useEffect(() {
      Future.microtask(() async {
        try {
          final ILevelService levelService =
          Provider.of<ILevelService>(context, listen: false);
          final ITopicService topicService =
          Provider.of<ITopicService>(context, listen: false);
          final ICategoryService categoryService =
          Provider.of<ICategoryService>(context, listen: false);

          levels.value = await levelService.fetchAllLevels() as List<Map<String, dynamic>>;
          topics.value = await topicService.fetchAllTopics() as List<Map<String, dynamic>>;
          categories.value = await categoryService.fetchAllCategories() as List<Map<String, dynamic>>;

          print('Levels: ${levels.value}');
          print('Topics: ${topics.value}');
          print('Categories: ${categories.value}');
        } catch (e) {
          print('Error fetching data: $e');
        }
      });
      return null;
    }, []);

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
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: (course.value['imagePreview'] != null &&
                        course.value['imagePreview'].isNotEmpty)
                        ? NetworkImage(course.value['imagePreview'])
                        : NetworkImage(
                      'https://api.dicebear.com/6.x/initials/png?seed=${course.value['title']}',
                    ),
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
                controller: TextEditingController(text: course.value["title"]),
                onChanged: (value) => course.value["title"] = value,
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
                controller: TextEditingController(text: course.value["description"]),
                onChanged: (value) => course.value["description"] = value,
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
                controller: TextEditingController(text: course.value["ownerUsername"]),
                onChanged: (value) => course.value["ownerUsername"] = value,
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
                items: topics.value
                    .map((topic) {
                  // Access 'title' from the topic map
                  final title = topic['title'] ?? 'Unknown';

                  return DropdownMenuItem<String>(
                    value: title, // Use the title string as the value
                    child: Text(title),
                  );
                })
                    .toList(),
                onChanged: (selectedValue) {
                  // Find the selected topic by title
                  final selectedTopic = topics.value
                      .firstWhere((topic) => topic['title'] == selectedValue);

                  print('Selected: ${selectedTopic['title']}');
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
                items: levels.value
                    .map((level) {
                  // Access 'title' from the level map
                  final title = level['title'] ?? 'Unknown';
                  return DropdownMenuItem<String>(
                    value: title, // Use the title string as the value
                    child: Text(title),
                  );
                })
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    selectedLevel.value = value;
                    // Find the corresponding level map by title
                    final selectedLevelMap = levels.value
                        .firstWhere((level) => level['title'] == value);
                    course.value["level"] = selectedLevelMap;
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
                items: categories.value
                    .map((category) {
                  // Access 'title' from the category map
                  final title = category['title'] ?? 'Unknown';
                  return DropdownMenuItem<String>(
                    value: title, // Use the title string as the value
                    child: Text(title),
                  );
                })
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    selectedCategory.value = value;
                    // Find the corresponding category map by title
                    final selectedCategoryMap = categories.value
                        .firstWhere((category) => category['title'] == value);
                    course.value["category"] = selectedCategoryMap;
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
                controller: TextEditingController(text: course.value["duration"]),
                onChanged: (value) => course.value["duration"] = value,
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
              DropdownButtonFormField<String?>(
                value: selectedStatus.value, // Replace this with the selected value from your state
                items: statusDisplayMapping.entries
                    .map((entry) => DropdownMenuItem<String?>(
                  value: entry.key,
                  child: Text(entry.value),
                ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    selectedStatus.value = value;
                    // Add logic to handle the selected status if needed
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
