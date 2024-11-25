import 'dart:convert';
import 'dart:ffi';
import 'package:flutter_easy_english/services/i_course_service.dart';
import 'package:flutter_easy_english/utils/http_request.dart';

class CourseService implements ICourseService {
  static const String SUFFIX_COURSE = '/v1/course';

  @override
  Future<dynamic> fetchAllCourses() async {
    final response = await HttpRequest.getReturnDynamic('$SUFFIX_COURSE/get-all-course');
    return response;
  }

  @override
  Future<Map<String, dynamic>?> createCourse(Map<String, dynamic> courseRequest) async {
    final response = await HttpRequest.postReturnDynamic(
      '$SUFFIX_COURSE/create-course',
      courseRequest,
      headers: {'Content-Type': 'multipart/form-data'},
    );

    return response != null ? jsonDecode(response) : null;
  }

  @override
  Future<Map<String, dynamic>?> updateCourse(Map<String, dynamic> courseRequest) async {
    final response = await HttpRequest.putReturnDynamic(
      '$SUFFIX_COURSE/update-course',
      courseRequest,
      headers: {'Content-Type': 'multipart/form-data'},
    );

    return response != null ? jsonDecode(response) : null;
  }

  @override
  Future<bool> deleteCourse(Map<String, dynamic> courseRequest) async {
    final response = await HttpRequest.postReturnDynamic(
      '$SUFFIX_COURSE/delete-course',
      courseRequest
    );

    return response != null;
  }

  @override
  Future<dynamic> fetchAllCourseOfTeacher(Map<String, dynamic> courseRequest) async {
    final response = await HttpRequest.postReturnDynamic(
      '$SUFFIX_COURSE/get-all-course-of-teacher',
      courseRequest,
    );

    return response != null ? jsonDecode(response)['content'] : null;
  }

  @override
  Future<Map<String, dynamic>?> getCourseByFilter(Map<String, dynamic> courseRequest) async {
    final response = await HttpRequest.postReturnDynamic(
      '$SUFFIX_COURSE/get-course-by-filter',
      courseRequest,
    );

    return response != null ? jsonDecode(response) : null;
  }

  @override
  Future<Map<String, dynamic>?> getCourseOfFavourite(Map<String, dynamic> courseRequest) async {
    final response = await HttpRequest.postReturnDynamic(
      '$SUFFIX_COURSE/get-all-course-favorite-of-student',
      courseRequest,
    );

    return response != null ? jsonDecode(response) : null;
  }

  @override
  Future<bool> deleteCourseOfFavourite(Map<String, dynamic> courseRequest) async {
    final response = await HttpRequest.postReturnDynamic(
      '$SUFFIX_COURSE/remove-course-from-favorite',
      courseRequest,
    );

    return response != null;
  }

  @override
  Future<Map<String, dynamic>?> getEnrollCourse(Map<String, dynamic> courseRequest) async {
    final response = await HttpRequest.postReturnDynamic(
      '$SUFFIX_COURSE/get-all-course-of-student',
      courseRequest,
    );

    return response != null ? jsonDecode(response) : null;
  }

  @override
  Future<Map<String, dynamic>?> fetchMainCourse(Map<String, dynamic> courseRequest) async {
    final response = await HttpRequest.postReturnDynamic(
      '$SUFFIX_COURSE/get-main-course',
      courseRequest,
    );

    return response != null ? jsonDecode(response) : null;
  }

  @override
  Future<bool> addCourseToFavourite(Map<String, dynamic> courseRequest) async {
    final response = await HttpRequest.postReturnDynamic(
      '$SUFFIX_COURSE/add-course-to-favorite',
      courseRequest,
    );

    return response != null;
  }

  @override
  Future<dynamic> getAllCourseForAdmin(Map<String, dynamic> filterReq) async {
    final response = await HttpRequest.postReturnDynamic(
      '$SUFFIX_COURSE/admin/get',
      filterReq,
      headers: {'Content-Type': 'application/json'},
    );

    return response != null ? response : null;
  }

  @override
  Future<bool> updateCourseStatus(int courseId, String? status) async {
    final response = await HttpRequest.putReturnDynamic(
      '$SUFFIX_COURSE/update-status/$courseId/$status',
      null
    );

    return response != null;
  }
}