import 'package:flutter/material.dart';
import 'package:flutter_easy_english/screens/course_detail_screen.dart';
import 'package:flutter_easy_english/services/i_course_service.dart';
import 'package:intl/intl.dart';
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
  String? searchQuery = '';
  String? selectedStatus;
  int currentPage = 1;
  int itemsPerPage = 100;
  int totalPages = 1;
  bool isLoading = true;

  final Map<String?, String> statusDisplayMapping = {
    null: 'All',
    'PUBLISHED': 'Published',
    'REJECTED': 'Rejected',
    'PENDING_APPROVAL': 'Pending Approval',
    'DRAFT': 'Draft',
    'DELETED': 'Deleted',
  };

  @override
  void initState() {
    super.initState();
    fetchCourses();
  }

  /// Converts a backend status value (e.g., "PUBLISHED") to a display string (e.g., "Published").
  String getDisplayStatus(String backendStatus) {
    return statusDisplayMapping[backendStatus] ?? backendStatus;
  }

  /// Converts a display string (e.g., "Published") to a backend status value (e.g., "PUBLISHED").
  String? getBackendStatus(String displayStatus) {
    return statusDisplayMapping.entries
        .firstWhere(
          (entry) => entry.value == displayStatus,
      orElse: () => MapEntry(displayStatus, displayStatus),
    )
        .key;
  }

  Future<void> fetchCourses() async {
    setState(() => isLoading = true);

    try {
      final ICourseService courseService =
      Provider.of<ICourseService>(context, listen: false);

      final courseRequest = {
        'pageNumber': currentPage - 1,
        'size': itemsPerPage,
        'title': searchQuery,
        'status': selectedStatus != null ? getBackendStatus(selectedStatus!) : null,
      };

      final dynamic fetchedCourses =
      await courseService.getAllCourseForAdmin(courseRequest);
      logger.i('fetchedCourses: $fetchedCourses');
      logger.i('content: ${fetchedCourses['content']}');

      setState(() {
        courses = fetchedCourses['content']?.cast<Map<String, dynamic>>() ?? [];
        filteredCourses = courses;

        // Ensure 'totalPages' is an integer
        totalPages = fetchedCourses['totalPages'] is int
            ? fetchedCourses['totalPages']
            : int.tryParse(fetchedCourses['totalPages'].toString()) ?? 1;
      });
    } catch (error) {
      logger.e('Fetching courses failed with error: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${error}'),
          duration: const Duration(seconds: 3),
        ),
      );
    } finally {
      setState(() => isLoading = false);
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

  Future<void> updateCourseStatus(int courseId) async {
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

      await courseService.updateCourseStatus(
        courseId,
        getBackendStatus(statusUpdates[courseId]!),
      );
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
          content: Text('$error'),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  String _getPriceText(Map<String, dynamic> price) {
    final NumberFormat currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');

    if (price['isActive'] == true && price['salePrice'] != null) {
      if (price['salePrice'] == 0) {
        return 'FREE';
      }
      return '${currencyFormat.format(price['salePrice'])} (Sale)';
    } else if (price['price'] != null) {
      if (price['price'] == 0) {
        return 'FREE';
      }
      return currencyFormat.format(price['price']);
    } else {
      return 'Giá không có sẵn';
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
                      labelText: 'Search by title',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      searchQuery = value.isEmpty ? null : value;
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
                    items: statusDisplayMapping.values.map((status) {
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
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Teacher: ${course['ownerUsername']}'),
                          Text(
                            _getPriceText(course['price']),
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          DropdownButton<String>(
                            value: getDisplayStatus(
                              statusUpdates[course['id']] ??
                                  course['status'],
                            ),
                            onChanged: (newStatus) {
                              if (newStatus != null) {
                                handleStatusChange(
                                    course['id'], newStatus);
                              }
                            },
                            items: statusDisplayMapping.values
                                .map((status) {
                              return DropdownMenuItem(
                                value: status,
                                child: Text(status),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.check,
                            color: Colors.green),
                        onPressed: () {
                          updateCourseStatus(course['id']);
                        },
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CourseDetailScreen(
                              courseId: course['id'],
                            ),
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
      ),
    );
  }
}