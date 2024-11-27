import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:logger/logger.dart';

import 'package:flutter_easy_english/services/i_category_service.dart';
import 'package:flutter_easy_english/services/i_level_service.dart';
import 'package:flutter_easy_english/services/i_topic_service.dart';

class CourseDetailScreen extends StatefulWidget {
  final Map<String?, String> statusDisplayMapping = {
    null: 'All',
    'PUBLISHED': 'Published',
    'REJECTED': 'Rejected',
    'PENDING_APPROVAL': 'Pending Approval',
    'DRAFT': 'Draft',
    'DELETED': 'Deleted',
  };

  final dynamic course;

  CourseDetailScreen({Key? key, this.course}) : super(key: key);

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  final _logger = Logger();

  String? selectedStatus;

  // Course data
  late Map<String, dynamic> course;

  @override
  void initState() {
    super.initState();

    // Initialize course data
    course = {
      'title': "Flutter Development",
      'description': "Learn how to build beautiful and responsive apps with Flutter.",
      'ownerUsername': "john_doe",
      'imagePreview': "http://10.147.20.214:9000/easy-english/image/course2.jpg",
      'topic': "Programming",
      'level': "Beginner",
      'categories': ["Technology"], // Updated to reflect a list
      'duration': "15",
      'status': "PUBLISHED",
    };
    
    course = widget.course;

    selectedStatus = course["status"];
  }

  List<String> _convertMapListToStringList({
    required List<Map<String, dynamic>> mapList,
    required String key,
  }) {
    return mapList.map((map) => map[key]?.toString() ?? "Unknown").toList();
  }

  @override
  Widget build(BuildContext context) {
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
                    backgroundImage: (course['imagePreview'] != null &&
                        course['imagePreview'].isNotEmpty)
                        ? NetworkImage(course['imagePreview'])
                        : NetworkImage(
                      'https://api.dicebear.com/6.x/initials/png?seed=${course['title']}',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Title
              _buildTextField(
                label: "Title",
                value: course["title"],
                onChanged: (value) => setState(() => course["title"] = value),
              ),

              // Owner Username
              _buildTextField(
                label: "Owner Username",
                value: course["ownerUsername"],
                onChanged: (value) =>
                    setState(() => course["ownerUsername"] = value),
              ),

              // Duration
              _buildTextField(
                label: "Duration (hours)",
                value: course["duration"]?.toString() ?? '',
                onChanged: (value) => setState(() => course["duration"] = value),
                keyboardType: TextInputType.number,
              ),

              // Status Dropdown
              _buildDropdown(
                label: "Status",
                value: selectedStatus,
                items: widget.statusDisplayMapping.entries
                    .map((entry) => entry.key ?? '')
                    .toList(),
                onChanged: (selectedValue) {
                  setState(() {
                    selectedStatus = selectedValue;
                    course["status"] = selectedValue;
                  });
                },
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
                    padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
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

  Widget _buildTextField({
    required String label,
    required String value,
    required Function(String) onChanged,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 5),
        TextField(
          controller: TextEditingController(text: value),
          onChanged: onChanged,
          maxLines: maxLines,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: "Enter $label",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 5),
        DropdownButtonFormField<String>(
          value: value,
          items: items
              .map((item) => DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          ))
              .toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildMultiSelect({
    required String label,
    required List<String> selectedValues,
    required List<String> items,
    required Function(List<String>) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 5),
        Wrap(
          spacing: 8,
          children: items.map((item) {
            final isSelected = selectedValues.contains(item);
            return ChoiceChip(
              label: Text(item),
              selected: isSelected,
              onSelected: (selected) {
                final newSelectedValues = List<String>.from(selectedValues);
                if (selected) {
                  newSelectedValues.add(item);
                } else {
                  newSelectedValues.remove(item);
                }
                onChanged(newSelectedValues);
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}