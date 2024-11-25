import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_easy_english/services/i_course_service.dart';
import 'package:provider/provider.dart';
import 'package:logger/logger.dart';

class CourseScreen extends StatefulWidget {
  @override
  _CourseScreenState createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  final logger = Logger();
  List<Map<String, dynamic>> courses = [];
  List<Map<String, dynamic>> filteredCourses = [];
  Map<int, String> statusUpdates = {};
  String searchQuery = '';
  String? selectedStatus;
  String? ownerUsername;
  int currentPage = 1;
  int itemsPerPage = 8;
  int totalPages = 1;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCourses();
  }

  Future<void> fetchCourses() async {
    setState(() => isLoading = true);

    try {
      final ICourseService courseService =
      Provider.of<ICourseService>(context, listen: false);

      final courseRequest = {
        'pageNumber': currentPage - 1,
        'size': itemsPerPage,
        'ownerUsername': ownerUsername,
        'status': selectedStatus,
      };

      final dynamic fetchedCourses = await courseService.getAllCourseForAdmin(courseRequest);
      logger.i('fetchedCourses: $fetchedCourses');

      setState(() {
        courses = fetchedCourses['content']?.cast<Map<String, dynamic>>() ?? [];
        filteredCourses = courses;

        // Ensure 'totalPages' is an integer
        totalPages = fetchedCourses['totalPages'] is int
            ? fetchedCourses['totalPages']
            : int.tryParse(fetchedCourses['totalPages'].toString()) ?? 1;
      });
    } catch (error) {
      setState(() => isLoading = false);
      logger.e('Fetching courses failed with error: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load courses: $error'),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void handleFilterChange() {
    setState(() {
      currentPage = 1;
    });
    fetchCourses();
  }

  void handleStatusChange(int courseId, String newStatus) {
    setState(() {
      statusUpdates[courseId] = newStatus;
    });
  }

  Future<void> updateCourseStatus(Long courseId) async {
    final ICourseService courseService =
    Provider.of<ICourseService>(context, listen: false);

    try {
      if (statusUpdates[courseId] == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select a status to update.'),
            duration: Duration(seconds: 2),
          ),
        );
        return;
      }

      await courseService.updateCourseStatus(courseId, statusUpdates[courseId]!);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Course status updated successfully.'),
          duration: Duration(seconds: 2),
        ),
      );
      fetchCourses();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update status: $error'),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Management'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Filters
            Row(
              children: [
                // Search by teacher
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: 'Search by teacher',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      ownerUsername = value.isEmpty ? null : value;
                    },
                  ),
                ),
                const SizedBox(width: 8),
                // Filter by status
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Filter by status',
                      border: OutlineInputBorder(),
                    ),
                    value: selectedStatus,
                    onChanged: (value) {
                      setState(() {
                        selectedStatus = value;
                      });
                    },
                    items: [
                      'Published',
                      'Rejected',
                      'Pending Approval',
                      'Draft',
                      'Deleted'
                    ].map((status) {
                      return DropdownMenuItem(
                        value: status,
                        child: Text(status),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: handleFilterChange,
                  child: const Text('Search'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Course List
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : courses.isEmpty
                  ? const Center(
                child: Text(
                  'No courses found!',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
                  : ListView.builder(
                itemCount: filteredCourses.length,
                itemBuilder: (context, index) {
                  final course = filteredCourses[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 10.0),
                    elevation: 2.0,
                    child: ListTile(
                      leading: Image.network(
                        course['imagePreview'] ?? '',
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                      title: Text(
                        course['title'] ?? 'Unnamed Course',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Teacher: ${course['ownerUsername']}'),
                          Text('Price: \$${course['price']}'),
                          DropdownButton<String>(
                            value: statusUpdates[course['id']] ??
                                course['status'],
                            onChanged: (newStatus) {
                              if (newStatus != null) {
                                handleStatusChange(
                                    course['id'], newStatus);
                              }
                            },
                            items: [
                              'Published',
                              'Rejected',
                              'Pending Approval',
                              'Draft',
                              'Deleted'
                            ].map((status) {
                              return DropdownMenuItem(
                                value: status,
                                child: Text(status),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.check, color: Colors.green),
                        onPressed: () {
                          updateCourseStatus(course['id']);
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
            // Pagination
            if (!isLoading && totalPages > 1)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: currentPage > 1
                        ? () {
                      setState(() => currentPage--);
                      fetchCourses();
                    }
                        : null,
                  ),
                  Text('Page $currentPage of $totalPages'),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward),
                    onPressed: currentPage < totalPages
                        ? () {
                      setState(() => currentPage++);
                      fetchCourses();
                    }
                        : null,
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}